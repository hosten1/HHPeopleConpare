//
//  HHParseJson.m
//  HankowThamesCode
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHParseJson.h"
#import <CoreLocation/CoreLocation.h>
#import "HHAddressPosition.h"
#import "HHDiscusses.h"
#import "HHHomeCellDatas.h"
@implementation HHParseJson

+(NSArray*)parseDataWithDatas:(NSData*)datas{
    NSMutableArray *arrar = [NSMutableArray array];
    if (!datas) {
        NSLog(@"获取数据失败！");
        return nil;
    }
     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
    NSArray *businesses = dic[@"businesses"];
    for (NSDictionary *info in businesses) {
        if (info) {
            HHHomeCellDatas *homecell = [[HHHomeCellDatas alloc]init];
          
                if (info[@"business_id"]) {
                   
                    homecell.shopID = info[@"business_id"];
//                     NSLog(@"%@",homecell.shopID);
                }
           
            if (info[@"branch_name"]) {
                
                homecell.homeBranch_name = info[@"branch_name"];
            }
            if (info[@"address"]) {
                homecell.homeAddress = info[@"address"];
            }
            if (info[@"telephone"]) {
                
            }
            if (info[@"city"]) {
                
            }
            if (info[@"regions"]) {
                homecell.homeRegins = info[@"regions"];
//                for (NSArray *regions in info[@"regions"]) {
////                    NSLog(@"regions:%@",regions);
//                }
            }
            if (info[@"categories"]) {
                homecell.homeCategories = info[@"categories"];
//                for (NSArray *categorie in info[@"regions"]) {
////                    NSLog(@"categories:%@",categorie);
//                }
            }
            /*******地图位置******/
            if (info[@"latitude"]) {
//                  NSLog(@"%@",info[@"latitude"]);
                homecell.homeLatitude = info[@"latitude"];
            }
            if (info[@"longitude"]) {
                homecell.homeLongitude = info[@"longitude"];
            }
            /******评级*********/
            if (info[@"rating_img_url"]) {
                
            }
            if (info[@"rating_s_img_url"]) {
                
            }
            /************************/
            if (info[@"name"]) {
                 NSArray*arr = [info[@"name"] componentsSeparatedByString:@"("];
                        homecell.homeCellTitle =arr[0];
                
//                homecell.homeCellDescription = @"这是一条测试商户数据，仅用于测试开发，开发完成后请申请正式数据...";
                    }
            if (info[@"deals"]) {
                NSArray *dealss = info[@"deals"];
                for (NSDictionary *dic in dealss) {
                    if (dic != nil) {
                        
                        
                        //dic[@"id"];dic[@"url"]
                        
                        
                        NSString  *desc = dic[@"description"];
                        homecell.homeCellDescription = desc;
//                        NSMutableString *mutstr = [NSMutableString stringWithString:desc];
//                        for (NSInteger i = 0; i < mutstr.length; i++) {
//                            
//                            unichar ch = [desc characterAtIndex:i];
//                            NSString *str = [NSString stringWithFormat:@"%c",ch];
////                            NSLog(@"charff...%@",str);
//                        }
   
                    }
                   
                }
                //                        sj.shopID =caini[@"business_id"];
            }
            
            /****大图和小图****/
            if (info[@"photo_url"]) {
                homecell.b_img = info[@"photo_url"];
            }
                   if (info[@"s_photo_url"]) {
                           homecell.homeCellImg = info[@"s_photo_url"];
                      }
                    NSInteger setnum = arc4random_uniform(100)+100;
                    homecell.homeCellAlsale = [NSString stringWithFormat:@"%ld",setnum];
            
                   homecell.homeCellPrice = [NSString stringWithFormat:@"%d",arc4random()%10+40];
            
            
               [arrar addObject:homecell];
                }

        

//         NSLog(@"ddddfgdsf%@",info);
    }
   
    return  arrar;
}

//评论解析
+(NSMutableArray *)parsepinglun:(NSData *)data{
    NSMutableArray*pls = [[NSMutableArray alloc]init];
    NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (dic[@"reviews"]) {
        NSArray*reArr = dic[@"reviews"];
        if (reArr) {
            for (NSDictionary*rewiew in reArr) {
                if (rewiew) {
                    HHDiscusses *discus = [[HHDiscusses alloc]init];
                    if (rewiew[@"user_nickname"]) {
                        discus.nicheng =rewiew[@"user_nickname"];
                        if(rewiew[@"created_time"]) {
                            discus.shijian = rewiew[@"created_time"];
                            if (rewiew[@"text_excerpt"]) {
                                discus.pinglun = rewiew[@"text_excerpt"];
//                                discus.datu = @"tuxiang";
                                [pls addObject:discus];
                            }
                        }
                    }
                }
            }
        }
    }
    return pls;
}

@end
