//
//  HHUserInfoDB.h
//  HankowThamesCode
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHUserInfo.h"

@interface HHUserInfoDB : NSObject
-(void)insertDB:(HHUserInfo *)userInfo ;
-(void)deleteDB:(HHUserInfo *)userInfo ;
-(bool)updataDBWithuserid:(NSInteger)_id columName:(NSString*)columName pwd:(NSString*)pwdValue;
-(void)deleteDBWithNumber:(NSString*)phoneNumber;
-(HHUserInfo*)findUserWithNumber:(NSString*)phoneNumber;
//根据用户姓名找
-(HHUserInfo*)findUserWithName:(NSString*)username;
-(NSMutableArray*)FindAllWithTableName;
//按照密码查询
-(HHUserInfo*)findUserWithName:(NSString*)username pwd:(NSString*)pwd;
@property(nonatomic, strong)HHUserInfo *userinfo;
@end
