//
//  NestMainController.m
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/24.
//  Copyright © 2019 波儿菜. All rights reserved.
//

#import "NestMainController.h"
#import "YBNestViews.h"
#import "NestSubView.h"
#import "NestSubController.h"
#import "NestSubSpaceView.h"

@interface NestMainController () <UITableViewDelegate, UITableViewDataSource, YBNestContainerViewDataSource>
@property (nonatomic, strong) YBNestTableView *tableView;
@property (nonatomic, strong) YBNestContainerView *containerView;
@end

@implementation NestMainController {
    NestSubController *vc;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

/// 容器视图的高度
+ (CGSize)containerSize {
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    return CGSizeMake(screenSize.width, screenSize.height - UIApplication.sharedApplication.statusBarFrame.size.height - 44);
}

#pragma mark - <YBNestContainerViewDataSource>

- (NSInteger)yb_numberOfContentsInNestContainerView:(YBNestContainerView *)view {
    return 4;
}

- (id<YBNestContentProtocol>)yb_nestContainerView:(YBNestContainerView *)view contentAtPage:(NSInteger)page{
    switch (page) {
        case 0: return [NestSubView new];
        case 1: return [NestSubView new];
        case 2: return [NestSubSpaceView new];
        case 3: return [NestSubController new];
        default: return nil;
    }
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return [self.class containerSize].height;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        static NSString * const kContainerIdentifier = @"Container";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kContainerIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kContainerIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // 添加容器到 Cell 上
            [cell.contentView addSubview:self.containerView];
            self.containerView.frame = (CGRect){CGPointZero, [self.class containerSize]};
        }
        return cell;
    }
    
    static NSString * const kCellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.containerView mainScrollViewDidScroll:scrollView];
}

#pragma mark - getter

- (YBNestTableView *)tableView {
    if (!_tableView) {
        _tableView = [[YBNestTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (YBNestContainerView *)containerView {
    if (!_containerView) {
        _containerView = [YBNestContainerView viewWithDataSource:self];
    }
    return _containerView;
}

@end
