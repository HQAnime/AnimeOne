package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.material.Button
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.runtime.*

@Composable
fun ScheduleScreen() {
    Surface {
        var counter by remember {  mutableStateOf(0) }
        Text("Schedule List")
        Button(onClick = { counter += 1 }) {
            Text("add one")
        }
        Text(counter.toString())
    }
}
