//
//  HHSettingItem.h
//  HHSweepstakes
//
//  Created by mac on 16/1/17.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^OperationBlock)();
@interface HHMyMessage : NSObject
@property(nonatomic, copy)NSString *icon;
@property(nonatomic, copy)NSString *title;

//存储一个特殊的Block 属性(使用copy)
@property(nonatomic, copy)OperationBlock opeBlock;
//给一个控制器的类型
@property(nonatomic, assign)Class vcClass;
-(instancetype)initWithIcon:(NSString*)icon title:(NSString*)title;
+(instancetype)msgWithIcon:(NSString*)icon title:(NSString*)title;
-(NSMutableArray*)addData;
//@property(nonatomic, copy)NSString *timeDate;
@end
