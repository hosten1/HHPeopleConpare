//
//  regixMarthcis.m
//  ios正则表达式
//
//  Created by mac on 16/1/8.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "Regular.h"

@implementation Regular

#pragma mark ---替换字符串
+(void)ValidateReplaseString:(NSString*)string{
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"(encoding=\")[^\"]+(\")" 
                                                                           options:0
                                                                             error:&error];
    NSString* sample = @"<xml encoding=\"abc\"></xml><xml encoding=\"def\"></xml><xml encoding=\"ttt\"></xml>";
    NSLog(@"Start:%@",sample);
    NSString* result = [regex stringByReplacingMatchesInString:sample
                                                       options:0
                                                         range:NSMakeRange(0, sample.length)
                                                  withTemplate:@"$1utf-8$2"];
    NSLog(@"Result:%@", result);
}
#pragma mark  ---截取字符串如下
+(void)VilidateString:(NSString*)string{
    //组装一个字符串，需要把里面的网址解析出来
    NSString *urlString=@"<meta/><link/><title>1Q84 BOOK1</title></head><body>";
    
    //NSRegularExpression类里面调用表达的方法需要传递一个NSError的参数。下面定义一个
    NSError *error;
    
    //http+:[^\\s]* 这个表达式是检测一个网址的。(?<=title\>).*(?=</title)截取html文章中的<title></title>中内文字的正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=title\\>).*(?=</title)" options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            
            //从urlString当中截取数据
            NSString *result=[urlString substringWithRange:resultRange];
            //输出结果
            NSLog(@"->%@<-",result);
        }
        
    }
}
#pragma mark --- 正则判断手机号码地址格式
+(NSString*)ValidateMobileNumber:(NSString *)mobileNum
{
    NSString* isPhone = nil;
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
    */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
    * 中国电信：China Telecom
    * 133,1349,153,180,189
    */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
    * 大陆地区固话及小灵通
    * 区号：010,020,021,022,023,024,025,027,028,029
    * 号码：七位或八位
    */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        if([regextestcm evaluateWithObject:mobileNum] == YES) {
            isPhone = @"cm";
        } else if([regextestct evaluateWithObject:mobileNum] == YES) {
            isPhone = @"ct";
        } else if ([regextestcu evaluateWithObject:mobileNum] == YES) {
            isPhone = @"cu";
        } else {
            isPhone = @"phone";
        }
        
        
    } else {
        isPhone = @"失败";
    }
    
    return isPhone;
}
////是否是有效的正则表达式

+(BOOL)ValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression

{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    
    return [predicate evaluateWithObject:strDestination];
    
}
//
#pragma mark  --- 验证email
+(BOOL)ValidateEmail:(NSString *)email {
    
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    NSPredicate *regextestemail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    BOOL isEmail = [regextestemail evaluateWithObject:email];
    if (isEmail ){
        NSLog(@"是电子邮件!");
        
    }
    
    //   BOOL rt = [CommonTools isValidateRegularExpression:email byExpression:strRegex];
    
    return isEmail;
    
}

@end
