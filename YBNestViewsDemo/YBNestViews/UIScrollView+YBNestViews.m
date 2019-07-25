//
//  UIScrollView+YBNestViews.m
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/25.
//  Copyright © 2019 杨波. All rights reserved.
//

#import "UIScrollView+YBNestViews.h"
#import <objc/runtime.h>

@implementation UIScrollView (YBNestViews)

static void *YBNestContentArriveTopKey = &YBNestContentArriveTopKey;
- (void)setYb_nestContentArriveTop:(BOOL)ybNest_fringe {
    objc_setAssociatedObject(self, YBNestContentArriveTopKey, @(ybNest_fringe), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)yb_nestContentArriveTop {
    NSNumber *top = objc_getAssociatedObject(self, YBNestContentArriveTopKey);
    if (!top) {
        top = @YES;
        self.yb_nestContentArriveTop = top;
    }
    return top.boolValue;
}

@end
