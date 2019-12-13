//
//  NestSubController.m
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/24.
//  Copyright © 2019 波儿菜. All rights reserved.
//

#import "NestSubController.h"
#import "NestSubView.h"

@interface NestSubController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NestSubController

#pragma mark - life cycle

- (void)dealloc {
    YBLog(@"%@ 释放", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    YBLog(@"%@ %@", self, NSStringFromSelector(_cmd));
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    YBLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    YBLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - <YBNestContentProtocol>

@synthesize yb_scrollViewDidScroll = _yb_scrollViewDidScroll;

- (UIView *)yb_contentView {
    return self.view;
}

- (UIScrollView *)yb_contentScrollView {
    return self.tableView;
}

- (void)yb_contentWillAppear {
    YBLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

- (void)yb_contentDidDisappear {
    YBLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const kCellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.textLabel.textColor = UIColor.orangeColor;
        cell.contentView.backgroundColor = UIColor.groupTableViewBackgroundColor;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.yb_scrollViewDidScroll(scrollView);
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
