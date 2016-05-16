//
//  HHTextFiled.m
//  HHComparePeople
//
//  Created by VRV2 on 16/5/16.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHTextFiled.h"

@implementation HHTextFiled
-(id)initWithFrame:(CGRect)frame drawingLeft:(UIImageView *)icon{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = icon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}
    
-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;// 右偏10
    return iconRect;
}
@end
