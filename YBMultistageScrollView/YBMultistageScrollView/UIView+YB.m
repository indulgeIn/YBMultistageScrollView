//
//  UIView+YB.m
//  ToolsDemo
//
//  Created by abc on 16/8/17.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "UIView+YB.h"

@implementation UIView (YB)

- (void)setX:(CGFloat)X
{
    CGRect frame = self.frame;
    frame.origin.x = X;
    self.frame = frame;
}

- (CGFloat)X
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)Y
{
    CGRect frame = self.frame;
    frame.origin.y = Y;
    self.frame = frame;
}
- (CGFloat)Y
{
    return self.frame.origin.y;
}
- (void)setW:(CGFloat)W
{
    CGRect frame = self.frame;
    frame.size.width = W;
    self.frame = frame;
}
- (CGFloat)W
{
    return self.frame.size.width;
}

- (void)setH:(CGFloat)H
{
    CGRect frame = self.frame;
    frame.size.height = H;
    self.frame = frame;
}

- (CGFloat)H
{
    return self.frame.size.height;
}

- (void)blurryWithAlpha:(CGFloat)alpha {
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualEffectView.frame = self.bounds;
    visualEffectView.alpha = alpha;
    visualEffectView.userInteractionEnabled = NO;
    [self addSubview:visualEffectView];
}

- (void)gradientWithColors:(NSArray *)colors partitionLocations:(NSArray<NSNumber *> *)partitionLocations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    //初始化渐变层
    CAGradientLayer *gradientColorLayer = [CAGradientLayer layer];
    gradientColorLayer.frame = self.bounds;
    
    //设置颜色组
    gradientColorLayer.colors = colors;
    
    //设置颜色分割点
    gradientColorLayer.locations = partitionLocations;
    
    
    //设置渐变颜色方向
    // 1、起始位置
    gradientColorLayer.startPoint = startPoint;
    // 2、结束位置
    gradientColorLayer.endPoint = endPoint;
    
    //添加
    [self.layer addSublayer:gradientColorLayer];
}

- (void)takePhone:(NSString *)phone {
    //拨打电话
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", phone];
    UIWebView *callWebView = [UIWebView new];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebView];
}

@end
