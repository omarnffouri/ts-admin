import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:ts_admin/app/modules/chat/data/models/messages_notifications_db_model.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/message_notification_response_entity.dart';

class MessagesNotificationsDatabase {
  static Database? _database;
  final String _databaseName = 'messages_notifications_database.db';
  final String _messagesNotificationsTableName = 'messages_notifications';
  final String logName = 'Messages Notifications Database Log: ';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_messagesNotificationsTableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            conversation_id INTEGER,
            message_id INTEGER UNIQUE,
            viewed INTEGER,
            read INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        //
      },
    );
  }

  /// Inserts a single message notification into the database.
  /// If a message with the same `message_id` already exists, it will be replaced due to the conflict resolution strategy.
  /// Returns the number of rows affected.
  Future<int> insertMessageNotification(
      MessageNotificationEntity messageNotification) async {
    try {
      final db = await database;

      // Insert the message notifications into the database with conflict resolution
      final result = await db.insert(
        _messagesNotificationsTableName,
        {
          'conversation_id': messageNotification.message?.conversationId,
          'message_id': messageNotification.message?.id,
          'viewed': messageNotification.viewed.value ? 1 : 0,
          'read': messageNotification.read.value ? 1 : 0
        },
        conflictAlgorithm:
            ConflictAlgorithm.ignore, // ignore on conflict (same message_id)
      );

      debugPrint(
          '$logName Message notifications with message_id ${messageNotification.message?.id} inserted successfully.');

      return result; // Return the number of rows affected
    } catch (e) {
      debugPrint(
          '$logName Error inserting message notification with message_id ${messageNotification.message?.id}: $e');
      return 0; // Return 0 in case of error (no rows inserted)
    }
  }

  /// Inserts a list of messages notifications into the database.
  /// If a message with the same `message_id` already exists, it will be replaced due to the conflict resolution strategy.
  /// Handles empty lists gracefully. Returns function if empty list provided.
  Future<void> insertMessagesNotifications(
      List<MessageNotificationEntity> messagesNotifications) async {
    try {
      // Return early if the messages notifications list is empty
      if (messagesNotifications.isEmpty) {
        return;
      }

      final db = await database;
      final batch = db.batch();

      // Prepare batch operations for each message
      for (final messageNotification in messagesNotifications) {
        try {
          batch.insert(
            _messagesNotificationsTableName,
            {
              'conversation_id': messageNotification.message?.conversationId,
              'message_id': messageNotification.message?.id,
              'viewed': messageNotification.viewed.value ? 1 : 0,
              'read': messageNotification.read.value ? 1 : 0,
            },
            conflictAlgorithm: ConflictAlgorithm.ignore, // ignore on conflict
          );
        } catch (e) {
          debugPrint(
              '$logName Error preparing insert batch for message notification ID ${messageNotification.message?.id}: $e');
        }
      }

      // Execute the batch commit
      try {
        await batch.commit();
        debugPrint(
            '$logName Messages Notifications batch insert: ${messagesNotifications.length}');
      } catch (e) {
        debugPrint('$logName Error committing batch insert: $e');
      }
    } catch (e) {
      debugPrint('$logName Error inserting messages notifications: $e');
    }
  }

  ///
  ///
  /// function to fetch messages notifications with specific message id in [message ids]
  Future<List<MessagesNotificationsDbModel>>
      getMessagesNotificationsByMessageIds(List<int> messageIds) async {
    try {
      final db = await database;

      if (messageIds.isEmpty) return [];

      // Build the correct number of `?` placeholders
      final placeholders = List.filled(messageIds.length, '?').join(',');

      final maps = await db.rawQuery(
        'SELECT * FROM $_messagesNotificationsTableName WHERE message_id IN ($placeholders)',
        messageIds,
      );

      //
      //  build messages notifications list from query result
      final messagesNotifications = List.generate(maps.length, (i) {
        return MessagesNotificationsDbModel.fromJson(maps[i]);
      });

      return messagesNotifications;
    } catch (e) {
      debugPrint(
          '$logName Error while fetching messages notifications with specific ids: $e');
    }
    return [];
  }

  ///
  ///
  /// function will mark all messages notifications as viewed
  Future<void> markAllMessagesNotificationsAsViewed() async {
    try {
      final db = await database;
      await db.update(_messagesNotificationsTableName, {'viewed': 1});
      debugPrint('$logName All messages notifications marked as viewed');
    } catch (e) {
      debugPrint(
          '$logName Error while marking all messages notifications as viewed: $e');
    }
  }

  ///
  ///
  /// function will mark message notification as read
  Future<void> markMessageNotificationAsRead(int messageId) async {
    try {
      final db = await database;

      await db.update(
        _messagesNotificationsTableName,
        {
          'read': 1, // Mark as read
          'viewed': 1, // Optional: Also mark as viewed
        },
        where: 'message_id = ?',
        whereArgs: [messageId],
      );

      debugPrint(
          '$logName Message notification with message_id $messageId marked as read.');
    } catch (e) {
      debugPrint(
          '$logName Error while marking message notification as read (message_id: $messageId): $e');
    }
  }

  ///
  ///
  /// function will delete a specific message notification from DB
  Future<int> deleteMessageNotification(int messageId) async {
    try {
      final db = await database;

      final deletedCount = await db.delete(
        _messagesNotificationsTableName,
        where: 'message_id = ?',
        whereArgs: [messageId],
      );

      debugPrint(
          '$logName Message notification with message_id $messageId deleted.');

      return deletedCount; // Number of rows deleted
    } catch (e) {
      debugPrint(
          '$logName Error deleting message notification with message_id $messageId: $e');
      return 0;
    }
  }

  ///
  ///
  /// Deletes all message notifications from the database that match
  /// the provided list of message IDs.
  Future<int> deleteMessagesNotificationsByMessagesIds(
      List<int> messageIds) async {
    try {
      final db = await database;

      if (messageIds.isEmpty) return 0;

      // Create placeholders (?, ?, ?) for safe binding
      final placeholders = List.filled(messageIds.length, '?').join(',');

      final deletedCount = await db.delete(
        _messagesNotificationsTableName,
        where: 'message_id IN ($placeholders)',
        whereArgs: messageIds,
      );

      debugPrint(
          '$logName Deleted $deletedCount message notifications for message_ids: $messageIds');

      return deletedCount; // Number of rows deleted
    } catch (e) {
      debugPrint(
          '$logName Error deleting messages for message_ids $messageIds: $e');
      return 0;
    }
  }

  ///
  ///
  /// function will delete all messages notifications related to specific conversation.
  Future<int> deleteConversationNotifications(int conversationId) async {
    final db = await database;
    return await db.delete(
      _messagesNotificationsTableName,
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
    );
  }

  ///
  ///
  /// function will delete the table means all messages notifications will be
  /// deleted
  Future<int> deleteMessagesNotifications() async {
    final db = await database;
    return await db.delete(
      _messagesNotificationsTableName,
    );
  }
}
