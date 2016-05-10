//
//  HHDiscussShopDB.h
//  HankowThamesCode
//
//  Created by mac on 16/3/21.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HHDiscusses;
@interface HHDiscussShopDB : NSObject


-(NSArray *)findAllCityShopDiscountWithShopID:(NSString*)shopID;

-(void)insertFromHistoryWithName:(HHDiscusses*)dis;

@end
