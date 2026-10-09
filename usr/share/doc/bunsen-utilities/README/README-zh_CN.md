bunsen-utilities  
================  

一组小型脚本，提供多种功能，  
可供 BunsenLinux 用户和系统管理员使用。  

beepmein:               基于 "at" 命令的闹钟脚本。  

bl-imgbb-upload:        截取屏幕并将图像上传到 Imgbb。  
bl-imgur-upload:        截取屏幕并将图像上传到 Imgur。  
bl-image-upload:        BunsenLabs 通用图像上传工具。  

bl-conkyedit:           查找并编辑 Conky 配置文件。  
bl-conky-manager:       基于 Yad 的 Conky 管理器。  
bl-conkymove:           协助移动 Conky 窗口。  
bl-conky-session:       管理多个 Conky 会话。  

bl-kb:                  读取 Openbox 键盘快捷键并将其写入文本文件。  
bl-xbk:                 解析 xbindkeys 配置，并将快捷键写入与 bl-kb 相同的文本文件。  
bl-lock:                锁定屏幕（需要 bunsen-exit）。  
bl-setlocale:           基于 Yad 的脚本，用于选择区域设置。  

bl-pkg-versions:        显示 APT 软件包仓库和 GitHub 中 BunsenLabs 软件包的版本。  
bl-notify-broadcast:    从以 root 身份运行的进程向用户发送弹出通知。  
bl-urxlx:               将 Xresources 颜色转换为 RGB 格式，以便配置 lxterminal。  
bl-xinerama-prop:       通过 shell 脚本获取 Xinerama 属性。  
bl-reload-gtk23:        通知 GTK2/3 应用程序配置更改，例如主题更改。  

xml2xconf:              将 xfce4 (xfconf) 配置 XML 文件中的条目转换为 xfconf-query 命令。  

注意：tint2 已不再属于 BunsenLabs 的默认桌面环境，  
但以下实用工具仍随此软件包一起提供：  

bl-tint2edit:           查找并编辑 tint2 配置文件。  
bl-tint2-manager:       基于 Yad 的 tint2 管理器。  
bl-tint2-restart:       重启所有正在运行的 tint2 进程。  
bl-tint2-session:       管理多个 tint2 会话。  
