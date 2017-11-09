//
//  PicAndTextTableView.m
//  CSJF
//
//  Created by cqdingwei@163.com on 2017/5/18.
//  Copyright © 2017年 dingwei. All rights reserved.
//

#import "PicAndTextTableView.h"
#import "YbWebView.h"

#import "GoodsDetailsVC.h"

@interface PicAndTextTableView ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, YbWebViewDelegate>

@property (nonatomic, assign) BOOL isDrag;
@property (nonatomic, strong) YbWebView *ybWebview;

@property (nonatomic, assign) CGFloat heightOfCell;

@end

@implementation PicAndTextTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.alwaysBounceVertical = YES;
        
        _heightOfCell = kHeightOfGoodsDetailsBottomCell;
    }
    return self;
}

#pragma mark *** UIScrollViewDelegate ***
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isDrag = YES;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    _isDrag = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    OffsetType type = self.mainVC.offsetType;
    
    if (scrollView.contentOffset.y <= 0) {
        self.offsetType = OffsetTypeMin;
    } else {
        self.offsetType = OffsetTypeCenter;
    }
    
    if (type == OffsetTypeMin) {
        scrollView.contentOffset = CGPointZero;
    }
    if (type == OffsetTypeCenter) {
        scrollView.contentOffset = CGPointZero;
    }
    if (type == OffsetTypeMax) {
        
    }
    
}

#pragma mark *** YbWebViewDelegate ***
- (void)ybWebView:(YbWebView *)ybWebView finishLoadWithHeight:(CGFloat)height {
    _heightOfCell = height;
    
    [self reloadData];
}

#pragma mark *** UITableViewDataSource ***
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _heightOfCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nullCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"nullCell"];
        
        _ybWebview = [YbWebView new];
        _ybWebview.delegate = self;
//        @"http://www.jianshu.com/u/a89bf7b8bdd8"
        [_ybWebview loadWithUrlStr:@"https://github.com/indulgeIn/YBMultistageScrollView"];
        
        [cell.contentView addSubview:_ybWebview];
        [_ybWebview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
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
