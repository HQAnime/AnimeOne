package org.github.henryquan.animeone.data.database

import android.content.Context
import androidx.room.*
import org.github.henryquan.animeone.model.AnimeInfo
import org.github.henryquan.animeone.model.AnimeSchedule

@Dao
interface AnimeListDAO {
    @Insert
    fun insertAnime(anime: AnimeInfo)
}

@Dao
interface AnimeScheduleDAO {
    @Insert
    fun insertSchedule(schedule: AnimeSchedule)
}

/**
 * The only database of AnimeOne
 */
@Database(entities = [AnimeInfo::class, AnimeSchedule::class], version = 1, exportSchema = false)
abstract class AnimeOneDatabase : RoomDatabase() {
    abstract val animeListDAO: AnimeListDAO
    abstract val animeScheduleDAO: AnimeScheduleDAO

    companion object {

        @Volatile
        private var INSTANCE: AnimeOneDatabase? = null

        fun getInstance(context: Context): AnimeOneDatabase {
            synchronized(this) {
                var instance = INSTANCE

                if (instance == null) {
                    instance = Room.databaseBuilder(
                        context.applicationContext,
                        AnimeOneDatabase::class.java,
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