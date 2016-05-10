//
//  HHUpdateInfoViewController.h
//  HankowThamesCode
//
//  Created by mac on 16/3/10.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHUserInfo.h"
@interface HHUpdateInfoViewController : UIViewController
@property(nonatomic, copy)NSString *name;
@property(nonatomic, strong)HHUserInfo *infos;
@property(nonatomic, copy)NSString *usinfo;
@end
