package org.github.henryquan.animeone.data.database

import android.content.Context
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import org.github.henryquan.animeone.model.AnimeInfo

@Dao
interface AnimeListDataBaseDAO {
    update
}

@Database(entities = [AnimeInfo::class], version = 1, exportSchema = false)
abstract class AnimeListDatabase : RoomDatabase() {
    abstract val animeListDataBaseDAO: AnimeListDataBaseDAO

    companion object {

        @Volatile
        private var INSTANCE: AnimeListDatabase? = null

        fun getInstance(context: Context): AnimeListDatabase {
            synchronized(this) {
                var instance = INSTANCE

                if (instance == null) {
                    instance = Room.databaseBuilder(
                        context.applicationContext,
                        AnimeListDatabase::class.java,
                        "animeone_database"
                    )
                        .fallbackToDestructiveMigration()
                        .build()
                    INSTANCE = instance
                }
                return instance
            }
        }
    }
}