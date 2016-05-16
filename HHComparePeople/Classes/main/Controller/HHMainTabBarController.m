//
//  HHMainTabBarController.m
//  HankowThamesCode
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHMainTabBarController.h"
#import "HHHomeViewController.h"
#import "HHGroupViewController.h"
#import "HHFinderViewController.h"
#import "HHMyMessagesViewController.h"

@interface HHMainTabBarController ()

@end

@implementation HHMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTabBarSubContrller];
}
-(void)addTabBarSubContrller{
    
    NSMutableArray *mutArray = [[NSMutableArray alloc]init];
    
    //主页
 
    HHHomeViewController *home = [[HHHomeViewController alloc]init];
    UINavigationController *navHome = [[UINavigationController alloc]initWithRootViewController:home];
    [mutArray addObject:navHome];
    //团购优惠也
    HHGroupViewController *group = [[HHGroupViewController alloc]init];
    UINavigationController *navGroup = [[UINavigationController alloc]initWithRootViewController:group];
    [mutArray addObject:navGroup];
    //发现
    HHFinderViewController *finder = [[HHFinderViewController alloc]init];
    UINavigationController *navFinder = [[UINavigationController alloc]initWithRootViewController:finder];
    [mutArray addObject:navFinder];
    
    //我的个人中心也
    HHMyMessagesViewController *myMessage = [[HHMyMessagesViewController alloc]init];
    UINavigationController *navMyMessage = [[UINavigationController alloc]initWithRootViewController:myMessage];
    [mutArray addObject:navMyMessage];
    //添加到tabbar中
    
    [self setViewControllers:mutArray];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
