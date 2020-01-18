# 如何編譯桌面版
- [如何設置 Flutter Web](https://flutter.dev/docs/get-started/web)
- 首先回到上一層 `cd ../`
- 運行 `build_desktop.cmd`
- 然後進入 desktop 文件夾 `cd desktop/`
- 安裝包 `npm install` （不安裝也可以運行）
- 運行 `run.cmd`
- AnimeOne 桌面應該會打開
- 如果需要生成 Release 包，運行 `packager.cmd` 即可

## 關於桌面版
**沒有錯！** 其實桌面版就是`網頁版 + electron`。 編譯網頁版之後只要拷貝一下生成的文件就可以輕鬆變成桌面程序了。`electron` 確實還是很不錯的，就是程序會有一些大（150M）。
