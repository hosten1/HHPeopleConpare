//
//  HHUserInfoSettingViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHUserInfoSettingViewController.h"
#import "UIImage+Extention.h"
#import "HHMyMessagesViewController.h"
#import "HHUserInfo.h"
#import "HHuserInfoSetting.h"
#import "HHuserInfoSettingTableViewCell.h"
#import "HHUserInfoDB.h"
#import "HHUpdateInfoViewController.h"

#define mScreenSize [UIScreen mainScreen].bounds.size
@interface HHUserInfoSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, weak)UIView *headerView;
@property(nonatomic, weak)UITableView *infoSettingTableView;
@property(nonatomic, strong)NSMutableArray *infoarray;
@property(nonatomic, strong)HHUserInfoDB *useDB;
@property(nonatomic, strong)HHUpdateInfoViewController *updateUser;
//@property(nonatomic, strong)HHuserInfoSetting *set ;
@end

@implementation HHUserInfoSettingViewController
//-(NSMutableArray*)infoarray{
//    
//    return _infoarray;
//}
-(void)viewDidAppear:(BOOL)animated{
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
    
    _infoarray = nil;

    _useDB = [[HHUserInfoDB alloc]init];
    NSUserDefaults *use = [NSUserDefaults standardUserDefaults];
    NSString *infoNumber = [use objectForKey:@"loginInfo"];
    _suserInfo = nil;
    _suserInfo =  [_useDB findUserWithNumber:infoNumber];
//    NSLog(@"dddddee%@",_suserInfo.userName);
//
    if (_infoarray == nil) {
        
        
        _infoarray = [NSMutableArray array];
        
        HHuserInfoSetting *set  = [HHuserInfoSetting new];
        set.title =[NSString stringWithFormat: @"昵称 %@",_suserInfo.userName ];
        set.descrip = @"修改";
        HHuserInfoSetting *set1  = [HHuserInfoSetting new];        set1.title = @"密码";
        set1.descrip = @"修改";
        NSArray *arr1 = @[set,set1];
        HHuserInfoSetting *set2  = [HHuserInfoSetting new];        set2.title = @"会员身份";
        set2.descrip = @"成为vip享特权";
        NSArray *arr2 = @[set2];
        
        HHuserInfoSetting *set3  = [HHuserInfoSetting new];        set3.title = @"性别";
        set3.descrip = @"设置";
        HHuserInfoSetting *set4  = [HHuserInfoSetting new];        set4.title = @"常居住地";
        set4.descrip = _suserInfo.address;
        NSArray *arr3 = @[set3,set4];
        
        HHuserInfoSetting *set5  = [HHuserInfoSetting new];        set5.title = @"收货地址";
        set5.descrip = @"修改/添加";
        NSArray *arr4 = @[set5];
        
        [ _infoarray addObject:arr1];
        [ _infoarray addObject:arr2];
        [ _infoarray addObject:arr3];
        [ _infoarray addObject:arr4];
        
        
    }
//    NSLog(@"%@----%@",_userInfo.numberPhone,_infoarray);
    if (_infoSettingTableView != nil) {
        [_infoSettingTableView reloadData];
    }else{
        [self initTableView];
        [self addHeader];
    }
    
    
    
}
-(void)addHeader{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenSize.width, mScreenSize.height*0.06)];
    self.headerView = headerView;
    CGSize sizze = headerView.frame.size;
    UIButton  *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"ic_back_u"] ;
    img = [UIImage scaleImage:img toScale:0.5];
    [headerBtn setBackgroundImage:img forState:UIControlStateNormal];
    //返回按钮点击事件
    [headerBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    headerBtn.frame = CGRectMake(8,13 , 10, 15);
    
    [headerView addSubview:headerBtn];
    
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(sizze.width*0.45,15, 100, sizze.height*0.33)];
    headerLab.text = @"个人信息";
    [headerView addSubview:headerLab];
    
    
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
}
/***返回到我的信息页面***/
-(void)backBtn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initTableView{
    //tableView
    CGFloat tabY = self.headerView.frame.origin.y+44;
    CGFloat heithy = mScreenSize.height - tabY;
    /*
     
     */
    UITableView *homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tabY, mScreenSize.width, heithy) style:UITableViewStyleGrouped];
    homeTableView.backgroundColor = [UIColor clearColor];
    homeTableView.delegate = self;
    homeTableView.dataSource = self;
    self.infoSettingTableView = homeTableView;
    [self.view addSubview:homeTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- table 的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section-1 != _infoarray.count) {
       
        NSArray *arr = _infoarray[section-1];
        return arr.count;

    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _infoarray.count+2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
  return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    return 50;
}
#pragma mark   --数据源方法
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
// if (indexPath.section != _infoarray.count) {
    static NSString *userId = @"reuseId";
    HHuserInfoSettingTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:userId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HHuserInfoSettingTableViewCell" owner:nil options:nil]lastObject];
    }else{
        //当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
     if (indexPath.section == 0) {
         UIView *im = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 80)];
         im.backgroundColor = [UIColor whiteColor];
         UIImage *img = [UIImage imageNamed:_suserInfo.icon];
         UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 70, 70)];
         imgView.image = img;
         [im addSubview:imgView];
         [cell.contentView addSubview:im];
         return cell;
     }else if(indexPath.section-1 != _infoarray.count){
         
         UIImageView *accImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
         accImgView.frame = CGRectMake(0, 0, 10, 10);
         cell.accessoryView = accImgView;
         NSInteger sor = indexPath.section - 1;
         NSArray *arr = _infoarray[sor];
         
         HHuserInfoSetting *useinfo = arr[indexPath.row];
         cell.userSet = useinfo;
         return cell;
     }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UIButton *unLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [unLogin setTitle:@"退出登录" forState:UIControlStateNormal];
        [unLogin setFrame:CGRectMake(10, 0, 350, 35)];
        [unLogin setBackgroundColor:[UIColor orangeColor]];
        [unLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //设置点击事件
        [unLogin addTarget:self action:@selector(btnUnlogin) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:unLogin];
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    
    return  nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            
                NSLog(@"改头像");
            
            break;
        case 1:
            if (indexPath.row == 0) {
                NSLog(@"昵称");
                _updateUser = [[HHUpdateInfoViewController alloc]init];
                _updateUser.name = @"昵称";
                _updateUser.infos = _suserInfo;
                _updateUser.usinfo = _suserInfo.userName;
                [self presentViewController:_updateUser animated:YES completion:nil];
            }else{
                NSLog(@"密码");
                _updateUser = [[HHUpdateInfoViewController alloc]init];
                _updateUser.name = @"密码";
                _updateUser.infos = _suserInfo;
               
                [self presentViewController:_updateUser animated:YES completion:nil];
                

            }
            break;
        case 2:
               NSLog(@"会员身份");
            break;
        case 3:
            
            if (indexPath.row == 0) {
                NSLog(@"性别");
                _updateUser = [[HHUpdateInfoViewController alloc]init];
                _updateUser.name = @"性别";
                _updateUser.infos = _suserInfo;
                [self presentViewController:_updateUser animated:YES completion:nil];
                

            }else{
                NSLog(@"常居住地");
                _updateUser = [[HHUpdateInfoViewController alloc]init];
                _updateUser.name = @"常居住地";
                _updateUser.infos = _suserInfo;
               
                [self presentViewController:_updateUser animated:YES completion:nil];
                

            }
            break;
        case 4:
               NSLog(@"收货地址");
            _updateUser = [[HHUpdateInfoViewController alloc]init];
            _updateUser.name = @"收货地址";
            _updateUser.infos = _suserInfo;
            [self presentViewController:_updateUser animated:YES completion:nil];
            

            break;
            
        default:
            break;
    }
}
/***********退出登录**********/
-(void)btnUnlogin{
    NSUserDefaults *userDafault = [NSUserDefaults standardUserDefaults];
    [userDafault removeObjectForKey:@"loginInfo"];
    [userDafault synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

///******懒加载数据******/
//-(HHUserInfoDB *)useDB{
//    if (_useDB == nil) {
//        _useDB = [[HHUserInfoDB alloc]init];
//    }
//    return _useDB;
//}
@end
