//
//  GoodsDetailsVC.m
//  CSJF
//
//  Created by cqdingwei@163.com on 2017/5/17.
//  Copyright © 2017年 dingwei. All rights reserved.
//

#import "GoodsDetailsVC.h"

#import "PicAndTextTableView.h"
#import "EvaluateTableView.h"

#import "YBLevelListView.h"


@interface GoodsDetailsVC () <UITableViewDelegate, UITableViewDataSource, YBLevelListViewDelegate>
{
    UIScrollView *subScrollView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YBLevelListView *levelListView;

@property (nonatomic, strong) EvaluateTableView *evaluateTableView;
@property (nonatomic, strong) PicAndTextTableView *picAndTextTableView;

@end

@implementation GoodsDetailsVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isEqual:subScrollView]) {
        self.evaluateTableView.scrollEnabled = NO;
        self.picAndTextTableView.scrollEnabled = NO;
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isEqual:subScrollView]) {
        self.evaluateTableView.scrollEnabled = YES;
        self.picAndTextTableView.scrollEnabled = YES;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.tableView]) {
        
        NSLog(@"%lf, %lf", scrollView.contentOffset.y, scrollView.contentSize.height-scrollView.H);
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height-scrollView.H-0.5)) {
            self.offsetType = OffsetTypeMax;
        } else if (scrollView.contentOffset.y <= 0) {
            self.offsetType = OffsetTypeMin;
        } else {
            self.offsetType = OffsetTypeCenter;
        }

        if (self.levelListView.selectedIndex == 0 && _picAndTextTableView.offsetType == OffsetTypeCenter) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height-scrollView.H);
        }
    
        if (self.levelListView.selectedIndex == 1 && _evaluateTableView.offsetType == OffsetTypeCenter) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height-scrollView.H);
        }
        
    } else if ([scrollView isEqual:subScrollView]) {
        
        [self.levelListView configAnimationOffsetX:subScrollView.contentOffset.x];
    }
    

}

#pragma mark *** YBLevelListViewDelegate ***
- (void)yBLevelListView:(YBLevelListView *)yBLevelListView chooseIndex:(NSInteger)index {
    [subScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0)];
}

#pragma mark *** UITableViewDataSource ***
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 400;
    } else {
        return kHeightOfGoodsDetailsBottomCell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nullCell0"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"nullCell0"];
        }
        
        cell.backgroundColor = [UIColor orangeColor];
        
        return cell;
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nullCell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"nullCell1"];

            
            subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeightOfGoodsDetailsBottomCell)];
            subScrollView.bounces = NO;
            [subScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*2, kHeightOfGoodsDetailsBottomCell)];
            subScrollView.pagingEnabled = YES;
            subScrollView.showsHorizontalScrollIndicator = NO;
            subScrollView.delegate = self;
            [cell addSubview:subScrollView];
            
            
            _picAndTextTableView = [[PicAndTextTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeightOfGoodsDetailsBottomCell) style:UITableViewStylePlain];
            _picAndTextTableView.backgroundColor = [UIColor whiteColor];
            _picAndTextTableView.mainVC = self;
            [subScrollView addSubview:_picAndTextTableView];
            
            _evaluateTableView = [[EvaluateTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, kHeightOfGoodsDetailsBottomCell) style:UITableViewStylePlain];
            _evaluateTableView.backgroundColor = [UIColor whiteColor];
            _evaluateTableView.mainVC = self;
            [subScrollView addSubview:_evaluateTableView];

            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.levelListView;
    }
    return nil;
}


#pragma mark *** getter ***
- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (YBLevelListView *)levelListView {
    if (!_levelListView) {
        
        YBLevelListConfigModel *model = [YBLevelListConfigModel new];
        model.titleArr = @[@"图文详情", @"客户评分"];
        model.titleColorOfSelected = [UIColor orangeColor];
        
        _levelListView = [[YBLevelListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) configModel:model];
        _levelListView.backgroundColor = [UIColor whiteColor];
        _levelListView.delegate = self;
    }
    return _levelListView;
}


@end
