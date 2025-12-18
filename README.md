macOS的程序坞默认是在主屏幕底部，在有多个屏幕的情况下，鼠标如果移动到其它屏幕底部非常容易触发程序坞跳到这个屏幕。可惜macOS并没有提供原生API固定程序坞也没有提供相关配置指定触发时间。这个工具就是将程序坞强制限制在主屏幕询问，原理是检测鼠标在非主屏幕上是否到达底部，如果到达底部则强制将鼠标纵坐标-1。

1. xcode-select --install
2. swiftc DockAnchor.swift -o DockAnchor
3. 将生成的DockAnchor拖到应用程序中，路径为：/Applications/DockAnchor
4. 打开 系统设置 -> 隐私与安全性 (Privacy & Security) -> 辅助功能 (Accessibility)，/Applications/DockAnchor添加到列表中
5. 复制DockAnchor.plist到~/Library/LaunchAgents/
6. 执行launchctl load ~/Library/LaunchAgents/DockAnchor.plist，实现开机自启动。
