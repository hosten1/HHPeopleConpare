//
//  HHGroupTableViewCell.h
//  HankowThamesCode
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHGroupTableViewCell : UITableViewCell
//把加载数据（使用xib创建cell的内部细节进行封装）
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
