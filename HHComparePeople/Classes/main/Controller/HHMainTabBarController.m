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
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface HHMainTabBarController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (strong, nonatomic)  BMKLocationService *locService;
@property (strong, nonatomic)CLLocation *cllocation;
@property (strong, nonatomic)BMKReverseGeoCodeOption *reverseGeoCodeOption;//逆地理编码
@property (nonatomic, strong) BMKGeoCodeSearch *geoCode;
@end

@implementation HHMainTabBarController
#pragma mark geoCode的Get方法，实现延时加载
- (BMKGeoCodeSearch *)geoCode
{
    if (!_geoCode) {
        _geoCode = [[BMKGeoCodeSearch alloc] init];
        _geoCode.delegate = self;
    }
    return _geoCode;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /**********开始获取定位信息*************/
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled ]) {
        
        NSLog(@"定位服务打开");
    }
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        NSLog(@"授权成功");
        //请求成功后设置代理
        
    }else{
        NSLog(@"授权失败");
    }
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
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

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
    
    // 初始化反地址编码选项（数据模型）
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    // 将TextField中的数据传到反地址编码模型
    option.reverseGeoPoint = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    // 调用反地址编码方法，让其在代理方法中输出
    [self.geoCode reverseGeoCode:option];
}

#pragma mark 代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    /**    @property (nonatomic, strong) NSString* streetNumber;
    /// 街道名称
    @property (nonatomic, strong) NSString* streetName;
    /// 区县名称
    @property (nonatomic, strong) NSString* district;
    /// 城市名称
    @property (nonatomic, strong) NSString* city;
    /// 省份名称
    @property (nonatomic, strong) NSString* province;
    */
    if (result) {
        BMKAddressComponent* addressDetail = result.addressDetail;
        NSLog(@"%@ - %@", addressDetail.city, result.addressDetail.streetNumber);
        //存入沙盒 用户偏好设置中
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:addressDetail.city forKey:@"cityName"];
        [userDefault synchronize];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

        [user setObject:addressDetail.city forKey:@"LocationCityName"];
        [user synchronize];
    }else{
//        self.address.text = @"找不到相对应的位置信息";
    }
}
@end
