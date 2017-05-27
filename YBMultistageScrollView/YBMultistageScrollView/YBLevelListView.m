//
//  YBLevelListView.m
//  ToolsDemoByYangBo
//
//  Created by 杨波 on 2017/4/21.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import "YBLevelListView.h"

static const NSInteger kConstTagOfYBLevelListSubView = 666;

@interface YBLevelListView () <UIScrollViewDelegate>

//记录子视图数组
@property (nonatomic, strong) NSMutableArray<YBLevelListSubView *> *subViewArr;
//记录子视图总共的长度
@property (nonatomic, assign) CGFloat totalLengthOfSubView;
//记录当前选择的角标
@property (nonatomic, assign) NSInteger selectedIndex;
//记录上一次滚动视图偏移量
@property (nonatomic, assign) CGFloat lastOffsetX;


//滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;


//选择状态下划线
@property (nonatomic, strong) UIView *underLineSelectView;
//默认下划线
@property (nonatomic, strong) UIView *underLineView;


//开始颜色,取值范围0~1
@property (nonatomic, assign) CGFloat startR;
@property (nonatomic, assign) CGFloat startG;
@property (nonatomic, assign) CGFloat startB;


//完成颜色,取值范围0~1
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;



@property (nonatomic, strong) YBLevelListConfigModel *configModel;


@end

@implementation YBLevelListView

#pragma mark *** initialize ***
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeProperty];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame configModel:(YBLevelListConfigModel *)configModel
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeProperty];
        
        [self configUIWithModel:configModel];
        
    }
    return self;
}

#pragma mark *** event ***
- (void)clickTapGesture:(UITapGestureRecognizer *)tapGesture {
    
    YBLevelListSubView *subView = (YBLevelListSubView *)tapGesture.view;
    
    if (_selectedIndex == subView.tag - kConstTagOfYBLevelListSubView && !_configModel.canRepeatTouch) {
        
        return;
    }
    
    _selectedIndex = subView.tag - kConstTagOfYBLevelListSubView;
    
    [self configSubView];
    [self configUnderLineSelectedView];
    [self configScrollViewContentsize];
    [self scrollSelectedViewToCenter];
    
    if (_delegate && [_delegate respondsToSelector:@selector(yBLevelListView:chooseIndex:)]) {
        [_delegate yBLevelListView:self chooseIndex:_selectedIndex];
    }
    
}

#pragma mark *** public ***
- (void)selectToIndex:(NSInteger)toIndex {
    if (_subViewArr.count > toIndex) {
        _selectedIndex = toIndex;
        
        [self configSubView];
        [self configUnderLineSelectedView];
        [self configScrollViewContentsize];
        [self scrollSelectedViewToCenter];
    } else {
        LOGERRORMESSAGE(@"超过数组个数")
    }
}
- (void)traverseAllSubView:(void (^)(YBLevelListSubView *, NSInteger))block {
    [_subViewArr enumerateObjectsUsingBlock:^(YBLevelListSubView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj, idx);
    }];
}

#pragma mark *** config ***
- (void)configUIWithModel:(YBLevelListConfigModel *)model {
    
    if (!model) {
        LOGERRORMESSAGE(@"初始化模型configModel不能为空")
        return;
    }
    if (!model.titleArr || model.titleArr.count == 0) {
        LOGERRORMESSAGE(@"初始化参数titleArr不能为空")
        return;
    }
    
    _configModel = model;
    
    [self configUI];
}

- (void)configUI {
    
    [self removeSubViewOfSuperfluous];
    
    [self initializeScrollView];
    [self initializeUnderLineView];
    
    [self configSubView];
    [self configUnderLineSelectedView];
    [self configScrollViewContentsize];
    [self scrollSelectedViewToCenter];
    
    [self setupStartColor:_configModel.titleColorOfUnSelected];
    [self setupEndColor:_configModel.titleColorOfSelected];
}

- (void)configUnderLineSelectedView {
    //配置选择下划线
    if (_subViewArr.count > _selectedIndex) {
        //如果标题数量还能显示上一次点击的下标，只需要改变选择下划线大小
        YBLevelListSubView *selectSubView = _subViewArr[_selectedIndex];
        if (!self.underLineSelectView.superview) {
            [self.scrollView addSubview:self.underLineSelectView];
        }
        self.underLineSelectView.backgroundColor = _configModel.underLineSelectedViewColor;
        self.underLineSelectView.frame = CGRectMake(selectSubView.frame.origin.x, self.bounds.size.height-_configModel.heightOfUnderLineSelectedView, selectSubView.bounds.size.width, _configModel.heightOfUnderLineSelectedView);
        
    } else {
        //如果标题数量不能显示上一次点击下标了，回到第一个
        if (_subViewArr.count > 0) {
            _selectedIndex = 0;
            [self configUnderLineSelectedView];
        } else {
            LOGERRORMESSAGE(@"_subViewArr为空，理论上不会出现的错误")
        }
    }
}
- (void)configScrollViewContentsize {
    //计算scrollview  contentsize大小
    YBLevelListSubView *finalSubView = _subViewArr.lastObject;
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(finalSubView.frame)+_configModel.spacingOfSubView, finalSubView.bounds.size.height);
}

- (void)configAnimationOffsetX:(CGFloat)offsetX {
    
    // 获取左边角标
    NSInteger leftIndex = offsetX / self.bounds.size.width;
    
    // 左边按钮
    YBLevelListSubView *leftSubView = _subViewArr[leftIndex];
    
    // 右边角标
    NSInteger rightIndex = leftIndex + 1;
    
    // 右边按钮
    YBLevelListSubView *rightSubView;
    if (rightIndex < _subViewArr.count) {
        rightSubView = _subViewArr[rightIndex];
    } else {

    }
    
    if (_configModel.scrollAnimationType == YBLevelListScrollAnimationTypeGradient) {
        //移动下标
        [self moveUnderLineSelectViewWithOffsetX:offsetX leftSubView:leftSubView rightSubView:rightSubView];
        //文字渐变
        [self configTitleColorGradientWithOffset:offsetX rightSubView:rightSubView leftSubView:leftSubView];

    } 
    
    //改变文字和图片UI
    CGFloat tempF = offsetX/(self.bounds.size.width*1.0);
    if (tempF == floorf(tempF)) {
        [self selectToIndex:floorf(tempF)];
    }
    
    //记录偏移量
    _lastOffsetX = offsetX;
    
}

//动态移动下划线
- (void)moveUnderLineSelectViewWithOffsetX:(CGFloat)offsetX leftSubView:(YBLevelListSubView *)leftSubView rightSubView:(YBLevelListSubView *)rightSubView {
    // 获取两个标题中心点距离
    CGFloat centerDelta = rightSubView.frame.origin.x - leftSubView.frame.origin.x;
    
    // 标题宽度差值
    CGFloat widthDelta = rightSubView.frame.size.width - leftSubView.frame.size.width;
    
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetDelta * centerDelta / self.bounds.size.width;
    
    // 宽度递增偏移量
    CGFloat underLineWidth = offsetDelta * widthDelta / self.bounds.size.width;
    
    
    CGRect changeFrame;
    changeFrame.size.width = _underLineSelectView.frame.size.width + underLineWidth;
    changeFrame.size.height = _underLineSelectView.frame.size.height;
    changeFrame.origin.x = _underLineSelectView.frame.origin.x + underLineTransformX;
    changeFrame.origin.y = _underLineSelectView.frame.origin.y;
    _underLineSelectView.frame = changeFrame;
}

//动态改变字体渐变
- (void)configTitleColorGradientWithOffset:(CGFloat)offsetX rightSubView:(YBLevelListSubView *)rightSubView leftSubView:(YBLevelListSubView *)leftSubView
{
    
    // 获取右边缩放
    CGFloat rightSacle = offsetX / self.bounds.size.width - (leftSubView.tag-kConstTagOfYBLevelListSubView);
    
    // 获取左边缩放比例
    CGFloat leftScale = 1 - rightSacle;
    
    // RGB渐变
        
    CGFloat r = _endR - _startR;
    CGFloat g = _endG - _startG;
    CGFloat b = _endB - _startB;
    
    // rightColor
    // 1 0 0
    UIColor *rightColor = [UIColor colorWithRed:_startR + r * rightSacle green:_startG + g * rightSacle blue:_startB + b * rightSacle alpha:1];
    
    // 0.3 0 0
    // 1 -> 0.3
    // leftColor
    UIColor *leftColor = [UIColor colorWithRed:_startR +  r * leftScale  green:_startG +  g * leftScale  blue:_startB +  b * leftScale alpha:1];
    
    // 右边颜色
    rightSubView.titleLabel.textColor = rightColor;
    
    // 左边颜色
    leftSubView.titleLabel.textColor = leftColor;

}

////动态缩放
//- (void)configSubViewScaleWithOffsetX:(CGFloat)offsetX rightSubView:(YBLevelListSubView *)rightSubView leftSubView:(YBLevelListSubView *)leftSubView {
//    
//    // 获取右边缩放
//    CGFloat rightSacle = offsetX / (self.bounds.size.width*1.0) - (leftSubView.tag-kConstTagOfYBLevelListSubView);
//    
//    //右边缩放
//    CGFloat leftScale = 1 - rightSacle;
//    
//    CGFloat scaleTransform = 1.2;
//    
//    scaleTransform -= 1;
//    
//    CABasicAnimation *basicAnimationL = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    if ([leftSubView.layer animationForKey:@"scale"]) {
//        CABasicAnimation *l = (CABasicAnimation *)[leftSubView.layer animationForKey:@"scale"];
//        basicAnimationL.fromValue = l.toValue;
//    }
//    basicAnimationL.toValue = @(leftScale * scaleTransform+1);
//    basicAnimationL.duration = 0;
//    basicAnimationL.removedOnCompletion = NO;
//    basicAnimationL.fillMode = kCAFillModeForwards;
//    [leftSubView.layer addAnimation:basicAnimationL forKey:@"scale"];
//    
//    CABasicAnimation *basicAnimationR = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    if ([rightSubView.layer animationForKey:@"scale"]) {
//        CABasicAnimation *R = (CABasicAnimation *)[rightSubView.layer animationForKey:@"scale"];
//        basicAnimationR.fromValue = R.toValue;
//    }
//    basicAnimationR.toValue = @(rightSacle * scaleTransform+1);
//    basicAnimationR.duration = 0;
//    basicAnimationR.removedOnCompletion = NO;
//    basicAnimationR.fillMode = kCAFillModeForwards;
//    [rightSubView.layer addAnimation:basicAnimationR forKey:@"scale"];
//}
//

- (void)configSubView {
    
    _totalLengthOfSubView = 0;
    
    //配置subview
    [_configModel.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //subview的约束变量
        CGFloat x, y, width, height;
        
        //创建subView (复用之前创建的内存)
        YBLevelListSubView *subView;
        if (_subViewArr.count > idx) {
            subView = _subViewArr[idx];
        } else {
            subView = [YBLevelListSubView new];
        }
        subView.tag = kConstTagOfYBLevelListSubView+idx;
        
        
        //配置标题属性
        if (_selectedIndex == idx) {
            [self configSubViewTitleOfSelected:subView width:&width];
        } else {
            [self configSubViewTitleOfUnSelected:subView width:&width];
        }
        
        
        //配置图片属性
        BOOL haveImage;
        if (_selectedIndex == idx) {
            haveImage = [self configSubViewTitleImageOfSelected:subView width:&width];
        } else {
            haveImage = [self configSubViewTitleImageOfUnSelected:subView width:&width];
        }
        
        //配置subview及其子视图 的frame
        y = 0.0;
        width = width + 2*_configModel.marginOfSubView;
        height = self.bounds.size.height;
        YBLevelListSubView *lastSubView;
        if (idx > 0 && _subViewArr.count > (idx-1)) {
            lastSubView = _subViewArr[idx-1];
            x = CGRectGetMaxX(lastSubView.frame) + _configModel.spacingOfSubView;
        } else {
            x = _configModel.spacingOfSubView;
        }
        
        
        subView.frame = CGRectMake(x, y, width, height);
        if (haveImage) {
            CGFloat titleLabelX = _configModel.spacingOfTitleAndImage + _configModel.sizeOfImageView.width+_configModel.marginOfSubView;
            subView.titleLabel.frame = CGRectMake(titleLabelX, 0, width-titleLabelX-_configModel.marginOfSubView, height);
            subView.titleImageView.frame = CGRectMake(_configModel.marginOfSubView, height/2.0-_configModel.sizeOfImageView.height/2.0, _configModel.sizeOfImageView.width, _configModel.sizeOfImageView.height);
        } else {
            subView.titleLabel.frame = CGRectMake(_configModel.marginOfSubView, 0, width-_configModel.marginOfSubView*2, height);
            subView.titleImageView.frame = CGRectZero;
        }
        
        
        //记录总长度
        _totalLengthOfSubView += width;
        
        //如果是复用以前的内存，这里不做操作
        if (!subView.superview) {
            //添加到父视图
            [self.scrollView addSubview:subView];
            //添加记录数组
            [_subViewArr addObject:subView];
            //添加手势
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapGesture:)];
            [subView addGestureRecognizer:tapGesture];
        }
        
        
    }];
    _totalLengthOfSubView += (_configModel.spacingOfSubView*(_subViewArr.count+1));
    
    
    //注意：此处-0.1操作不可少，防止cgfloat长度越界四舍五入，从而导致死循环
    if (_totalLengthOfSubView < self.bounds.size.width-0.1) {
        
        //如果总长度不能填满self.view.bounds.width
//        CGFloat DIF = self.bounds.size.width - _totalLengthOfSubView;
//        _configModel.marginOfSubView += DIF*1.0/(_subViewArr.count*1.0)/2.0;
//        [self configSubView];
        
        CGFloat DIF = self.bounds.size.width - _totalLengthOfSubView;
        _configModel.spacingOfSubView += DIF*1.0/(_subViewArr.count*1.0+1);
        [self configSubView];
        
    }
    
}

- (void)configSubViewTitleOfUnSelected:(YBLevelListSubView *)subView width:(CGFloat *)width {
    
    if (![self configSubViewTitleWithSubView:subView infoArr:_configModel.titleArr width:width]) {
        //不是富文本 设置未选择的颜色
        subView.titleLabel.textColor = _configModel.titleColorOfUnSelected;
    }
    

}
- (void)configSubViewTitleOfSelected:(YBLevelListSubView *)subView width:(CGFloat *)width {
    
    [self configSubViewTitleWithSubView:subView infoArr:_configModel.titleSelectedArr width:width];
    subView.titleLabel.textColor = _configModel.titleColorOfSelected;
    

}


//返回值为  是否是富文本 YES 为是
- (BOOL)configSubViewTitleWithSubView:(YBLevelListSubView *)subView infoArr:(NSArray<id> *)infoArr width:(CGFloat *)width {
    
    id obj;
    if (infoArr.count > (subView.tag - kConstTagOfYBLevelListSubView)) {
        obj = infoArr[subView.tag-kConstTagOfYBLevelListSubView];
    } else {
        //当前infoArr无法匹配特定tag的subview，那么默认显示titleArr里面内容
        obj = _configModel.titleArr[subView.tag-kConstTagOfYBLevelListSubView];
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *tempStr = (NSString *)obj;
        *width = [self getWidthWithText:tempStr font:_configModel.titleFont];
        subView.titleLabel.text = tempStr;
        subView.titleLabel.font = _configModel.titleFont;
    } else if ([obj isKindOfClass:[NSAttributedString class]]) {
        NSAttributedString *tempAttStr = (NSAttributedString *)obj;
        *width = [self getWidthWithAttStr:tempAttStr];
        subView.titleLabel.attributedText = tempAttStr;
        
        return YES;
    } else {
        *width = 0;
        subView.titleLabel.text = @"";
        LOGERRORMESSAGE(@"初始化参数titleArr元素 类型异常")
    }
    
    return NO;
}

- (BOOL)configSubViewTitleImageOfSelected:(YBLevelListSubView *)subView width:(CGFloat *)width {
    return [self configSubViewTitleImageWithSubView:subView infoArr:_configModel.imageInfoSelectedArr width:width];
}
- (BOOL)configSubViewTitleImageOfUnSelected:(YBLevelListSubView *)subView width:(CGFloat *)width {
    return [self configSubViewTitleImageWithSubView:subView infoArr:_configModel.imageInfoArr width:width];
}

- (BOOL)configSubViewTitleImageWithSubView:(YBLevelListSubView *)subView infoArr:(NSArray<id> *)infoArr width:(CGFloat *)width {
    
    NSInteger idx = subView.tag - kConstTagOfYBLevelListSubView;
    
    id tempObj;
    
    
    if (infoArr.count > idx) {
        
        tempObj = infoArr[idx];
    }
    
    BOOL haveImage = [self configImage:subView tempObj:tempObj];
    
    
    if (haveImage) {
        *width = *width + _configModel.spacingOfTitleAndImage + _configModel.sizeOfImageView.width;
    } else {
        
        //图片去除
        subView.titleImageView.image = nil;
    }
    
    return haveImage;
}
- (BOOL)configImage:(YBLevelListSubView *)subView tempObj:(id)tempObj {
    if (!tempObj) {
        return NO;
    } else if ([tempObj isKindOfClass:[NSString class]]) {
        NSString *tempStr = (NSString *)tempObj;
        if ([self isEmpty:tempStr]) {
            LOGERRORMESSAGE(@"初始化参数imageInfoArr元素 无效字符串")
            return NO;
        } else if ([tempStr containsString:@"http://"]||[tempStr containsString:@"https://"]) {
            [subView.titleImageView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
        } else {
            subView.titleImageView.image = [UIImage imageNamed:tempStr];
        }
    } else if ([tempObj isKindOfClass:[UIImage class]]) {
        subView.titleImageView.image = (UIImage *)tempObj;
    } else if ([tempObj isKindOfClass:[NSURL class]]) {
        [subView.titleImageView sd_setImageWithURL:(NSURL *)tempObj];
    } else {
        LOGERRORMESSAGE(@"初始化参数imageInfoArr元素 类型异常")
        return NO;
    }
    
    return YES;
}


#pragma mark *** initialize other ***
- (void)initializeProperty {
    _subViewArr = [@[] mutableCopy];
    _selectedIndex = 0;
}
- (void)initializeScrollView {
    //配置滚动视图
    self.scrollView.backgroundColor = _configModel.backColor;
    if (!self.scrollView.superview) {
        [self addSubview:self.scrollView];
    }
}
- (void)initializeUnderLineView {
    //配置默认底线
    self.underLineView.frame = CGRectMake(0, self.bounds.size.height-_configModel.heightOfUnderLineView, self.bounds.size.width, _configModel.heightOfUnderLineView);
    self.underLineView.backgroundColor = _configModel.underLineViewColor;
    if (!self.underLineView.superview) {
        [self addSubview:self.underLineView];
    }
}
- (void)setupStartColor:(UIColor *)color
{
    CGFloat components[3];
    
    [self getRGBComponents:components forColor:color];
    
    _startR = components[0];
    _startG = components[1];
    _startB = components[2];
}

- (void)setupEndColor:(UIColor *)color
{
    CGFloat components[3];
    
    [self getRGBComponents:components forColor:color];
    
    _endR = components[0];
    _endG = components[1];
    _endB = components[2];
}

#pragma mark *** logic ***

- (void)scrollSelectedViewToCenter {
    
    YBLevelListSubView *subView = _subViewArr[_selectedIndex];
        
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = subView.center.x - self.bounds.size.width * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.bounds.size.width;
    
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 滚动区域
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

- (void)removeSubViewOfSuperfluous {
    //更新了UI去掉多余的subview
    if (_configModel.titleArr.count < _subViewArr.count) {
        [_subViewArr enumerateObjectsUsingBlock:^(YBLevelListSubView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= _configModel.titleArr.count) {
                //从父视图移除
                [obj removeFromSuperview];
                obj = nil;
            }
        }];
        //从数组里面移除
        [_subViewArr removeObjectsInRange:NSMakeRange(_configModel.titleArr.count, _subViewArr.count-_configModel.titleArr.count)];
    }
}

//判断图片数据是否有效
- (BOOL)judgeWhetherHaveImage:(id)tempObj {
    if (!tempObj) {
        return NO;
    } else if ([tempObj isKindOfClass:[NSString class]]) {
        
        NSString *tempStr = (NSString *)tempObj;
        if ([self isEmpty:tempStr]) {
            LOGERRORMESSAGE(@"初始化参数imageInfoArr元素 无效字符串")
            return NO;
            
        } else if ([tempStr containsString:@"http://"]||[tempStr containsString:@"https://"]) {
            
        } else {
            
        }
    } else if ([tempObj isKindOfClass:[UIImage class]]) {
        
    } else if ([tempObj isKindOfClass:[NSURL class]]) {
        
    } else {
        LOGERRORMESSAGE(@"初始化参数imageInfoArr元素 类型异常")
        return NO;
    }
    
    return YES;
}

#pragma mark *** UIScrollViewDelegate ***
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark *** getter ***
- (UIView *)underLineView {
    if (!_underLineView) {
        _underLineView = [UIView new];
    }
    return _underLineView;
}
- (UIView *)underLineSelectView {
    if (!_underLineSelectView) {
        _underLineSelectView = [UIView new];
    }
    return _underLineSelectView;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = self.bounds;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        
        
    }
    return _scrollView;
}










#pragma mark *** tool ***
- (CGFloat)getWidthWithText:(NSString *)text font:(UIFont *)font {
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
}

- (CGFloat)getWidthWithAttStr:(NSAttributedString *)attStr {
    return [attStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
}
- (BOOL)isEmpty:(NSString *)string
{
    NSString *toString = [NSString stringWithFormat:@"%@",string];
    if (toString == nil || toString == NULL) {
        return YES;
    }
    
    if ([toString isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([toString isEqualToString:@""]) {
        return YES;
    }
    
    if ([toString isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([toString isEqualToString:@"null"]) {
        return YES;
    }
    
    if ([toString isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([toString stringByReplacingOccurrencesOfString:@" " withString:@""].length<=0) {
        return YES;
    }
    
    return NO;
}


/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}






@end
