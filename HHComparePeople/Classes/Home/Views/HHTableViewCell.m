//
//  HHTableViewCell.m
//  HankowThamesCode
//
//  Created by mac on 16/2/26.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHTableViewCell.h"
#import "HHHomeCellDatas.h"
#import "UIImageView+WebCache.h"

@interface HHTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLableView;
@property (weak, nonatomic) IBOutlet UILabel *contentDescriptionLavble;
@property (weak, nonatomic) IBOutlet UILabel *contentPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *contentAlsaleLable;

@end
@implementation HHTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identifier= @"tg";
    HHTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
     if (cell==nil) {
              //如何让创建的cell加个戳
              //对于加载的xib文件，可以到xib视图的属性选择器中进行设置
             cell=[[[NSBundle mainBundle]loadNibNamed:@"HHTableViewCell" owner:nil options:nil]firstObject];
//             NSLog(@"创建了一个cell");
       }
      return cell;
}
//父控件改变时候 调用
-(void)layoutSublayersOfLayer:(CALayer *)layer{
    
}
/****重新set方法完成cell控件初始化****/
-(void)setCellDatas:(HHHomeCellDatas *)cellDatas{
    _cellDatas = cellDatas;
//    NSLog(@"sbimg:>>>%@",_cellDatas.homeCellImg);
    //头像
    
    if (_cellDatas == nil) {
        return ;
            }
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString: _cellDatas.homeCellImg] options:(SDWebImageAvoidAutoSetImage) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        //设置图片
         self.contentImgView.image = image;
    }];
    
   
    //标题
    self.contentTitleLableView.text = _cellDatas.homeCellTitle;
    //描述
    self.contentDescriptionLavble.text = _cellDatas.homeCellDescription;
    //单价
    self.contentPriceLable.text = [NSString stringWithFormat:@"￥ %@", _cellDatas.homeCellPrice];
;
    //已售
    self.contentAlsaleLable.text = [NSString stringWithFormat:@"已售:%@",_cellDatas.homeCellAlsale];
}
//-(void)awakeFromNib
@end
