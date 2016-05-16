//
//  HHMainViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHMainViewController.h"
#import "HHMainTabBarController.h"
#import "HHHomeViewController.h"
#import "HHGroupViewController.h"
#import "HHFinderViewController.h"
#import "HHMyMessagesViewController.h"
#import "EAIntroView.h"

#define kVersionKey @"versioncode"
static NSString * const sampleDescription1 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
static NSString * const sampleDescription2 = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
static NSString * const sampleDescription3 = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
static NSString * const sampleDescription4 = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";


@interface HHMainViewController ()<EAIntroDelegate>
@property (weak, nonatomic)  UIButton *mainBtnView;
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (assign,nonatomic) int picCount;
@property (weak, nonatomic)  UIPageControl *WelcomPageControl;
@end

@implementation HHMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{

  [self showIntroWithCrossDissolve];//显示滑动图
    
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    
    [intro showInView:self.view animateDuration:0.3];
}
#pragma mark -- EAInroView delegate
-(void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped{
//    [self gotoTabbarVIew:nil];
}
-(void)intro:(EAIntroView *)introView pageEndScrolling:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex{
    
    if (pageIndex == 3) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(introView.bounds.size.width*0.3, introView.bounds.size.height/2, 150, 44);
        [btn setBackgroundColor:[UIColor colorWithRed:0.400 green:1.000 blue:0.400 alpha:1.000]];
        [btn setTitle:@"开始" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gotoTabbarVIew:) forControlEvents:UIControlEventTouchUpInside];
        [introView addSubview:btn];
    }
}
-(void)gotoTabbarVIew:(id)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *currentVersionCode = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    NSString *lsatVersionCode = [userDefaults objectForKey:kVersionKey];
    if (![currentVersionCode isEqualToString: lsatVersionCode]) {
        if (userDefaults) {
            
            [userDefaults setObject:currentVersionCode forKey:kVersionKey];
            [userDefaults synchronize];
        }
        }
        
     HHMainTabBarController *tabBarController = [[HHMainTabBarController alloc]init];
   
    //跳转
    [self presentViewController:tabBarController animated:YES completion:NULL];
}

@end
