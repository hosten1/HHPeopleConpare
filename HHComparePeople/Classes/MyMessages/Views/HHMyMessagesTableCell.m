//
//  HHMyMessagesTableCell.m
//  HankowThamesCode
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHMyMessagesTableCell.h"
#import "HHMyMessage.h"
#import "HHMyMessgeItemLogin.h"

@interface HHMyMessagesTableCell()
@property(nonatomic, weak)UIImageView *iconView;
@property(nonatomic, weak)UILabel *nameLabel;
@property(nonatomic, weak)UIButton *nameButton;
@property(nonatomic, weak)UIButton *addBtn;
@end
@implementation HHMyMessagesTableCell
+(instancetype)msgTableViewCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"myMsgCell";
    HHMyMessagesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HHMyMessagesTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([self.myMessage isKindOfClass:[HHMyMessgeItemLogin class]]) {
            
            
            // 1.创建头像
            UIImageView *iconView = [[UIImageView alloc] init];
            [self.contentView addSubview:iconView];
            self.iconView = iconView;
            
            // 
            UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.contentView addSubview:nameButton];
             self.nameButton = nameButton;
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.contentView addSubview:addBtn];
             self.addBtn = addBtn;
        }else{
            // 1.创建头像
            UIImageView *iconView = [[UIImageView alloc] init];
            [self.contentView addSubview:iconView];
             self.iconView = iconView;
            
            // 2.创建昵称
            UILabel *nameLabel = [[UILabel alloc] init];
            [self.contentView addSubview:nameLabel];
            self.nameLabel = nameLabel;
        }
        
    }
    return self;
}


@end
