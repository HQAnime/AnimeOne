package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalUriHandler
import androidx.lifecycle.viewmodel.compose.viewModel
import org.github.henryquan.animeone.BuildConfig
import org.github.henryquan.animeone.viewmodel.home.AboutViewModel

@OptIn(ExperimentalMaterialApi::class)
@Composable
fun AboutScreen(
    viewModel: AboutViewModel = viewModel()
) {
    viewModel.webLauncher = LocalUriHandler.current
    val context = LocalContext.current

    Surface {
        val scrollState = rememberScrollState()
        Column(
            modifier = Modifier.verticalScroll(scrollState)
        ) {
            ListItem(
                text = { Text("支持開發") },
                secondaryText = { Text("特別喜歡本 APP 的話，可以支持一下~~") },
                modifier = Modifier.clickable {
                    viewModel.supportAnimeOne()
                }
            )
            Divider()
            ListItem(
                text = { Text("官方 Discord 伺服器") },
                secondaryText = { Text("https://61.uy/d") },
                modifier = Modifier.clickable {
                    viewModel.viewOfficialDiscord()
                }
            )
            ListItem(
                text = { Text("官方網站 - 關於") },
                secondaryText = { Text("官方網站的聯繫方式和捐款") },
                modifier = Modifier.clickable {
                    viewModel.viewOfficialAbout()
                }
            )
            Divider()
            ListItem(
                text = { Text("軟件源代碼") },
                secondaryText = { Text("源代碼在 GitHub 上開放，歡迎 Pull Request") },
                modifier = Modifier.clickable {
                    viewModel.viewSourceCode()
                }
            )
            ListItem(
                text = { Text("隱私條款") },
                secondaryText = { Text("AnimeOne 不會收集用戶的任何數據") },
                modifier = Modifier.clickable {
                    viewModel.viewPrivacyPolicy()
                }
            )
            ListItem(
                text = { Text("開源許可證") },
                secondaryText = { Text("查看所有的開源許可證") },
                modifier = Modifier.clickable {

                }
            )
            Divider()
            ListItem(
                text = { Text("下載 Emina One") },
                secondaryText = { Text("splitline 製作的 anime1 app") },
                modifier = Modifier.clickable {
                    viewModel.downloadEminaOne()
                }
            )
            ListItem(
                text = { Text("下載 AnimeGo") },
                secondaryText = { Text("非官方 gogoanime app") },
                modifier = Modifier.clickable {
                    viewModel.downloadAnimeGo()
                }
            )
            Divider()
            ListItem(
                text = { Text("電子郵件") },
                secondaryText = { Text("聯係本軟件的開發者") },
                modifier = Modifier.clickable {
                    viewModel.emailDeveloper()
                }
            )
            ListItem(
                text = { Text("分享軟件") },
                secondaryText = { Text("喜歡本APP的話，可以分享給朋友們") },
                modifier = Modifier.clickable {
                    viewModel.shareAnimeOne(context)
                }
            )
            ListItem(
                text = { Text("軟件更新") },
                secondaryText = { Text(BuildConfig.VERSION_NAME) },
                modifier = Modifier.clickable {

                }
            )
        }
    }
}