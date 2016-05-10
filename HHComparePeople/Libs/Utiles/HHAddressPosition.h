//
//  HHAddressPosition.h
//  HankowThamesCode
//
//  Created by mac on 16/3/7.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HHAddressPosition : NSObject
@property(nonatomic, strong)  NSDictionary *addressDict;
@property(nonatomic, copy)NSString *addressName;
//地理编码
-(void)addressGecode:(NSString*)address ;
/*****地理反编码**/
-(void)addressRervsecodeWithLatitude:(NSString*)latitude longtitude:(NSString*)longitude;
@end
