//
//  HHUpdateInfoViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/3/10.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHUpdateInfoViewController.h"
#import "UIImage+Extention.h"
#import "HHUserInfoDB.h"
#import "HHUserInfoSettingViewController.h"
#import "MBProgressHUD+Extend.h"
#define mScreenSize [UIScreen mainScreen].bounds.size

@interface HHUpdateInfoViewController ()<UITextFieldDelegate>
@property(nonatomic, weak)UIView *headerView;

@property(nonatomic, strong)HHUserInfoDB *useDB;
@property(nonatomic, weak)UITextField *margField;
@property(nonatomic, weak)UIView *textView;
@property(nonatomic, weak)UITextField *margpedField;
@property(nonatomic, weak)UITextField *newpwdField;
@property(nonatomic,weak)UITextField *rewpwdField;

@end

@implementation HHUpdateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
    
//    NSLog(@"dfasfd:%@",_name);
    [self addHeader];
    [self updateUser];
    [self addButton];
}
-(void)addButton{
    
    UIButton *upd = [UIButton buttonWithType:UIButtonTypeCustom];
    [upd setTitle:@"保存" forState:UIControlStateNormal];
    [upd setFrame:CGRectMake(10,self.textView.frame.origin.y+self.textView.frame.size.height+10, 345, 35)];
    [upd setBackgroundColor:[UIColor orangeColor]];
    [upd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //设置点击事件
    [upd addTarget:self action:@selector(btnlogins) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upd];
    
}
/***按钮点击事件**/
-(void)btnlogins{
    NSLog(@"返回");
     _useDB = [[HHUserInfoDB alloc]init];
    [self.margField resignFirstResponder];
    HHUserInfoSettingViewController *us = [[HHUserInfoSettingViewController alloc]init];
    NSString *text = self.margField.text;
    if (text != nil) {

        if ([_name isEqualToString:@"昵称"]) {
            
            bool result = [_useDB updataDBWithuserid:_infos.ID columName:@"username" pwd:text];
            if (result) {
//                NSLog(@"知心这里");
                //                us.suserInfo = _infos;
                [self dismissViewControllerAnimated:YES completion:nil];
                [us viewDidLoad];
            }
            }else if ([_name isEqualToString:@"常居住地"]) {
                
                bool result = [_useDB updataDBWithuserid:_infos.ID columName:@"address" pwd:text];
                if (result) {
                    NSLog(@"常居住地");
                    //                us.suserInfo = _infos;
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [us viewDidLoad];
                }
                }else if ([_name isEqualToString:@"收货地址"]) {
                    
                    bool result = [_useDB updataDBWithuserid:_infos.ID columName:@"shippingAddress" pwd:text];
                    if (result) {
                        NSLog(@"收货地址");
                        //                us.suserInfo = _infos;
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [us viewDidLoad];
                        
                    }
                }
    }else if([_name isEqualToString:@"密码"]) {
        NSString *pwd =  self.newpwdField.text;
        NSString *repwd = self.rewpwdField.text;
        if ([pwd isEqualToString:repwd]) {
            
            bool result = [_useDB updataDBWithuserid:_infos.ID columName:@"userpwd" pwd:pwd];
            if (result) {
//                NSLog(@"知心这里");
                [us viewDidLoad];
                //                us.suserInfo = _infos;
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }

        }else{
            [MBProgressHUD showError:@"两次密码不一致" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
            });
        }
    }

  
}
/**修改信息**/
-(void)updateUser{
    if ([_name isEqualToString:@"密码"]) {
        
        
        UIView *testView = [[UIView alloc]initWithFrame:CGRectMake(0, 78, mScreenSize.width, 55*3)];
        self.textView = testView;
        [testView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *margpwd = [[UILabel alloc]initWithFrame:CGRectMake(10,5, 74, 44)];
        margpwd.text = @"原密码";
        margpwd.textColor = [UIColor grayColor];
        margpwd.alpha = 0.6;
        
        UITextField *margpedField = [[UITextField alloc]initWithFrame:CGRectMake(110, 5, 200, 44)];
        self.margpedField = margpedField;
//        margpedField.text = _resu;
        margpedField.delegate = self;
        [testView addSubview:margpwd];
        [testView addSubview:margpedField];
        
        
        UILabel *newpwd = [[UILabel alloc]initWithFrame:CGRectMake(10,margpedField.frame.origin.y+margpedField.frame.size.height+6, 74, 44)];
        newpwd.text = @"新密码";
        newpwd.textColor = [UIColor grayColor];
        newpwd.alpha = 0.6;
        
        UITextField *newpwdField = [[UITextField alloc]initWithFrame:CGRectMake(110, margpedField.frame.origin.y+margpedField.frame.size.height+6, 200, 44)];
        self.newpwdField = newpwdField;
//        newpwdField.text = _resu;
       
        [testView addSubview:newpwd];
        [testView addSubview:newpwdField];
        
        UILabel *rewpwd = [[UILabel alloc]initWithFrame:CGRectMake(10,newpwdField.frame.origin.y+newpwdField.frame.size.height+6, 74, 44)];
        rewpwd.text = @"再次输入";
        rewpwd.textColor = [UIColor grayColor];
        rewpwd.alpha = 0.6;
        
        UITextField *rewpwdField = [[UITextField alloc]initWithFrame:CGRectMake(110, newpwdField.frame.origin.y+newpwdField.frame.size.height+6, 200, 44)];
        self.rewpwdField = rewpwdField;
//        rewpwdField.text = _resu;
        rewpwdField.enabled = NO;
        [testView addSubview:rewpwd];
        [testView addSubview:rewpwdField];
        
        
        [self.view addSubview:testView];
    }else{
        UIView *testView = [[UIView alloc]initWithFrame:CGRectMake(0, 78, mScreenSize.width, 55)];
        self.textView = testView;
        [testView setBackgroundColor:[UIColor whiteColor]];
        UILabel *margLab = [[UILabel alloc]initWithFrame:CGRectMake(10,5, 74, 44)];
        margLab.text = _name;
        margLab.textColor = [UIColor grayColor];
        margLab.alpha = 0.6;
        
        UITextField *margField = [[UITextField alloc]initWithFrame:CGRectMake(110, 5, 200, 44)];
        self.margField = margField;
        margField.text = _usinfo;
        //    self.margField.backgroundColor = [UIColor redColor];
        [testView addSubview:margLab];
        [testView addSubview:margField];
        
        
        [self.view addSubview:testView];
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
    headerBtn.frame = CGRectMake(8,13,10,15);
    
    [headerView addSubview:headerBtn];
    
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(sizze.width*0.2,15, 200, sizze.height*0.33)];
    headerLab.text = [NSString stringWithFormat:@"修改%@",_name] ;
    headerLab.textAlignment = UITextAlignmentCenter;
    [headerView addSubview:headerLab];
    
    
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
}
/***返回个人信息设置页面***/
-(void)backBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///******懒加载数据******/
//-(HHUserInfoDB *)useDB{
//    if (_useDB == nil) {
//        NSLog(@"ddddddd");
//        _useDB = [[HHUserInfoDB alloc]init];
//    }
//    return _useDB;
//}
#pragma mark ---textFiled代理方法
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *pwd = textField.text;
    [textField resignFirstResponder];
     _newpwdField.enabled = NO;
    if (pwd != nil) {
        NSLog(@"%@",_infos.userName);
        _useDB = [[HHUserInfoDB alloc]init];
       HHUserInfo *info = [_useDB findUserWithName:_infos.userName pwd:pwd];
        if (info == nil) {
            self.newpwdField.enabled = NO;
            self.rewpwdField.enabled = NO;
            
            [MBProgressHUD showError:@"密码错误" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
            });
        }else{
            self.newpwdField.enabled = YES;
            self.rewpwdField.enabled = YES;
        }
    }
}

@end
