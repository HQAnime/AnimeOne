package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.material.Button
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.runtime.*
import androidx.lifecycle.viewmodel.compose.viewModel
import org.github.henryquan.animeone.viewmodel.home.ScheduleViewModel

@Composable
fun ScheduleScreen(
    viewModel: ScheduleViewModel = viewModel()
) {
    Surface {
        var counter by remember { mutableStateOf(0) }
        Text("Schedule List")
        Button(onClick = { counter += 1 }) {
            Text("add one")
        }
        Text(counter.toString())
    }
}
