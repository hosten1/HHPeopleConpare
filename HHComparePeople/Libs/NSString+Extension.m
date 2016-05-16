//
//  NSString+Extension.m
//  QQ聊天列表
//
//  Created by mac on 15/12/11.
//  Copyright © 2015年 Hosten. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
-(CGSize)sizeWithMaxSize:(CGSize)maxSize andFont:(CGFloat)fontSize{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size ;
}

@end
