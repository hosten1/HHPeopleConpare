//
//  HHHomeCellDatas.h
//  HankowThamesCode
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHHomeCellDatas : NSObject
@property(nonatomic, copy)NSString *shopID;
@property (copy, nonatomic)  NSString *homeCellImg;
@property (copy, nonatomic)  NSString *homeCellTitle;
@property(nonatomic, copy)NSString *homeBranch_name;//店铺分店
@property(nonatomic, copy)NSString *homeAddress;
@property(nonatomic, strong)NSArray *homeRegins;//分店位置数组
@property(nonatomic, strong)NSArray *homeCategories;
@property(nonatomic, weak)NSString *homeLatitude;//维度
@property(nonatomic, weak)NSString *homeLongitude;//精度
@property (copy, nonatomic)  NSString *homeCellDescription;
@property (copy, nonatomic)  NSString *homeCellPrice;
@property (copy, nonatomic)  NSString *homeCellAlsale;
@property(nonatomic, copy)   NSString *b_img;
@end
