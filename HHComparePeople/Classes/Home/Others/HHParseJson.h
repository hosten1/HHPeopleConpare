//
//  HHParseJson.h
//  HankowThamesCode
//  解析处理网络请求数据
//  Created by mac on 16/3/8.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class HHAddressPosition;

@interface HHParseJson : NSObject
/********猜你喜欢*******/
+(NSArray*)parseDataWithDatas:(NSData*)datas;
//@property(nonatomic, strong)HHAddressPosition *postionsss;
+(NSMutableArray *)parsepinglun:(NSData *)data;//评论数据请求

@property(nonatomic, copy)NSDictionary *addressPosition;
@end
