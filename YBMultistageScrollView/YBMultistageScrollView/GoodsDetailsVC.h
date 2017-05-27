//
//  GoodsDetailsVC.h
//  CSJF
//
//  Created by cqdingwei@163.com on 2017/5/17.
//  Copyright © 2017年 dingwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultstageScrollViewHeader.h"

@interface GoodsDetailsVC : UIViewController

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, assign) OffsetType offsetType;

@end
