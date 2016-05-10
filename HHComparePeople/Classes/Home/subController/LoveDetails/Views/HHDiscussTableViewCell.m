//
//  HHDiscussTableViewCell.m
//  HankowThamesCode
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHDiscussTableViewCell.h"
#import "HHDiscusses.h"

@interface HHDiscussTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *leveImg;
@property (weak, nonatomic) IBOutlet UILabel *detailImg;

@end

@implementation HHDiscussTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
+(HHDiscussTableViewCell*)initHHTabelViewCellWithTableView:(UITableView*)tableView{
    
    static NSString *details = @"detailsID";
    HHDiscussTableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:details];
    if (detailCell == nil) {
        
     detailCell = [[[NSBundle mainBundle]loadNibNamed:@"HHDiscussTableViewCell" owner:nil options:nil]lastObject];
    }
    
    return detailCell;
}
-(void)setDetails:(HHDiscusses *)details{
    _details = details;
    
    
    
    
    if (_details != nil) {
//        NSLog(@"%@",self.details.icon);
        self.iconImg.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.details.icon]];
        
        self.titleLab.text = self.details.nicheng;
        self.detailImg.text = self.details.pinglun;
        self.leveImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",self.details.xingji]];
    }
    
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
