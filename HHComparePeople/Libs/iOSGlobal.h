//
//  iOSGlobal.h
//
//  Created by stlwtr on 13-10-11.
//  Copyright (c) 2013年 stlwtr. All rights reserved.
//

#ifndef iOSGlobal_h
#define iOSGlobal_h
#import <Availability.h>
/// arc and noarc
#if __has_feature(objc_arc)
#define cf_bridge_id __bridge id
#define cf_bridge __bridge
#define safe_release( __v__ )
#define safe_dealloc( __v__ )
#define safe_autorelease( __v__ ) __v__
#else
#define cf_bridge_id id
#define cf_bridge
#define safe_release( __v__ ) [__v__ release]
#define safe_dealloc( __v__ ) [__v__ dealloc]
#define safe_autorelease( __v__ ) [__v__ autorelease]
#endif

#pragma mark - Device && Screen
/// 判断是否是iPhone5
#define isPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
/// 是否iPad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
/// 是否模拟器
#ifdef TARGET_IPHONE_SIMULATOR
#define isSimulator TARGET_IPHONE_SIMULATOR
#endif

/// 屏幕高度、宽度
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
#pragma mark - System Version
/// 当前系统版本大于等于某版本
#define IOS_SYSTEM_VERSION_EQUAL_OR_ABOVE(v) (([[[UIDevice currentDevice] systemVersion] floatValue] >= (v))? (YES):(NO))
/// 当前系统版本小于等于某版本
#define IOS_SYSTEM_VERSION_EQUAL_OR_BELOW(v) (([[[UIDevice currentDevice] systemVersion] floatValue] <= (v))? (YES):(NO))
/// 当前系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define iOS7 (IOS_SYSTEM_VERSION >= 7.0)

/// 系统语言
#define IOS_SYSTEM_Language ([[NSLocale preferredLanguages] objectAtIndex:0])

/// 当前应用版本号
#define AppVersion [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]

#pragma mark - common path
/// 常用文件路径
#define PathForDocument NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define PathForLibrary  NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES)[0]
#define PathForCaches   NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES)[0]

#pragma mark - shared tool

#define SharedUserDefault         [NSUserDefaults standardUserDefaults]
#define SharedNotificationCenter  [NSNotificationCenter defaultCenter]
#define SharedFileManager         [NSFileManager defaultManager]
#define SharedApplicationDelegate [[UIApplication sharedApplication] delegate]

#pragma mark - image && color
/// 加载图片
#define UIImageLoad(name, type)     [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:type]]
#define UIImageNamed( name )    [UIImage imageNamed: name]
/// 颜色
#define UIColorWithRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorWithRGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
/// 方正黑体简体字体定义
#define UIFontWithSize( __size__ ) [UIFont systemFontOfSize: __size__]
#define UIFontBoldWithSize( __size__ ) [UIFont boldSystemFontOfSize: __size__]



#pragma mark - NSString format
/** data format */

#define NSStringFromNumber_c( __v__ ) [NSString stringWithFormat:@"%@", @(__v__)]
#define NSStringFromObject_oc( __v__ ) [NSString stringWithFormat:@"%@", __v__]

#pragma mark - DEBUG
/** ======================= 调试相关宏定义 ========================== */
/// 添加调试控制台输出
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d]\n😄 " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define ELog(fmt, ...) NSLog((@"%s [Line %d]\n😥 " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#define ELog(...)
#define NSLog(...)
#endif
/// 是否输出dealloc log
//#define Dealloc
#ifdef Dealloc
#define DeallocLog(fmt, ...) NSLog((fmt @"dealloc ..."), ##__VA_ARGS__);
#else
#define DeallocLog(...)
#endif

#endif
