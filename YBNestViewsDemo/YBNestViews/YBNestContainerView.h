//
//  YBNestContainerView.h
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/24.
//  Copyright © 2019 波儿菜. All rights reserved.
//

#import "YBNestContentProtocol.h"
#import "YBNestCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@class YBNestContainerView;

@protocol YBNestContainerViewDataSource <NSObject>

@required

/**
 返回内容视图的数量

 @param view 容器视图
 @return 数量
 */
- (NSInteger)yb_numberOfContentsInNestContainerView:(YBNestContainerView *)view;

/**
 返回指定页码的内容视图

 @param view 容器视图
 @param page 目标页码
 @return 内容视图
 */
- (id<YBNestContentProtocol>)yb_nestContainerView:(YBNestContainerView *)view contentAtPage:(NSInteger)page;

@optional

/**
 横向滚动的集合视图的类类型，必须是 YBNestCollectionView 或其子类

 @return 类类型
 */
- (Class)yb_nestCollectionViewClass;

@end


@protocol YBNestContainerViewDelegate <NSObject>

@optional

- (void)yb_nestContainerView:(YBNestContainerView *)view pageChanged:(NSInteger)page;

@end


@interface YBNestContainerView : UIView

/**
 指定便利构造方法
 */
+ (instancetype)viewWithDataSource:(id<YBNestContainerViewDataSource>)dataSource;

/// 代理对象
@property (nonatomic, weak) id<YBNestContainerViewDelegate> delegate;

/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

/**
 刷新数据
 */
- (void)reloadData;

/// 页间距
@property (nonatomic, assign) CGFloat distanceBetweenPages;

#pragma mark - 外部调用

- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView;


+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
