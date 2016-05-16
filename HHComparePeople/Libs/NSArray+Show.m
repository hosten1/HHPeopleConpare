//
//  NSArray+Show.m
//  OC  数组
//
//  Created by len on 15/11/15.
//  Copyright © 2015年 WangHao. All rights reserved.
//

#import "NSArray+Show.h"

@implementation NSArray (Show)
//当用%@打印数组的时候，自动调用此方法
-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *mulStr=[NSMutableString string];
    [mulStr appendString:@"(\n"];
    //遍历数组
    for (id obj in self)//self指的是数组
    {
        if ([obj isEqual:[self lastObject]])
        {
            //如果是最后一个元素
            [mulStr appendFormat:@"\t%@\n",obj];
        }
        else
        {
            [mulStr appendFormat:@"\t%@,\n",obj];
        }
    }
    [mulStr appendString:@")"];
    return mulStr;
}
@end
