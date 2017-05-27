//
//  YBLevelListView.h
//  ToolsDemoByYangBo
//
//  Created by 杨波 on 2017/4/21.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "YBLevelListConfigModel.h"
#import "YBLevelListSubView.h"

#if DEBUG
#define LOGERRORMESSAGE(x) NSLog(@"YBLevelListView ———— error : \n%@", x);
#else
#define LOGERRORMESSAGE(x) nil;
#endif

@class YBLevelListView;

@protocol YBLevelListViewDelegate <NSObject>

- (void)yBLevelListView:(YBLevelListView *)yBLevelListView chooseIndex:(NSInteger)index;

@end

@interface YBLevelListView : UIView

@property (nonatomic, weak) id <YBLevelListViewDelegate> delegate;

/**
 初始化方法

 @param frame frame
 @param configModel 配置UI的model
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame configModel:(YBLevelListConfigModel *)configModel;


/**
 UI配置的model
 */
@property (nonatomic, strong, readonly) YBLevelListConfigModel *configModel;

/**
 通过model配置UI

 @param model --
 */
- (void)configUIWithModel:(YBLevelListConfigModel *)model;


/**
 当前选择的下标
 */
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

/**
 手动选择下标
 
 @param toIndex 下标
 */
- (void)selectToIndex:(NSInteger)toIndex;


/**
 遍历所有选择模块视图（用来适当的自定义选择模块的view）

 @param block --
 */
- (void)traverseAllSubView:(void(^)(YBLevelListSubView *subView, NSInteger idx))block;


/**
 配置动画偏移

 @param offsetX x方向偏移量
 */
- (void)configAnimationOffsetX:(CGFloat)offsetX;


@end
