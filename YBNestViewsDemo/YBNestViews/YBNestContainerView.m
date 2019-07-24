//
//  YBNestContainerView.m
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/24.
//  Copyright © 2019 杨波. All rights reserved.
//

#import "YBNestContainerView.h"
#import "YBNestContainerLayout.h"

static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface YBNestContainerView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id<YBNestContainerViewDataSource> dataSource;
@end

@implementation YBNestContainerView

#pragma mark - life cycle

+ (instancetype)viewWithDataSource:(id<YBNestContainerViewDataSource>)dataSource {
    return [[YBNestContainerView alloc] initWithDataSource:dataSource];
}

- (instancetype)initWithDataSource:(id<YBNestContainerViewDataSource>)dataSource {
    if (self = [super init]) {
        self.dataSource = dataSource;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource yb_numberOfViewsInNestContainerView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *view = [self.dataSource yb_nestContainerView:self viewAtPage:indexPath.row];
    view.frame = cell.bounds;
    [cell.contentView addSubview:view];
    
    return cell;
}

#pragma mark - getters & setters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        Class cls = [self.dataSource yb_nestCollectionViewClass] ?: UICollectionView.self;
        _collectionView = [[cls alloc] initWithFrame:CGRectZero collectionViewLayout:YBNestContainerLayout.new];
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:UICollectionViewCell.self forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
