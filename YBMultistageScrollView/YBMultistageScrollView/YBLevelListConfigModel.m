//
//  YBLevelListConfigModel.m
//  ToolsDemoByYangBo
//
//  Created by 杨波 on 2017/4/21.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import "YBLevelListConfigModel.h"

@implementation YBLevelListConfigModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //配置初值
        self.titleFont = [UIFont systemFontOfSize:14];
        self.titleColorOfSelected = [UIColor orangeColor];
        self.titleColorOfUnSelected = [UIColor darkGrayColor];
        
        self.sizeOfImageView = CGSizeMake(15, 15);
        self.spacingOfTitleAndImage = 3.0f;
        
        self.heightOfUnderLineSelectedView = 3.0f;
        
        self.underLineViewColor = [UIColor groupTableViewBackgroundColor];
        self.heightOfUnderLineView = 1.0f;
        
        self.spacingOfSubView = 15.0f;
        self.marginOfSubView = 4.0f;
        
        self.backColor = [UIColor whiteColor];
        
        self.canRepeatTouch = NO;
        
        self.scrollAnimationType = YBLevelListScrollAnimationTypeGradient;
    }
    return self;
}
- (void)setTitleColorOfSelected:(UIColor *)titleColorOfSelected {
    _titleColorOfSelected = titleColorOfSelected;
    
    self.underLineSelectedViewColor = titleColorOfSelected;
}
- (void)setImageInfoArr:(NSArray<id> *)imageInfoArr {
    _imageInfoArr = imageInfoArr;
    
    if (!self.imageInfoSelectedArr) {
        self.imageInfoSelectedArr = [imageInfoArr mutableCopy];
    }
}


@end
