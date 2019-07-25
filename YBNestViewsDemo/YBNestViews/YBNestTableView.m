//
//  YBNestTableView.m
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/24.
//  Copyright © 2019 波儿菜. All rights reserved.
//

#import "YBNestTableView.h"
#import "YBNestCollectionView.h"

@interface YBNestTableView () <UIGestureRecognizerDelegate>
@end

@implementation YBNestTableView

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.self] && [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.self]) {
        if ([otherGestureRecognizer.view isKindOfClass:YBNestCollectionView.self]) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

@end
