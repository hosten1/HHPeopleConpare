//
//  HHDetailsViewConTroller.m
//  HankowThamesCode
//
//  Created by mac on 16/3/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHDetailsViewConTroller.h"
#import "UIImage+Extention.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
#import "HHDiscussShopDB.h"
#import "HHDiscussTableViewCell.h"
#import "HHDiscusses.h"
//#import "HHMapViewController.h"
#import "HHBaiduMapViewController.h"

#define mScreenSize [UIScreen mainScreen].bounds.size

@interface HHDetailsViewConTroller ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate
>
@property(nonatomic, strong)CLLocationManager *locationManager;

@property(nonatomic, weak)UIView *headerView;
@property(nonatomic, strong)UITableView *htableView;
@property(nonatomic, strong)NSArray *detailsArray;
@property(nonatomic, strong)HHDiscussShopDB *discussDB;
//获取定位后两者之间距离的方法
@property(nonatomic, assign)CGFloat locationDistance;
@end
@implementation HHDetailsViewConTroller

#pragma  mark --- 懒加载初始化表格
/**********懒加载初始化定位服务***************/
-(CLLocationManager *)locationManager{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        
        //        NSLog(@"获取定位初始化：%@",_locationMana);
        //设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        //定位的每隔多少米更新一次
        [_locationManager requestAlwaysAuthorization];
        _locationManager.distanceFilter = 50.0f;
    }
    
    return _locationManager;
}

-(HHDiscussShopDB *)discussDB{
    if (_discussDB == nil){
        
        _discussDB = [[HHDiscussShopDB alloc]init];
    }
    
    return _discussDB;
}
-(UITableView *)htableView{
    if (_htableView == nil) {
        CGFloat y = self.headerView.frame.size.height+self.headerView.frame.origin.y;
        NSLog(@"%lf,",mScreenSize.width);
        _htableView = [[UITableView alloc]initWithFrame:CGRectMake(0,y , mScreenSize.width, mScreenSize.height-y) style:UITableViewStyleGrouped];
        _htableView.delegate = self;
        _htableView.dataSource = self;
        [self.view addSubview:_htableView];
          }
    return _htableView;
}
-(NSArray *)detailsArray{
    if (_detailsArray == nil) {
//        NSLog(@"fffffgfhd%@",self.homeCellDatas.shopID);
        _detailsArray = [[NSArray alloc]init];
        //数据库加载数据
       _detailsArray = [self.discussDB findAllCityShopDiscountWithShopID:self.homeCellDatas.shopID];
        if (_detailsArray != nil) {
            
//            NSLog(@"获取到的数据shi:%@",_detailsArray);
        }
        
    }
    return _detailsArray;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
    
    _locationDistance = 100.0f;
  //插入数据库的测试数据
//    [self insertTable];
    //初始化定位服务
    [self initLocationService];
    //添加头部
    [self addHeader];
    //初始化表格
    [self addtableview];
}
#pragma mark -- 数据库插入数据
-(void)insertTable{
    /*****inser db*****/
    
        for (NSInteger i = 0; i < 5; i++) {
    
            HHDiscusses *discu = [[HHDiscusses alloc]init];
             NSInteger locLevel = arc4random_uniform(7)+1;
             NSInteger locId = arc4random()%100+100;
    
            discu.userID = [NSString stringWithFormat:@"%ld",locId];
            discu.nicheng = @"哈小子";
            discu.shopID =  self.homeCellDatas.shopID;
            discu.shijian = [self getCurrentData];
            discu.pinglun = @" startTime是一个全局变量,在别处可以调用,比如刚进程序的时候存一个时间值,程序结束的时候再调用,获得结束时间.";
            NSString *nameicon = [NSString stringWithFormat:@"firstcover0%ld",i];
            discu.icon = nameicon;
            discu.xingji = locLevel;
    
            //插入数据库
            [self.discussDB insertFromHistoryWithName:discu];
            
        }
}
#pragma mark -- 定位服务获取两点之间的距离
-(void)getCountDistanceWithLatitude:(CGFloat)currentLatitude longtitude:(CGFloat)currentLongtitude{
    //根据经纬度创建两个位置对象
    CLLocation *loc1=[[CLLocation alloc]initWithLatitude:currentLatitude longitude:currentLongtitude];
    CLLocation *loc2=[[CLLocation alloc]initWithLatitude:[self.homeCellDatas.homeLatitude doubleValue]longitude:[self.homeCellDatas.homeLongitude doubleValue]];
    //计算两个位置之间的距离
    CLLocationDistance distance= [loc1 distanceFromLocation:loc2];
//    distance
    if (distance >= 100) {
        
        self.locationDistance = distance;
        //重新初始化表格数据
        [self.htableView reloadData];
    }else{
        self.locationDistance = 100.0;
    }
    NSLog(@"(%@)和(%@)的距离=%fM",loc1,loc2,distance);
//    return distance;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark   -- 定位服务
-(void)initLocationService{
    /**********开始获取定位信息*************/
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled ]) {
        
        NSLog(@"定位服务打开");
    }
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        NSLog(@"授权成功");
        
        self.locationManager.delegate = self;
        //开启定位服务
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"授权失败");
    }
    
}
#pragma mark   ------定位服务的代理方法
/**********获取定位位置的代理方法************/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"出错了%@",error);
}
//定位方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = locations[0];
        CLLocationCoordinate2D oCoordinate = newLocation.coordinate;
    //计算两个位置之间的距离
    [self getCountDistanceWithLatitude:oCoordinate.latitude longtitude:oCoordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    
}

-(void)dealloc{
    
    [_locationManager stopUpdatingLocation];
}
/********获取系统当前时间点********/
-(NSString*)getCurrentData{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    return dateTime;
    
}
-(void)addHeader{
    
   UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenSize.width, 40)];
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
-(void)addtableview{
    

    [self.htableView setBackgroundColor:[UIColor clearColor]];
    
}
-(void)backBtn:(UIButton *)sender{
    if (sender.tag ==  1000001) {
        
        NSLog(@"收藏");
      
        sender.selected =  !sender.selected;
    }else if (sender.tag ==  1000002){
        NSLog(@"分享");
    }else if (sender.tag ==  1000003){
        
     [self dismissViewControllerAnimated:YES completion:nil];
 
    }
}
#pragma mark 设置tableView数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4) {
        return 3;
    }
    return 1;
}
#pragma mark  --设置头部和尾部
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1f;
    }else if (section == 2) {
        return 34;
    }else if(section == 3){
        return 35;
    }else if (section == 4) {
        return 30;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }else if (section == 2) {
        return 54;
    }
    return 5;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 44)];
        
        [self addHeaderOne:view imgFrame:CGRectMake(15, 15, 15, 15) labFrame:CGRectMake(36, 17, 40, 10) title:@"随时退"];
        
        [self addHeaderOne:view imgFrame:CGRectMake(90, 15, 15, 15) labFrame:CGRectMake(109, 17, 80, 10) title:@"免预约"];
        
        [self addHeaderOne:view imgFrame:CGRectMake(165, 15, 15, 15) labFrame:CGRectMake(185, 17, 80, 10) title:@"包满意"];
        return view;
    }else if (section == 2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 44)];
        UIButton *btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAll.frame = view.frame;
        [btnAll addTarget:self action:@selector(btnToMap) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnAll];
        view.backgroundColor = [UIColor whiteColor];

        UIImage *imaged = [UIImage imageNamed:@"ic_address_big"];
//        imaged = [UIImage scaleImage:imaged toScale:0.8];
        UIImageView *ImgView = [[UIImageView alloc]initWithImage:imaged];
        ImgView.frame = CGRectMake(10, 10, 20, 20);
        [view addSubview:ImgView];
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(30+5, 10, 200, 20)];
        NSString *name = [NSString stringWithFormat:@"%@",self.homeCellDatas.homeAddress];
        lab.textColor = [UIColor grayColor];
        lab.alpha = 0.7;
        lab.text = name;
        lab.font = [UIFont systemFontOfSize:14];
        [view addSubview:lab];
        
        UIImage *image = [UIImage imageNamed:@"arrow"];
        image = [UIImage scaleImage:image toScale:0.4];
        UIImageView *accsImgView = [[UIImageView alloc]initWithImage:image];
        accsImgView.frame = CGRectMake(mScreenSize.width-30, 10, 15, 15);
        
        UIView *margin = [[UIView alloc]initWithFrame:CGRectMake(0, 40, mScreenSize.width, 10)];
        //设置分割线
        margin.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
        [view addSubview:margin];
        [view addSubview:accsImgView];
        
        return view;

    
    }
    
    return nil;
}
#pragma mark -- 跳转到地图服务
-(void)btnToMap{
//    NSLog(@"到地图啦");
    HHBaiduMapViewController *BaiDumapView = [[HHBaiduMapViewController alloc]init];
    BaiDumapView.shopDate = self.homeCellDatas;
//    BaiDumapView.ShopLongitude = self.homeCellDatas.homeLongitude;
    [self presentViewController:BaiDumapView animated:YES completion:nil];
    
}
-(void)addHeaderOne:(UIView*)view imgFrame:(CGRect)imgFrame labFrame:(CGRect)labFrame title:(NSString*)title{
    view.backgroundColor = [UIColor whiteColor];
    UIImage *img = [UIImage imageNamed:@"icon_pay_success"];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:imgFrame];
    imgView.image = img;
    [view addSubview:imgView];
    
    UILabel *titlelab = [[UILabel alloc]initWithFrame:labFrame];
    
    titlelab.text = title;
    titlelab.font = [UIFont systemFontOfSize:12];
    titlelab.textColor = [UIColor greenColor];
    [view addSubview:titlelab];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        
        NSString *name = [NSString stringWithFormat:@"适合商户(%ld)",self.homeCellDatas.homeRegins.count];
        
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont systemFontOfSize:13];
        lab.alpha = 0.7;
        lab.text = name;
        [view addSubview:lab];
        
        UIImage *image = [UIImage imageNamed:@"arrow"];
        image = [UIImage scaleImage:image toScale:0.4];
        UIImageView *accsImgView = [[UIImageView alloc]initWithImage:image];
        accsImgView.frame = CGRectMake(mScreenSize.width-30, 16, 10, 15);
        [view addSubview:accsImgView];
        return view;
        
    }else if(section == 3){
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        NSString *name = @"购买须知";
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.alpha = 0.7;
        lab.text = name;
        [view addSubview:lab];
        return view;
    }else if (section == 4){
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        NSString *name = [NSString stringWithFormat:@"网友点评(%ld)",(long)554];
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont systemFontOfSize:13];
        lab.alpha = 0.7;
        lab.text = name;
        [view addSubview:lab];
        
        UIImage *image = [UIImage imageNamed:@"arrow"];
        image = [UIImage scaleImage:image toScale:0.4];
        UIImageView *accsImgView = [[UIImageView alloc]initWithImage:image];
        accsImgView.frame = CGRectMake(mScreenSize.width-30, 10, 10, 15);
        [view addSubview:accsImgView];
        return view;

    }

    return nil;
}
#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 230;
    }else if(indexPath.section == 1){
        return 44;
    }else if (indexPath.section == 3){
        return 500;
    }else if (indexPath.section == 4){
        return 120;
    }
    return 64.0f;
}
#pragma MARK -- 设置tablevier 的内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *resuid = @"resuid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuid];
    }else{
//        while ([cell.contentView.subviews lastObject] != nil) {
//            [[cell.contentView.subviews lastObject]removeFromSuperview];
//        }
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    if (indexPath.section == 0) {
        
        UIView *img = [self addCellimgView];
        
        [cell.contentView addSubview:img];
    }else if (indexPath.section == 1){
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(17, 10, 15, 15)];
        imgV.image = [UIImage imageNamed:@"like_bg"];
        [cell.contentView addSubview:imgV];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(35, 15, 55, 10)];
        lab.text = @"好评度";
        lab.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:lab];
        
        float x = lab.frame.origin.x + lab.bounds.size.width;
        UILabel *labNum = [[UILabel alloc]initWithFrame:CGRectMake(x, 16, 50, 10)];
        NSInteger attitu = arc4random()%100;
        labNum.text = [NSString stringWithFormat:@"%ld",attitu];
        labNum.font = [UIFont systemFontOfSize:14];
        labNum.textColor = [UIColor orangeColor];
        [cell.contentView addSubview:labNum];
        
        UILabel *labde = [[UILabel alloc]initWithFrame:CGRectMake(245, 17, 120, 10)];
        labde.text = @"共19个消费评价";
        labde.font = [UIFont systemFontOfSize:14];
        labde.textColor = [UIColor grayColor];
        [cell.contentView addSubview:labde];
        
        UIImage *image = [UIImage imageNamed:@"arrow"];
        image = [UIImage scaleImage:image toScale:0.4];
        UIImageView *accsImgView = [[UIImageView alloc]initWithImage:image];
        cell.accessoryView = accsImgView;
    }else if(indexPath.section == 2){
        UIView *subView = [self addsubSecCellimgView];
        
        [cell.contentView addSubview:subView];

    }else if (indexPath.section == 3){
        UIView *subView = [self addsubThrCellimgView];
        
        [cell.contentView addSubview:subView];
    }else if (indexPath.section == 4){
        //评论cell
        HHDiscussTableViewCell *cell = [HHDiscussTableViewCell initHHTabelViewCellWithTableView:tableView];
        if (self.detailsArray!= nil&& self.detailsArray.count != 0) {
            
            HHDiscusses *dis = self.detailsArray[indexPath.row];
            cell.details = dis;
        }
        return cell;
    }

   
    return cell;
}
-(UIView*)addsubThrCellimgView{
    UIView *thridView = [[UIView alloc]init];
    
    for (NSInteger i = 0; i< 10; i++) {
        CGFloat mar = 15;
        CGFloat width = 200;
        CGFloat heirht = 30;
        CGFloat x = 15;
        CGFloat y =15+ (mar+heirht)*i;
        UIView *contentViews = [[UIView alloc]initWithFrame:CGRectMake(x, y, width,heirht )];
        
        UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200,10)];
        titLab.text = @"看看啊可";
        titLab.textColor = [UIColor grayColor];
        titLab.font = [UIFont systemFontOfSize:12];
        [contentViews addSubview:titLab];
        
        UILabel *descLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200,10)];
        descLab.text = @".看看啊可dfasfsfsdfasdfasdfasfasdfsf";
//        descLab.textColor = [UIColor grayColor];
        descLab.font = [UIFont systemFontOfSize:12];
        [contentViews addSubview:descLab];
        
        [thridView addSubview:contentViews];
    }
    return thridView;
}
-(UIView*)addsubSecCellimgView{
    UIView *sunv = [[UIView alloc]init];
    sunv.frame = CGRectMake(0, 0, mScreenSize.width, 80);
//    sunv.backgroundColor = [UIColor redColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 110, 20)];
    NSString *name = [NSString stringWithFormat:@"%@",self.homeCellDatas.homeBranch_name];
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:14];
    lab.alpha = 0.7;
    lab.text = name;
    [sunv addSubview:lab];
    
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 37, 60,15)];
    [imgv setImage:[UIImage imageNamed:@"5"]];
    [sunv addSubview:imgv];
    
    UILabel *labdista = [[UILabel alloc]initWithFrame:CGRectMake(160, 40, 170, 15)];
    NSString *nameDis;
   if (self.locationDistance <= 1000) {
//    
         nameDis = [NSString stringWithFormat:@"离你最近%.2lfM",self.locationDistance];
   }else{
       
        nameDis = [NSString stringWithFormat:@"离你最近%.2lfKM",self.locationDistance/1000];
   }
    
    labdista.textColor = [UIColor grayColor];
    labdista.font = [UIFont systemFontOfSize:13];
    labdista.alpha = 0.7;
    labdista.text = nameDis;
    [sunv addSubview:labdista];
    
    UIView *al = [[UIView alloc]initWithFrame:CGRectMake(305, 5, 1, 50)];
    [al setBackgroundColor:[UIColor grayColor]];
    [sunv addSubview:al];
    
    UIButton *imgPhone = [UIButton buttonWithType:UIButtonTypeCustom];
     imgPhone.frame = CGRectMake(315, 20, 25,25);
    UIImage *img = [UIImage imageNamed:@"call1副本"];
//    img = [UIImage scaleImage:img toScale:0.7];
    UIImage *imgsele = [UIImage imageNamed:@"call"];
//    imgsele = [UIImage scaleImage:imgsele toScale:0.7];
    [imgPhone setBackgroundImage:img forState:UIControlStateNormal];
    [imgPhone setBackgroundImage:imgsele forState:UIControlStateHighlighted];
    [sunv addSubview:imgPhone];
    return sunv;
}
-(UIView*)addCellimgView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 5,mScreenSize.width, 225)];
    
    
   UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = view.bounds;
    imgView.alpha = 0.7;

    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:self.homeCellDatas.b_img]  options:SDWebImageAvoidAutoSetImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        UIImage *img= [UIImage imageNamed:@"hotpot08"];
        NSLog(@"%@ddddddd",image);
        imgView.image = image;
    }];

    
        [view addSubview:imgView];
    
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, imgView.bounds.size.height/2+5, mScreenSize.width, imgView.bounds.size.height*0.45)];
    backView.alpha = 0.5;
    backView.backgroundColor = [UIColor darkGrayColor];
    
    UILabel *labTitle = [[UILabel alloc]initWithFrame:CGRectMake(22, 10, mScreenSize.width*0.8, 20)];
    [labTitle setTextColor:[UIColor whiteColor]];
    //设置百题
    [labTitle setText:self.homeCellDatas.homeCellTitle];
    [labTitle setFont:[UIFont systemFontOfSize:20]];
    [backView addSubview:labTitle];
    
    UILabel *labDesc = [[UILabel alloc]initWithFrame:CGRectMake(22, 15, mScreenSize.width*0.8, backView.bounds.size.height - 30)];
//    labDesc.backgroundColor = [UIColor grayColor];
    [labDesc setTextColor:[UIColor whiteColor]];
    [labDesc setText:self.homeCellDatas.homeCellDescription];
    labDesc.numberOfLines = 0;
    [labDesc setFont:[UIFont systemFontOfSize:14]];
    [backView addSubview:labDesc];
    [view addSubview:backView];
    return view;
}
@end
