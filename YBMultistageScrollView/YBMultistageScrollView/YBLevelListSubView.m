//
//  YBLevelListSubView.m
//  ToolsDemoByYangBo
//
//  Created by 杨波 on 2017/4/21.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import "YBLevelListSubView.h"

@implementation YBLevelListSubView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleImageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark *** getter ***
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [UIImageView new];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        _titleImageView.layer.masksToBounds = YES;
    }
    return _titleImageView;
}

@end
