//
//  YBNestContainerView.h
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/24.
//  Copyright © 2019 杨波. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YBNestContainerView;

@protocol YBNestContainerViewDataSource <NSObject>

@required

- (NSInteger)yb_numberOfViewsInNestContainerView:(YBNestContainerView *)view;

- (UIView *)yb_nestContainerView:(YBNestContainerView *)view viewAtPage:(NSInteger)page;

@optional

/**
 横向滚动的集合视图的类类型

 @return 类类型
 */
- (Class)yb_nestCollectionViewClass;

@end

@interface YBNestContainerView : UIView

+ (instancetype)viewWithDataSource:(id<YBNestContainerViewDataSource>)dataSource;


+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
