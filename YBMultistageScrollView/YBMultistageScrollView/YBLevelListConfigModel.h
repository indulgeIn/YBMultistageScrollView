//
//  YBLevelListConfigModel.h
//  ToolsDemoByYangBo
//
//  Created by 杨波 on 2017/4/21.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YBLevelListScrollAnimationType) {
    YBLevelListScrollAnimationTypeGradient, //渐变+底部滑条动画
    YBLevelListScrollAnimationTypeNone
};

@interface YBLevelListConfigModel : NSObject 


//* 标题相关属性

//标题数组（NSString类型或者NSAttributeString类型, 注意：1、此次copy修饰关键字至关重要不可修改 2、如果是NSAttributeString类型，请务必设置字体）
@property (nonatomic, copy) NSArray<id> *titleArr;
//选中状态的标题数组
@property (nonatomic, copy, nullable) NSArray<id> *titleSelectedArr;
//标题字体（仅在标题数组元素是NSString时有效）
@property (nonatomic, strong, nullable) UIFont *titleFont;
//标题选中颜色
@property (nonatomic, strong, nullable) UIColor *titleColorOfSelected;
//标题未选择颜色
@property (nonatomic, strong, nullable) UIColor *titleColorOfUnSelected;


//* 标题图片相关属性

//标题图片数组（图片名字字符串、图片链接字符串、UIImage类型、NSURL类型）
@property (nonatomic, copy, nullable) NSArray<id> *imageInfoArr;
//选中状态的标题图片数组（图片名字字符串、图片链接字符串、UIImage类型、NSURL类型）
@property (nonatomic, copy, nullable) NSArray<id> *imageInfoSelectedArr;
//标题图片大小
@property (nonatomic, assign) CGSize sizeOfImageView;
//标题图片与标题距离
@property (nonatomic, assign) CGFloat spacingOfTitleAndImage;


//* 标题下划线相关属性

//选择状态下滑线颜色
@property (nonatomic, strong, nullable) UIColor *underLineSelectedViewColor;
//选择状态下滑线高度
@property (nonatomic, assign) CGFloat heightOfUnderLineSelectedView;
//默认下边线颜色
@property (nonatomic, strong, nullable) UIColor *underLineViewColor;
//默认下边线高度
@property (nonatomic, assign) CGFloat heightOfUnderLineView;


//*距离相关属性

//子模块间的距离
@property (nonatomic, assign) CGFloat spacingOfSubView;
//子模块的左右边缘距离
@property (nonatomic, assign) CGFloat marginOfSubView;

//* 背景色
@property (nonatomic, strong) UIColor *backColor;

//* 重复点击事件
@property (nonatomic, assign) BOOL canRepeatTouch;

//* 滚动动画 (手动调用改变偏移量的时候)
@property (nonatomic, assign) YBLevelListScrollAnimationType scrollAnimationType;

@end

NS_ASSUME_NONNULL_END
