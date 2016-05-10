//
//  UIImage+Extention.h
//  QQ聊天列表
//
//  Created by mac on 15/12/11.
//  Copyright © 2015年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extention)
+(UIImage*)resizeImage:(UIImage *)image;
+(UIImage*)scaleImage:(UIImage*)image toScale:(float)scaleSize;
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
;
@end
