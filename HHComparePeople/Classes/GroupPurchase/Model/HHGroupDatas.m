//
//  HHGroupDatas.m
//  HankowThamesCode
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHGroupDatas.h"

@implementation HHGroupDatas
+(NSMutableArray *)addTitleData{
    NSMutableArray *datasArray = [NSMutableArray array];
    NSArray *iconTitles = @[@"food_u",@"film_u",@"bar_o",@"takeaway_u",@"food_u",@"hotel_o",@"jingdian",@"ktv",@"liren"];
    NSArray *nameTitles = @[@"美食",@"电影",@"休闲娱乐",@"外卖",@"火锅",@"酒店",@"景点",@"ktv",@"丽人"];
   
    
    for (NSInteger j = 0; j < iconTitles.count; j++) {
           HHGroupDatas *datas = [[HHGroupDatas alloc]init];
        
                datas.iconNameTitle = iconTitles[j];
                datas.nameTitle = nameTitles[j];
        
               [datasArray addObject:datas];

        }
              //    NSLog(@"%@",datasArray);
    return datasArray;
}
@end
