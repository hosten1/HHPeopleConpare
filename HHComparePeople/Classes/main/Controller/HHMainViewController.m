//
//  HHMainViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHMainViewController.h"
#import "HHMainTabBarController.h"
#import "HHHomeViewController.h"
#import "HHGroupViewController.h"
#import "HHFinderViewController.h"
#import "HHMyMessagesViewController.h"

#define kVersionKey @"versioncode"


@interface HHMainViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic)  UIButton *mainBtnView;
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (assign,nonatomic) int picCount;
@property (weak, nonatomic)  UIPageControl *WelcomPageControl;
@end

@implementation HHMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{

  [self showScrollView];//显示滑动图
    
}
-(void) showScrollView{
    //设置图片数
    int imgCount = 5;
    self.picCount = imgCount;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //设置UIScrollView 的显示内容的尺寸，有n张图要显示，就设置 屏幕宽度*n ，这里假设要显示4张图
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * imgCount, [UIScreen mainScreen].bounds.size.height);
    
    _scrollView.tag = 101;
    
    //设置翻页效果，不允许反弹，不显示水平滑动条，设置代理为自己
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.delegate = self;
    
    //在UIScrollView 上加入 UIImageView
    for (NSInteger i = 0 ; i < imgCount; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i , 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        NSString *picName = [NSString stringWithFormat:@"show%ld",i+1];
        //将要加载的图片放入imageView 中
        UIImage *image = [UIImage imageNamed:picName];
        imageView.image = image;
        if (i == imgCount-1) {
            // 给最后一张添加按钮
            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.frame = CGRectMake(self.view.frame.size.width*0.3, self.view.frame.size.height*0.3, 150, 50);
            [imgBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
            [imgBtn setBackgroundImage:[UIImage imageNamed:@"btn_click"]  forState:UIControlStateHighlighted];
            [imgBtn setTitle:@"点击进入" forState:UIControlStateNormal];
            [imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.mainBtnView = imgBtn;
            [imgBtn addTarget:self action:@selector(gotoTabbarVIew:) forControlEvents:UIControlEventTouchUpInside];
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:imgBtn];
        }
        [_scrollView addSubview:imageView];
    }
    
    //初始化 UIPageControl 和 _scrollView 显示在 同一个页面中
    UIPageControl *pageConteol = [[UIPageControl alloc] initWithFrame:CGRectMake(140, self.view.frame.size.height - 60, 50, 40)];
    pageConteol.numberOfPages = imgCount;//设置pageConteol 的page 和 _scrollView 上的图片一样多
    pageConteol.tag = 201;
    self.WelcomPageControl = pageConteol;
    
    [self.view addSubview:_scrollView];
    [self.view addSubview: pageConteol];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    //根据scrollView 的位置对page 的当前页赋值
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    page.currentPage = current;
    
    //当显示到最后一页时，让滑动图消失
    if (page.currentPage == self.picCount-1) {
        
        //调用方法，使滑动图消失
        //        [self scrollViewDisappear];
    }
}

-(void)scrollViewDisappear{
    
    //拿到 view 中的 UIScrollView 和 UIPageControl
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:101];
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    
    //设置滑动图消失的动画效果图
    [UIView animateWithDuration:1.0f animations:^{
        
        scrollView.center = CGPointMake(self.view.frame.size.width/2, 1.5 * self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
//        NSLog(@"ffffff");
        //将滑动图启动过的信息保存到 NSUserDefaults 中，使得第二次不运行滑动图
        NSString *currentVersionCode = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:currentVersionCode forKey:kVersionKey];
        
        [scrollView removeFromSuperview];
        [page removeFromSuperview];
        //在这里跳转到home页面
//        [self gotoTabbarVIew:self];
        
    }];
    
   
}
-(void)gotoTabbarVIew:(id)sender{
    [self scrollViewDisappear];
    
    
    
//    NSMutableArray *mutArray = [[NSMutableArray alloc]init];
     HHMainTabBarController *tabBarController = [[HHMainTabBarController alloc]init];
//    //主页
//    HHHomeViewController *home = [[HHHomeViewController alloc]init];
//    [mutArray addObject:home];
//    //团购优惠也
//    HHGroupViewController *group = [[HHGroupViewController alloc]init];
//    [mutArray addObject:group];
//    //发现
//    HHFinderViewController *finder = [[HHFinderViewController alloc]init];
//    [mutArray addObject:finder];
//    //我的个人中心也
//    HHMyMessagesViewController *myMessage = [[HHMyMessagesViewController alloc]init];
//    [mutArray addObject:myMessage];
//    //添加到tabbar中
//    [tabBarController setViewControllers:mutArray];
    
   
    //跳转
    [self presentViewController:tabBarController animated:YES completion:NULL];
}

@end
