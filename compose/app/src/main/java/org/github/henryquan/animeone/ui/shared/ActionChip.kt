package org.github.henryquan.animeone.ui.shared

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import org.github.henryquan.animeone.ui.theme.AnimeOneTheme

@Composable
fun ActionChip(
    text: String,
    onClick: () -> Unit,
) {
    TextButton(onClick = onClick, shape = MaterialTheme.shapes.large) {
        Text(text, style = MaterialTheme.typography.caption)
    }
}

@Preview
@Composable
fun ActionChipPreview() {
    AnimeOneTheme() {
        Column {
            ActionChip("OVA", onClick = {})
            ActionChip("OAD", onClick = {})
            ActionChip("2022", onClick = {})
            ActionChip("2021", onClick = {})
        }
    }
}