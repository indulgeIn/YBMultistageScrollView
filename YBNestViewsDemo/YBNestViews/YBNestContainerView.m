//
//  YBNestContainerView.m
//  YBNestViewsDemo
//
//  Created by 波儿菜 on 2019/7/24.
//  Copyright © 2019 波儿菜. All rights reserved.
//

#import "YBNestContainerView.h"
#import "YBNestContainerLayout.h"
#import "UIScrollView+YBNestViews.h"

static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface YBNestContainerView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) YBNestCollectionView *collectionView;
@property (nonatomic, weak) id<YBNestContainerViewDataSource> dataSource;
@end

@implementation YBNestContainerView {
    YBNestContainerLayout *_layout;
    NSMutableDictionary<NSNumber *, id<YBNestContentProtocol>> *_contentsCache;
    BOOL _mainScrollViewArriveBottom;
}

#pragma mark - life cycle

+ (instancetype)viewWithDataSource:(id<YBNestContainerViewDataSource>)dataSource {
    return [[YBNestContainerView alloc] initWithDataSource:dataSource];
}

- (instancetype)initWithDataSource:(id<YBNestContainerViewDataSource>)dataSource {
    if (self = [super init]) {
        _layout = [YBNestContainerLayout new];
        _contentsCache = [NSMutableDictionary dictionary];
        _mainScrollViewArriveBottom = YES;
        self.dataSource = dataSource;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - public

- (void)reloadData {
    [_contentsCache removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - private

- (NSInteger)numberOfContents {
    return [self.dataSource yb_numberOfContentsInNestContainerView:self];
}

- (id<YBNestContentProtocol>)contentAtPage:(NSInteger)page {
    id<YBNestContentProtocol> content = [_contentsCache objectForKey:@(page)];
    if (!content) {
        content = [self.dataSource yb_nestContainerView:self contentAtPage:page];
        [_contentsCache setObject:content forKey:@(page)];
        
        if ([content respondsToSelector:@selector(setYb_scrollViewDidScroll:)]) {
            NSInteger curPage = page;
            __weak typeof(self) wSelf = self;
            [content setYb_scrollViewDidScroll:^(UIScrollView * _Nonnull scrollView) {
                __strong typeof(wSelf) self = wSelf;
                [self contentScrollViewDidScroll:scrollView page:curPage];
            }];
        }
    }
    return content;
}

#pragma mark - scroll control

- (void)containerScrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView {
    id<YBNestContentProtocol> content = [self contentAtPage:self.currentPage];
    
    UIScrollView *contentScrollView = nil;
    if ([content respondsToSelector:@selector(yb_contentScrollView)]) {
        contentScrollView = [content yb_contentScrollView];
    }
    
    CGFloat maxOffsetY = scrollView.contentSize.height - scrollView.bounds.size.height;
    if (contentScrollView && !contentScrollView.yb_nestContentArriveTop) {
        // Fixed 'contentOffset'.
        scrollView.contentOffset = CGPointMake(0, maxOffsetY);
    }
    
    BOOL beforeBottom = _mainScrollViewArriveBottom;
    _mainScrollViewArriveBottom = scrollView.contentOffset.y >= maxOffsetY - 0.5;
    
    scrollView.showsVerticalScrollIndicator = !_mainScrollViewArriveBottom;
    
    if (beforeBottom != _mainScrollViewArriveBottom && !_mainScrollViewArriveBottom) {
        // Reset 'contentOffset' of all the 'contentScrollView'.
        for (id<YBNestContentProtocol> content in _contentsCache.allValues) {
            if (![content respondsToSelector:@selector(yb_contentScrollView)]) continue;
            UIScrollView *cView = [content yb_contentScrollView];
            if (cView.yb_nestContentArriveTop) continue;
            cView.contentOffset = CGPointZero;
        }
    }
}

- (void)contentScrollViewDidScroll:(UIScrollView *)scrollView page:(NSInteger)page {
    scrollView.yb_nestContentArriveTop = scrollView.contentOffset.y <= 0;
    
    if (!_mainScrollViewArriveBottom) {
        // Fixed 'contentOffset'.
        scrollView.contentOffset = CGPointZero;
    }
    
    scrollView.showsVerticalScrollIndicator = !scrollView.yb_nestContentArriveTop;
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfContents];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    id<YBNestContentProtocol> content = [self contentAtPage:indexPath.row];
    
    UIView *view = [content yb_contentView];
    view.frame = cell.bounds;
    [cell.contentView addSubview:view];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    for (id<YBNestContentProtocol> content in _contentsCache.allValues) {
        if (![content respondsToSelector:@selector(yb_contentWillAppear)]) continue;
        [content yb_contentWillAppear];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    for (id<YBNestContentProtocol> content in _contentsCache.allValues) {
        if (![content respondsToSelector:@selector(yb_contentDidDisappear)]) continue;
        [content yb_contentDidDisappear];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self containerScrollViewDidScroll:scrollView];
    
    CGFloat pageF = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSInteger page = (NSInteger)(pageF + 0.5);
    if (page < 0 || page > [self numberOfContents] - 1) return;
    
    if (!scrollView.isDecelerating && !scrollView.isDragging) {
        // Return if not scrolled by finger.
        return;
    }
    
    if (page != _currentPage) {
        _currentPage = page;
        [self pageNumberChanged];
    }
}

- (void)pageNumberChanged {
    if ([self.delegate respondsToSelector:@selector(yb_nestContainerView:pageChanged:)]) {
        [self.delegate yb_nestContainerView:self pageChanged:self.currentPage];
    }
}

#pragma mark - getters & setters

- (void)setCurrentPage:(NSInteger)currentPage {
    NSInteger maxPage = [self numberOfContents] - 1;
    if (currentPage > maxPage) {
        currentPage = maxPage;
    }
    _currentPage = currentPage;
    if (self.collectionView.superview) {
        [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width * self.currentPage, 0)];
        [self pageNumberChanged];
    }
}

- (void)setDistanceBetweenPages:(CGFloat)distanceBetweenPages {
    _layout.distanceBetweenPages = distanceBetweenPages;
}
- (CGFloat)distanceBetweenPages {
    return _layout.distanceBetweenPages;
}

- (YBNestCollectionView *)collectionView {
    if (!_collectionView) {
        Class cls = YBNestCollectionView.self;
        if ([self.dataSource respondsToSelector:@selector(yb_nestCollectionViewClass)]) {
            cls = [self.dataSource yb_nestCollectionViewClass];
        }
        _collectionView = [[cls alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
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
