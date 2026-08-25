package com.transport_system.ts_admin.data_providers.database.extensions

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import com.transport_system.ts_admin.data_providers.database.DatabaseManager


 fun getOtoDatabase(context: Context): SQLiteDatabase? {
    val dbPath = context.getDatabasePath(DatabaseManager.OTO_CONVERSATIONS_DATABASE_NAME).absolutePath
    return try {
        SQLiteDatabase.openDatabase(dbPath, null, SQLiteDatabase.OPEN_READONLY)
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}



fun getGroupDatabase(context: Context): SQLiteDatabase? {
    val dbPath = context.getDatabasePath(DatabaseManager.GROUP_CONVERSATIONS_DATABASE_NAME).absolutePath
    return try {
        SQLiteDatabase.openDatabase(dbPath, null, SQLiteDatabase.OPEN_READONLY)
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}
