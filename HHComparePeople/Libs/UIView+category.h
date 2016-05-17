//
//  UIView+category.h
//  BaseTool
//
//  Created by spinery on 14/10/28.
//  Copyright (c) 2014年 GMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Accelerate/Accelerate.h>

@interface UIView (category)

/**
 * 视图坐标
 * @returned    视图坐标
 */
- (CGPoint)origin;

/**
 * 视图相对于父view的最小x坐标
 * @returned    最小x坐标
 */
- (CGFloat)minX;

/**
 * 视图相对于父view的最大x坐标
 * @returned    最大x坐标
 */
- (CGFloat)maxX;

/**
 * 视图相对于父view的最小y坐标
 * @returned    最小y坐标
 */
- (CGFloat)minY;

/**
 * 视图相对于父view的最大y坐标
 * @returned    最大y坐标
 */
- (CGFloat)maxY;

/**
 * 视图高宽
 * @returned    视图高宽
 */
- (CGSize)size;

/**
 * 视图宽
 * @returned    视图宽
 */
- (CGFloat)width;

/**
 * 视图高
 * @returned    视图高
 */
- (CGFloat)height;

/**
 * 当前界面隐藏键盘
 */
- (void)hideKeyboard;

/**
 * 视图阴影渲染
 * @param       radius 渲染半径
 * @param       color 渲染颜色
 */
- (void)render:(CGFloat)radius withColor:(UIColor*)color;

/**
 * 视图截取为突破
 * @returned    视图截取后的图片
 */
- (UIImage*)viewShot;

/**
 * 视图圆角
 * @param       radius 圆角半径
 */
- (void)setCornerRadius:(CGFloat)radius;

/**
 * 视图边框
 * @param       width 边框宽度
 * @param       color 边框颜色
 */
- (void)setBorder:(CGFloat)width withColor:(CGColorRef)color;

/**
 * 缩放动画显示
 */
- (void)scaleToShow;

//显示badge
- (UIView *)showBadge;

- (void)removeBadgeValue;
@end

@interface UIImage (category)

/**
 * 通过颜色和大小生成纯色图片
 * @param       color 图片的颜色
 * @param       bounds 图片大小
 * @returned    纯色图片
 */
+ (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)size;

/**
 * 图片宽度
 * @param       无
 * @returned    图片宽度
 */
- (CGFloat)width;

/**
 * 图片高度
 * @param       无
 * @returned    图片高度
 */
- (CGFloat)height;

/**
 * 拍摄图片压缩后进行旋转处理
 * @param       iWidth 缩放适应的宽度
 * @param       isClip 超过宽度是否裁剪
 * @returned    纯色图片
 */
- (UIImage *)scaleSuit:(CGFloat)iWidth clip:(BOOL)isClip;

/**
 * 图片圆角
 * @param       radius 圆角半径
 * @returned    圆角图片
 */
- (UIImage *)pruning:(float)radius;

/**
 * 生成图片的遮罩图片
 * @returned    添加遮罩后的图片
 */
- (UIImage *)maskImage;

/**
 * 图片等比缩放
 * @param       size 缩放的相对大小
 * @returned    缩放后的图片
 */
- (UIImage*)zoom:(CGSize)size;

/**
 * 图片裁剪
 * @param       size 裁剪后图片大小
 * @param       rect 裁剪区域
 * @returned    裁剪后的图片
 */
- (UIImage*)trim:(CGSize)size inRect:(CGRect)rect;

/**
 * 图片玻璃效果
 * @param       radius圆角
 * @param       iterations阴影长度
 * @param       tintColor模糊效果颜色
 * @returned    玻璃效果处理后的图片
 */
- (UIImage *)blurredWithRadius:(CGFloat)radius
                    iterations:(NSUInteger)iterations
                     tintColor:(UIColor *)tintColor;

/**
 * 图片圆角
 * @param       处理图片
 * @returned    转正后的图片
 */
- (UIImage *)fixOrientation;

@end

@interface UITabBarItem (category)

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
                selectedImage:(UIImage *)selectedImage;

@end
