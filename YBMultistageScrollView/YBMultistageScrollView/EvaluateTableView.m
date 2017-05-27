//
//  EvaluateTableView.m
//  CSJF
//
//  Created by cqdingwei@163.com on 2017/5/18.
//  Copyright © 2017年 dingwei. All rights reserved.
//

#import "EvaluateTableView.h"
#import "GoodsDetailsVC.h"

@interface EvaluateTableView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isDrag;

@end

@implementation EvaluateTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        
        self.alwaysBounceVertical = YES;
    }
    return self;
}

#pragma mark *** tool ***
- (UIViewController *)getViewControllerByView:(UIView *)view {
    
    for (id next = view; next; next = [next superview]) {
        UIResponder *responder = [next nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

#pragma mark *** UIScrollViewDelegate ***
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isDrag = YES;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    _isDrag = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    

    GoodsDetailsVC *vc = (GoodsDetailsVC *)[self getViewControllerByView:self];
    
    if (scrollView.contentOffset.y <= 0) {
        self.offsetType = OffsetTypeMin;
    } else {
        self.offsetType = OffsetTypeCenter;
    }
    
    if (vc.offsetType == OffsetTypeMin) {
        scrollView.contentOffset = CGPointZero;
    }
    if (vc.offsetType == OffsetTypeCenter) {
        scrollView.contentOffset = CGPointZero;
    }
    if (vc.offsetType == OffsetTypeMax) {
        
    }
    
}


#pragma mark *** UITableViewDataSource ***
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"simpleCell"];
    }
    cell.textLabel.text = @"评论模块";
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark *** UITableViewDelegate ***
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark *** other ***
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
