//
//  HHDiscussShopDB.m
//  HankowThamesCode
//
//  Created by mac on 16/3/21.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHDiscussShopDB.h"
#import "HHDiscusses.h"

#import "FMDB.h"

FMDatabase *_discussdb;
@implementation HHDiscussShopDB
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self openDBWithDBname];
    }
    return self;
}
-(void)openDBWithDBname{
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"discussShop.sqlite"];
    NSLog(@"这个是商铺评论缓存：%@",fileName);
    //2.获得数据库
    _discussdb=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([_discussdb open]) {
        //4.创表
        BOOL result=[_discussdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_discussShop (_id integer PRIMARY KEY AUTOINCREMENT, userName text NOT NULL, shopID text NOT NULL,times text not null,discusess text not null,userID text not null,icon text,leve integer not null);"];
        if (result) {
            NSLog(@"创表成功");
        }else
        {
            NSLog(@"创表失败");
        }
    }
}
-(NSArray *)findAllCityShopDiscountWithShopID:(NSString*)shopID{
   
    NSMutableArray *citys = [NSMutableArray array];
    if ([_discussdb open]) {
        
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_discussShop where shopID=%@ order by _id desc;",shopID];        // 1.执行查询语句
        
        FMResultSet *resultSet = [_discussdb executeQuery:sql];
        HHDiscusses *discus = nil;
        // 2.遍历结果
        while ([resultSet next]) {
            discus = [[HHDiscusses alloc]init];
             NSString *name = [resultSet stringForColumn:@"userName"];
             NSString *_id =  [resultSet stringForColumn:@"_id"];
             NSString *shopID = [resultSet stringForColumn:@"shopID"];
             NSString *times = [resultSet stringForColumn:@"times"];
             NSString *discusess = [resultSet stringForColumn:@"discusess"];
             NSInteger leve = [resultSet longForColumn:@"leve"];
            NSString *userid = [resultSet stringForColumn:@"userID"];
            NSString *userIocn = [resultSet stringForColumn:@"icon"];
            
             discus.userID = userid;
             discus.nicheng = name;
             discus.shopID = shopID;
             discus.shijian = times;
             discus.pinglun = discusess;
//             discus.datu = ;
             discus.xingji = leve;
             discus.ID = _id;
            discus.icon = userIocn;
//            userName , shopID ,times ,discusess,leve
            [citys addObject:discus];
       
        }
        [_discussdb close];
        
    }
    
    
    return citys;

}
-(void)insertFromHistoryWithName:(HHDiscusses*)dis{
    
    
   
   
    if ([_discussdb open]) {
                    // 1.执行查询语句
            NSString *sql=[NSString stringWithFormat:@"insert into t_discussShop (userName , shopID ,times ,discusess,leve,userID,icon) values ('%@','%@','%@','%@','%ld','%@','%@');",dis.nicheng ,dis.shopID,dis.shijian,dis.pinglun,dis.xingji,dis.userID,dis.icon];
        
            BOOL ye = [_discussdb executeUpdate:sql];
            if (ye) {
                NSLog(@"插入成功");
            }else{
                NSLog(@"插入失败");
                
            }
        
        [_discussdb close];
        
    }
    
}


@end
