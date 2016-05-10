//
//  HHCity.m
//  HankowThamesCode
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHCity.h"
#import "HHAddressDatasDB.h"
#import "ChineseString.h"
#import "pinyin.h"

@implementation HHCity
+(NSArray*)cityNameOfSort{
    HHAddressDatasDB *db = [[HHAddressDatasDB alloc]init];
    NSArray *cityArray = [db findAllCityName ];
    
//    NSLog(@"ceshi:%@",cityArray);
    NSArray *sortCitysName = [ChineseString LetterSortArray:cityArray];

    return sortCitysName;
}
+(NSArray*)cityNamePingYingOfSort{
    HHAddressDatasDB *db = [[HHAddressDatasDB alloc]init];
    NSArray *cityArray = [db findAllCityName ];
    NSArray *sortCitysNameIndex = [ChineseString IndexArray:cityArray];
    
    return sortCitysNameIndex;
}
@end
