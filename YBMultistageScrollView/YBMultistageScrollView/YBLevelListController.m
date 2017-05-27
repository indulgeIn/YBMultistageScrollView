//
//  YBLevelListController.m
//  ToolsDemoByYangBo
//
//  Created by 杨波 on 2017/4/23.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import "YBLevelListController.h"

@interface YBLevelList_spaceCC : UICollectionViewCell

//是否是第一次加载
@property (nonatomic, assign) BOOL isFirstLoadSubview;

@end

@implementation YBLevelList_spaceCC

@end


@interface YBLevelListController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, YBLevelListViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YBLevelListView *titleView;

@property (nonatomic, assign) CGRect titleViewFrame;
@property (nonatomic, assign) CGRect contentViewFrame;

@property (nonatomic, assign) BOOL updateWhenScrollEnd;
@property (nonatomic, assign) NSInteger updateWhenScrollEnd_index;

@property (nonatomic, assign) BOOL isDrag;

@end

@implementation YBLevelListController

#pragma mark *** life cycle ***
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark *** public ***
- (void)initializeWithControllers:(NSArray<UIViewController *> *)controllers titleViewTitles:(NSArray<id> *)titleViewTitles titleViewHeight:(CGFloat)titleViewHeight contentViewHeight:(CGFloat)contentViewHeight {
    
    YBLevelListConfigModel *model = [YBLevelListConfigModel new];
    model.titleArr = [titleViewTitles mutableCopy];
    
    [self initializeWithControllers:controllers titleViewConfigModel:model titleViewHeight:titleViewHeight contentViewHeight:contentViewHeight];
    
}
- (void)initializeWithControllers:(NSArray<UIViewController *> *)controllers titleViewConfigModel:(YBLevelListConfigModel *)configModel titleViewHeight:(CGFloat)titleViewHeight contentViewHeight:(CGFloat)contentViewHeight {
    
    [self initializeWithControllers:controllers titleViewConfigModel:configModel titleViewFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, titleViewHeight) contentViewFrame:CGRectMake(0, titleViewHeight, [UIScreen mainScreen].bounds.size.width, contentViewHeight)];
    
}
- (void)initializeWithControllers:(NSArray<UIViewController *> *)controllers titleViewConfigModel:(YBLevelListConfigModel *)configModel titleViewFrame:(CGRect)titleViewFrame contentViewFrame:(CGRect)contentViewFrame {
    
    if (configModel.titleArr.count < controllers.count) {
        LOGERRORMESSAGE(@"标题数量不可小于控制器的数量")
        return;
    }
    
    for (UIViewController *vc in controllers) {
        [self addChildViewController:vc];
    }
    
    _titleViewFrame = titleViewFrame;
    _contentViewFrame = contentViewFrame;
    
    [self.titleView configUIWithModel:configModel];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView layoutIfNeeded];
    [self.collectionView reloadData];
}

- (void)configTitleViewWithConfigModel:(YBLevelListConfigModel *)configModel {
    [self.titleView configUIWithModel:configModel];
}
- (void)yBLevelListController_clickTitleWithIndex:(NSInteger)index {}
- (void)traverseTitleViewAllSubView:(void (^)(YBLevelListSubView * _Nonnull, NSInteger))block {
    [self.titleView traverseAllSubView:^(YBLevelListSubView *subView, NSInteger idx) {
        block(subView, idx);
    }];
}
- (void)updateUIWhenScrollEnd:(BOOL)update {
    _updateWhenScrollEnd = update;
}


#pragma mark *** YBLevelListViewDelegate ***
- (void)yBLevelListView:(YBLevelListView *)yBLevelListView chooseIndex:(NSInteger)index {
    if (self.childViewControllers.count-1 >= index) {
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width*index, 0) animated:NO];
    } else {
        LOGERRORMESSAGE(@"该标题没有对应的controller")
    }
    
    if ([self respondsToSelector:@selector(yBLevelListController_clickTitleWithIndex:)]) {
        [self yBLevelListController_clickTitleWithIndex:index];
    }
    
}

#pragma mark *** UIScrollViewDelegate ***
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x < 0 || (scrollView.contentOffset.x > (scrollView.contentSize.width-scrollView.bounds.size.width))) {
        return;
    }
    
    if (_updateWhenScrollEnd) {
        
        CGFloat tempF = scrollView.contentOffset.x/(self.view.bounds.size.width*1.0);
        if (tempF == floorf(tempF)) {
            _updateWhenScrollEnd_index = tempF;
            
            [self.collectionView reloadData];
        }
    }
    
    [self.titleView configAnimationOffsetX:scrollView.contentOffset.x];

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _isDrag = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _isDrag = NO;
}

#pragma mark *** UICollectionViewDataSource ***
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViewControllers.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YBLevelList_spaceCC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"YBLevelList_spaceCC%ld", indexPath.row] forIndexPath:indexPath];
    
    UIViewController *vc = self.childViewControllers[indexPath.row];
    
    if (!vc.view.superview) {
        
        vc.view.frame = CGRectMake(0, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
        [cell.contentView addSubview:vc.view];
        
        cell.isFirstLoadSubview = YES;
        
    } else {
        
        //打开了滚动结束刷新UI，不是第一次加载，滑动结束index对应
        if (_updateWhenScrollEnd && !cell.isFirstLoadSubview && (_updateWhenScrollEnd_index == indexPath.row)) {
            [vc.view removeFromSuperview];
            [cell.contentView addSubview:vc.view];
        }
        
        cell.isFirstLoadSubview = NO;
    }
    
    return cell;
}

#pragma mark *** UICollectionViewDelegate ***
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark *** UICollectionViewDelegateFlowLayout ***
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark *** getter ***
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:_contentViewFrame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([UICollectionViewCell class])]];

        for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
            [self.collectionView registerClass:[YBLevelList_spaceCC class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"YBLevelList_spaceCC%ld", i]];
        }
    }
    return _collectionView;
}
- (YBLevelListView *)titleView {
    if (!_titleView) {
        _titleView = [[YBLevelListView alloc] initWithFrame:_titleViewFrame];
        _titleView.delegate = self;
        
    }
    return _titleView;
}


@end
