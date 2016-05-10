//
//  AppDelegate.m
//  HHComparePeople
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "AppDelegate.h"
#import <SMS_SDK/SMSSDK.h>
#import "HHMainViewController.h"
#import "HHMainTabBarController.h"
#define kVersionKey @"versioncode"
@interface AppDelegate ()
@property(nonatomic, strong)BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *main = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //    main.backgroundColor = [UIColor grayColor];
    
    self.window = main;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [self showScrollView];
    //判断滑动图是否出现过，第一次调用时“isScrollViewAppear” 这个key 对应的值是nil，会进入if中
    NSString *currentVersionCode = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    NSString *lsatVersionCode = [userDefaults objectForKey:kVersionKey];
    
    //    NSLog(@"%@>>>>>>%@",lsatVersionCode,currentVersionCode);
    if (![currentVersionCode isEqualToString:lsatVersionCode]) {
        
        
        HHMainViewController *newFeature = [[HHMainViewController alloc]init];
        
        main.rootViewController = newFeature;
    }else{
        //创建tabbar
        HHMainTabBarController *tabBarVc = [[HHMainTabBarController alloc]init];
        
        
        //设置根控制器
        [main setRootViewController:tabBarVc];
    }
    
    
    
    [main makeKeyAndVisible];
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"S7zL1E6E7SAg8blqbA1vVQ4ghAVFIavy"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    [SMSSDK registerApp:@"ee7daef626c0" withSecret:@"b1dd8c990e6d56dcb2952c1cad8e4a4f"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
