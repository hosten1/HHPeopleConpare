//
//  requestData.h
//  General public comment
//
//  Created by student35 on 15/11/30.
//  Copyright (c) 2015年 student21. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BackData <NSObject>
@optional
//请求数据
-(void)backJSONData:(NSData*)data widthUrl:(NSString*)url;

@end
@interface requestData : NSObject
@property(assign)id <BackData>delegate;

+(NSString*)proSignedUrl:(NSMutableString*)url withParam:(NSDictionary*)dic;//签名方法

-(void)startRequestWithUrl:(NSString*)urlS withParam:(NSDictionary*)dic;

+(NSData *)request:(NSString*)str;//请求网络

@end
