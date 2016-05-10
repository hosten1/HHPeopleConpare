//
//  HHSettingViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHSettingViewController.h"
#import "UIImage+Extention.h"
#import "HHMyMessagesViewController.h"
#import "HHSetting.h"
#define mScreenSize [UIScreen mainScreen].bounds.size

@interface HHSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, weak)UIView *headerView;
@property(nonatomic, weak)UITableView *infoSettingTableView;
@property(nonatomic, strong)NSMutableArray *infoarray;

@end

@implementation HHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
    // Do any additional setup after loading the view.
    //    NSLog(@"")
    if (_infoarray == nil) {
       
        _infoarray = [NSMutableArray array];
        HHSetting *set  = [HHSetting new];
        set.title = @"图片设置";
        set.descrip = @"";
        HHSetting *set1  = [HHSetting new];
        set1.title = @"消息提醒设置";
        set1.descrip = @"";
        HHSetting *set2  = [HHSetting new];
        set2.title = @"清除缓存";
        set2.descrip = @"";
        HHSetting *set3  = [HHSetting new];
        set3.title = @"手机安全防护设置";
        set3.descrip = @"未开启";
        NSArray *arr1 = @[set,set1,set2,set3];
        
        HHSetting *set4  = [HHSetting new];
        set4.title = @"意见反馈";
        set4.descrip = @"";
        HHSetting *set5  = [HHSetting new];
        set5.title = @"检测新版本";
        set5.descrip = @"";
        HHSetting *set6  = [HHSetting new];
        set6.title = @"自动下载安装包";
        set6.descrip = @"仅WI-FI网络";
        HHSetting *set7  = [HHSetting new];
        set7.title = @"关于我们";
        set7.descrip = @"";
        NSArray *arr2 = @[set4,set5,set6,set7];
        
        HHSetting *set8  = [HHSetting new];
        set8.title = @"诊断网络";
        set8.descrip = @"";
        
        NSArray *arr3 = @[set8];
        
        HHSetting *set9  = [HHSetting new];
        set9.title = @"邀请送红包";
        set9.descrip = @"";
        NSArray *arr4 = @[set9];
        
        [ _infoarray addObject:arr1];
        [ _infoarray addObject:arr2];
        [ _infoarray addObject:arr3];
        [ _infoarray addObject:arr4];
        
        
    }
    //    NSLog(@"%@----%@",_userInfo.numberPhone,_infoarray);
    [self initTableView];
    [self addHeader];

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
    
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(sizze.width*0.45,15, 100, sizze.height*0.33)];
    headerLab.text = @"设置中心";
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


#pragma mark -- table 的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section != _infoarray.count) {
        NSArray *arr = _infoarray[section];
        return arr.count;
        
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _infoarray.count+1;
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
    
    return 50;
}
#pragma mark   --数据源方法
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != _infoarray.count) {
        static NSString *userId = @"reuseId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        UIImageView *accImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        accImgView.frame = CGRectMake(0, 0, 10, 10);
        cell.accessoryView = accImgView;
        NSArray *arr = _infoarray[indexPath.section];
        
        HHSetting *setting = arr[indexPath.row];
        cell.textLabel.text = setting.title;
        if (setting.descrip != nil) {
            cell.detailTextLabel.text = setting.descrip;
        }
        return cell;
        
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UIButton *unLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [unLogin setTitle:@"邀请新伙伴" forState:UIControlStateNormal];
        [unLogin setFrame:CGRectMake(10, 0, 350, 35)];
        [unLogin setBackgroundColor:[UIColor orangeColor]];
        [unLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:unLogin];
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    
    return  nil;
}

@end
