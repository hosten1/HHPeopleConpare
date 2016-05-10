//
//  requestData.m
//  General public comment
//
//  Created by student35 on 15/11/30.
//  Copyright (c) 2015年 student21. All rights reserved.
//

#import "requestData.h"
#import <CommonCrypto/CommonDigest.h>
@implementation requestData

-(void)startRequestWithUrl:(NSString*)urlS withParam:(NSDictionary*)dic{
    NSString*signurl = [self proSignedUrl:urlS withParam:dic];
    NSDictionary*dic1 = [NSDictionary dictionaryWithObjectsAndKeys:signurl,@"signurl",urlS,@"url", nil];
    [self performSelectorInBackground:@selector(bgMethod:) withObject:dic1];
}

-(void)bgMethod:(id)sender{
    NSDictionary*dic = (NSDictionary*)sender;
    NSString*urlStr = dic[@"signurl"];
    NSURL*url = [NSURL URLWithString:urlStr];
    NSURLResponse*response;
    NSURLRequest*request = [[NSURLRequest alloc]initWithURL:url];
    NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSDictionary*dic1 = [NSDictionary dictionaryWithObjectsAndKeys:data,@"data",dic[@"url"],@"url", nil];
    [self performSelectorOnMainThread:@selector(mainMethod:) withObject:dic1 waitUntilDone:YES];
}


-(void)mainMethod:(id)sender{
    if (self.delegate) {
        NSDictionary*dic = (NSDictionary*)sender;
        [self.delegate backJSONData:dic[@"data"] widthUrl:dic[@"url"]];        
    }
   
}

//给连接添加签名
-(NSString*)proSignedUrl:(NSString*)urlS withParam:(NSDictionary*)dic{
    NSMutableString*url = [[NSMutableString alloc]initWithString:urlS];
    NSString*result=@"";
    [url appendString:@"?appkey=8321387501&"];
    //签名第一步添加appkey
    NSMutableString*signString = [[NSMutableString alloc]initWithString:@"8321387501"];
    //签名第二步请求参数排序后并把键值连接起来
    NSArray *sortedKeys = [[dic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for (NSString *key in sortedKeys) {
        //拼接签名
        [signString appendFormat:@"%@%@", key, [dic objectForKey:key]];
        //拼接连接
        [url appendFormat:@"%@=%@&",key,[dic objectForKey:key]];
    }
    //签名第三步添加secret
    [signString appendString:@"cdb76920645b4d66a5c77796f5e22059"];
    //开始签名
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [signString dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_SHA1([stringBytes bytes], (int)[stringBytes length], digest)) {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString *digestString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02X", aChar];
        }
        NSString*resSign = [digestString uppercaseString];
        //转为utf8编码 防止汉字导致连接失效
        result = [[NSString stringWithFormat:@"%@sign=%@",url,resSign]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSLog(@"%@",result);
    return result;
}

//完整的链接，请求数据
+(NSDictionary *)requsetNet:(NSMutableString*)subURL andDic:(NSMutableDictionary*)dics{
    NSString * str = [requestData proSignedUrl:subURL withParam:dics];
    NSData * data = [requestData request:str];
    //NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"%@",dataStr);
    NSDictionary * rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return rootDic;
}
@end
