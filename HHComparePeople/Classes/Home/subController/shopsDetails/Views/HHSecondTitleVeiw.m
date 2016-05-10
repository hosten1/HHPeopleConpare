//
//  HHSecondTitleVeiw.m
//  HHComparePeople
//
//  Created by mac on 16/3/27.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHSecondTitleVeiw.h"
#import "HHTitleBtn.h"

@implementation HHSecondTitleVeiw
+(instancetype)addSecondTitleView{
    return [[self alloc]init];
}
-(instancetype)init{
    self = [super init];
    if (self) {
        
        /*添加子控件**/
        [self addsubBtn];
    }
    return self;
}
-(void)addsubBtn{
    NSArray *titlearr = @[@"附近",@"美食",@"排序",@"筛选"];
   
    CGFloat marginy = 10;
   
    CGFloat subViewWidth = mScreenSize.width/4-4;
    NSInteger count = titlearr.count;
    for (NSInteger i = 0 ;i < count; i++) {
        HHTitleBtn *titileBtn = [[HHTitleBtn alloc]initWithImage:[UIImage imageNamed:@"ic_arrow_down_black"] title:titlearr[i]];
              //        当前子view的列号=当前的索引值%总列数；
     
        CGFloat subViewX = (1+subViewWidth)*i;
        [titileBtn setBackgroundImage:[UIImage imageNamed:@"btn_selct"] forState:UIControlStateHighlighted];
        titileBtn.frame = CGRectMake(subViewX+i*2, 0, subViewWidth,44);
       
        
        [self addSubview:titileBtn];
        if (i>0) {
            UIView *sub = [[UIView alloc]init];
            
            CGFloat marx = subViewX;
            if(i == 3){
                sub.frame = CGRectMake(marx+6, 5, 1, 30);
            }else{
                sub.frame = CGRectMake(marx, 5, 1, 30);
 
            }
            
            sub.backgroundColor = [UIColor grayColor];
            
            [self addSubview:sub];
        }
        

    }
}

@end
