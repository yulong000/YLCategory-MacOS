//
//  Marco.h
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#ifndef Marco_h
#define Marco_h

/****************************************  打印 ** ***********************************/

#if DEBUG
#   define YLLog(...) NSLog(__VA_ARGS__)
#else
#   define YLLog(...)
#endif

/****************************************  颜色 ** ***********************************/


// 纯白色
#define WhiteColor                  [NSColor whiteColor]
// 纯黑色
#define BlackColor                  [NSColor blackColor]
// 透明色
#define ClearColor                  [NSColor clearColor]
// 灰色
#define GrayColor                   [NSColor grayColor]
// 深灰色
#define DarkGrayColor               [NSColor darkGrayColor]   // 0.333 white
// 亮灰色
#define LightGrayColor              [NSColor lightGrayColor]  // 0.667 white
// 红色
#define RedColor                    [NSColor redColor]
// 绿色
#define GreenColor                  [NSColor greenColor]
// 橙色
#define OrangeColor                 [NSColor orangeColor]
// 黄色
#define YellowColor                 [NSColor yellowColor]
// 蓝色
#define BlueColor                   [NSColor blueColor]
// 系统蓝色
#define SystemBlueColor             [NSColor systemBlueColor]
// control accent color
#define ControlAccentColor          [NSColor controlAccentColor]
// r, g, b, a 颜色
#define RGBA(r, g, b, a)            [NSColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
// r=g=b, a=1 颜色
#define RGB(r)                      [NSColor colorWithRed:r / 255.0 green:r / 255.0 blue:r / 255.0 alpha:1.0]
// 16进制颜色
#define Hex(s)                      [NSColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0  alpha:1.0]
// 随机颜色
#define RandomColor                 [NSColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1]
// 半透明黑
#define BlackColorAlpha(a)          [NSColor colorWithWhite:0 alpha:a]
// 半透明白
#define WhiteColorAlpha(a)          [NSColor colorWithWhite:1 alpha:a]

/****************************************  数据类型转换  ***********************************/

// int float -> string
#define NSStringFromInt(int)            [NSString stringWithFormat:@"%d", int]
#define NSStringFromUInt(int)           [NSString stringWithFormat:@"%u", int]
#define NSStringFromInteger(integer)    [NSString stringWithFormat:@"%zd", integer]
#define NSStringFromUInteger(integer)   [NSString stringWithFormat:@"%tu", integer]
#define NSStringFromFloat(float)        [NSString stringWithFormat:@"%f", float]
#define NSStringFromFloatPrice(float)   [NSString stringWithFormat:@"%.2f", float]


/****************************************  屏幕  ***********************************/

#define kScreenScale                    [NSScreen mainScreen].backingScaleFactor
#define kScreenWidth                    [NSScreen mainScreen].frame.size.width
#define kScreenHeight                   [NSScreen mainScreen].frame.size.height
#define kStatusBarHeight                [NSApp mainMenu].menuBarHeight

/****************************************  字体  ***********************************/

// 字体大小
#define Font(size)                      [NSFont systemFontOfSize:size]
#define BoldFont(size)                  [NSFont boldSystemFontOfSize:size]
#define MediumFont(size)                [NSFont systemFontOfSize:size weight:NSFontWeightMedium]


/****************************************  快捷方法  ***********************************/

// weakself
#define WeakObject(obj)                 __weak typeof(obj) weak##obj = obj;
#define WeakSelf                        __weak typeof(self) weakSelf = self;

// 从中心拉伸图片
#define StretchImageName(imageName)     [[NSImage imageNamed:imageName] \
                                        stretchableImageWithLeftCapWidth:ImageWithName(imageName).size.width * 0.5 \
                                        topCapHeight:ImageWithName(imageName).size.height * 0.5]
#define StretchImage(image)             [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 \
                                        topCapHeight:image.size.height * 0.5]
// 从指定位置拉伸图片
#define StretchImageNameWith(imageName, left, top)  [[NSImage imageNamed:imageName] \
                                                    stretchableImageWithLeftCapWidth:left topCapHeight:top]
#define StretchImageWith(image, left, top)          [image stretchableImageWithLeftCapWidth:left topCapHeight:top]

// 系统当前是否是深色模式
#define kSystemIsDarkTheme          \
^ BOOL{                             \
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:NSGlobalDomain];    \
    id style = [dict objectForKey:@"AppleInterfaceStyle"];  \
    return style && [style isKindOfClass:[NSString class]] && NSOrderedSame == [style caseInsensitiveCompare:@"dark"];  \
}()

// 判断当前app是否是深色模式
#define kAppIsDarkTheme                    ([NSApp.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua, NSAppearanceNameAqua]] == NSAppearanceNameDarkAqua)
// 是否是沙盒模式
#define kAppIsSandbox                   ([[[NSProcessInfo processInfo] environment] objectForKey:@"APP_SANDBOX_CONTAINER_ID"] != nil)

// 文件路径
#define kDocumentPath                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define kCachePath                      [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define kBundlePath(file)               [[NSBundle mainBundle] pathForResource:file ofType:nil]

// app版本号
#define kAPP_Version                    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// building 号
#define kAPP_Build_Number               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
// app Name
#define kAPP_Name                       ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] ?: [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleName"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
// bundle id
#define kBundle_id                      [NSBundle mainBundle].bundleIdentifier
// 系统版本号
#define kSystem_OS_Version              [NSString stringWithFormat:@"%ld.%ld.%ld", [NSProcessInfo processInfo].operatingSystemVersion.majorVersion, [NSProcessInfo processInfo].operatingSystemVersion.minorVersion, [NSProcessInfo processInfo].operatingSystemVersion.patchVersion]

// 判断2个CF字符串是否相等
#define CFStringEqual(str1, str2)       (CFStringCompare(str1, str2, 0) == kCFCompareEqualTo)

#endif /* Marco_h */
