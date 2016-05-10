//
//  HHDetailsShopsViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHDetailsShopsViewController.h"
#import "UIImage+Extention.h"
#import <CoreLocation/CoreLocation.h>
#import "HHSecondTitleVeiw.h"

#define mScreenSize [UIScreen mainScreen].bounds.size

@interface HHDetailsShopsViewController ()
@property(nonatomic, weak)UIView *detailheaderView;
@end

@implementation HHDetailsShopsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
//    [self initLocationService];
    NSLog(@"类别是：%@",self.titleTextSender);

        [self addHeader];
    
    
        [self addsecondHeader];
    
    
    
}
-(void)addsecondHeader{
    HHSecondTitleVeiw *titleView = [HHSecondTitleVeiw addSecondTitleView];
    titleView.frame = CGRectMake(0, CGRectGetMaxY(self.detailheaderView.frame)+3, mScreenSize.width, 44);
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
}
/***********头部***********/
-(void)addHeader{
    if (self.detailheaderView) {
       
        return;
    }

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenSize.width, mScreenSize.height*0.06)];
    self.detailheaderView = headerView;
    CGSize sizze = headerView.frame.size;
    UIButton  *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"ic_back_u"];
    img = [UIImage scaleImage:img toScale:0.5];
    [headerBtn setBackgroundImage:img forState:UIControlStateNormal];
    //返回按钮点击事件
    [headerBtn addTarget:self action:@selector(detailheaderViewBtn) forControlEvents:UIControlEventTouchUpInside];
    headerBtn.frame = CGRectMake(8,13 , 10, 15);
    
    [headerView addSubview:headerBtn];
    
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(sizze.width*0.45,15, 100, sizze.height*0.33)];
    headerLab.text = @"商户信息";
    [headerView addSubview:headerLab];
    
    
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
}
-(void)detailheaderViewBtn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
