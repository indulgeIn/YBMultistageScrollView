//
//  UIView+YB.h
//  ToolsDemo
//
//  Created by abc on 16/8/17.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YB)

//frame
@property (nonatomic, assign) CGFloat  X;
@property (nonatomic, assign) CGFloat  Y;
@property (nonatomic, assign) CGFloat  W;
@property (nonatomic, assign) CGFloat  H;


//模糊效果
- (void)blurryWithAlpha:(CGFloat)alpha;


/** 图层渐变
 * colors:桥接过后的CGColor
 * partitionLocations:图层渐变的位置点，注意比colors多一个内容
 * startPoint:开始位置
 * endPoint:结束位置
 */
- (void)gradientWithColors:(NSArray *)colors partitionLocations:(NSArray <NSNumber *> *)partitionLocations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end



NS_ASSUME_NONNULL_END
