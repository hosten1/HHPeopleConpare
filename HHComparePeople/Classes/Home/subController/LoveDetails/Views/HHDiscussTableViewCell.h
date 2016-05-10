//
//  HHDiscussTableViewCell.h
//  HankowThamesCode
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHDiscusses;
@interface HHDiscussTableViewCell : UITableViewCell
+(HHDiscussTableViewCell*)initHHTabelViewCellWithTableView:(UITableView*)tableView;
@property(nonatomic, strong)HHDiscusses *details;
@end
