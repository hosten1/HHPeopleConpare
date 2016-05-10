//
//  HHSettingItem.m
//  HHSweepstakes
//
//  Created by mac on 16/1/17.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHMyMessage.h"
#import "HHMyMessgeItemLogin.h"

@implementation HHMyMessage
-(instancetype)initWithIcon:(NSString*)icon title:(NSString*)title{
    if (self == [super init]) {
        self.icon = icon;
        self.title= title;
       
    }
    return self;
}
/**
 初始化数据
*/
-(NSMutableArray*)addData{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSMutableArray *infoArray = nil;
    
    NSArray *arr = @[@"my_order_user_icon_normal"];
    NSArray *arr1 = @[@"my_order_user_icon_normal",@"my_wallet_user_icon_normal",@"my_card_user_icon_normal"];
    NSArray *arr2 = @[@"my_review_user_icon_normal"];
    NSArray *arr3 = @[@"navibar_search_icon_search"];
    NSArray *arr4 = @[@"my_history_user_icon_normal",@"my_setting_user_icon_normal"];
    
    NSArray *arr5 = @[@"my_wallet_user_icon_normal"];
    NSArray *iconArray = @[arr,arr1,arr2,arr3,arr4,arr5];
    
    NSArray *nameArr = @[@"登陆"];
    NSArray *nameArr1 = @[@"我的订单",@"我的钱包",@"我的积分"];
    NSArray *nameArr2 = @[@"带点评"];
    NSArray *nameArr3 = @[@"找好友"];
    NSArray *nameArr4 = @[@"最近浏览",@"设置"];
    NSArray *nameArr5 = @[@"我是商家"];
//    NSArray *nameArr6 = @[];
    NSArray *nameArray = @[nameArr,nameArr1,nameArr2,nameArr3,nameArr4,nameArr5];
    HHMyMessage *mess = nil;
    
    for (NSInteger i = 0; i < iconArray.count; i++) {
           NSArray *ic = iconArray[i];
           NSArray *name = nameArray[i];
//           NSLog(@"%ld",ic.count);
         infoArray =[NSMutableArray array];

        for (NSInteger j = 0; j < ic.count; j++) {
            if (i == 0) {
                mess = [[HHMyMessgeItemLogin alloc]init];
                mess.icon = ic[j];
                mess.title = name[j];
                
                [infoArray addObject:mess];
            }else{
                mess = [[HHMyMessage alloc]init];
                mess.icon = ic[j];
                mess.title = name[j];
                
                [infoArray addObject:mess];
            }
           
//            NSLog(@"%ld",infoArray.count);
        }
//        NSLog(@"%@",infoArray);
        [mutArray addObject:infoArray];
//          NSLog(@"%@",mutArray);
    }
  
    return mutArray;
}

+(instancetype)msgWithIcon:(NSString*)icon title:(NSString*)title{
      return [[self alloc]initWithIcon:icon title:title];
}
@end
