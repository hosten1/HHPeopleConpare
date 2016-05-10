//
//  HHMyMessagesViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHMyMessagesViewController.h"
#import "UIImage+Extention.h"
#import "HHMyMessage.h"
#import "UIImage+Extention.h"
#import "HHLoginViewController.h"
#import "HHUserInfo.h"
#import "HHUserInfoDB.h"
#import "HHUserInfoSettingViewController.h"
#import "HHSettingViewController.h"
#define mScreenSize [UIScreen mainScreen].bounds.size

@interface HHMyMessagesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, weak)UIView *headerView;
@property(nonatomic, weak)UITableView *msgTableView;
@property(nonatomic, strong)NSArray *infoArray;
@property(nonatomic, strong)HHUserInfoDB *userDb;
@property(nonatomic, strong)HHUserInfo *userinfo;
@end

@implementation HHMyMessagesViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *norimg = [UIImage imageNamed:@"main_index_my_normal"];
        UIImage *selectImg = [UIImage imageNamed:@"main_index_my_pressed"];
        
        norimg = [UIImage scaleImage:norimg toScale:0.4];
        
        selectImg = [UIImage scaleImage:selectImg toScale:0.4];
        
        
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"我的" image:norimg selectedImage:selectImg];
        
        
        self.tabBarItem = item;
        
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewWillAppear:(BOOL)animated{
   
    /*********获取用户登录信息**************/
    self.userinfo = nil;
    NSUserDefaults *use = [NSUserDefaults standardUserDefaults];
    NSString *infoNumber = [use objectForKey:@"loginInfo"];
    _userDb = [[HHUserInfoDB alloc]init];
    if (infoNumber != nil) {
        
        _userinfo =  [_userDb findUserWithNumber:infoNumber];
    }
//    NSLog(@"视图要重新出现咯%@",infoNumber);
    [self initTableView];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
    //设置头部
    [self addHeader];
    /**
     初始化tabview
     */
    [self initTableView];
    
    HHMyMessage *my = [HHMyMessage new];
    NSArray *arr = my.addData;
    self.infoArray = arr;
//    HHMyMessage *msg = arr[0];
//    NSLog(@"长度:%@",arr);
    
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
    self.msgTableView = homeTableView;
    [self.view addSubview:homeTableView];
}
-(void)addHeader{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenSize.width, mScreenSize.height*0.06)];
    self.headerView = headerView;
    CGSize sizze = headerView.frame.size;
    UIButton  *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [headerBtn setFont:[UIFont systemFontOfSize:14]];
    [headerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    headerBtn.frame = CGRectMake(8,15 , 60, sizze.height*0.33);
    [headerView addSubview:headerBtn];
    
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(sizze.width*0.45,15, 60, sizze.height*0.33)];
    headerLab.text = @"我的";
    [headerView addSubview:headerLab];
//
    UIButton  *headerBtnim = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBtnim setImage:[UIImage imageNamed:@"detail_topbar_icon_share"] forState:UIControlStateNormal];
    headerBtnim.frame = CGRectMake(sizze.width*0.9,15,20, sizze.height*0.45);
    [headerView addSubview:headerBtnim];

    
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- table 的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.infoArray[section];
//        NSLog(@"ddd:%@",arr);
    return arr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.infoArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 0.1;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 80;
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

    NSArray *msgArray = self.infoArray[indexPath.section];
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        HHMyMessage *msg = msgArray[indexPath.row];
        // 1.创建头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [cell.contentView addSubview:iconView];
        iconView.frame = CGRectMake(5, 10, 60,60);
//        iconView.backgroundColor = [UIColor grayColor];
                      //
        UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
       
        [nameButton setFont:[UIFont systemFontOfSize:13]];
        [nameButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [nameButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
         nameButton.frame = CGRectMake(50, 25, 160, 15);
        [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:nameButton];
        
        UIButton *addrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [addrBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [addrBtn setFont:[UIFont systemFontOfSize:12]];
         addrBtn.frame = CGRectMake(50,45, 150, 15);
        if (self.userinfo != nil) {
            [addrBtn setTitle:[NSString stringWithFormat:@"常居住地:%@",self.userinfo.address] forState:UIControlStateNormal];
            [nameButton setTitle:self.userinfo.userName forState:UIControlStateNormal];
            UIImage *icon = [UIImage imageNamed:self.userinfo.icon];
            icon = [UIImage scaleImage:icon toScale:0.6f];
            icon = [UIImage resizeImage:icon];
             [iconView setImage:icon];

        }else{
            
            UIImage *icon = [UIImage imageNamed:@"login01"];
            icon = [UIImage scaleImage:icon toScale:0.6f];
            icon = [UIImage resizeImage:icon];
            [iconView setImage:icon];
            
            [addrBtn setTitle:@"常居住地设置" forState:UIControlStateNormal];
            [nameButton setTitle:@"点击登录" forState:UIControlStateNormal];
        }
       

        [cell.contentView addSubview:addrBtn];

        UIImageView *accImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        accImgView.frame = CGRectMake(0, 0, 10, 10);
        cell.accessoryView = accImgView;
//        NSLog(@"%@",msg.title);
    }else{
        
    HHMyMessage *msg = msgArray[indexPath.row];
//        NSLog(@"...个数%@：",msgArray);
//        NSLog(@"title:%@",msg.icon);
        
        
    UIImageView *accImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
    accImgView.frame = CGRectMake(0, 0, 10, 10);
    cell.accessoryView = accImgView;
    cell.imageView.bounds = CGRectMake(0, 0, 10, 10);
     UIImage *iconImg =[UIImage imageNamed:msg.icon];
        
    iconImg = [UIImage scaleImage:iconImg toScale:0.45];
    cell.imageView.image = iconImg;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = msg.title;
    }
    return  cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 100)];
        
        
        //最上面的间隔
        UIView *img = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenSize.width, 2)];
        img.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
        [footView addSubview:img];
        
        UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
        btnView.frame = CGRectMake(30, 15, 35, 35);
//        btnView.backgroundColor =[UIColor whiteColor];
        [btnView setBackgroundImage:[UIImage imageNamed:@"main_index_my_pressed"] forState:UIControlStateNormal];
        [footView addSubview:btnView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(25, 55, 55, 20)];
        lable.text = @"我的点评";
        lable.font = [UIFont systemFontOfSize:12];
        [footView addSubview:lable];
        
        UIView *margView = [[UIView alloc]initWithFrame:CGRectMake(mScreenSize.width*0.3, 20, 1, 45)];
        margView.backgroundColor = [UIColor grayColor];
        [footView addSubview:margView];
        
        
        
         UIButton *btnView1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btnView1.frame = CGRectMake(mScreenSize.width*0.3+50, 15, 35, 35);
//        btnView1.backgroundColor =[UIColor whiteColor];
         [btnView1 setBackgroundImage:[UIImage imageNamed:@"tuan_review_good"] forState:UIControlStateNormal];
        [footView addSubview:btnView1];
        
        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(mScreenSize.width*0.3+40, 55, 55, 20)];
        lable1.text = @"我的收藏";
        lable1.font = [UIFont systemFontOfSize:12];
        [footView addSubview:lable1];
        
        UIView *margView1 = [[UIView alloc]initWithFrame:CGRectMake(mScreenSize.width*0.6+20, 20, 1, 45)];
        margView1.backgroundColor = [UIColor grayColor];
        [footView addSubview:margView1];
        
       UIButton *btnView2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btnView2.frame = CGRectMake(mScreenSize.width*0.6+80, 15, 35, 35);
//        btnView2.backgroundColor =[UIColor whiteColor];
        [btnView2 setBackgroundImage:[UIImage imageNamed:@"main_index_tuan_pressed"] forState:UIControlStateNormal];
        [footView addSubview:btnView2];
        
        UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(mScreenSize.width*0.6+65, 55, 60, 20)];
        lable2.text = @"我的团购卷";
        lable2.font = [UIFont systemFontOfSize:12];
        [footView addSubview:lable2];
        
        footView.backgroundColor = [UIColor whiteColor];
        return footView;
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        if (_userinfo == nil) {
            NSLog(@"进这里login");
            HHLoginViewController *login = [[HHLoginViewController alloc]init];
            [self presentViewController:login animated:YES completion:nil];
        }else{
             NSLog(@"进这里set");
            HHUserInfoSettingViewController *setting = [HHUserInfoSettingViewController new];
             setting.suserInfo = _userinfo;
            [self presentViewController:setting animated:YES completion:nil];
        }
//         NSLog(@"你选择了%ld",indexPath.section);
       
    }else if (indexPath.section == 4) {
        if (indexPath.row == 1) {
            HHSettingViewController *setting = [[HHSettingViewController alloc]init];
            [self presentViewController:setting animated:YES completion:nil];
        }
    }
}
@end
