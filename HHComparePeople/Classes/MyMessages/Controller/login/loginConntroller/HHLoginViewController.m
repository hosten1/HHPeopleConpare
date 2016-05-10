//
//  HHLoginViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHLoginViewController.h"
#import "UIImage+Extention.h"
#import "HHUserInfoDB.h"
#import "HHUserInfo.h"
#import "HHRegistViewController.h"
#import "Regular.h"
#import "MBProgressHUD+Extend.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/Extend/SMSSDK+ExtexdMethods.h>
#import <MOBFoundation/MOBFoundation.h>

#define mScreenSize [UIScreen mainScreen].bounds.size

@interface HHLoginViewController ()<UITextFieldDelegate>
@property(nonatomic, strong)HHUserInfoDB *userDB;

@property(nonatomic, weak)UIView *headerView;
@property(nonatomic, weak)UIButton *loginButton;
@property(nonatomic, weak)UITextField *numFiled;
@property(nonatomic, weak)UITextField *regFiled;
@property(nonatomic, weak)UITextField *nameFiled;
@property(nonatomic, weak)UITextField *pwdFiled;


@property(nonatomic, assign)int count;
@property(nonatomic, weak)UIView *numberView;
@property(nonatomic,strong)  UILabel* timeLabel;
@property (nonatomic, strong) NSTimer* timer2;
@property(nonatomic, weak)UIButton *btnShare;
@property (nonatomic, strong) NSTimer* timer1;
@property(nonatomic, weak)UIButton *headerBtnim;
@property (nonatomic) SMSGetCodeMethod getCodeMethod;
@property(nonatomic, strong)NSArray *arrayName;
@end

@implementation HHLoginViewController
-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *use = [NSUserDefaults standardUserDefaults];
    NSString *info = [use objectForKey:@"loginInfo"];
    if (info != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
    self.arrayName = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"g",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    
    //添加头部
    [self addHeader];
    if (self.userDB == nil) {
        HHUserInfoDB *use = [[HHUserInfoDB alloc]init];
        self.userDB = use;
    }
    
    
     NSArray *uses = [self.userDB FindAllWithTableName];
    if (uses == nil) {
        //添加登陆框
        [self addLoginView];
    }else{
        //添加登陆框
        [self addReLoginView];
    }
    
}
/**********已注册用户登录*************/
-(void)addReLoginView{
    /**************登陆手机号填写***************/
    UIView *numberView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, mScreenSize.width, 50)];
    numberView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =  CGRectMake(10, 20, 50, 20);
    UILabel *labBtn = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    labBtn.text = @"用户名: ";
   
    labBtn.font = [UIFont systemFontOfSize:14];
    [numberView addSubview:labBtn];
    
    [numberView addSubview:button];
    /*****/
    UITextField *numFiled = [[UITextField alloc]initWithFrame:CGRectMake(69, 5, 210,40)];
    //    numFiled.backgroundColor = [UIColor grayColor];
    numFiled.placeholder = @"手机号或用户名";
    numFiled.font = [UIFont systemFontOfSize:14];
    self.nameFiled = numFiled;
    self.nameFiled.delegate = self;
    
    [numberView addSubview:numFiled];
    
    [self.view addSubview:numberView];
    
    UIView *ma = [[UIView alloc]initWithFrame:CGRectMake(0, 124, mScreenSize.width, 1)];
    [ma setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:ma];
    /**************密码***************/
    UIView *registView = [[UIView alloc]initWithFrame:CGRectMake(0, 126, mScreenSize.width, 50)];
    registView.backgroundColor = [UIColor whiteColor];
    
    UILabel *markLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 70, 40)];
    markLab.text = @"密  码:";
    markLab.font = [UIFont systemFontOfSize:15];
    [registView addSubview:markLab];
    
    UITextField *regFiled = [[UITextField alloc]initWithFrame:CGRectMake(70, 13, 250, 30)];
    regFiled.placeholder = @"请输入密码";
    [registView addSubview:regFiled];
    regFiled.font = [UIFont systemFontOfSize:14];
    regFiled.delegate = self;
    self.pwdFiled =regFiled;
    self.pwdFiled.delegate = self;
    [self.view addSubview:registView];
    /**************login button***************/
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, registView.frame.origin.y+70, mScreenSize.width*0.9, 40);
    loginButton.backgroundColor = [UIColor orangeColor];
    //设置透明度
    loginButton.alpha = 0.4;
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    //    loginButton.titleLabel.text =
    loginButton.titleLabel.textColor = [UIColor whiteColor];
    //点击按钮登陆
    loginButton.tag = 2010;
    [loginButton addTarget:self action:@selector(btnloginlog:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5;
    self.loginButton = loginButton;
    [self.view addSubview:loginButton];
}
#pragma mark -- 用户登陆
-(void)addLoginView{
     /**************登陆手机号填写***************/
    UIView *numberView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, mScreenSize.width, 50)];
    numberView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =  CGRectMake(10, 17, 40, 20);
    UILabel *labBtn = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    labBtn.text = @"+86";
//    [button setTitle:@"+86" forState:UIControlStateNormal];
    UIImage *img = [UIImage imageNamed:@"ic_arrow_down_black"];
//    [button setImage:img forState:UIControlStateNormal];
    img = [UIImage scaleImage:img toScale:0.7];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(40,13, 15,25)];
    imgView.image = img;
//    button.imageView.frame = CGRectMake(3, 3, 10, 10);
//    CGFloat imgWidthBtn = button.imageView.frame.size.width;
//    CGFloat labWithBtn = button.titleLabel.frame.size.width;
    //设置图片偏移量
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, labWithBtn, 0, -labWithBtn);
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imgWidthBtn ,0, imgWidthBtn);
     labBtn.font = [UIFont systemFontOfSize:14];
    [numberView addSubview:labBtn];
    [numberView addSubview:imgView];
    [numberView addSubview:button];
    /*****/
    UITextField *numFiled = [[UITextField alloc]initWithFrame:CGRectMake(69, 5, 210,40)];
//    numFiled.backgroundColor = [UIColor grayColor];
     numFiled.placeholder = @"手机号";
     numFiled.font = [UIFont systemFontOfSize:14];
    
    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(270, 15, 90, 20);
//    btnShare.backgroundColor = [UIColor redColor];
    [btnShare.layer setBorderColor:[UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9].CGColor];
    [btnShare.layer setBorderWidth:1];
    [numberView addSubview:btnShare];
    [btnShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnShare setTitle:@"获取验证码" forState:UIControlStateNormal];
    btnShare.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnShare addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.btnShare = btnShare;
    self.numberView = numberView;
    self.numFiled = numFiled;
    [numberView addSubview:numFiled];
    
    [self.view addSubview:numberView];
     /**************y验证信息填写***************/
    UIView *registView = [[UIView alloc]initWithFrame:CGRectMake(0, 131, mScreenSize.width, 50)];
    registView.backgroundColor = [UIColor whiteColor];
    
    UILabel *markLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 70, 40)];
    markLab.text = @"验证码";
    markLab.font = [UIFont systemFontOfSize:15];
    [registView addSubview:markLab];
    
    UITextField *regFiled = [[UITextField alloc]initWithFrame:CGRectMake(90, 13, 250, 30)];
    regFiled.placeholder = @"请输入短信验证码";
    [registView addSubview:regFiled];
    regFiled.delegate = self;
    self.regFiled =regFiled;
    [self.view addSubview:registView];
  /**************login button***************/
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, registView.frame.origin.y+70, mScreenSize.width*0.9, 40);
    loginButton.backgroundColor = [UIColor orangeColor];
    //设置透明度
    loginButton.alpha = 0.4;
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
//    loginButton.titleLabel.text =
    loginButton.titleLabel.textColor = [UIColor whiteColor];
    //点击按钮登陆
    loginButton.tag = 2011;
    [loginButton addTarget:self action:@selector(btnloginlog:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5;
    self.loginButton = loginButton;
    [self.view addSubview:loginButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)btnloginlog:(UIButton*)sender{
    if (sender.tag == 2010) {
        NSLog(@"点击我");
        [self.pwdFiled resignFirstResponder];
        [self.nameFiled resignFirstResponder];
        NSString *name = self.pwdFiled.text;
        NSString *pwd  = self.nameFiled.text;
        
        if (self.userDB == nil) {
            HHUserInfoDB *db = [[HHUserInfoDB alloc]init];
            self.userDB = db;
        }else{
            
          HHUserInfo *userInfo =  [self.userDB findUserWithName:name pwd:pwd];
            if (userInfo != nil) {
//                NSLog(@"你登录了");
                //存入沙盒中
                NSUserDefaults *userDafault = [NSUserDefaults standardUserDefaults];
                [userDafault setObject:userInfo.numberPhone forKey:@"loginInfo"];
                [userDafault synchronize];
                [self dismissViewControllerAnimated:YES completion:nil];
//                NSLog(@"ddskl%@",userInfo.numberPhone);
            }
            
        }
    }else{
        
        self.loginButton.alpha = 1.0;
        //    HHUserInfoDB *userinfo = [[HHUserInfoDB alloc]init];
        NSString *username = self.numFiled.text;
        //    HHUserInfo *use = [userinfo findUserWithName:username];
        
        NSUserDefaults *userDafault = [NSUserDefaults standardUserDefaults];
        [userDafault setObject:self.numFiled.text forKey:@"loginInfo"];
        [userDafault synchronize];
        //随机生成用户名
        //随机生成用户名
        NSMutableString *name = [[NSMutableString alloc]init];
        
        for (NSInteger i = 0; i < 6; i++) {
            int ran = arc4random_uniform(20);
            [name appendString:self.arrayName[ran]];
        }
        [name appendString:@"_"];
        NSMutableString *pwd = [[NSMutableString alloc]init];
        for (NSInteger i = 0; i < 7; i++) {
            int ran = arc4random_uniform(10);
            [pwd appendString:[NSString stringWithFormat:@"%d",ran]];
        }
        [name appendString:pwd];
        
        HHUserInfo *user = [[HHUserInfo alloc]init];
        user.userName = name;
        user.userPwd = pwd;
        user.numberPhone = self.numFiled.text;
        
        //存入数据库
        if (self.userDB == nil) {
            HHUserInfoDB *db = [[HHUserInfoDB alloc]init];
            self.userDB = db;
        }else{
            [self.userDB insertDB:user];
        }
        
        
//        NSLog(@"登陆了");
        [self dismissViewControllerAnimated:YES completion:nil];
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
    
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(sizze.width*0.45,15, 60, sizze.height*0.33)];
    headerLab.text = @"登陆";
    [headerView addSubview:headerLab];
    //
    UIButton  *headerBtnim = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtnim.frame = CGRectMake(sizze.width*0.9,15,30, sizze.height*0.45);
    [headerBtnim setTitle:@"注册" forState:UIControlStateNormal];
    [headerBtnim.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [headerBtnim setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.headerBtnim = headerBtnim;
    //注册按钮点击事件
    [headerBtnim addTarget:self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headerBtnim];
    
    
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
}
//注册
-(void)registBtnClick{
//    NSLog(@"注册");
    HHRegistViewController *regController = [[HHRegistViewController alloc]init];
    
    [self presentViewController:regController animated:YES completion:nil];
}
  //返回按钮点击事件
-(void)backBtn{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*************短信注册按钮*****************/
-(void)shareBtnClick{
//    NSLog(@"ffffffffff");
    if (self.numFiled.text.length == 11 || self.numFiled.text == nil)
    {
        NSString * isMatch = [Regular ValidateMobileNumber:self.numFiled.text];
        if ([isMatch isEqualToString:@"失败"])
        {
            //手机号码不正确
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"手机号码非法" message:@"请输入合法手机号" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"点击取消按钮执行");
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"点击确定按钮执行");
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            //                return;
        }else{
            NSString* str2 = [@"+86" stringByReplacingOccurrencesOfString:@"+" withString:@""];
            //                NSLog(@"3333333333");
            [self getVerificationCodeByMethod:self.getCodeMethod phoneNumber:self.numFiled.text zone:str2];
        }

    }else{
        
        [MBProgressHUD showError:@"不可以为空/请输入手机号" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
        });
        
        
        //            return;
    }
    
    
    self.loginButton.enabled = NO;
    self.loginButton.alpha = 0.5;
}

- (void)getVerificationCodeByMethod:(SMSGetCodeMethod)getCodeMethod phoneNumber:(NSString *)phoneNumber zone:(NSString *)zone
{
    __weak HHLoginViewController *regViewController = self;
    
    if (getCodeMethod == SMSGetCodeMethodSMS) {
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumber zone:zone customIdentifier:nil result:^(NSError *error)
         {
             NSLog(@"获取验证码");
             [regViewController getVerificationCodeResultHandler:phoneNumber zone:zone error:error];
             
             
         }];
        
    }
    else if (getCodeMethod == SMSGetCodeMethodVoice)
    {
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodVoice phoneNumber:phoneNumber zone:zone customIdentifier:nil result:^(NSError *error)
         {
             [regViewController getVerificationCodeResultHandler:phoneNumber zone:zone error:error];
             
             
         }];
    }
}

- (void)getVerificationCodeResultHandler:(NSString *)phoneNumber zone:(NSString *)zone error:(NSError *)error
{
    
    //    NSString *icon = [NSString stringWithFormat:@"SMSSDKUI.bundle/button4.png"];
    self.loginButton.enabled = YES;
    [self.loginButton setAlpha:0.1];
    
    if (!error)
    {
        [MBProgressHUD showSuccess:@"验证码已发送到你的手机，请注意查收" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
        });
        NSLog(@"验证码发送成功");
        //        btnShare.frame = CGRectMake(270, 15, 90, 20);
        //        //    btnShare.backgroundColor = [UIColor redColor];
        //        [btnShare.layer setBorderColor:[UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9].CGColor];
        //更改原来获取验证码按钮
        self.btnShare.hidden = YES;
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.frame = CGRectMake(270, 15, 110, 20);
        _timeLabel.numberOfLines = 0;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        _timeLabel.text = @"60秒后重新发送";
        
        [self.numberView addSubview:_timeLabel];
        [_timer2 invalidate];
        [_timer1 invalidate];
        
        _count = 0;
        
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(showRepeatButton) userInfo:nil repeats:YES];
        
        self.timeLabel.textColor = [UIColor lightGrayColor];
        NSTimer* timer2 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        _timer1 = timer;
        _timer2 = timer2;
        /****************发送成功进行处理*********************/
        
    }else{
        //手机号码不正确
        [MBProgressHUD showError:@"手机号码申请次数过多" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
        });
//            NSLog(@"失败");
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)sendMSGSuccess:(NSString *)phoneNumber zone:(NSString *)zone{
    //验证号码
    [self.view endEditing:YES];
//    NSLog(@"开始验证");
    NSLog(@"self.pwdFiled.text:%@",self.regFiled.text);
    if(self.regFiled.text.length != 4)
    {
        [MBProgressHUD showError:@"验证码位数错误" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
        });
        //验证码长度错误
    }else{
        [SMSSDK commitVerificationCode:self.regFiled.text phoneNumber:phoneNumber zone:zone result:^(NSError *error) {
            
            if (!error) {
                [MBProgressHUD showSuccess:@"验证成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view];
                });
//                NSLog(@"验证成功");
                self.timeLabel.hidden = YES;
//                self.btnShare.hidden = NO;
                self.btnShare.enabled = NO;
                _headerBtnim.hidden = YES;
                self.loginButton.enabled  = YES;
                self.loginButton.alpha = 1.0f;
//                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
            else
            {
                
                //                NSLog(@"验证失败");
                
                [MBProgressHUD showError:@"验证失败，请重新输入或重新获取" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view];
                });
                
                
            }
        }];
    }
}
-(void)updateTime
{
    
    _count ++;
    if (self.count >= 60)
    {
        [_timer2 invalidate];
        return;
    }
    //NSLog(@"更新时间");
    
    self.timeLabel.text = [NSString stringWithFormat:@"%i后重新发送",60 - self.count];
    
    if (self.count == 30)
    {
        if (self.getCodeMethod == SMSGetCodeMethodSMS) {
            
            //            if (_voiceCallMsgLabel.hidden)
            //            {
            //                _voiceCallMsgLabel.hidden = NO;
            //            }
            //
            //            if (_voiceCallButton.hidden)
            //            {
            //                _voiceCallButton.hidden = NO;
            //            }
        }
        
    }
}
#pragma mark --textFiled的代理
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"sssf3>>%@",[textField text]) ;
    
    if (self.userDB == nil) {
        HHUserInfoDB *db = [[HHUserInfoDB alloc]init];
        self.userDB = db;
    }else{
       HHUserInfo *inso = [self.userDB findUserWithName:self.nameFiled.text];
        if (inso == nil) {
            [MBProgressHUD showError:@"用户名不存在" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
            });
        }
    }
    //结束编辑处理
    [textField resignFirstResponder];
//    [self sendMSGSuccess:self.numFiled.text zone:@"+86"];
    
}
-(void)showRepeatButton{
    self.timeLabel.hidden = YES;
    self.btnShare.hidden = !self.btnShare.hidden;
    self.loginButton.enabled = NO;
    [self.btnShare setTitle:@"重新发送" forState:UIControlStateNormal];
    [_timer1 invalidate];
    return;
}


@end
