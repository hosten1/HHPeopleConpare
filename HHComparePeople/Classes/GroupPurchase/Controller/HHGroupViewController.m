//
//  HHGroupViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHGroupViewController.h"
#import "UIImage+Extention.h"
#import "HHGroupTableViewCell.h"
#import "HHGroupDatas.h"
#import "HHPickerViewController.h"
#import "HHAddressViewController.h"

#define mScreenSize [UIScreen mainScreen].bounds.size

@interface HHGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic, weak)UIView *headerView;
@property(nonatomic, weak)UITableView *groupTableView;
@property (assign,nonatomic) int viewCount;
@property(nonatomic, strong)NSArray *groupdatas;
@property(nonatomic, strong)HHPickerViewController *pickerControlller;
@property(nonatomic, weak)UITextField *headerTextFiled;

@end

@implementation HHGroupViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        UIImage *norimg = [UIImage imageNamed:@"main_index_tuan_normal"];
        UIImage *selectImg = [UIImage imageNamed:@"main_index_tuan_pressed"];
        
        norimg = [UIImage scaleImage:norimg toScale:0.4];
        
        selectImg = [UIImage scaleImage:selectImg toScale:0.4];
        
        
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"团购优惠" image:norimg selectedImage:selectImg];
        
        
        self.tabBarItem = item;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [self addHeader];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
    [self addHeader];
    
    //    HHHomeDatas *hom = [[HHHomeDatas alloc]init];/
    self.groupdatas =  [HHGroupDatas addTitleData];
    //加载数据
    //设置tableeView
    [self initTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNameNotification:) name:@"ChangeNameNotification" object:nil];
    
    
}
#pragma mark  通只事件
-(void)ChangeNameNotification:(NSNotification*)notification{
    [self addHeader];
}


-(void)initTableView{
    //tableView
    CGFloat tabY = self.headerView.frame.origin.y+40;
    CGFloat heithy = mScreenSize.height - tabY;
    /*
     
     */
    UITableView *groupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tabY, mScreenSize.width, heithy) style:UITableViewStyleGrouped];
    groupTableView.backgroundColor = [UIColor clearColor];
    groupTableView.delegate = self;
    groupTableView.dataSource = self;
    self.groupTableView = groupTableView;
    [self.view addSubview:groupTableView];
}
-(void)addHeader{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenSize.width, mScreenSize.height*0.06)];
    self.headerView = headerView;
    CGSize sizze = headerView.frame.size;
    UIButton  *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //获取沙盒记录
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString  *address =[user objectForKey:@"cityName"];
//    NSLog(@"address>>>%@",address);
    if (address == nil) {
        address = @"西安";
    }
    [headerBtn setTitle:address forState:UIControlStateNormal];

     headerBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    [headerBtn addTarget:self action:@selector(addPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [headerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    headerBtn.frame = CGRectMake(5,15 , 60, sizze.height*0.33);
    [headerView addSubview:headerBtn];
    
    UIImage *addreImg = [UIImage imageNamed:@"title_home_arrow_down_normal"];
    UIImageView *addreImgView = [[UIImageView alloc]initWithFrame:CGRectMake(60,12 , 20, 20 )];
    [addreImgView setImage:addreImg];
    [headerView addSubview:addreImgView];
    
    UITextField *headerTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(80,5, 290, sizze.height*0.73)];
    [headerTextFiled setPlaceholder:@"输入用户名,地点"];
    [headerTextFiled setFont:[UIFont systemFontOfSize:12]];
    [headerTextFiled.layer setCornerRadius:15];
    [headerTextFiled.layer setMasksToBounds:YES];
    headerTextFiled.backgroundColor = [UIColor whiteColor];
    [headerTextFiled setLayoutMargins:UIEdgeInsetsMake(0, 30, 0, 0)];
    headerTextFiled.delegate = self;
    [headerView addSubview:headerTextFiled];
    //文本框图片
    UIImageView *leftView = [[UIImageView alloc]initWithImage: [UIImage imageNamed: @"booking_channel_search_icon" ]];
    leftView.frame = CGRectMake(0, 0, 15, 15);
    [headerTextFiled setLeftView:leftView];
    [headerTextFiled setLeftViewMode:UITextFieldViewModeAlways];
  
    
    headerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:headerView];
}
//点击按钮出现
-(void)addPickerView:(UIButton*)sender{
    //    NSLog(@"我被点击了");
    if (self.pickerControlller == nil) {
        //        NSLog(@"ddddddddd");
        HHPickerViewController *pickerView = [[HHPickerViewController alloc]init];
        self.pickerControlller = pickerView;
        CGRect rect = CGRectMake(20, 60, 325, 100);
        
        [pickerView.view setFrame:rect];
        
        [pickerView.view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:pickerView.view];
    }else{
        [self.pickerControlller.view removeFromSuperview];
        self.pickerControlller = nil;
        [self viewDidLoad];
    }
    
}



#pragma mark -- table 的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    NSArray *arr = self.infoArray[section];
    //            NSLog(@"ddd:%@",arr);
    int cou = 0;
    if (section == 0 || section ==1 ) {
        cou = 1;
    }else{
        cou = 100;
    }
    return cou;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 30;
    }else if (section == 0){
        return 0.1;
    }
    
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
        {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        if (indexPath.section == 0) {
            
            [self addScrollView:cell];
        }
        
        return  cell;
    }else{
        //设置自己的cell
        //1.创建cell
        HHGroupTableViewCell *cell=[HHGroupTableViewCell cellWithTableView:tableView];
        //2.获取当前行的模型,设置cell的数据
        //         cell.yytg=tg;
        //3.返回cell
        return cell;
    }
    return nil;
}
#pragma mark --设置选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.groupTableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UILabel *titlLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 20)];
        titlLable.font = [UIFont systemFontOfSize:12];
        titlLable.textColor = [UIColor redColor];
        titlLable.text = @"为你精选";
        return titlLable;
    }
    return nil;
}
-(void)addScrollView:(UITableViewCell*)cell{
    
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, mScreenSize.width, 170)];
        
    
        [self addSubBtn:subView];
    [subView setBackgroundColor:[UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9]];
        [cell.contentView addSubview:subView];
   
    
    
    
}
-(void)addSubBtn:(UIView*)subView{
    NSInteger count = 9;
    CGFloat subViewWidth = 120;
    CGFloat subViewHight = 57;
    NSInteger rowNum = 3;
    
  
    
    HHGroupDatas *homesda = nil;
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
        CGFloat subViewX = 3 + col*(marginX+subViewWidth);
        //        子view的纵坐标公式=50+行号*（子view的纵向间距+子view的高度）
        CGFloat subViewY =3 + row * (marginY + subViewHight);
        
        [views setFrame:CGRectMake(subViewX, subViewY, subViewWidth, subViewHight)];
        //添加子button
        UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
        btnView.frame = CGRectMake(15, 10, 35, 35);
        
        [views addSubview:btnView];
        UILabel *sunLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, 90, 20)];
        sunLab.font = [UIFont systemFontOfSize:10];
        [views addSubview:sunLab];
        homesda= [HHGroupDatas new];
        homesda =   self.groupdatas[i];
        //           NSLog(@"%@.....%@",homesda.nameTitle,homesda);
        [btnView setBackgroundImage:[UIImage imageNamed:homesda.iconNameTitle] forState:UIControlStateNormal];
        sunLab.text = homesda.nameTitle;
        
        btnView.tag = 3000+i;
            
        [btnView addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [views setBackgroundColor:[UIColor whiteColor]];
    }
    
    
}
#pragma mark ---UITextFiled 代理方法

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    //跳转
    HHAddressViewController *addr = [[HHAddressViewController alloc]init];
    [self presentViewController:addr animated:YES completion:nil];
}
-(void)titleBtnClick:(UIButton*)sender{
    NSLog(@"被点击了：+%ld",sender.tag);
}

@end
