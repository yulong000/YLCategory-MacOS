//
//  Macro.swift
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/12/3.
//

// MARK: - 颜色

import Cocoa

public let WhiteColor: NSColor = .white
public let BlackColor: NSColor = .black
public let ClearColor: NSColor = .clear
public let GrayColor: NSColor = .gray
public let DarkGrayColor: NSColor = .darkGray
public let LightGrayColor: NSColor = .lightGray
public let RedColor: NSColor = .red
public let GreenColor: NSColor = .green
public let OrangeColor: NSColor = .orange
public let YellowColor: NSColor = .yellow
public let BlueColor: NSColor = .blue
public let SystemBlueColor: NSColor = .systemBlue
public var ControlAccentColor: NSColor { .controlAccentColor }
public var RandomColor: NSColor { NSColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: 1.0) }

public var RGBA:(CGFloat, CGFloat, CGFloat, CGFloat) -> NSColor  = { r, g, b, a in
    NSColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}
public var RGB: (CGFloat) -> NSColor = { NSColor(red: $0 / 255.0, green: $0 / 255.0, blue: $0 / 255.0, alpha: 1.0) }
public var Hex: (Int) -> NSColor = {
    NSColor(red: CGFloat(($0 & 0xFF0000) >> 16) / 255.0,
            green: CGFloat(($0 & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat($0 & 0x0000FF) / 255.0,
            alpha: 1.0)
}

public var BlackColorAlpha: (CGFloat) -> NSColor = { NSColor(white: 0, alpha: $0) }
public var WhiteColoAlpha: (CGFloat) -> NSColor = { NSColor(white: 1, alpha: $0) }

// MARK: - 屏幕

public var kScreenScale: CGFloat { NSScreen.main?.backingScaleFactor ?? 0.0 }
public var kScreenWidth: CGFloat { NSScreen.main?.frame.size.width ?? 0.0 }
public var kScreenHeight: CGFloat { NSScreen.main?.frame.size.height ?? 0.0 }
public var kStatusBarHeight: CGFloat { NSApp.mainMenu?.menuBarHeight ?? 0.0 }

// MARK: - 字体

public var Font: (CGFloat) -> NSFont = { .systemFont(ofSize: $0) }
public var BoldFont: (CGFloat) -> NSFont = { .boldSystemFont(ofSize: $0) }
public var MediumFont: (CGFloat) -> NSFont = { .systemFont(ofSize: $0, weight: .medium) }
public var ThinFont: (CGFloat) -> NSFont = { .systemFont(ofSize: $0, weight: .thin) }

// MARK: - app相关信息

// app是沙盒
public let kAppIsSanbox: Bool = ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
// app是暗黑模式
public var kAppIsDarkTheme: Bool { NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua }
// 系统是暗黑模式
public var kSystemIsDarkTheme: Bool {
    let info = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain)
    if let style = info?["AppleInterfaceStyle"] as? String {
        return style.caseInsensitiveCompare("dark") == .orderedSame
    }
    return false
}

public var kDocumentPath: String { NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "" }
public var kCachePath: String { NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last ?? "" }
public var BundlePath: (String) -> String? = { Bundle.main.path(forResource: $0, ofType: nil) }

public let kAPP_Version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
public let kAPP_Build_Number: String = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
public let kApp_Name: String = {
    let localizedInfo = Bundle.main.localizedInfoDictionary ?? [:]
    let info = Bundle.main.infoDictionary ?? [:]
    return  localizedInfo["CFBundleDisplayName"] as? String ??
            info["CFBundleDisplayName"] as? String ??
            localizedInfo["CFBundleName"] as? String ??
            info["CFBundleName"] as? String ?? ""
}()
public let kBundle_Id: String = Bundle.main.bundleIdentifier ?? ""
public let kSystem_OS_Version = {
    let version = ProcessInfo.processInfo.operatingSystemVersion
    return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
} ()

// MARK: - 其他

// 判断2个CF字符串是否相等
public var CFStringEqual: (CFString, CFString) -> Bool = { CFStringCompare($0, $1, []) == .compareEqualTo }


