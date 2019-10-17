# AnimeOne
<img src="https://raw.githubusercontent.com/HenryQuan/AnimeOne/master/design/logo/Logo.png" width="200px" height="200px" />

**AnimeOne不是官方APP**。這是我使用Flutter製作的第三方APP。第一個React Native的APP是用來看動漫的，第一個Flutter的APP也是用來看動漫的。これは運命かもしれない。不久之前，我學習了[COMP2511](https://www.handbook.unsw.edu.au/undergraduate/courses/2019/COMP2511/)，正好用這個App來練手。
總的來講，Flutter非常好用，比起React Native我覺得最大的進步就是編譯方面。我沒有一次會因爲編譯不通過而苦惱。大多數時間可以專心寫代碼而且調試也非常棒。但是APP應該是無法上架應用商店的，我之後也許會和站長交流一下。

If you prefer watching anime with English subtitles, you might consider [AnimeGo](https://github.com/HenryQuan/AnimeGo).

## 功能
- 最新動畫
- 動畫列表
- 快速搜索
- 新番時間表
- 新番介紹視頻
- 内置視頻播放器
- 自動軟件更新
- 自動夜間模式

## 關於
目前版本已經可以正常使用，有任何問題的話可以使用issues。
有一些數據會到本地本地（每七天會更新一次數據，1月/4月/7月/10月1日會自動更新）。
這是因爲動畫列表以及新番時間表并不會每天都更新，
所以APP也沒有理由每次開打都重新下載一遍數據。

## **安卓權限**
AnimeOne不需要任何權限（除網絡連接）

## **隱私條款**
AnimeOne不會收集用戶的任何數據，
GitHub會紀錄APK下載次數以及頁面觀看次數和Clone次數。

## 截圖 (1.0.3版本之前)
<div>
  <img src="https://raw.githubusercontent.com/HenryQuan/AnimeOne/master/screenshot/1.jpg" width="180px" height="320px" />
  <img src="https://raw.githubusercontent.com/HenryQuan/AnimeOne/master/screenshot/2.jpg" width="180px" height="320px" />
  <img src="https://raw.githubusercontent.com/HenryQuan/AnimeOne/master/screenshot/3.jpg" width="180px" height="320px" />
  <img src="https://raw.githubusercontent.com/HenryQuan/AnimeOne/master/screenshot/4.jpg" width="180px" height="320px" />
  <img src="https://raw.githubusercontent.com/HenryQuan/AnimeOne/master/screenshot/5.jpg" width="180px" height="320px" />
</div>

## 下載安裝
安卓可以在[這裏下載](https://github.com/HenryQuan/AnimeOne/releases/latest)，IOS則需要自己使用Xcode進行編譯（也後也許會提供IPA包）。

### Xcode如何編譯
- 在電腦上安裝Flutter以及Xcode
- 使用`flutter doctor`指令來檢查是否設置成功
- clone這個repo
- 進入`animeone`文件夾（注意是小寫）
- 使用`flutter build ios --release`獲得release包 （如果代碼沒有變化的話，只需要運行一次）
- 進入Xcode打開ios文件夾下的`Runner.xcworkspace`
- 在暫停按鈕旁邊選擇`RunnerRelease`
- 點擊運行按鈕
- 等一會兒
- App打開
- 每七天重複一次

## 支持
- 給Repo一顆星星
- 上面的Sponsor按鈕
