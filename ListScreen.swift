import Cocoa
import CoreGraphics

// 获取屏幕的 displayID
func getDisplayID(for screen: NSScreen) -> CGDirectDisplayID? {
    return screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID
}

// 安全获取屏幕名称
func getScreenName(for screen: NSScreen) -> String {
    if #available(macOS 10.15, *) {
        return screen.localizedName
    } else {
        if let displayID = getDisplayID(for: screen) {
            return "Display \(displayID)"
        }
        return "Unknown"
    }
}

// 字符串左对齐填充
func padRight(_ str: String, _ width: Int) -> String {
    let len = str.count
    if len >= width {
        return str
    }
    return str + String(repeating: " ", count: width - len)
}

// 主程序
func main() {
    // 确保 NSApplication 已初始化（某些 NSScreen API 需要）
    let app = NSApplication.shared
    app.setActivationPolicy(.prohibited)
    
    let screens = NSScreen.screens
    let mainDisplayID = CGMainDisplayID()
    
    if screens.isEmpty {
        print("未检测到任何屏幕")
        return
    }
    
    print("=== DockAnchor 屏幕信息列表 ===")
    print("")
    
    // 表头
    print("\(padRight("名称", 26))\(padRight("DisplayID", 14))\(padRight("尺寸", 16))主屏幕")
    print(String(repeating: "-", count: 65))
    
    for screen in screens {
        let displayID = getDisplayID(for: screen) ?? 0
        let size = screen.frame.size
        let isMain = (displayID == mainDisplayID)
        let name = getScreenName(for: screen)
        let sizeStr = "\(Int(size.width)) x \(Int(size.height))"
        
        print("\(padRight(name, 26))\(padRight(String(displayID), 14))\(padRight(sizeStr, 16))\(isMain ? "✓" : "")")
    }
    
    print("")
    print("提示:")
    print("  1. DisplayID 在同一时刻连接的屏幕中是唯一的")
    print("  2. 屏幕断开后重新连接，DisplayID 可能会改变，需重新运行此工具获取")
    print("")
}

main()
