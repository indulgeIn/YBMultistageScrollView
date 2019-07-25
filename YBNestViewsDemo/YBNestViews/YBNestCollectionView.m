//
//  YBNestCollectionView.m
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/25.
//  Copyright © 2019 杨波. All rights reserved.
//

#import "YBNestCollectionView.h"
#import "YBNestTableView.h"

@interface YBNestCollectionView () <UIGestureRecognizerDelegate>
@end

@implementation YBNestCollectionView

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:YBNestTableView.self]) {
        return NO;
    }
    return NO;
}

@end
