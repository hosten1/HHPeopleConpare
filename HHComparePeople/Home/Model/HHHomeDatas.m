//
//  HHHomeDatas.m
//  HankowThamesCode
//
//  Created by mac on 16/2/26.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHHomeDatas.h"

@implementation HHHomeDatas
+(NSMutableArray *)addTitleData{
    NSMutableArray *datasArray = [NSMutableArray array];
    NSArray *iconTitles = @[@"food_u",@"film_u",@"bar_o",@"takeaway_u",@"food_u",@"hotel_o",@"jingdian",@"ktv"];
    NSArray *nameTitles = @[@"美食",@"电影",@"休闲娱乐",@"外卖",@"火锅",@"酒店",@"景点",@"ktv"];
    NSArray *iconTitles1 = @[@"liren",@"jiehun",@"vip",@"historic_o",@"natural_o",@"shopping_o",@"qinzi",@"performance_o"];
    NSArray *nameTitles1 = @[@"丽人",@"结婚",@"运动健身",@"生活服务",@"周边游",@"购物",@"亲子",@"演出"];
    NSArray *iconTitles2 = @[@"car",@"seafood_o",@"dish_o",@"car",@"boy_o",@"snack_u",@"comment_u",@"more_u"];
    NSArray *nameTitles2 = @[@"爱车",@"度假套餐",@"自助餐",@"机票",@"医疗健康",@"小吃快餐",@"教育培训",@"全部分类"];
    
    for (NSInteger i = 0; i < 3; i++) {
        
        NSMutableArray *temlArra = [NSMutableArray array];
        for (NSInteger j = 0; j < iconTitles.count; j++) {
            HHHomeDatas *datas = [[HHHomeDatas alloc]init];
            if (i == 0) {
                datas.iconNameTitle = iconTitles[j];
                datas.nameTitle = nameTitles[j];
                [temlArra addObject:datas];
//                NSLog(@"cehsi :%@",datas.nameTitle);
                
            }else if(i == 1 ){
                datas.iconNameTitle = iconTitles1[j];
                datas.nameTitle = nameTitles1[j];
                [temlArra addObject:datas];
            }else if(i == 2){
                datas.iconNameTitle = iconTitles2[j];
                datas.nameTitle = nameTitles2[j];
                [temlArra addObject:datas];

            }

           
            
        }
        [datasArray addObject:temlArra];
    }
//    NSLog(@"%@",datasArray);
    return datasArray;
}
@end
