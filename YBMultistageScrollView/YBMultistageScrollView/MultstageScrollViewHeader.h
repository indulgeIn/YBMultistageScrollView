//
//  MultstageScrollViewHeader.h
//  YBMultistageScrollView
//
//  Created by cqdingwei@163.com on 2017/5/27.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#ifndef MultstageScrollViewHeader_h
#define MultstageScrollViewHeader_h


#import "UIView+YB.h"
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>

#define kHeightOfGoodsDetailsBottomCell (SCREEN_HEIGHT-44)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define WEAK_SELF __weak __typeof(self) weakSelf = self;

//tableview偏移类型
typedef NS_ENUM(NSInteger, OffsetType) {
    OffsetTypeMin,
    OffsetTypeCenter,
    OffsetTypeMax,
};

#endif /* MultstageScrollViewHeader_h */
