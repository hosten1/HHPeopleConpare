//
//  regixMarthcis.h
//  ios正则表达式
//
//  Created by mac on 16/1/8.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Regular : UIView
+(BOOL)ValidateEmail:(NSString *)email;
+(BOOL)ValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression;
+(NSString*)ValidateMobileNumber:(NSString *)mobileNum;
+(void)ValidateReplaseString:(NSString*)string;
+(void)VilidateString:(NSString*)string;
@end
