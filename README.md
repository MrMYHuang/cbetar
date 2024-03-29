# CBETA電子佛典閱讀器(非官方)

## 注意!
此app目前只支援Android, iOS，作者決定改寫成progressive web app的第2代閱讀器，此第1代app目前停止開發。

第2代非官方CBETA電子佛典閱讀器Github repo: https://github.com/MrMYHuang/cbetar2

## 特色

搜尋經文、書籤功能、離線瀏覽、暗色模式、字型調整。

## 介紹

CBETA電子佛典閱讀器(非官方)，使用CBETA API存取電子佛經，支援以下功能

* 搜尋
    1. 在目錄頁，按下右上角放大鏡圖示。在對話框輸入經文部分標題，確認後會列出相關經文。
* 書籤
    1. 開啟某經文後，長按後選擇想標記為書籤的字串位置，再按右上角書籤圖示，會變紅色，即新增一書籤，可至書籤頁查詢。
    2. 在書籤頁點擊某一書籤，即會開啟經文，並自動跳至標記文字的位置。
    3. 若要同一經文新增多個書籤，操作方法為:新增一個書籤後，按左上角上一頁箭頭，再重點同一經文，書籤會變回白色，即可新增下一個書籤。
* 離線瀏覽
    1. 書籤頁包含的經文都具有離線瀏覽的功能。
* 字型調整
    1. 考量視力不佳的同修，提供最大64px的經文字型設定。若有需要更大字型，請E-mail或GitHub聯絡開發者新增。

程式碼為開放，可自由下載修改。

## 程式

使用Flutter開發，請參考 https://flutter.dev/docs/get-started/install 作開發環境建置。目前主要開發Android, iOS版，未來希望能支援macOS, Linux, Windows。

## 市集上架

Google Play (Android): https://play.google.com/store/apps/details?id=com.github.mrmyhuang.cbetar

App Store (iOS): https://apps.apple.com/app/id1526621889 

## 版本歷史
* 1.9.5:
    * 升級 Android Target SDK 33.
* 1.9.3:
    * 修改 app 名為"電子佛典(舊版)"
* 1.9.2:
    * 升級 Flutter 2.2.3
* 1.9.0:
    * 目錄支援書籤功能
* 1.8.0:
    * 支援CBETA完整目錄
    * 新增顯示註腳設定
* 1.7.0:
    * 新增列表字型大小增設定
* 1.6.4:
    App Store上架第一版
* 1.6.3:
    * 支援暗色模式
* 1.5.0:
    * Google Play上架第一版

## 隱私政策聲明

此app無收集使用者個人資訊。
