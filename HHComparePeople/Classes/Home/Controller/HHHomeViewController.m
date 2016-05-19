//
//  HHHomeViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHHomeViewController.h"
#import "HHTabBar.h"
#import "UIImage+Extention.h"
#import "NSString+Extension.h"
#import "HHHomeDatas.h"
#import "HHAddressDatasDB.h"
#import "HHHomeCellDatas.h"
#import "HHTableViewCell.h"
#import "HHPickerViewController.h"
#import "HHAddressViewController.h"
#import "HHParseJson.h"
#import "requestData.h"
#import "HHDetailsViewConTroller.h"
#import "HHDetailsShopsViewController.h"
//#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "HHTextFiled.h"

#define URLRe @"http://api.dianping.com/v1/business/find_businesses"
//#import "ParseJSON.h"
//#import <CoreLocation/CoreLocation.h>

@interface HHHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BackData,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UISearchBarDelegate>

@property(nonatomic, strong)HHTextFiled *searchBar;
@property(nonatomic, weak)UIView *headerView;
@property(nonatomic, weak)UIButton *leftBtn;
@property(nonatomic, weak)UITableView *homeTableView;
@property (assign,nonatomic) int viewCount;
@property(nonatomic, strong)NSArray *homedatas;
@property(nonatomic, strong)HHPickerViewController *pickerControlller;
/*********获取网络请求数据***********/
@property(nonatomic, strong)NSMutableArray *celldata;
@property(nonatomic, strong)requestData *rd;
/*****获取用户位置信息****/
//@property(nonatomic, strong)CLLocationManager *locationMana;
@property(nonatomic, strong) BMKLocationService* locationServices;
@property(nonatomic, strong)CLLocation *oldLocation;
/*********地理编码反编码服务**********/
@property(nonatomic, strong)BMKGeoCodeSearch * geocodesearch;
@property(nonatomic, strong)CLGeocoder *gecode;

@property(nonatomic, strong)UIButton *btnBg;
@property(nonatomic,strong)UIBarButtonItem *leftBtnitem;
@property(nonatomic,strong)UIBarButtonItem *rightBtnitem;

@end

@implementation HHHomeViewController
-(void)dealloc{
    if (_locationServices) {
        _locationServices = nil;
    }
    if (_geocodesearch) {
        _geocodesearch = nil;
    }
}
-(CLGeocoder *)gecode{
    if (!_gecode) {
        _gecode = [[CLGeocoder alloc]init];
    }
    return _gecode;
}
/********懒加载 初始化位置编码啊******/
-(BMKGeoCodeSearch *)geocodesearch{
    if (!_geocodesearch) {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    }
    return _geocodesearch;
}
/********懒加载 初始化位置管理******/
-(BMKLocationService *)locationServices{
    if (!_locationServices) {
        _locationServices = [[BMKLocationService alloc]init];
    }
    return _locationServices;
}
//-(CLLocationManager *)locationMana{
//    if (_locationMana == nil) {
//        _locationMana = [[CLLocationManager alloc]init];
//        
////        NSLog(@"获取定位初始化：%@",_locationMana);
//        //设置定位精度
//        _locationMana.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//        [_locationMana requestAlwaysAuthorization];
//        _locationMana.distanceFilter = 50.0f;
//        
//    }
//    return _locationMana;
//}

/*******懒加载数据*******/
-(NSMutableArray *)celldata{
    if (_celldata == nil) {
      
//        NSLog(@"你好dddd");
        _rd = [[requestData alloc]init];
        _celldata = [NSMutableArray array];
        //获取沙盒记录
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString  *address =[user objectForKey:@"cityName"];
        //    NSLog(@"address>>>%@",address);
        if (address == nil) {
        
            address = @"西安市";
        }else{
            
//            HHParseJson *pj = [[HHParseJson alloc]init];
            NSMutableString *mutString = [NSMutableString stringWithString:address];
            NSInteger location = [mutString rangeOfString:@"市"].location;
//            NSLog(@"yes@+%ld",location);
           if (location == mutString.length-1)//_roaldSearchText
            {
                address = [mutString substringToIndex:mutString.length-1];
//                NSLog(@"截取后的:%@",address);

            }
            NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
            [dic setValue:address forKey:@"city"];
            [dic setValue:@"30" forKey:@"limit"];
            [_rd startRequestWithUrl:URLRe withParam:dic];
            _rd.delegate = self;

        }

        
    }
    return _celldata;
}
/***********json返回数据**************/
-(void)backJSONData:(NSData *)data widthUrl:(NSString *)url{
    [_celldata addObjectsFromArray:[HHParseJson parseDataWithDatas:data]];
//    NSLog(@"解析的数据实时%@",url);
//     NSLog(@"nndhflahks%@",self.celldata);
    [self.homeTableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *norimg = [UIImage imageNamed:@"main_index_home_normal"];
        UIImage *selectImg = [UIImage imageNamed:@"main_index_home_pressed"];

        norimg = [UIImage scaleImage:norimg toScale:0.4];
        
        selectImg = [UIImage scaleImage:selectImg toScale:0.4];
        
        
      UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"首页" image:norimg selectedImage:selectImg];
        
        
        self.tabBarItem = item;
//        item.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{

    // 初始化 navigationController
    [self initNavigationController];
//    [self addHeader];
    [self.homeTableView reloadData];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    
  
        //结束后停止定位
    if (_locationServices) {
        _locationServices.delegate = nil;
        [_locationServices stopUserLocationService];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    //适配ios7
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
//    {
//        self.navigationController.navigationBar.translucent = NO;
//    }
    
    self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];

   self.homedatas =  [HHHomeDatas addTitleData];
    //加载数据
    //设置tableeView
    [self initTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNameNotification:) name:@"ChangeNameNotification" object:nil];
    
}
-(void)initNavigationController{

    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];

    //获取沙盒记录
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString  *address =[user objectForKey:@"cityName"];
    if (address == nil || address.length == 0) {
        address = @"西安市";
    }
    CGSize btnSize = [address sizeWithMaxSize:CGSizeMake(200, 200) andFont:16];
    
    UIImage *addreImg = [UIImage imageNamed:@"yy_arrow"];
    UIButton *btnImg = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBg = btnImg;
    btnImg.frame = CGRectMake((15+btnSize.width)*ScreenScale_width, 7*ScreenScale_height, 30*ScreenScale_width, 30*ScreenScale_height);
    [btnImg setBackgroundImage:addreImg forState:UIControlStateNormal];
    [btnImg setBackgroundImage:[UIImage imageNamed:@"yy_arrow_pressed"] forState:UIControlStateHighlighted];
    [btnImg addTarget:self action:@selector(addPickerViewhome:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btnImg];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:address style:(UIBarButtonItemStyleDone) target:self action:@selector(addPickerViewhome:)];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    self.leftBtnitem = leftItem;
    
    //导航条的搜索条
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,15, 15)];
    img.image = [UIImage imageNamed:@"booking_channel_search_icon"];
    _searchBar = [[HHTextFiled alloc]initWithFrame:CGRectMake(0.0f,0.0f,180.0f,30.0f) drawingLeft:img];
    _searchBar.delegate = self;
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    [_searchBar setTintColor:[UIColor whiteColor]];
    [_searchBar setPlaceholder:@"输入用户名/地名"];
    [_searchBar.layer setCornerRadius:15];
    [_searchBar.layer setMasksToBounds:YES];

    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(95*ScreenScale_width,3*ScreenScale_height, 180*ScreenScale_width, 35*ScreenScale_height)];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:_searchBar];
    self.navigationItem.titleView = searchView;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(loadMoreInfo:)];
    self.navigationItem.rightBarButtonItem = rightItem;
;
    self.rightBtnitem = rightItem;
    
}
#pragma mark  通只事件
-(void)ChangeNameNotification:(NSNotification*)notification{

    
}

-(void)initTableView{

    CGFloat tabY = 0;
    CGFloat heithy = mScreenSize.height - tabY;
    /*
     
     */
    UITableView *homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tabY, mScreenSize.width, heithy) style:UITableViewStyleGrouped];
    homeTableView.backgroundColor = [UIColor clearColor];
    homeTableView.delegate = self;
    homeTableView.dataSource = self;
    self.homeTableView = homeTableView;
    [self.view addSubview:homeTableView];
}
//点击按钮出现
-(void)addPickerViewhome:(UIButton*)sender{
    //跳转
    HHAddressViewController *addr = [[HHAddressViewController alloc]init];
    self.btnBg.hidden = YES;
    [self.navigationController pushViewController:addr animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- table 的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *arr = self.infoArray[section];
//            NSLog(@"ddd:%@",arr);
   NSInteger cou = 0;
    if (section == 0 || section ==1 ) {
        cou = 1;
    }else{
        if (self.celldata != nil && self.celldata.count != 0) {
            cou = self.celldata.count;
        }else{
            cou = 20;
        }
       
    }
    return cou;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 20;
    }else if (section == 0){
        return 0.1;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }
    return 80;
}
#pragma mark   --数据源方法
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
    
    static NSString *cellid= @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }else{
        //当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    if (indexPath.section == 0) {
        
        [self addScrollView:cell];
    }else if(indexPath.section == 1){
        [self addSecondView:cell];
    }
  
      return  cell;
    }else{
        //设置自己的cell
        //1.创建cell
         HHTableViewCell *cell=[HHTableViewCell cellWithTableView:tableView];
      //2.获取当前行的模型,设置cell的数据
        if (_celldata != nil && _celldata.count != 0) {
            
            HHHomeCellDatas *cellData = _celldata[indexPath.row];
            if (cellData != nil) {
                
                cell.cellDatas = cellData;
            }
        }
       
       

      //3.返回cell
          return cell;
    }
    return nil;
}
-(void)addSecondView:(UITableViewCell*)cell{
    UIView *allView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 70)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(5, 5, allView.frame.size.width*0.48, 70);
    [allView addSubview:leftBtn];
//    leftBtn.backgroundColor = [UIColor greenColor];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"seekrank9"] forState:UIControlStateNormal];
    UIButton *reightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     reightBtn.frame = CGRectMake(allView.frame.size.width*0.48+10,  5, allView.frame.size.width*0.48, 70);
//    reightBtn.backgroundColor =[UIColor redColor] ;
    [reightBtn setBackgroundImage:[UIImage imageNamed:@"seekrank10"] forState:UIControlStateNormal];
    [allView addSubview:reightBtn];
    
    allView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:allView];
}
#pragma mark  ---table代理方法
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 40)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, mScreenSize.width, 40);
//        btn.backgroundColor = [UIColor grayColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView bringSubviewToFront:btn];
        [footView addSubview:btn];
           UILabel *leftLable = [[UILabel alloc]init];
           leftLable.frame = CGRectMake(10,10, 100, 10);
           leftLable.text = @"附近头条";
        leftLable.textColor = [UIColor orangeColor];
        leftLable.font = [UIFont systemFontOfSize:18];
        [footView addSubview:leftLable];
        
        
        UIView *margin = [[UIView alloc]initWithFrame:CGRectMake(80+10, 5, 1, 20)];
        margin.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
        [footView addSubview:margin];
        
        UILabel *rightLable = [[UILabel alloc]init];
        rightLable.frame = CGRectMake(100,12, 200, 10);
        rightLable.text = @"假装在异国的体验";
        rightLable.font = [UIFont systemFontOfSize:12];
        rightLable.textColor = [UIColor blackColor];
        [footView addSubview:rightLable];
        
        footView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *accImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        accImgView.frame = CGRectMake(350, 10, 10, 10);
        [footView addSubview:accImgView];

        return footView;
    }
    
    return nil;
}
-(void)btnClick:(UIButton*)sender{
    NSLog(@"异域风情");
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UILabel *titlLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 20)];
        titlLable.font = [UIFont systemFontOfSize:10];
        titlLable.textColor = [UIColor grayColor];
        titlLable.text = @"猜你喜欢";
        return titlLable;
    }
    return nil;
}
#pragma mark  table View X选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
   

        if (self.celldata != nil || self.celldata.count != 0) {
            
            HHHomeCellDatas *cellDat = _celldata[indexPath.row];
            if (cellDat != nil) {
                
//                NSLog(@"%@",cellDat.homeCellTitle);
                //地理编码后跳转
                [self goToGeocodesearchOfNext:cellDat];
                
            }
        

        }
        //跳转页面
//        [self presentViewController:deta animated:YES completion:nil];
    
    }
}
#pragma mark --这里进行页面跳转和地理编码
-(void)goToGeocodesearchOfNext:(HHHomeCellDatas*)celldate{
    //获取沙盒记录
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString  *city =[user objectForKey:@"cityName"];
    //    NSLog(@"address>>>%@",address);
    if (city.length == 0) {
        city = @"西安市";
    }

    NSString *address = [NSString stringWithFormat:@"%@%@",city,celldate.homeAddress];
    if (address.length==0) return;
    
    //2.开始地理编码
    //说明：调用下面的方法开始编码，不管编码是成功还是失败都会调用block中的方法
    [self.gecode geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //如果有错误信息，或者是数组中获取的地名元素数量为0，那么说明没有找到
        if (error || placemarks.count==0) {
           NSString* text=@"你输入的地址没找到，可能在月球上";
            NSLog(@"%@",text);
            /**失败还是跳转**/
            HHDetailsViewConTroller *deta = [[HHDetailsViewConTroller alloc]init];
            deta.homeCellDatas = celldate;
            self.btnBg.hidden = YES;
            //跳转页面
//            [self.navigationController pushViewController:deta animated:YES];
            
        }else   //  编码成功，找到了具体的位置信息
        {
            //打印查看找到的所有的位置信息
            /*
             name:名称
             locality:城市
             country:国家
             postalCode:邮政编码
             */
            for (CLPlacemark *placemark in placemarks) {
                NSLog(@"name=%@ locality=%@ country=%@ postalCode=%@",placemark.name,placemark.locality,placemark.country,placemark.postalCode);
            }
            
            //取出获取的地理信息数组中的第一个显示在界面上
            CLPlacemark *firstPlacemark=[placemarks firstObject];
//            //详细地址名称
//            self.detailAddressLabel.text=firstPlacemark.name;
            //纬度
            CLLocationDegrees latitude=firstPlacemark.location.coordinate.latitude;
            //经度
            CLLocationDegrees longitude=firstPlacemark.location.coordinate.longitude;
           NSString* latitudetext = [NSString stringWithFormat:@"%.5f",latitude];
           NSString* longitudeLabeltext = [NSString stringWithFormat:@"%.5f",longitude];
             HHDetailsViewConTroller *deta = [[HHDetailsViewConTroller alloc]init];
            //重新赋值
            celldate.homeLatitude = latitudetext;
            celldate.homeLongitude = longitudeLabeltext;
            deta.homeCellDatas = celldate;
            //跳转页面
            self.btnBg.hidden = YES;
            [self.navigationController pushViewController:deta animated:YES];
        }
    }];
}
-(void)addScrollView:(UITableViewCell*)cell{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 180)];
//    scrollView.backgroundColor = [UIColor redColor];
    int viewCount = 3;
    self.viewCount = viewCount;
    //设置UIScrollView 的显示内容的尺寸，有n张图要显示，就设置 屏幕宽度*n ，这里假设要显示4张图
    scrollView.contentSize = CGSizeMake(mScreenSize.width * viewCount, cell.bounds.size.height);
    
    scrollView.tag = 101;
    
    //设置翻页效果，不允许反弹，不显示水平滑动条，设置代理为自己
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    scrollView.delegate = self;
    
    //在UIScrollView 上加入 UIImageView
    for (NSInteger i = 0 ; i < viewCount; i ++) {
//        NSLog(@"sub:%ld",i);
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(scrollView.bounds.size.width*i, 0, mScreenSize.width, 160)];
        
        subView.tag = 2000+i;
        [self addSubBtn:subView];
        [scrollView addSubview:subView];
    }
    
    //初始化 UIPageControl 和 _scrollView 显示在 同一个页面中
    UIPageControl *pageConteol = [[UIPageControl alloc] initWithFrame:CGRectMake(140, 150, 50, 40)];
    pageConteol.numberOfPages = viewCount;//设置pageConteol 的page 和 _scrollView 上的图片一样多
    pageConteol.tag = 201;
//    self.WelcomPageControl = pageConteol;
    pageConteol.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    [pageConteol setPageIndicatorTintColor:[UIColor grayColor]];
    [cell.contentView  addSubview:scrollView];
    [cell.contentView  addSubview: pageConteol];
    
    
    
}
-(void)addSubBtn:(UIView*)subView{
    NSInteger count = 8;
    CGFloat subViewWidth = 40;
    CGFloat subViewHight = 55;
    NSInteger rowNum = 4;
    
    NSArray *subViewData = nil;
    if (subView.tag == 2000) {
        subViewData = self.homedatas[0] ;
//        NSLog(@"sub:%@....%ld",subViewData,subView.tag);
        
    }else if(subView.tag == 2001){
        subViewData = self.homedatas[1] ;
//         NSLog(@"sub:%@....%ld",subViewData,subView.tag);
       
        
    }else if(subView.tag == 2002){
        subViewData = self.homedatas[2] ;
//        NSLog(@"sub:%@....%ld",subViewData,subView.tag);
        
    }
    

       HHHomeDatas *homesda = nil;
       for (int i=0; i<count; i++) {
        UIView *views = [[UIView alloc] init];
        [subView addSubview:views];
        
        //        子view的横向间距=（父view的宽度-3*子view的宽度）/(3+1);
        CGFloat marginX = (subView.frame.size.width-rowNum*subViewWidth)/(rowNum+1);
        //        子view的纵向间距 = 20；
        CGFloat marginY = 20;
        //        当前子view的行号=当前遍历的索引值/总列数；
        int row = i/rowNum;
        //        当前子view的列号=当前的索引值%总列数；
        int col = i%rowNum;
        //        子view的横坐标 =子view的横向间距 + 列号*（子view的横向间距+子view宽度）
        CGFloat subViewX = marginX + col*(marginX+subViewWidth);
        //        子view的纵坐标公式=50+行号*（子view的纵向间距+子view的高度）
        CGFloat subViewY =10 + row * (marginY + subViewHight);
        
        [views setFrame:CGRectMake(subViewX, subViewY, subViewWidth, subViewHight)];
        //添加子button
        UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
        btnView.frame = CGRectMake(0, 0, views.bounds.size.width, views.bounds.size.height*0.7);

        [views addSubview:btnView];
        UILabel *sunLab = [[UILabel alloc]initWithFrame:CGRectMake(5, views.bounds.size.height*0.7+5, views.bounds.size.width, 20)];
           [sunLab setTextAlignment:NSTextAlignmentCenter];
        sunLab.font = [UIFont systemFontOfSize:10];
                [views addSubview:sunLab];
         homesda= [HHHomeDatas new];
         homesda =  subViewData[i];
//           NSLog(@"%@.....%@",homesda.nameTitle,homesda);
        [btnView setBackgroundImage:[UIImage imageNamed:homesda.iconNameTitle] forState:UIControlStateNormal];
        sunLab.text = homesda.nameTitle;
           //设置标题标签
           [btnView setTitle:homesda.nameTitle forState:UIControlStateNormal];
           [btnView setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
           //设置按钮点击事件
           if (subView.tag == 2000) {
               btnView.tag = 3000+i;
               
           }else if(subView.tag == 2001){
              btnView.tag = 3016+i;
               
               
           }else if(subView.tag == 2002){
             btnView.tag = 3024+i;
               
           }
           [btnView addTarget:self action:@selector(oneTitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
          
//        [views setBackgroundColor:[UIColor blueColor]];
           
        
     }
  

}
#pragma mark  ---跳转到商户详情页面

    
-(void)oneTitleBtnClick:(UIButton*)sender{
    HHDetailsShopsViewController *shop = [[HHDetailsShopsViewController alloc]init];
    
     shop.titleTextSender = sender.titleLabel.text;
    
    [self.navigationController pushViewController:shop animated:YES];
//    NSLog(@"被点击了：+%ld,title:%@",sender.tag,sender.titleLabel.text);
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    //根据scrollView 的位置对page 的当前页赋值
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    page.currentPage = current;
    
    //当显示到最后一页时，让滑动图消失
    if (page.currentPage == self.viewCount-1) {
        
        //调用方法，使滑动图消失
        //        [self scrollViewDisappear];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}


#pragma mark ---UITextFiled 代理方法

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    //跳转
    HHAddressViewController *addr = [[HHAddressViewController alloc]init];
    self.btnBg.hidden = YES;
    [self.navigationController pushViewController:addr animated:YES];
}
#pragma mark --定位服务的代理方法
@end
