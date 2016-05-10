//
//  HHTitleBtn.m
//  HHComparePeople
//
//  Created by mac on 16/3/27.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHTitleBtn.h"

@interface HHTitleBtn ()


@property(nonatomic, weak)UILabel *titleLab;
@property(nonatomic, weak)UIImageView *titleImageView;
@end
@implementation HHTitleBtn

-(instancetype)initWithImage:(UIImage *)titleImage title:(NSString *)title{
    self = [super init];
    if (self) {
        
        UILabel *titleLab = [[UILabel alloc]init];
        self.titleLab = titleLab;
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.text = title;
        [titleLab setTextAlignment: NSTextAlignmentCenter];
        [self addSubview:titleLab];
        
        UIImageView *titleImageView = [[UIImageView alloc]init];
        self.titleImageView = titleImageView;
        titleImageView.image = titleImage;
        [self addSubview:titleImageView];

        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize btnsize = self.frame.size;
    
    self.titleLab.frame = CGRectMake(0, 0, btnsize.width*0.8, btnsize.height);
    
    CGFloat x = CGRectGetMaxX(self.titleLab.frame)-20;
    
    self.titleImageView.frame = CGRectMake(x,15,  15, 15);
    
}

@end
