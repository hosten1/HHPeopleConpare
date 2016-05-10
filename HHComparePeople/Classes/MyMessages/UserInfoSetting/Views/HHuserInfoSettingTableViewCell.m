//
//  HHuserInfoSettingTableViewCell.m
//  HankowThamesCode
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHuserInfoSettingTableViewCell.h"
@interface HHuserInfoSettingTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
@implementation HHuserInfoSettingTableViewCell
-(void)setUserSet:(HHuserInfoSetting *)userSet{
    _userSet = userSet;
    
    _titleLable.text = _userSet.title;
    [_btn setTitle:_userSet.descrip forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
