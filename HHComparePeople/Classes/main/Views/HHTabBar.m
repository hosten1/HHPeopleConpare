//
//  HHTabBar.m
//  HHSweepstakes
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHTabBar.h"
@interface HHTabBar()


@property(nonatomic, weak)UIButton *selectedBtn;
@end
@implementation HHTabBar
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        //初始化按钮
//        [self addSubBtn];
    }
    return  self;
}
//-(void)addSubBtn{
//  
//    //添加按钮
//    for (NSInteger i = 0; i<5; i++) {
//        //获取普通状态的图片名字
//        NSString *picNameNor = [NSString stringWithFormat:@"TabBar%ld",i+1];
//        //获取选中的图片
//        NSString *picNameSelect = [NSString stringWithFormat:@"TabBar%ldSel",i+1];
//        
//        UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [subBtn setBackgroundImage:[UIImage imageNamed:picNameNor] forState:UIControlStateNormal];
//        [subBtn setBackgroundImage:[UIImage imageNamed:picNameSelect] forState:UIControlStateSelected];
//        //设置按钮的frame
//      
//        //监听自定义button的事件,跳转页面
//        subBtn.tag = i;
//        [subBtn addTarget:self action:@selector(subButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self addSubview:subBtn];
//        
//        if (i == 0) {
//            subBtn.selected = YES;
//            self.selectedBtn = subBtn;
//        }
//        
//    }
//    
//    
//}
-(void)addTabbarBtnWithNormalImg:(NSString *)norImg andSelectedImg:(NSString *)selectedImg{
  
    
    UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [subBtn setBackgroundImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    [subBtn setBackgroundImage:[UIImage imageNamed:selectedImg] forState:UIControlStateSelected];
    //监听自定义button的事件,跳转页面
    subBtn.tag = self.subviews.count;
    [subBtn addTarget:self action:@selector(subButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:subBtn];
    
    if (subBtn.tag == 0) {
        [self subButtonClick:subBtn];
    }
}
-(void)subButtonClick:(UIButton*)sender{
    if ([self.hdelegate respondsToSelector:@selector(tabbar:didSelectedFrom:to:)]) {
        [self.hdelegate tabbar:self didSelectedFrom:self.selectedBtn.tag to:sender.tag];
    }
    //    NSLog(@"%ld",sender.tag);
    //取消之前选中的
    self.selectedBtn.selected = NO;
    //讲当前的按钮赋值给选中的
    sender.selected = YES;
    self.selectedBtn = sender;
  
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    CGFloat btnW = self.bounds.size.width/count ;
    CGFloat btnH = self.bounds.size.height;
  
    for (UIButton *btn in self.subviews) {
        
        //设置按钮的frame
        
        CGFloat btnX = btnW*btn.tag;
        CGFloat btnY = 0;
        btn.frame = CGRectMake(btnX,btnY,btnW,btnH);
        
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation HHButton

-(void)setSelected:(BOOL)selected{
    //只要不调用父类得方法，按钮就不会有高度的效果
//    [super setSelected:selected];
}

@end




