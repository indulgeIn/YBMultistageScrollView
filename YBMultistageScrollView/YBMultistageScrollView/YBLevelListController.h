//
//  YBLevelListController.h
//  ToolsDemoByYangBo
//
//  Created by 杨波 on 2017/4/23.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLevelListView.h"


/*Introductions
 
 简介：该类主要解决项目中常见的横向列表布局，主要分两个模块：1.titleView（标题视图）2.contentView（内容视图）
    其中，标题视图十分灵活，详情可以查看 YBLevelListConfigModel (标题视图UI配置model)
 
 用法：1、创建自己的控制器继承自本类（比如：customViewController）
    2、调用initialize初始化方法族，初始化配置
 
*/


NS_ASSUME_NONNULL_BEGIN

@interface YBLevelListController : UIViewController


@property (nonatomic, strong, readonly) YBLevelListView *titleView;


/**
 初始化方法 （常用）

 @param controllers 控制器数组
 @param titleViewTitles 控制器数组对应的标题数组
 @param titleViewHeight 标题view高度
 @param contentViewHeight 内容view高度
 */
- (void)initializeWithControllers:(NSArray<UIViewController *> *)controllers titleViewTitles:(NSArray<id> *)titleViewTitles titleViewHeight:(CGFloat)titleViewHeight contentViewHeight:(CGFloat)contentViewHeight;

/**
 详细的初始化方法

 @param controllers --
 @param configModel 标题view配置UI的model（详细看api）
 @param titleViewHeight --
 @param contentViewHeight --
 */
- (void)initializeWithControllers:(NSArray<UIViewController *> *)controllers titleViewConfigModel:(YBLevelListConfigModel *)configModel titleViewHeight:(CGFloat)titleViewHeight contentViewHeight:(CGFloat)contentViewHeight;

/**
 详细的初始化方法

 @param controllers --
 @param configModel --
 @param titleViewFrame 标题view的frame
 @param contentViewFrame 内容view的frame
 */
- (void)initializeWithControllers:(NSArray<UIViewController *> *)controllers titleViewConfigModel:(YBLevelListConfigModel *)configModel titleViewFrame:(CGRect)titleViewFrame contentViewFrame:(CGRect)contentViewFrame;


/**
 获取点击title下标的方法 (use by rewrite)

 @param index --
 */
- (void)yBLevelListController_clickTitleWithIndex:(NSInteger)index;


/**
 动态的设置titleView的各项属性 （这里朗阔了所有titleview的配置）

 @param configModel 配置UI的model
 */
- (void)configTitleViewWithConfigModel:(YBLevelListConfigModel *)configModel;


/**
 遍历titleView的所有子视图

 @param block --
 */
- (void)traverseTitleViewAllSubView:(void(^)(YBLevelListSubView *subView, NSInteger idx))block;


/**
 是否每次滚动完成都刷新UI（确保每次Controller会走viewWillApear方法）  此方法慎用

 @param update --
 */
- (void)updateUIWhenScrollEnd:(BOOL)update;

@end

NS_ASSUME_NONNULL_END
