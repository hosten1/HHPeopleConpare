//
//  HHBaiduMapViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHBaiduMapViewController.h"
#import "UIImage+Extention.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import "WayPointRouteSearchDemoViewController.h"


#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
@interface HHBaiduMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate>{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}


@property(nonatomic, weak)UIView *headerView;
@property(nonatomic, strong)BMKMapView *mapView;
//定位功能
@property(nonatomic, strong)BMKLocationService *locationService;
//检索功能
@property(nonatomic, strong)BMKGeoCodeSearch *sgeoCodeSearch;

//路线规划
@property(nonatomic, strong)BMKRouteSearch *routeSearch;

@property(nonatomic, assign)CLLocationCoordinate2D userCootdinate;
@property(nonatomic, assign)CLLocationCoordinate2D shopCootdinate;
/**记录时间 即距离**/
@property(nonatomic, weak)UILabel *distanceLable;
@property(nonatomic, weak)UILabel *duratanceLable;

@end

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@implementation HHBaiduMapViewController
-(void)dealloc{
    if (_mapView) {
        _mapView = nil;
    }
    if (_routeSearch) {
        _routeSearch = nil;
    }
    if (_sgeoCodeSearch) {
        _sgeoCodeSearch = nil;
    }
}
/**懒加载初始化数据***/
-(BMKGeoCodeSearch *)sgeoCodeSearch{
    //检索功能初始化
    if (_sgeoCodeSearch == nil) {
        //初始化检索对象
        _sgeoCodeSearch =[[BMKGeoCodeSearch alloc]init];
        _sgeoCodeSearch.delegate = self;
            }
    return _sgeoCodeSearch;
}
//位置初始化
-(BMKLocationService *)locationService{
    if (_locationService == nil) {
        _locationService = [[BMKLocationService alloc ]init];
        _locationService.delegate = self;
    }
    return _locationService;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }

    // Do any additional setup after loading the view.
    //启动地图定位服务
    [self.locationService startUserLocationService];
    [self addMApHeader];
    [self setupMapBaseSetting];
    [self setupSearch];
    //路径规划
    [self setupRouteSearch];
    [self addBackUserLocation];
}
//返回到用户的当前位置
-(void)addBackUserLocation{
    
    UIButton  *userLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *userLocationBtnimg = [UIImage imageNamed:@"ic_back_u"] ;
    userLocationBtnimg = [UIImage scaleImage:userLocationBtnimg toScale:0.5];
    [userLocationBtn setBackgroundImage:userLocationBtnimg forState:UIControlStateNormal];
    //返回按钮点击事件
    [userLocationBtn addTarget:self action:@selector(userLocationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    userLocationBtn.frame = CGRectMake(10,mScreenSize.height-30 ,40, 15);
    [userLocationBtn setTitle:@"点击我回到你的位置" forState:UIControlStateNormal];
    [userLocationBtn setBackgroundColor:[UIColor grayColor]];
    userLocationBtn.titleLabel.font = [UIFont systemFontOfSize:8];
    [self.view addSubview:userLocationBtn];

}
-(void)userLocationBtnClick{
    
    [self.mapView setCenterCoordinate:self.userCootdinate animated:YES];
}
#pragma mark  ---路径规划类
-(void)setupRouteSearch{
    _routeSearch = [[BMKRouteSearch alloc]init];
   
}
-(void)setupSearch{
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    
    
    //获取沙盒记录
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *oldCity = [user objectForKey:@"cityName"];
    geoCodeSearchOption.city= oldCity;
    geoCodeSearchOption.address = self.shopDate.homeAddress;
    
    BOOL flag = [_sgeoCodeSearch geoCode:geoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }

}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
#pragma mark  --地图定位
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    if (self.userCootdinate.latitude != 0) {
//        return;
//    }
    NSLog(@"获取用户位置");
   
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
    //赋值给全局
    self.userCootdinate = userLocation.location.coordinate;
    //设置地图中心点
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = userLocation.location.coordinate;//中心点
    region.span.latitudeDelta = 0.03;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.05;//纬度范围 [_mapView setRegion:region animated:YES];
    [self.mapView setRegion:region animated:YES];
//    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    //获取一次后停止
    [self.locationService stopUserLocationService];
//    [self.mapView ];
}
/*******地图基本的设置*******/
-(void)setupMapBaseSetting{
    CGFloat mapX = CGRectGetMaxY(self.headerView.frame)+5;
    BMKMapView *mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, mapX, mScreenSize.width, mScreenSize.height-40)];
    mapView.mapType = BMKMapTypeStandard;
    
    [self.view addSubview:mapView];
    _mapView.mapType = BMKMapTypeNone;//设置地图为空白类型
    //设置显示范围
    _mapView.zoomLevel = 20;
   
    self.mapView = mapView;
}
-(void)addMApHeader{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 64)];
    self.headerView = headerView;
//    CGSize sizze = headerView.frame.size;
    
    UIButton  *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"ic_back_u"] ;
    img = [UIImage scaleImage:img toScale:0.5];
    [headerBtn setBackgroundImage:img forState:UIControlStateNormal];
    //返回按钮点击事件
    [headerBtn addTarget:self action:@selector(mapbackBtn) forControlEvents:UIControlEventTouchUpInside];
    headerBtn.frame = CGRectMake(10,13+20 , 10, 15);
    
    [headerView addSubview:headerBtn];
    
   /**公交***/
    UIButton  *busBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *img = [UIImage imageNamed:@"ic_back_u"] ;
//    img = [UIImage scaleImage:img toScale:0.5];
//    [headerBtn setBackgroundImage:img forState:UIControlStateNormal];
    NSInteger marginY = 10;
//    //返回按钮点击事件
    [busBtn setBackgroundColor:[UIColor redColor]];
    [busBtn addTarget:self action:@selector(onClickBusSearch) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat busx = CGRectGetMaxX(headerBtn.frame)+130;
    busBtn.frame = CGRectMake(busx,13+marginY , 50, 15);
    [busBtn setTitle:@"公交" forState:UIControlStateNormal];
    [headerView addSubview:busBtn];
    
    UIButton  *walkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    UIImage *img = [UIImage imageNamed:@"ic_back_u"] ;
    //    img = [UIImage scaleImage:img toScale:0.5];
    //    [walkBtn setBackgroundImage:img forState:UIControlStateNormal];
    //    //返回按钮点击事件
    [walkBtn setBackgroundColor:[UIColor redColor]];
    [walkBtn addTarget:self action:@selector(onClickWalkSearch) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat walkx = CGRectGetMaxX(busBtn.frame)+10;

     walkBtn.frame = CGRectMake(walkx,13+marginY , 50, 15);
    
    [walkBtn setTitle:@"步行" forState:UIControlStateNormal];
    [headerView addSubview:walkBtn];
    
    
    
    UIButton  *driverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    UIImage *img = [UIImage imageNamed:@"ic_back_u"] ;
    //    img = [UIImage scaleImage:img toScale:0.5];
    //    [driverBtn setBackgroundImage:img forState:UIControlStateNormal];
    //    //返回按钮点击事件
    [driverBtn setBackgroundColor:[UIColor redColor]];
    CGFloat drivex = CGRectGetMaxX(walkBtn.frame)+10;
    
    
//    NSLog(@"driver:%lf",drivex);
    driverBtn.frame = CGRectMake(drivex,13+marginY, 50, 15);

    [driverBtn addTarget:self action:@selector(onClickDriveSearch) forControlEvents:UIControlEventTouchUpInside];
//    driverBtn.frame = CGRectMake(8,13 , 10, 15);
    
    [driverBtn setTitle:@"驾车" forState:UIControlStateNormal];
    [headerView addSubview:driverBtn];
    
    UILabel *distanceLable = [[UILabel alloc]init];
    CGFloat disx = busx;
    CGFloat disy = CGRectGetMaxY(busBtn.frame)+5;
    distanceLable.frame = CGRectMake(disx, disy, 100, 20);
//    distanceLable.backgroundColor = [UIColor grayColor];
    distanceLable.font = [UIFont systemFontOfSize:12];
    self.distanceLable = distanceLable;
    [headerView addSubview:distanceLable];
    
    UILabel *duratanceLable = [[UILabel alloc]init];
    CGFloat durax = CGRectGetMaxX(distanceLable.frame)+5;
    CGFloat duray = disy;
    duratanceLable.frame = CGRectMake(durax, duray, 100, 20);
//    duratanceLable.backgroundColor = [UIColor grayColor];
    duratanceLable.textColor = [UIColor orangeColor];
    duratanceLable.font = [UIFont systemFontOfSize:12];
    self.duratanceLable = duratanceLable;
    [headerView addSubview:duratanceLable];
    
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
}
-(void)mapbackBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    // 添加一个PointAnnotation
    [super viewDidAppear:animated];
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    if (self.shopDate != nil ) {
//        if (self.shopCootdinate.latitude > 0) {
//            
//            
//        annotation.coordinate = self.shopCootdinate;
//        annotation.title = self.shopDate.homeCellTitle;
//        annotation.subtitle = self.shopDate.homeAddress;
//
//        }
//    }else{
//        coor.latitude = 34.223;
//        //34.223,108.952
//        coor.longitude = 108.952;
//        annotation.coordinate = coor;
//        annotation.title = @"这里是西安";
//    }
//    BMKCoordinateRegion region ;//表示范围的结构体
//    region.center = coor;//中心点
//    region.span.latitudeDelta = 0.01;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
//    region.span.longitudeDelta = 0.02;//纬度范围 [_mapView setRegion:region animated:YES];
//    [self.mapView setRegion:region animated:YES];
//    [_mapView addAnnotation:annotation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routeSearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _sgeoCodeSearch.delegate = nil;
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _routeSearch.delegate = nil;
}
#pragma mark -- 地图检索代理方法
//实现Deleage处理回调结果
//接收正向编码结果
-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        CLLocationCoordinate2D corlocation = result.location;
        self.shopCootdinate = corlocation;
        NSString * shopAddress = result.address;
        NSLog(@"shopAddress%@",shopAddress);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }

}
#pragma mark   --- 地图代理方法

-(void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status{
//    CLLocationCoordinate2D corr = [status targetGeoPt];
//    NSLog(@"拖动我了:%lf",corr.longitude);
//    [mapView setCenterCoordinate:corr animated:YES];
}
#pragma mark   -- 地图标注
-(BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
#pragma mark --- 路径规划

- (void)wayPointDemo {
    
    WayPointRouteSearchDemoViewController * wayPointCont = [[WayPointRouteSearchDemoViewController alloc]init];
    wayPointCont.title = @"驾车途经点";
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    [self.navigationController pushViewController:wayPointCont animated:YES];
}

#pragma mark - BMKMapViewDelegate

//- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
//{ if ([annotation isKindOfClass:[RouteAnnotation class]]) {
//return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
//}

//       return nil;
//}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - BMKRouteSearchDelegate
/**公交的方案**/
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
//        BMKRouteLine(_distance,_duration)
        
        [self setLableText:plan];
    // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}
/***自驾**/
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        
        [self setLableText:plan];
        
        
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}
-(void)setLableText:(BMKRouteLine*)plan{
    CGFloat distance = plan.distance;
    BMKTime *time = plan.duration;
    /**
     int       _dates;
     int       _hours;
     int       _minutes;
     int       _seconds;
     */
    NSString *dura = nil;
    if (time.hours) {
        dura = [NSString stringWithFormat:@"用时:%d小时%d分",time.hours,time.minutes];
    }else if(time.minutes){
        dura = [NSString stringWithFormat:@"用时:%d分",time.minutes];
    }
    /*添加显示*/
    NSString *distanceStr = nil;
    if (distance > 1000) {
        distance = distance/1000;
        distanceStr = [NSString stringWithFormat:@"距离:%.2lf公里",distance];
    }else{
        distance = distance;
        distanceStr = [NSString stringWithFormat:@"距离:%.2lf米",distance];
    }
    self.distanceLable.text = distanceStr;
    self.duratanceLable.text = dura;
    NSLog(@"%@",dura);

}
/***********步行************/
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        
        
        [self setLableText:plan];
        
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetRidingRouteResult error:%d", (int)error);
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKRidingRouteLine* plan = (BMKRidingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:i];
            if (i == 0) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
            } else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.degree = (int)transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

#pragma mark - action

-(void)onClickBusSearch
{
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
  
    start.pt = self.userCootdinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D shop = CLLocationCoordinate2DMake([self.shopDate.homeLatitude doubleValue], [self.shopDate.homeLongitude doubleValue]);
    end.pt = shop;
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    //获取沙盒记录
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString  *city =[user objectForKey:@"cityName"];
    //    NSLog(@"address>>>%@",address);
    if (city.length == 0) {
        city = @"西安市";
    }

    transitRouteSearchOption.city= city;
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routeSearch transitSearch:transitRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }
}



-(void)onClickDriveSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    
    start.pt = self.userCootdinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D shop = CLLocationCoordinate2DMake([self.shopDate.homeLatitude doubleValue], [self.shopDate.homeLongitude doubleValue]);
    end.pt = shop;
    
//    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
//    //获取沙盒记录
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString  *city =[user objectForKey:@"cityName"];
//    //    NSLog(@"address>>>%@",address);
//    if (city.length == 0) {
//        city = @"西安市";
//    }
//    
//    transitRouteSearchOption.city= city;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routeSearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}

-(void)onClickWalkSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    
    start.pt = self.userCootdinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D shop = CLLocationCoordinate2DMake([self.shopDate.homeLatitude doubleValue], [self.shopDate.homeLongitude doubleValue]);
    end.pt = shop;

    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routeSearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
    
}

- (void)onClickRidingSearch:(id)sender {
   
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    
    start.pt = self.userCootdinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D shop = CLLocationCoordinate2DMake([self.shopDate.homeLatitude doubleValue], [self.shopDate.homeLongitude doubleValue]);
    end.pt = shop;
    
    
    BMKRidingRoutePlanOption *option = [[BMKRidingRoutePlanOption alloc]init];
    option.from = start;
    option.to = end;
    BOOL flag = [_routeSearch ridingSearch:option];
    if (flag)
    {
        NSLog(@"骑行规划检索发送成功");
    }
    else
    {
        NSLog(@"骑行规划检索发送失败");
    }
}

#pragma mark - 私有

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}



@end
