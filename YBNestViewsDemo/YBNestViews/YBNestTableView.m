//
//  YBNestTableView.m
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/24.
//  Copyright © 2019 杨波. All rights reserved.
//

#import "YBNestTableView.h"

@interface YBNestTableView () <UIGestureRecognizerDelegate>
@end

@implementation YBNestTableView

#pragma mark - <UIGestureRecognizerDelegate>

// Override the methode of super class.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIPanGestureRecognizer.self] && [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.self];
}

@end
