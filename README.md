macOS的程序坞默认是在主屏幕底部，在有多个屏幕的情况下，鼠标如果移动到其它屏幕底部非常容易触发程序坞跳到这个屏幕。可惜macOS并没有提供原生API固定程序坞也没有提供相关配置指定触发时间。这个工具就是将程序坞强制限制在主屏幕，不跳到非主屏幕，原理是检测鼠标在非主屏幕上是否到达底部，如果到达底部则强制将鼠标坐标-1。

1. xcode-select --install
2. swiftc DockAnchor.swift -o DockAnchor
3. ./DockAnchor或者双击运行DockAnchor
4. 打开 系统设置 -> 隐私与安全性 (Privacy & Security) -> 辅助功能 (Accessibility)，将终端或者这个小工具添加到列表中
5. 通过launchctl配置开机自启动
