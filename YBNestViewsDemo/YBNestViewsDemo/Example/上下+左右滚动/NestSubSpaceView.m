//
//  NestSubSpaceView.m
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/25.
//  Copyright © 2019 杨波. All rights reserved.
//

#import "NestSubSpaceView.h"

@implementation NestSubSpaceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.orangeColor;
    }
    return self;
}

#pragma mark - <YBNestContentProtocol>

- (UIView *)yb_contentView {
    return self;
}

- (void)yb_contentWillAppear {
    YBLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

- (void)yb_contentDidDisappear {
    YBLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}


@end
