//
//  HHUserInfoDB.m
//  HankowThamesCode
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHUserInfoDB.h"
//#import <sqlite3.h>
//#import "HHUserInfo.h"
#import "FMDB.h"
FMDatabase *_db;
//@interface HHUserInfoDB ()
// @property(nonatomic,assign)FMDatabase *db;
//@end


@implementation HHUserInfoDB
-(instancetype)init{
    self = [super init];
    if (self) {
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *fileName = [doc stringByAppendingPathComponent:@"userInfo.sqlite"];
        NSLog(@"ddd......%@",fileName);
        //获取数据库文件
        FMDatabase *db=[FMDatabase databaseWithPath:fileName];
        _db = db;
        //打开数据库
            if ([db open]) {
            //创建表
            NSString *sql  = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_userinfo(_id integer PRIMARY KEY AUTOINCREMENT,username text NOT NULL,userpwd text NOT NULL,numberPhone text NOT NULL,address text,sex text,vip text,shippingAddress text,icon text);"];
            BOOL result = result=[db executeUpdate:sql];
            if (result){
                NSLog(@"创表成功");
            }else{
                NSLog(@"创表失败");
            }
            
            
        }else{
            NSLog(@"数据库打开失败");
        }
    }
    return self;
}
-(void)insertDB:(HHUserInfo *)userInfo{
    //    1.拼接SQL语句
    

    if ([_db open]) {
        NSString *sql=[NSString stringWithFormat:@"INSERT INTO t_userinfo(username,userpwd,numberPhone,address,sex,vip,shippingAddress,icon) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@');",userInfo.userName,userInfo.userPwd,userInfo.numberPhone,(userInfo.address == nil)?@"西安":userInfo.address,(userInfo.sex == nil)?@"男":userInfo.sex,(userInfo.vip == nil)?@"NO":userInfo.vip,userInfo.shippingAddress,userInfo.icon];
        
        
        BOOL errmsg = [_db executeUpdate:sql];
        if (!errmsg) {//如果有错误信息
            NSLog(@"插入数据失败");
        }else{
            NSLog(@"插入数据成功");
        }
        [_db close];
    }
    
    
}

-(NSMutableArray*)FindAllWithTableName{
    NSMutableArray *infos = [NSMutableArray array];
    if ([_db open]) {
       //        NSLog(@"打开成功");
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_userinfo;"];
        // 1.执行查询语句
        FMResultSet *resultSet = [_db executeQuery:sql];
        HHUserInfo *user = nil;
        // 2.遍历结果
        while ([resultSet next]) {
//            NSLog(@"ddddddddddddddddddddd");
            user = [[HHUserInfo alloc]init];
            NSInteger ID = [resultSet intForColumn:@"_id"];
            NSString *name = [resultSet stringForColumn:@"username"];
            NSString *userpwd = [resultSet stringForColumn:@"userpwd"];
            NSString *numberPhone = [resultSet stringForColumn:@"numberPhone"];
            NSString *address = [resultSet stringForColumn:@"address"];
            NSString *sex = [resultSet stringForColumn:@"sex"];
            NSString *vip = [resultSet stringForColumn:@"vip"];
            NSString *shippingAddress = [resultSet stringForColumn:@"shippingAddress"];
             NSString *icon = [resultSet stringForColumn:@"icon"];
            
            user.ID = ID;
            user.userName = name;
            user.userPwd = userpwd;
            user.numberPhone = numberPhone;
            user.address = address;
            user.sex =sex;
            user.vip = vip;
            user.shippingAddress = shippingAddress;
            user.icon = icon;
            [infos addObject:user];
//            NSLog(@"%ld %@ %@", ID, name, userpwd);
        }
        [_db close];
    }
    return infos;
}
-(void)deleteDB:(HHUserInfo *)userInfo {
    if ([_db open]) {
        
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_userinfo WHERE _id ='%ld';", userInfo.ID];
        BOOL res = [_db executeUpdate:sql];
        
        if (!res) {
            NSLog(@"error when delete db table");
        } else {
            NSLog(@"success to delete db table");
        }
        [_db close];
    }
}
-(void)deleteDBWithNumber:(NSString*)phoneNumber {
    if ([_db open]) {
        
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_userinfo WHERE _id ='%@';", phoneNumber];
        BOOL res = [_db executeUpdate:sql];
        
        if (!res) {
            NSLog(@"error when delete db table");
        } else {
            NSLog(@"success to delete db table");
        }
        [_db close];
    }
}

-(bool)updataDBWithuserid:(NSInteger)_id columName:(NSString*)columName pwd:(NSString*)pwdValue{
    
    bool res = NO;
    if ([_db open]) {
        
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_userinfo SET  %@ = '%@' WHERE _id = '%ld';",columName,pwdValue, _id];
        NSLog(@"sql:%@",sql);
         res = [_db executeUpdate:sql];
//        NSLog(@"sssss%@",res);
        if (!res) {
            NSLog(@"error when update db table");
//            return NO;
        } else {
//            return YES;
            NSLog(@"success to update db table");
        }
        [_db close];
    }
    return res;
}
//根据用户姓名找
-(HHUserInfo*)findUserWithName:(NSString*)username{
    if ([_db open]) {
       
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_userinfo WHERE username='%@';",username];
        // 1.执行查询语句
        FMResultSet *resultSet = [_db executeQuery:sql];
        HHUserInfo *user = nil;
        // 2.遍历结果
        while ([resultSet next]) {
            //            NSLog(@"ddddddddddddddddddddd");
            user = [[HHUserInfo alloc]init];
            NSInteger ID = [resultSet intForColumn:@"_id"];
            NSString *name = [resultSet stringForColumn:@"username"];
            NSString *userpwd = [resultSet stringForColumn:@"userpwd"];
            NSString *numberPhone = [resultSet stringForColumn:@"numberPhone"];
            NSString *address = [resultSet stringForColumn:@"address"];
            NSString *sex = [resultSet stringForColumn:@"sex"];
            NSString *vip = [resultSet stringForColumn:@"vip"];
            NSString *shippingAddress = [resultSet stringForColumn:@"shippingAddress"];
            NSString *icon = [resultSet stringForColumn:@"icon"];
            user.icon = icon;
            user.ID = ID;
            user.userName = name;
            user.userPwd = userpwd;
            user.numberPhone = numberPhone;
            user.address = address;
            user.sex =sex;
            user.vip = vip;
            user.shippingAddress = shippingAddress;
            
//            NSLog(@"%ld %@ %@", ID, name, userpwd);
           
        }
        [_db close];
        return user;
    }
    return nil;
}
/********根据用户名和密码查询********/

-(HHUserInfo*)findUserWithName:(NSString*)username pwd:(NSString*)pwd{
    if ([_db open]) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_userinfo WHERE username='%@' and userpwd='%@';",username,pwd];
        // 1.执行查询语句
        FMResultSet *resultSet = [_db executeQuery:sql];
        HHUserInfo *user = nil;
        // 2.遍历结果
        while ([resultSet next]) {
            //            NSLog(@"ddddddddddddddddddddd");
            user = [[HHUserInfo alloc]init];
            NSInteger ID = [resultSet intForColumn:@"_id"];
            NSString *name = [resultSet stringForColumn:@"username"];
            NSString *userpwd = [resultSet stringForColumn:@"userpwd"];
            NSString *numberPhone = [resultSet stringForColumn:@"numberPhone"];
            NSString *address = [resultSet stringForColumn:@"address"];
            NSString *sex = [resultSet stringForColumn:@"sex"];
            NSString *vip = [resultSet stringForColumn:@"vip"];
            NSString *shippingAddress = [resultSet stringForColumn:@"shippingAddress"];
            NSString *icon = [resultSet stringForColumn:@"icon"];
            
            user.icon = icon;
            user.ID = ID;
            user.userName = name;
            user.userPwd = userpwd;
            user.numberPhone = numberPhone;
            user.address = address;
            user.sex =sex;
            user.vip = vip;
            user.shippingAddress = shippingAddress;
            
            //            NSLog(@"%ld %@ %@", ID, name, userpwd);
            
        }
        [_db close];
        return user;
    }
    return nil;
}
//根据手机号
-(HHUserInfo*)findUserWithNumber:(NSString*)phoneNumber{
    if ([_db open]) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_userinfo WHERE numberPhone='%@';",phoneNumber];
        // 1.执行查询语句
        FMResultSet *resultSet = [_db executeQuery:sql];
        HHUserInfo *user = nil;
        // 2.遍历结果
        while ([resultSet next]) {
            //            NSLog(@"ddddddddddddddddddddd");
            user = [[HHUserInfo alloc]init];
            NSInteger ID = [resultSet intForColumn:@"_id"];
            NSString *name = [resultSet stringForColumn:@"username"];
            NSString *userpwd = [resultSet stringForColumn:@"userpwd"];
            NSString *numberPhone = [resultSet stringForColumn:@"numberPhone"];
            NSString *address = [resultSet stringForColumn:@"address"];
            NSString *sex = [resultSet stringForColumn:@"sex"];
            NSString *vip = [resultSet stringForColumn:@"vip"];
            NSString *shippingAddress = [resultSet stringForColumn:@"shippingAddress"];
            
            NSString *icon = [resultSet stringForColumn:@"icon"];
            
            user.icon = icon;
            user.ID = ID;
            user.userName = name;
            user.userPwd = userpwd;
            user.numberPhone = numberPhone;
            user.address = address;
            user.sex =sex;
            user.vip = vip;
            user.shippingAddress = shippingAddress;
            
            //            NSLog(@"%ld %@ %@", ID, name, userpwd);
            
        }
        [_db close];
        return user;
    }
    return nil;
}
-(void)dealloc{
    [_db close];
}
//-(instancetype)initWithDBName:(NSString*)DBName tableName:(NSString *)tableName{
//    self = [super init];
//    if (self) {
//        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//        NSString *fileName = [doc stringByAppendingPathComponent:DBName];
//        const char *cfileName = fileName.UTF8String;
//        int result = sqlite3_open(cfileName, &_db);
//        if (result == SQLITE_OK) {
//            NSLog(@"打开成功");
//            //1.打开数据库文件（如果数据库文件不存在，那么该函数会自动创建数据库文件）
//
//            NSString *sql  = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id integer PRIMARY KEY AUTOINCREMENT,username text NOT NULL,userpwd text NOT NULL);",tableName];
//                //2.创建表
//            const char  *csql= sql.UTF8String;
//
//                char *errmsg=NULL;
//                result = sqlite3_exec(_db,csql,NULL, NULL, &errmsg);
//                if (result==SQLITE_OK) {
//                    NSLog(@"创表成功");
//                }else
//                {
//                    NSLog(@"创表失败----%s",errmsg);
//                }
//
//        }else{
//            NSLog(@"打开失败");
//        }
//    }
//    return self;
//}
//+(void)insertDB:(HHUserInfo *)userInfo tableName:(NSString *)tableName{
//
//        //1.拼接SQL语句
//
//        NSString *sql=[NSString stringWithFormat:@"INSERT INTO %@(username,userpwd) VALUES ('%@',%@);",tableName,userInfo.userName,userInfo.userPwd];
//
//        //2.执行SQL语句
//        char *errmsg=NULL;
//
//        sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg);
//        if (errmsg) {//如果有错误信息
//            NSLog(@"插入数据失败--%s",errmsg);
//        }else
//        {
//            NSLog(@"插入数据成功");
//        }
//}
//+(void)deleteDB:(HHUserInfo *)userInfo tableName:(NSString *)tableName{
//
//}
//+(void)updataDB:(HHUserInfo *)userInfo tableName:(NSString *)tableName{
//
//}
//+(void)FindAll:(HHUserInfo *)userInfo tableName:(NSString *)tableName{
//    NSString *sql = [NSString stringWithFormat:@"SELECT id,username,userpwd FROM %@ ",tableName];
//    const char *csql = sql.UTF8String;
//    sqlite3_stmt *stmt=NULL;
//
//    //进行查询前的准备工作
//    if (sqlite3_prepare_v2(_db, csql, -1, &stmt, NULL)==SQLITE_OK) {//SQL语句没有问题
//        NSLog(@"查询语句没有问题");
//
//        //每调用一次sqlite3_step函数，stmt就会指向下一条记录
//        while (sqlite3_step(stmt)==SQLITE_ROW) {//找到一条记录
//            //取出数据
//            //(1)取出第0列字段的值（int类型的值）
//            int ID=sqlite3_column_int(stmt, 0);
//            //(2)取出第1列字段的值（text类型的值）
//            const unsigned char *name = sqlite3_column_text(stmt, 1);
//            //(3)取出第2列字段的值（int类型的值）
//            const unsigned char *pwd =sqlite3_column_text(stmt, 2);
//            //            NSLog(@"%d %s %d",ID,name,age);
//            printf("%d %s %s\n",ID,name,pwd);
//        }
//    }else
//    {
//        NSLog(@"查询语句有问题");
//    }
//}
@end
