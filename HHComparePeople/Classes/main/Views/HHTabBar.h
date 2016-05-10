//
//  HHTabBar.h
//  HHSweepstakes
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHTabBar;
@protocol HHTabBarDelegate <NSObject>
-(void)tabbar:(HHTabBar*)tabbar didSelectedFrom:(NSInteger)from to:(NSInteger)to;
@end
@interface HHTabBar : UIView
@property(nonatomic, weak)id<HHTabBarDelegate> hdelegate;

-(void)addTabbarBtnWithNormalImg:(NSString*)norImg andSelectedImg:(NSString*)selectedImg;
@end
//自定义bution取消
@interface HHButton : UIButton

@end