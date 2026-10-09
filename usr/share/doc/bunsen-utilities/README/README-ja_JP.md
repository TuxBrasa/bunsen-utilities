bunsen-utilities
================

BunsenLinux のユーザーやシステム管理者に役立つさまざまな機能を提供する
小さなスクリプト集です。

beepmein:               "at" コマンドを利用したアラーム時計スクリプト。

bl-imgbb-upload:        スクリーンショットを撮影して Imgbb にアップロードします。
bl-imgur-upload:        スクリーンショットを撮影して Imgur にアップロードします。
bl-image-upload:        BunsenLabs 用の汎用画像アップロードツール。

bl-conkyedit:           Conky の設定ファイルを検索して編集します。
bl-conky-manager:       Yad ベースの Conky 管理ツール。
bl-conkymove:           Conky ウィンドウの移動を支援します。
bl-conky-session:       複数の Conky セッションを管理します。

bl-kb:                  Openbox のキーボードショートカットを読み取り、テキストファイルに書き出します。
bl-xbk:                 xbindkeys の設定を解析し、bl-kb と同じテキストファイルにショートカットを書き出します。
bl-lock:                画面をロックします（bunsen-exit が必要です）。
bl-setlocale:           Yad ベースのスクリプトで、ロケール設定を選択できます。

bl-pkg-versions:        APT リポジトリおよび GitHub にある BunsenLabs パッケージのバージョンを表示します。
bl-notify-broadcast:    root 権限で実行されるプロセスからユーザーにポップアップ通知を送信します。
bl-urxlx:               lxterminal の設定用に Xresources の色を RGB 形式に変換します。
bl-xinerama-prop:       シェルスクリプトから Xinerama のプロパティを取得します。
bl-reload-gtk23:        テーマなどの設定変更を GTK2/3 アプリケーションに通知します。

xml2xconf:              xfce4 (xfconf) の設定 XML ファイルの項目を xfconf-query コマンドに変換します。

注意: tint2 は BunsenLabs の標準デスクトップ環境には含まれなくなりましたが、
以下のユーティリティは引き続きこのパッケージに含まれています。

bl-tint2edit:           tint2 の設定ファイルを検索して編集します。
bl-tint2-manager:       Yad ベースの tint2 管理ツール。
bl-tint2-restart:       実行中のすべての tint2 プロセスを再起動します。
bl-tint2-session:       複数の tint2 セッションを管理します。
