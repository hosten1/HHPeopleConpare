//
//  HHMyMessagesTableCell.h
//  HankowThamesCode
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHMyMessage;
@interface HHMyMessagesTableCell : UITableViewCell
+(instancetype)msgTableViewCellWithTableView:(UITableView*)tableView;
@property(nonatomic, strong) HHMyMessage *myMessage;
@end
