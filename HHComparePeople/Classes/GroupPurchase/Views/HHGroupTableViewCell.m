//
//  HHGroupTableViewCell.m
//  HankowThamesCode
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHGroupTableViewCell.h"
@interface HHGroupTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *contentGroupImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleGroupLableView;
@property (weak, nonatomic) IBOutlet UILabel *contentDescriptionGroupLavble;
@property (weak, nonatomic) IBOutlet UILabel *contentPriceGroupLable;
@property (weak, nonatomic) IBOutlet UILabel *contentDistanceGroupLable;
@property (weak, nonatomic) IBOutlet UILabel *contentOldpriceLable;
@end
@implementation HHGroupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identifier= @"tg";
    HHGroupTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        //如何让创建的cell加个戳
        //对于加载的xib文件，可以到xib视图的属性选择器中进行设置
        cell=[[[NSBundle mainBundle]loadNibNamed:@"HHGroupTableViewCell" owner:nil options:nil]firstObject];
//        NSLog(@"创建了一个cell");
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
