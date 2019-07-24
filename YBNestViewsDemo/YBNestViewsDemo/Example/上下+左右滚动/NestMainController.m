//
//  NestMainController.m
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/24.
//  Copyright © 2019 杨波. All rights reserved.
//

#import "NestMainController.h"
#import "YBNestTableView.h"
#import "YBNestContainerView.h"
#import "NestSubView.h"
#import "NestSubController.h"

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

- (NSInteger)yb_numberOfViewsInNestContainerView:(YBNestContainerView *)view {
    return 3;
}

- (UIView *)yb_nestContainerView:(YBNestContainerView *)view viewAtPage:(NSInteger)page {
    NSLog(@"获取视图 page：%ld", page);
    switch (page) {
        case 0:
            return [NestSubView new];
            break;
        case 1:
            return [NestSubView new];
            break;
        case 2:
            vc = NestSubController.new;
            return vc.view;
        default:
            return nil;
            break;
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
