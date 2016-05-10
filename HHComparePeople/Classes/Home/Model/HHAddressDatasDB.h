//
//  HHAddressDatasDB.h
//  HankowThamesCode
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHAddressDatasDB : NSObject

-(NSArray *)findProvinceOfAll;
-(NSArray *)findCityOfAllWithProvinceCode:(NSString*)ProvinceCode;
-(NSArray *)findTownOfAllWithCityCode:(NSString*)CityCode;
-(NSArray *)findAllCityName;
-(NSArray *)findAllCityNameAndTownNameWithName:(NSString*)name;

-(NSArray*)findAllCityNameFromHistory;
-(void)insertFromHistoryWithName:(NSString*)name;
@end
