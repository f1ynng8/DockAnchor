import Cocoa
import CoreGraphics

// 配置：拦截区域的高度（像素）
let bottomBuffer: CGFloat = 1.0

// 检查鼠标是否在某个屏幕的底部区域
func checkAndConstraintMouse(event: CGEvent) -> Unmanaged<CGEvent>? {
    let location = event.location
    
    // 遍历所有屏幕
    for screen in NSScreen.screens {
        // 忽略主屏幕（我们希望Dock在主屏幕正常工作）
        if screen == NSScreen.screens.first {
            continue
        }
        
        // 获取屏幕的 frame
        let screenFrame = screen.frame
        
        // 获取主屏幕高度用于坐标转换
        guard let mainScreenHeight = NSScreen.screens.first?.frame.height else { continue }
        
        // 计算 CoreGraphics 坐标系下的 Y 轴边界
        let screenTopY = mainScreenHeight - (screenFrame.origin.y + screenFrame.height)
        let screenBottomY = screenTopY + screenFrame.height
        
        // 检查鼠标是否在这个屏幕的水平范围内
        let minX = screenFrame.origin.x
        let maxX = minX + screenFrame.width
        
        if location.x >= minX && location.x <= maxX {
            // 检查鼠标是否在垂直范围内
            if location.y >= screenTopY && location.y <= screenBottomY {
                
                // 核心逻辑：如果鼠标太靠近底部
                if location.y >= (screenBottomY - bottomBuffer) {
                    // 修改事件的位置，将其向上推回 Buffer 区域之上
                    var newLocation = location
                    newLocation.y = screenBottomY - bottomBuffer - 2.0 
                    event.location = newLocation
                }
            }
        }
    }
    return Unmanaged.passUnretained(event)
}

// 事件回调函数
let eventCallback: CGEventTapCallBack = { (proxy, type, event, refcon) in
    if type == .mouseMoved || type == .leftMouseDragged {
        return checkAndConstraintMouse(event: event)
    }
    return Unmanaged.passUnretained(event)
}

// 主程序入口
print("DockAnchor started. Prevents cursor from hitting bottom of secondary screens.")
print("Press Ctrl+C to exit.")

// 创建事件监听
let eventMask = (1 << CGEventType.mouseMoved.rawValue) | (1 << CGEventType.leftMouseDragged.rawValue)

guard let eventTap = CGEvent.tapCreate(
    tap: .cghidEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: CGEventMask(eventMask),
    callback: eventCallback,
    userInfo: nil
) else {
    print("Failed to create event tap. Please ensure you have granted Accessibility permissions.")
    exit(1)
}

let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)

// --- 修复点：严格添加了 'enable:' 标签 ---
CGEvent.tapEnable(tap: eventTap, enable: true)

CFRunLoopRun()
