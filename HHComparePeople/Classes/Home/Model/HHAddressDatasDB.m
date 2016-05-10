//
//  HHAddressDatasDB.m
//  HankowThamesCode
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHAddressDatasDB.h"
#import "FMDB.h"
#import "HHProvince.h"
#import "HHCity.h"
#import "HHtown.h"
FMDatabase *_addressdb;
@implementation HHAddressDatasDB
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self openDBWithDBname];
    }
    return self;
}
-(NSString*)readyDatabase:(NSString*)dbName{
    BOOL success;
    NSFileManager *fileManeger = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    success = [fileManeger fileExistsAtPath:writableDBPath];
    if (!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:dbName];
        success = [fileManeger copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to creat writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    return writableDBPath;
}
-(void)openDBWithDBname{
    NSString *dataFilePath = [self readyDatabase:@"provience_city_coutry.sqlite"];
//    NSLog(@"ddd......%@",dataFilePath);
    //获取数据库文件
    if (_addressdb != nil) {
        return;
    }
    FMDatabase *db=[FMDatabase databaseWithPath:dataFilePath];
    _addressdb = db;
    //打开数据库
    if ([db open]) {
        
        NSLog(@"数据库打开成功");
    }else{
        
        NSLog(@"数据库打开失败");
    }
}
-(NSArray*)findProvinceOfAll{
    NSMutableArray *provinces = [NSMutableArray array];
      //开始查询
    
    if ([_addressdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_address_province;"];
        // 1.执行查询语句
        FMResultSet *resultSet = [_addressdb executeQuery:sql];
       
        // 2.遍历结果
        HHProvince *province = nil;
        while ([resultSet next]) {
            province = [[HHProvince alloc]init];
            NSInteger ID = [resultSet intForColumn:@"_id"];
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *code = [resultSet stringForColumn:@"code"];
            province.ID = ID;
            province.provinceName = name;
            province.provinceCode = code;
            
            [provinces addObject:province];
        }
      
        [_addressdb close];

    }
    
    return provinces;
}
-(NSArray *)findCityOfAllWithProvinceCode:(NSString*)ProvinceCode{
     NSMutableArray *citys = [NSMutableArray array];
    if ([_addressdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT *  FROM t_address_city where provinceCode=%@;",ProvinceCode];
        // 1.执行查询语句
        FMResultSet *resultSet = [_addressdb executeQuery:sql];
        
        // 2.遍历结果
        HHCity *city = nil;
        while ([resultSet next]) {
            
            city = [[HHCity alloc]init];
            NSInteger ID = [resultSet intForColumn:@"_id"];
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *cityCode = [resultSet stringForColumn:@"code"];
            NSString *provinceCode = [resultSet stringForColumn:@"provinceCode"];
            city.ID = ID;
            city.cityName = name;
            city.cityCode = cityCode;
            city.provinceCode = provinceCode;
            
            
            [citys addObject:city];
        }
        [_addressdb close];
        
    }

    
    return citys;
}
-(NSArray *)findTownOfAllWithCityCode:(NSString*)CityCode{
    NSMutableArray *towns = [NSMutableArray array];
    if ([_addressdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_address_town where cityCode=%@;",CityCode];
        // 1.执行查询语句
        FMResultSet *resultSet = [_addressdb executeQuery:sql];
        
        // 2.遍历结果
        HHtown *town = nil;
        while ([resultSet next]) {
            
            town = [[HHtown alloc]init];
            NSInteger ID = [resultSet intForColumn:@"_id"];
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *townCode = [resultSet stringForColumn:@"code"];
            NSString *cityCode = [resultSet stringForColumn:@"cityCode"];
            town.ID = ID;
            town.townName = name;
            town.cityCode = cityCode;
            town.townCode = townCode;
            
            
            [towns addObject:town];
        }
//        NSLog(@">>>%@",towns);
        [_addressdb close];
        
    }
    
    
    return towns;
}
//查找全部的城市
-(NSArray*)findAllCityName{
    NSMutableArray *citys = [NSMutableArray array];
    if ([_addressdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT *  FROM t_address_city;"];
        // 1.执行查询语句
        FMResultSet *resultSet = [_addressdb executeQuery:sql];
        
        // 2.遍历结果
        while ([resultSet next]) {
            
//            NSInteger ID = [resultSet intForColumn:@"_id"];
            NSString *name = [resultSet stringForColumn:@"name"];
//            NSString *cityCode = [resultSet stringForColumn:@"code"];
//            NSString *provinceCode = [resultSet stringForColumn:@"provinceCode"];
            [citys addObject:name];
        }
        [_addressdb close];
        
    }
    
    
    return citys;
}
/***模糊查询***/
//查找全部的城市
-(NSArray*)findAllCityNameAndTownNameWithName:(NSString*)name{
    
    
    NSMutableArray *citys = [NSMutableArray array];
    if ([_addressdb open]) {
         NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_address_city WHERE name like '%%%@%%' ;",name];        // 1.执行查询语句
        FMResultSet *resultSet = [_addressdb executeQuery:sql];
        
        // 2.遍历结果
        while ([resultSet next]) {
            NSString *name = [resultSet stringForColumn:@"name"];
           
            [citys addObject:name];
        }
        [_addressdb close];
        
    }
    
    
    return citys;
}
//查找全部的城市历史记录
-(NSArray*)findAllCityNameFromHistory{
    NSInteger i = 0;
    
    NSMutableArray *citys = [NSMutableArray array];
    if ([_addressdb open]) {
        
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_address_history order by _id desc ;"];        // 1.执行查询语句
        FMResultSet *resultSet = [_addressdb executeQuery:sql];
        
        // 2.遍历结果
        while ([resultSet next]) {
            NSString *name = [resultSet stringForColumn:@"name"];
            
           [citys addObject:name];
            i++;
            if (i == 6) {
                break;
            }
            
        }
        [_addressdb close];
        
    }
    
    
    return citys;
}

-(void)insertFromHistoryWithName:(NSString*)name{
    
   
   NSArray *findName =  [self findAllCityNameFromHistory];
    for (NSString*fname in findName) {
        if ([fname isEqualToString:name]) {
            return;
        }
    }
    NSInteger locID = arc4random_uniform(9);
    NSString *st = [NSString stringWithFormat:@"23000%ld",locID];
    if ([_addressdb open]) {
        /*****先间一张表用于保存历史数据*****/
        
        NSString *sqlCreate=@"create table if not exists t_address_history (_id integer primary key autoincrement,code text,name text);";
        BOOL flg = [_addressdb executeUpdate:sqlCreate];
        if (flg) {
             // 1.执行查询语句
            NSString *sql=[NSString stringWithFormat:@"insert into t_address_history (code,name) values ('%@','%@');",st ,name];
            BOOL ye = [_addressdb executeUpdate:sql];
            if (ye) {
                NSLog(@"插入成功");
            }else{
                NSLog(@"插入失败");
                
            }

        }else{
            NSLog(@"创建数据库表失败！");
        }
        
       [_addressdb close];
        
    }
 
}














@end
