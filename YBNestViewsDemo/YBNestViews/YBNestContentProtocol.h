//
//  YBNestContentProtocol.h
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/25.
//  Copyright © 2019 波儿菜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YBNestContentProtocol <NSObject>

@required

/**
 返回内容视图，若是 UIViewController 则返回 view 属性，若是 UIView 则返回 self

 @return 内容视图
 */
- (UIView *)yb_contentView;

@optional

/**
 若有滚动视图必须实现该方法

 @return 滚动视图
 */
- (UIScrollView *)yb_contentScrollView;

/// 若有滚动视图必须实现该属性，并且在 `- (void)scrollViewDidScroll:(UIScrollView *)scrollView` 代理方法中调用该属性
@property (nonatomic, copy) void(^yb_scrollViewDidScroll)(UIScrollView *scrollView);

/**
 视图即将显示
 */
- (void)yb_contentWillAppear;

/**
 视图已经消失
 */
- (void)yb_contentDidDisappear;

@end

NS_ASSUME_NONNULL_END
