//
//  HHCity.h
//  HankowThamesCode
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHCity : NSObject
@property(nonatomic, assign)NSInteger ID;
@property(nonatomic, copy)NSString *cityName;
@property(nonatomic, copy)NSString *cityCode;
@property(nonatomic, copy)NSString *provinceCode;

+(NSArray*)cityNameOfSort;
+(NSArray*)cityNamePingYingOfSort;
@end
