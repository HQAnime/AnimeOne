package org.github.henryquan.animeone.data.database

import android.content.Context
import androidx.annotation.WorkerThread
import androidx.room.*
import org.github.henryquan.animeone.model.AnimeInfo
import org.github.henryquan.animeone.model.AnimeSchedule

@Dao
interface AnimeListDAO {
    @Insert
    fun insertList(animeList: List<AnimeInfo>)

    @Query("Select * from anime_list_table")
    fun getAnimeList(): List<AnimeInfo>

    @Query("Delete from anime_list_table")
    fun clear()
}

@Dao
interface AnimeScheduleDAO {
    @Insert
    fun insertList(animeSchedule: List<AnimeSchedule>)

    @Query("Select * from anime_schedule_table")
    fun getAnimeSchedule(): List<AnimeSchedule>

    @Query("Delete from anime_schedule_table")
    fun clear()
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
