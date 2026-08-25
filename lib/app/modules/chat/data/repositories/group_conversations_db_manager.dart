import 'dart:convert';
import 'dart:developer';

import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:ts_admin/app/modules/chat/data/models/group_conversation_model.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';

class GroupConversationsDatabase {
  static Database? _database;
  final String _conversationsDatabaseName = 'group_conversations_database.db';
  final String _groupConversationsTableName = 'group_conversations';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _conversationsDatabaseName);

    return await openDatabase(path, version: 4, onCreate: (db, version) async {
      // creating group conversations table
      await db.execute('''
          CREATE TABLE $_groupConversationsTableName(
            id INTEGER PRIMARY KEY,
            name TEXT,
            conversations TEXT,
            group_settings TEXT,
            conversations_count INTEGER,
            unread_count INTEGER
          )
        ''');
    }, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      log('On DB upgrade ===> old version: $oldVersion, new version: $newVersion');

      var batch = db.batch();

      // commenting this alteration beacuse we are dropping old table and
      // creating new table in version 4 so no need for this aleration
      // if (oldVersion < 2) {
      //   batch.execute(
      //       'ALTER TABLE $_groupConversationsTableName ADD group_settings TEXT');
      // }

      if (oldVersion < 4) {
        // Drop the old table
        await db.execute('DROP TABLE $_groupConversationsTableName');

        // Create a new table with the correct schema
        await db.execute('''
          CREATE TABLE $_groupConversationsTableName(
            id INTEGER PRIMARY KEY,
            name TEXT,
            conversations TEXT,
            group_settings TEXT,
            conversations_count INTEGER,
            unread_count INTEGER
          )
      ''');
      }
      await batch.commit();
    } catch (_) {}
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  ///////////////////  Group Conversations List Methods ////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  Future<dynamic> insertGroupConversations(
      List<GroupConversationEntity> groupConversations) async {
    if (groupConversations.isEmpty) {
      return;
    }
    final db = await database;
    final batch = db.batch();

    //
    //
    // creating batches for every group insertion
    for (final conversation in groupConversations) {
      //
      Map<String, dynamic> dataToInsert = {
        'id': conversation.id,
        'name': conversation.name,
        'conversations_count': conversation.conversationsCount,
        'unread_count': conversation.unreadCount,
      };

      //
      //
      // adding group settings as json to dataToInsert if not null
      if (conversation.groupSettings != null) {
        try {
          dataToInsert['group_settings'] =
              jsonEncode(conversation.groupSettings?.toJson());
        } catch (_) {}
      }

      //
      //
      // adding inner converstion as json to dataToInsert if not null
      if (conversation.conversations?.isNotEmpty ?? false) {
        dataToInsert['conversations'] =
            jsonEncode(conversation.converstionListToJson());
      }

      //
      if (conversation.id != null) {
        batch.insert(
          _groupConversationsTableName,
          dataToInsert,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    return await batch.commit();
  }

  //
  /// get all group conversation from db
  Future<List<GroupConversationEntity>> getAllGroups() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(_groupConversationsTableName, orderBy: 'name ASC');

    final groupConversations = List.generate(maps.length, (i) {
      try {
        return _getGroupConversationModelFromMap(maps[i]);
      } catch (_) {
        return null;
      }
    });

    return _removeNulls(groupConversations);
  }

  //
  /// get group conversation by name
  Future<GroupConversationEntity?> getGroup(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        _groupConversationsTableName,
        where: 'id = ?',
        whereArgs: [id],
        orderBy: 'name ASC');

    final groupConversations = List.generate(maps.length, (i) {
      try {
        return _getGroupConversationModelFromMap(maps[i]);
      } catch (_) {
        return null;
      }
    });

    return _removeNulls(groupConversations).isNotEmpty
        ? groupConversations.first
        : null;
  }

  //
  /// get group conversation by name
  Future<GroupConversationEntity?> getGroupByName(String groupName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        _groupConversationsTableName,
        where: 'name = ?',
        whereArgs: [groupName],
        orderBy: 'name ASC');

    final groupConversations = List.generate(maps.length, (i) {
      try {
        return _getGroupConversationModelFromMap(maps[i]);
      } catch (_) {
        return null;
      }
    });

    return _removeNulls(groupConversations).isNotEmpty
        ? groupConversations.first
        : null;
  }

  //
  /// update group name, unread counts, conversations counts, conversations, group settings
  Future<int> updateGroup(
      int id, GroupConversationEntity groupConversationEntity) async {
    final db = await database;

    //
    // making map and string the data which needs to be update
    // note skip null values
    Map<String, dynamic> dataToUpdate = <String, dynamic>{};

    if (groupConversationEntity.name?.isNotEmpty ?? false) {
      dataToUpdate['name'] = groupConversationEntity.name;
    }

    //
    // checking and adding non null value to dataToUpdate
    if (groupConversationEntity.unreadCount != null) {
      dataToUpdate['unread_count'] = groupConversationEntity.unreadCount;
    }

    if (groupConversationEntity.conversationsCount != null) {
      dataToUpdate['conversations_count'] =
          groupConversationEntity.conversationsCount;
    }

    if (groupConversationEntity.conversations?.isNotEmpty ?? false) {
      dataToUpdate['conversations'] =
          jsonEncode(groupConversationEntity.converstionListToJson());
    }

    if (groupConversationEntity.groupSettings != null) {
      try {
        dataToUpdate['group_settings'] =
            jsonEncode(groupConversationEntity.groupSettings?.toJson());
      } catch (_) {}
    }

    // updating in db
    return await db.update(_groupConversationsTableName, dataToUpdate,
        where: 'id = ?', whereArgs: [id]);
  }

  //
  //
  /// will delete all the groups of provided ids
  Future<dynamic> deleteGroups(List<int> ids) async {
    final db = await database;
    final batch = db.batch();
    for (final id in ids) {
      //
      batch.delete(
        _groupConversationsTableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    return await batch.commit();
  }

  //
  //
  /// will delete all the groups from db
  Future<int> deleteAllGroupConversation() async {
    final db = await database;
    return await db.delete(
      _groupConversationsTableName,
    );
  }

  //
  // function that we create a GroupConversationEntity? from a map retrieved from db
  GroupConversationEntity? _getGroupConversationModelFromMap(
      Map<String, dynamic> map) {
    // id not exists in map means group data maybe invalid
    if (map['id'] == null) {
      return null;
    }

    // name not exists in map means group data maybe invalid
    if (map['name'] == null) {
      return null;
    }

    // creating instace and strong data from map
    GroupConversationModel convresation = GroupConversationModel();
    convresation.id = map['id'];
    convresation.name = map['name'];
    convresation.unreadCount = map['unread_count'];
    convresation.conversationsCount = map['conversations_count'];

    try {
      convresation.groupSettings =
          GroupSettingsEntity.fromJson(jsonDecode(map['group_settings']));
    } catch (_) {}

    //
    // parsing converstions list from json string to list of  GroupConversationConversationEntity
    try {
      if (map['conversations'] != null) {
        final conversationsJson = jsonDecode(map['conversations']);
        convresation.conversations = conversationsJson == null
            ? []
            : List<GroupConversationConversationEntity>.from(conversationsJson
                .map((x) => GroupConversationConversationEntity.fromJson(x)));
      }
    } catch (_) {}

    return convresation;
  }

  //
  // function that will filter and remove the null objects from list
  List<GroupConversationEntity> _removeNulls(
          List<GroupConversationEntity?> list) =>
      list.where((element) => element != null).map((e) => e!).toList();
}
