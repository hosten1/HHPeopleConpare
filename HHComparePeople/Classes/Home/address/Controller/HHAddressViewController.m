//
//  HHAddressViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHAddressViewController.h"
#import "UIImage+Extention.h"
#import "HHCity.h"
#import "HHSearchResultViewController.h"
#import "HHAddressDatasDB.h"

#define mScreenSize [UIScreen mainScreen].bounds.size

@interface HHAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic, weak)UIView *headerView;
@property(nonatomic, strong)NSArray *citysName;
@property(nonatomic, strong)NSArray *citysIndex;
@property(nonatomic, weak)UITableView *addressTableView;
//热门城市
@property(nonatomic, strong)NSArray *HoteCityArray;
//历史访问
@property(nonatomic, strong)NSArray *HistiryCityArray;
@property(nonatomic, weak)UITextField *textFiled;
@property(nonatomic, strong)HHSearchResultViewController *search;
@property(nonatomic, strong)HHAddressDatasDB *addrDB;
@end

@implementation HHAddressViewController
//-(NSArray*)citysName{
//    NSLog(@"dfdfffffff");
//    if (_citysName==nil) {
//        
//    }
//    return _citysName;
//}
//-(NSArray*)citysIndex{
//    if (_citysIndex==nil) {
//       
//    }
//    return _citysIndex;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
    //如果没有初始化则初始化
    if (self.addrDB == nil) {
        _addrDB = [[HHAddressDatasDB alloc]init];
    }
    [self addHeader];
    [self initTableView];
    [self addsearchView];
    _citysName = [HHCity cityNameOfSort];
     _citysIndex = [HHCity cityNamePingYingOfSort];
//    NSLog(@">>>>>%@.....%@",_citysName,_citysIndex);
    _HoteCityArray = @[@"北京",@"上海",@"广州",@"深圳",@"天津",@"杭州",];
    //查询全部历史记录数据库
    _HistiryCityArray = [self.addrDB findAllCityNameFromHistory];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(filedChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeAddNotification:) name:@"ChangeAddressNotification" object:nil];

}
/*接受通知事件*/
-(void)filedChange:(NSNotification*)userinfo{
//    NSLog(@"userinfo:%@",userinfo.userInfo);

    self.search.FiledText = self.textFiled.text;
    [self.search viewDidLoad];
    
}
-(void)ChangeAddNotification:(NSNotification*)notify{
//    NSLog(@"userinfo:%@",notify.userInfo);
    [self.search.view removeFromSuperview];
    NSString *name = notify.userInfo[@"addressChange"];
    self.textFiled.text = name;
    [self.textFiled resignFirstResponder];
//    存入数据库
    [self.addrDB insertFromHistoryWithName:name];
    //存入沙盒 用户偏好设置中
     NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:name forKey:@"cityName"];
    [userDefault synchronize];
     self.addressTableView.hidden = !self.addressTableView.hidden;
}
-(void)addsearchView{
    UITextField *headerTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(20,70, 330, 35)];
    [headerTextFiled setPlaceholder:@"输入用户名,地点"];
    [headerTextFiled setFont:[UIFont systemFontOfSize:12]];
    [headerTextFiled.layer setCornerRadius:15];
    [headerTextFiled.layer setMasksToBounds:YES];
    headerTextFiled.backgroundColor = [UIColor whiteColor];
    [headerTextFiled setLayoutMargins:UIEdgeInsetsMake(0, 30, 0, 0)];
    //设置代理
    headerTextFiled.delegate = self;
//    headerTextFiled.text = @"北";
    self.textFiled = headerTextFiled;
    [self.view addSubview:headerTextFiled];
    //文本框图片
    UIImageView *leftView = [[UIImageView alloc]initWithImage: [UIImage imageNamed: @"booking_channel_search_icon" ]];
    leftView.frame = CGRectMake(0, 0, 15, 15);
    [headerTextFiled setLeftView:leftView];
    [headerTextFiled setLeftViewMode:UITextFieldViewModeAlways];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addHeader{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenSize.width, mScreenSize.height*0.06)];
    self.headerView = headerView;
    CGSize sizze = headerView.frame.size;
    UIButton  *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"ic_back_u"];
    img = [UIImage scaleImage:img toScale:0.5];
    [headerBtn setBackgroundImage:img forState:UIControlStateNormal];
    //返回按钮点击事件
    [headerBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    headerBtn.frame = CGRectMake(8,13 , 10, 15);
    
    [headerView addSubview:headerBtn];
    
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(sizze.width*0.35,15, 100, sizze.height*0.33)];
    headerLab.text = @"位置设置";
    [headerView addSubview:headerLab];
    
    
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
}
//返回上一个页面
-(void)backBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)initTableView{
    //tableView
    CGFloat tabY = self.headerView.frame.origin.y+90;
    CGFloat heithy = mScreenSize.height - tabY;
    /*
     
     */
    UITableView *homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tabY, mScreenSize.width, heithy) style:UITableViewStyleGrouped];
    homeTableView.backgroundColor = [UIColor clearColor];
    homeTableView.delegate = self;
    homeTableView.dataSource = self;
    self.addressTableView = homeTableView;
    [self.view addSubview:homeTableView];
}


#pragma mark -- table 的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else{
   
        NSArray *cit = self.citysName[section-2];
        return cit.count;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _citysName.count+2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 ||section == 1) {
        return 30;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 ||section == 1) {
        return 10;
    }
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        NSInteger count = self.HistiryCityArray.count;
        CGFloat height = 0.0;
        if (count <= 3) {
            height = 30.0;
            
        }else if(count <= 6){
            height = 2*30.0+10;
        }
       NSLog(@"height:%lf",height);
        return height;
        
    }else if(indexPath.section == 1){
        return 90;
    }
    return 50;
}
#pragma mark   --数据源方法
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//
        static NSString *userId = @"addressId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }else{
            //当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
                }
        }
   if(indexPath.section == 0) {
//        NSLog(@"第一组");
       cell.backgroundColor = [UIColor clearColor];
       [self addSubBtn:cell.contentView array:self.HistiryCityArray];
    }else if(indexPath.section == 1){
        cell.backgroundColor = [UIColor clearColor];
        [self addSubBtn:cell.contentView array:self.HoteCityArray];
//        NSLog(@"第二组");
    }else{
//        NSLog(@"其他");
        NSArray *array = _citysName[indexPath.section-2];
        NSString *ciryname = array[indexPath.row];
        [cell.textLabel setText:ciryname];
    }
    
    
     return  cell;
}
-(void)addSubBtn:(UIView*)subView array:(NSArray*)titleArray{
    NSInteger count = titleArray.count;
//    NSLog(@"count///%ld",count);
    CGFloat subViewWidth = 100;
    CGFloat subViewHight = 30;
    NSInteger rowNum = 3;
       for (int i=0; i<count; i++) {
        UIView *views = [[UIView alloc] init];
        [subView addSubview:views];
        
        //        子view的横向间距=（父view的宽度-3*子view的宽度）/(3+1);
        CGFloat marginX = (subView.frame.size.width-rowNum*subViewWidth)/(rowNum+1);
        //        子view的纵向间距 = 20；
        CGFloat marginY = 1;
        //        当前子view的行号=当前遍历的索引值/总列数；
        int row = i/rowNum;
        //        当前子view的列号=当前的索引值%总列数；
        int col = i%rowNum;
        //        子view的横坐标 =子view的横向间距 + 列号*（子view的横向间距+子view宽度）
        CGFloat subViewX = 17 + col*(marginX+subViewWidth);
        //        子view的纵坐标公式=50+行号*（子view的纵向间距+子view的高度）
        CGFloat subViewY =13 + row * (marginY + subViewHight);
        
        [views setFrame:CGRectMake(subViewX, subViewY, subViewWidth, subViewHight)];
        //添加子button
        UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
        btnView.frame = CGRectMake(0, 0, subViewWidth, subViewHight);
        
        [views addSubview:btnView];
           
        btnView.tag = 4000+i;
        
        [btnView addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
           //获取数组中的值
           NSString *name = titleArray[i];
//           NSLog(@"name%@",name);
           [btnView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
           [btnView setTitle:name forState:UIControlStateNormal];
           [btnView.titleLabel setTextAlignment:NSTextAlignmentCenter];
           [views setBackgroundColor:[UIColor whiteColor]];
    }
    
    
}
-(void)titleBtnClick:(UIButton*)sender{
    NSString *name = sender.titleLabel.text;
    //存入沙盒 用户偏好设置中
    //    存入数据库
    [self.addrDB insertFromHistoryWithName:name];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:name forKey:@"cityName"];
    [userDefault synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
//    NSLog(@"点击了：%@",name);
}
#pragma mark  ---tableview代理方法
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"历史访问城市";
    }else if(section == 1){
        return @"国内热门城市";
    }
    return _citysIndex[section-2];
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return nil;
//    }
    return _citysIndex;
}
//索引列点击事件

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    NSLog(@"===%@  ===%d",title,index);
    //点击索引，列表跳转到对应索引的行
    
    [tableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index+2]
     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    
    //弹出首字母提示
    
    //[self showLetter:title ];
    
    return index+2;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    HHSearchResultViewController *search = [[HHSearchResultViewController alloc]init];
    self.search = search;
    search.FiledText = self.textFiled.text;
    search.view.frame = CGRectMake(0, 120, mScreenSize.width, mScreenSize.height-200);
    self.addressTableView.hidden = YES;
    [self.view addSubview:search.view];
}
/***/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    选中第一个
    //    NSLog(@"ffffff");
    UITableViewCell  *cell = [self.addressTableView  cellForRowAtIndexPath:indexPath];
    NSString *name = cell.textLabel.text;
    //    存入数据库
    [self.addrDB insertFromHistoryWithName:name];
    //存入沙盒 用户偏好设置中
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:name forKey:@"cityName"];
    [userDefault synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
    //    NSLog(@"点击的cell>>>>>>%@",name);
}

@end
