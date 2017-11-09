//
//  PicAndTextTableView.h
//  CSJF
//
//  Created by cqdingwei@163.com on 2017/5/18.
//  Copyright © 2017年 dingwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultstageScrollViewHeader.h"
#import "GoodsDetailsVC.h"

@interface PicAndTextTableView : UITableView

@property (nonatomic, assign) OffsetType offsetType;

@property (nonatomic, weak) GoodsDetailsVC *mainVC;

@end
