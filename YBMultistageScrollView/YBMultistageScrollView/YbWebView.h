//
//  YbWebView.h
//  ToolsDemoByYangBo
//
//  Created by cqdingwei@163.com on 17/3/8.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultstageScrollViewHeader.h"

@class YbWebView;

@protocol YbWebViewDelegate <NSObject>

- (void)ybWebView:(YbWebView *)ybWebView finishLoadWithHeight:(CGFloat)height;

@end

@interface YbWebView : UIView

@property (nonatomic, weak) id <YbWebViewDelegate> delegate;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, assign) BOOL notShowHUD;

- (void)loadWithUrlStr:(NSString *)urlStr;
- (void)loadWithHTMLStr:(NSString *)HTMLStr;

@end
