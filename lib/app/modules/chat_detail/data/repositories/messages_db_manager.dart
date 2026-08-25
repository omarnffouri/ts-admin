import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_details_model.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';

class MessagesDatabase {
  static Database? _database;
  final String _messagesDatabaseName = 'messages_database.db';
  final String _messagesTableName = 'messages';
  final String logName = 'Messages Database Log: ';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _messagesDatabaseName);

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_messagesTableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            conversation_id INTEGER,
            message TEXT,
            message_id INTEGER UNIQUE,
            message_text TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (newVersion == 3) {
          // Drop the old table
          await db.execute('DROP TABLE $_messagesTableName');

          // Create a new table with the correct schema
          await db.execute('''
          CREATE TABLE $_messagesTableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            conversation_id INTEGER,
            message TEXT,
            message_id INTEGER UNIQUE,
            message_text TEXT
          )
      ''');
        }
      },
    );
  }

  /// Inserts a single message into the database.
  /// If a message with the same `message_id` already exists, it will be replaced due to the conflict resolution strategy.
  /// Returns the number of rows affected.
  Future<int> insertMessage(ConversationMessageEntity message) async {
    try {
      final db = await database;

      // Insert the message into the database with conflict resolution
      final result = await db.insert(
        _messagesTableName,
        {
          'conversation_id': message.conversationId,
          'message_id': message.id,
          'message':
              jsonEncode(message.toJson()), // Convert message to JSON format
          'message_text': message.message ??
              "", // If message is null, insert an empty string
        },
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Replace on conflict (same message_id)
      );

      debugPrint(
          '$logName Message with message_id ${message.id} inserted successfully.');

      return result; // Return the number of rows affected
    } catch (e) {
      debugPrint(
          '$logName Error inserting message with message_id ${message.id}: $e');
      return 0; // Return 0 in case of error (no rows inserted)
    }
  }

  /// Inserts a list of messages into the database.
  /// If a message with the same `message_id` already exists, it will be replaced due to the conflict resolution strategy.
  /// Handles empty lists gracefully. Returns function if empty list provided.
  Future<void> insertMessages(List<ConversationMessageEntity> messages) async {
    try {
      // Return early if the messages list is empty
      if (messages.isEmpty) {
        return;
      }

      final db = await database;
      final batch = db.batch();

      // Prepare batch operations for each message
      for (final message in messages) {
        try {
          batch.insert(
            _messagesTableName,
            {
              'conversation_id': message.conversationId,
              'message_id': message.id,
              'message': jsonEncode(message.toJson()),
              'message_text': message.message ?? "",
            },
            conflictAlgorithm: ConflictAlgorithm.replace, // Replace on conflict
          );
        } catch (e) {
          debugPrint(
              '$logName Error preparing insert batch for message ID ${message.id}: $e');
        }
      }

      // Execute the batch commit
      try {
        await batch.commit();
        debugPrint('$logName Messages batch insert: ${messages.length}');
      } catch (e) {
        debugPrint('$logName Error committing batch insert: $e');
      }
    } catch (e) {
      debugPrint('$logName Error inserting messages: $e');
    }
  }

  /// This function retrieves all messages for a specific conversation, limited to the most recent 500 messages.
  /// Messages are retrieved in descending order of their IDs (most recent first) and then sorted before returning.
  /// Returns an empty list in case of any error or exception during the process.
  Future<List<ConversationMessageEntity>> getAllMessages(
      int conversationId) async {
    try {
      final db = await database;

      // Query the database for messages in the given conversation
      final List<Map<String, dynamic>> maps = await db.query(
        _messagesTableName,
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
        orderBy: 'message_id DESC', // Order by most recent messages first
        limit: 500, // Limit to the latest 500 messages
      );

      debugPrint(
          "$logName Found messages retrieved for conversation $conversationId: ${maps.length} (limit : 500)");

      // Convert the query results into message objects
      final messages = List.generate(maps.length, (i) {
        try {
          return ConversationMessageModel.fromJson(
              jsonDecode(maps[i]['message']));
        } catch (e) {
          debugPrint(
              '$logName Error decoding message at index $i after retriving from local DB: $e');
          return null; // Return null for invalid messages
        }
      })
          .whereType<ConversationMessageModel>()
          .toList(); // Filter out null values

      // Sort the messages before returning
      return _sortMessagesList(messages);
    } catch (e) {
      debugPrint(
          '$logName Error fetching messages for conversation $conversationId from loal DB: $e');
      return []; // Return an empty list in case of an error
    }
  }

  /// This function fetches the previous messages for a specific conversation,
  /// retrieving messages with a message_id less than lastMessageId.
  /// Returns an empty list if an error or exception occurs.
  Future<List<ConversationMessageEntity>> getPreviousMessages(
      int conversationId, int lastMessageId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _messagesTableName,
        where: 'conversation_id = ? AND message_id < ?',
        whereArgs: [conversationId, lastMessageId],
        orderBy: 'message_id DESC', // Order by most recent first
        limit: 500, // Limit the results to 500
      );

      debugPrint(
          "$logName Found previous messages for conversation $conversationId: ${maps.length} (limit : 500)");

      final messages = List.generate(maps.length, (i) {
        try {
          return ConversationMessageModel.fromJson(
              jsonDecode(maps[i]['message']));
        } catch (e) {
          debugPrint(
              '$logName Error processing messages for conversation $conversationId: $e');
          return null;
        }
      }).whereType<ConversationMessageModel>().toList();

      return _sortMessagesList(messages);
    } catch (e) {
      debugPrint(
          '$logName Error fetching previous messages for conversation $conversationId: $e');
      return [];
    }
  }

  /// This function searches for `message_id`s in a specific conversation
  /// where the `message_text` contains the given query string.
  /// It retrieves only the `message_id`s and orders them by the most recent (`id DESC`).
  /// Returns an empty list in case of any error or exception.
  Future<List<int>> searchMessageIds(int conversationId, String query) async {
    try {
      final db = await database;

      // Query the database to fetch only `message_id`
      final List<Map<String, dynamic>> maps = await db.query(
        _messagesTableName,
        columns: ['message_id'], // Fetch only the `message_id` column
        where: 'conversation_id = ? AND message_text LIKE ?',
        whereArgs: [conversationId, '%$query%'],
        orderBy: 'id DESC', // Order by the most recent message first
      );

      // Extract the `message_id` values from the result
      return maps.map<int>((map) => map['message_id'] as int).toList();
    } catch (e) {
      debugPrint('$logName Error searching message IDs: $e');
      return []; // Return an empty list in case of an error
    }
  }

  /// This function retrieves a single message based on the provided `messageId`.
  /// It queries the database to find the message with the matching `message_id`.
  /// If a message is found, it returns a `ConversationMessageEntity`; otherwise, it returns `null`.
  /// Returns `null` in case of any error or exception during the process.
  Future<ConversationMessageEntity?> getMessage(int? messageId) async {
    try {
      if (messageId == null) {
        return null;
      }
      final db = await database;

      // Query the database for the message with the given `message_id`
      final List<Map<String, dynamic>> maps = await db.query(
        _messagesTableName,
        where: 'message_id = ?',
        whereArgs: [messageId],
        orderBy:
            'id DESC', // Optional: Order by ID (useful if duplicates exist)
      );

      // Check if any results were found
      if (maps.isNotEmpty) {
        try {
          // Convert the first result into a `ConversationMessageEntity`
          return ConversationMessageModel.fromJson(
              jsonDecode(maps[0]['message']));
        } catch (e) {
          debugPrint('$logName Error decoding message: $e');
          return null;
        }
      }

      // Return `null` if no message was found
      return null;
    } catch (e) {
      debugPrint('$logName Error fetching message with ID $messageId: $e');
      return null; // Return `null` in case of an error
    }
  }

  /// This function retrieves the message ID for a specific conversation.
  /// It queries the database for messages in the conversation,
  /// sorts them, and returns the ID of the most recent message as per param.
  /// If no messages are found or an error occurs, it returns `null`.
  Future<int?> getMessageId(int conversationId, MessageSort messageSort) async {
    try {
      final db = await database;

      // Query the database for messages in the given conversation
      final List<Map<String, dynamic>> maps = await db.query(
        _messagesTableName,
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
        // orderBy: 'id DESC', // Order by the most recent message first
        orderBy:
            'message_id ${messageSort == MessageSort.oldest ? 'ASC' : 'DESC'}', // Sort by smallest message_id first
        limit: 1, // Limit to only the first result
      );

      // debugPrint(
      //     "$logName Total messages for conversation $conversationId: ${maps.length}");

      // Check if any messages were found
      if (maps.isNotEmpty) {
        try {
          // Convert the query results into message objects
          final messages = List.generate(maps.length, (i) {
            return ConversationMessageModel.fromJson(
              jsonDecode(maps[i]['message']),
            );
          });

          // Sort the messages and return the ID of the most recent one (sorting will be new to old)
          // return messageSort == MessageSort.oldest
          //     ? _sortMessagesList(messages).last.id
          //     : _sortMessagesList(messages).first.id;

          return messages.first.id;
        } catch (e) {
          debugPrint(
              '$logName Error processing messages for conversation $conversationId: $e');
          return null;
        }
      }

      // Return null if no messages were found
      return null;
    } catch (e) {
      debugPrint(
          '$logName Error fetching last message ID for conversation $conversationId: $e');
      return null; // Return null in case of an error
    }
  }

  Future<int> updateMessage(int conversationId, int messageId,
      ConversationMessageEntity message) async {
    final db = await database;
    return await db.update(
        _messagesTableName,
        {
          "message": jsonEncode(message.toJson()),
        },
        where: 'conversation_id = ? AND message_id = ?',
        whereArgs: [conversationId, messageId]);
  }

  Future<int> deleteConversation(int conversationId) async {
    final db = await database;
    return await db.delete(
      _messagesTableName,
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
    );
  }

  Future<int> deleteMessage(int conversationId, int messageId) async {
    final db = await database;
    return await db.delete(
      _messagesTableName,
      where: 'conversation_id = ? AND message_id = ?',
      whereArgs: [conversationId, messageId],
    );
  }

  Future<int> deleteMessages() async {
    final db = await database;
    return await db.delete(
      _messagesTableName,
    );
  }

  // sort messages list on the bases of the created at new to old
  List<ConversationMessageModel> _sortMessagesList(
      List<ConversationMessageModel> messages) {
    messages.sort((a, b) {
      DateTime? aDate = a.createdAt;
      DateTime? bDate = b.createdAt;

      if (aDate == null && bDate != null) {
        return 1;
      } else if (bDate == null && aDate != null) {
        return -1;
      } else if (bDate == null && aDate == null) {
        return 0;
      } else {
        return bDate!.compareTo(aDate!);
      }
    });
    return messages;
  }
}

enum MessageSort { newest, oldest }
