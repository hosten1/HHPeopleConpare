//
//  HHTableViewCell.h
//  HankowThamesCode
//
//  Created by mac on 16/2/26.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHHomeCellDatas;

@interface HHTableViewCell : UITableViewCell
/***处理模型数据**/
@property(nonatomic, strong)HHHomeCellDatas *cellDatas;
//把加载数据（使用xib创建cell的内部细节进行封装）
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
