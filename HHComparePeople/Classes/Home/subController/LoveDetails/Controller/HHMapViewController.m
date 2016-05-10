//
//  HHMapViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HHMyAnnoatation.h"
#import "UIImage+Extention.h"
#define mScreenSize [UIScreen mainScreen].bounds.size

@interface HHMapViewController ()<MKMapViewDelegate>
@property(nonatomic, weak)UIView *headerView;
@property(nonatomic, weak)MKMapView *mapView;
@end

@implementation HHMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addHeader];
    // Do any additional setup after loading the view.
    //初始化地图
    MKMapView *mapView = [[MKMapView alloc]init];
    self.mapView = mapView;
    mapView.frame = CGRectMake(0, 40, mScreenSize.width, mScreenSize.height);
    [self.view addSubview:mapView];
    //是否显示当前位置
    mapView.showsUserLocation = YES;
    //追踪用户位置
    mapView.userTrackingMode = MKUserTrackingModeFollow;
    mapView.delegate =self;
    //地图类型
    //使用第三方的地图可以查找周边环境的餐馆，学校之类的
    /*
     MKMapTypeStandard 标准地图
     MKMapTypeSatellite 卫星地图
     MKMapTypeHybrid 混合地图
     */
    mapView.mapType =  MKMapTypeStandard;
    
    HHMyAnnoatation *myannoation = [[HHMyAnnoatation alloc]init];
    

    CLLocationCoordinate2D coor2d = {34.227079,108.931505 };
    myannoation.coordinate = coor2d;
//    //显示范围，数值越大，范围就越大
    MKCoordinateSpan span = {0.1,0.13};
    MKCoordinateRegion region = {coor2d,span};
 
    //地图初始化时显示的区域
    [mapView setRegion:region];
    //返回到用户=所在位置的按钮
    [self backLocation];
    
}
/*********返回到定位的位置*************/
-(void)backLocation{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, mScreenSize.height-30, 30, 30);
//   [ backBtn setBackgroundColor:[UIColor orangeColor]];
//    [backBtn setTitle:@"点击按钮返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_map_locate"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_map_locate_hl"]forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(btnclickBackLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
}
-(void)btnclickBackLocation{
    
//    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
//    CLLocationCoordinate2D coor2d = {34.223,108.952 };
    //    //显示范围，数值越大，范围就越大
    MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.userLocation.coordinate , span);
    
    [self.mapView setRegion:region];
}
-(void)addHeader{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    self.headerView = headerView;
    //    CGSize sizze = headerView.frame.size;
    UIButton  *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"ic_back_u"] ;
    img = [UIImage scaleImage:img toScale:0.5];
    [headerBtn setBackgroundImage:img forState:UIControlStateNormal];
    //返回按钮点击事件
    [headerBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    headerBtn.frame = CGRectMake(8,13 , 10, 20);
    headerBtn.tag = 1000003;
    [headerView addSubview:headerBtn];
    /******分享*****/
    UIButton  *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shareimg = [UIImage imageNamed:@"detail_topbar_icon_share"] ;
    shareimg = [UIImage scaleImage:shareimg toScale:0.5];
    [shareBtn setBackgroundImage:shareimg forState:UIControlStateNormal];
    //分享按钮点击事件
    [shareBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.frame = CGRectMake(mScreenSize.width-90,11 , 20, 20);
    shareBtn.tag = 1000002;
    [headerView addSubview:shareBtn];
    /**********关注按钮**********/
    UIButton  *attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *attentionBtnimg = [UIImage imageNamed:@"shou1"] ;
    attentionBtnimg = [UIImage scaleImage:attentionBtnimg toScale:0.5];
    UIImage *attentionBtnimgSelect = [UIImage imageNamed:@"shou2"] ;
    attentionBtnimgSelect = [UIImage scaleImage:attentionBtnimg toScale:0.5];
    
    [attentionBtn setBackgroundImage:attentionBtnimgSelect forState:UIControlStateSelected];
    [attentionBtn setBackgroundImage:attentionBtnimg forState:UIControlStateNormal];
    //收藏按钮点击事件
    [attentionBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    attentionBtn.frame = CGRectMake(mScreenSize.width-40,11 , 20, 20);
    attentionBtn.tag = 1000001;
    [headerView addSubview:attentionBtn];
    
    
    [self.view addSubview:headerView];
}
-(void)backBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - mapview delegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //取出用户位置
    CLLocationCoordinate2D cootdinate = userLocation.location.coordinate;
    NSLog(@"%lf",cootdinate.latitude);
    //设置地图显示用户当前的位置
    [mapView setCenterCoordinate:cootdinate];
    //设置地图显示区域
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(cootdinate, span);
    [mapView setRegion:region];
    //设置大头针属性
    CLGeocoder *gecoder = [[CLGeocoder alloc]init];
    CLLocation *location = userLocation.location;
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            return ;
        }
        CLPlacemark *pm = [placemarks firstObject];
        
        if (pm.location) {
            userLocation.title = pm.locality;
        }else{
            
        userLocation.title = pm.administrativeArea;
          
        }
        userLocation.subtitle = pm.name;
    }];
    
}
#pragma mark -- 地图定位偏差
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    MKCoordinateRegion region = mapView.region;
    CLLocationCoordinate2D center = region.center;
    MKCoordinateSpan span = region.span;
    NSLog(@"latitu:%lf longtity:%lf",center.latitude,center.longitude);
}

@end
