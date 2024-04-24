//
//  FLYDeviceSegmentBar.m
//  FLYSegmentBar_Example
//
//  Created by fly on 2020/3/11.
//  Copyright © 2020 fly20160817. All rights reserved.
//

#import "FLYDeviceSegmentBar.h"
#import "FLYButton.h"

//按钮之间的空白距离（kSpaceWidth是一个按钮左右两边留白的总和）
#define kSpaceWidth 60

@interface FLYDeviceSegmentBar ()
{
    FLYSegmentBarConfig * _config;
}
@property (nonatomic, strong) UIScrollView * contentView;
@property (nonatomic, strong) UIView * indicatorView;//指示器（线）

@property (nonatomic, strong) NSMutableArray * itemBtns;
@property (nonatomic, strong) UIButton * lastItem;//存放上一次点击按钮

@property (nonatomic, strong) UIView * lineView;

@end

@implementation FLYDeviceSegmentBar

-(instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titleNames
{
    self = [self initWithFrame:frame];
    
    self.titleNames = titleNames;
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        //不写在自定义方法里是为了实现两个初始化方法都可以执行
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat totalBtnWidth = 0;
    for (int i = 0; i < self.itemBtns.count; i++ )
    {
        UIButton * button = self.itemBtns[i];
        if ( self.splitEqually == YES )
        {
            CGFloat btnWith = self.width / self.itemBtns.count;
            button.frame = CGRectMake(btnWith * i, 0, btnWith, self.height);
            totalBtnWidth += button.width;
        }
        else
        {
            [button sizeToFit];
            button.x = totalBtnWidth;
            button.y = 0;
            button.height = self.height;
            //sizeToFit之后按钮的宽度是紧包着里面的文字，按钮和按钮之间贴在一起，这里增加每个按钮的宽度，让按钮之间有距离感。(kSpaceWidth是一个按钮左右两边留白的总和)
            button.width += kSpaceWidth;
            totalBtnWidth += button.width;
        }
    }
    
    self.contentView.frame = self.bounds;
    self.contentView.contentSize = CGSizeMake(totalBtnWidth, 0);
    [self.contentView bringSubviewToFront:self.indicatorView];
    
    
    
    if (self.itemBtns.count == 0)
    {
        return;
    }
    
    //默认选中第一个
    if (self.lastItem == nil)
    {
        self.selectIndex = 0;
    }
    UIButton * button = self.itemBtns[self.selectIndex];
    self.indicatorView.width = self.config.indicatorWidth == FLYSegmentBarIndicatorAutomaticWidth ? button.width : self.config.indicatorWidth;
    self.indicatorView.centerX = button.centerX;
    self.indicatorView.height = self.config.indicatorHeight;
    self.indicatorView.y = self.height - self.indicatorView.height;
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}



#pragma mark - UI

- (void)initUI
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.indicatorView];
    
    [self addSubview:self.lineView];
}



#pragma mark - event handler

- (void)titleClick:(UIButton *)button
{
    self.selectIndex = button.tag;
}



#pragma mark - private methods

- (void)setSelectIndex:(NSInteger)selectIndex
{
    // 数据过滤
    if ( selectIndex < 0 || selectIndex >= self.itemBtns.count )
    {
        return;
    }
    
    _selectIndex = selectIndex;

    
    UIButton * button = self.itemBtns[selectIndex];
    
    self.lastItem.selected = NO;
    button.selected = YES;
    self.lastItem = button;
    
    [self buttonMoveToMiddle:button];
    [self indicatorMoveToMiddle:button];
    
    
    if ( [self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:fromIndex:)] )
    {
        [self.delegate segmentBar:self didSelectIndex:button.tag fromIndex:self.lastItem.tag];
    }
}

//让点击的按钮保持在中间的位置
- (void)buttonMoveToMiddle:(UIButton *)button
{
    CGFloat scrollX = button.centerX - self.width * 0.5;
    
    if (scrollX <= 0 || self.contentView.contentSize.width <= self.width)
    {
        scrollX = 0;
    }
    else if (scrollX > self.contentView.contentSize.width - self.width)
    {
        scrollX = self.contentView.contentSize.width - self.width;
    }

    [self.contentView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
}

//移动线的位置
- (void)indicatorMoveToMiddle:(UIButton *)button
{
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = self.config.indicatorWidth == FLYSegmentBarIndicatorAutomaticWidth ? button.width : self.config.indicatorWidth;
        self.indicatorView.centerX = button.centerX;
    }];
}



#pragma mark - setters and getters

-(void)setTitleNames:(NSArray *)titleNames
{
    _titleNames = titleNames;
    
    
    //删除之前添加过多额组件
    [self.itemBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemBtns removeAllObjects];
    self.lastItem = nil;
    
    
    for ( NSInteger i = 0; i < titleNames.count; i++ )
    {
        FLYButton * titleBtn = [FLYButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitle:titleNames[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.config.itemSelectColor forState:UIControlStateSelected];
        [titleBtn setTitleFont:self.config.itemNormalFont forState:UIControlStateNormal];
        [titleBtn setTitleFont:self.config.itemSelectFont forState:UIControlStateSelected];
        
        titleBtn.tag = i;
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:titleBtn];
        [self.itemBtns addObject:titleBtn];
    }
    
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)setSplitEqually:(BOOL)splitEqually
{
    _splitEqually = splitEqually;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(NSMutableArray *)itemBtns
{
    if ( _itemBtns == nil )
    {
        _itemBtns = [NSMutableArray new];
    }
    return _itemBtns;
}

-(UIScrollView *)contentView
{
    if ( _contentView == nil )
    {
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.bounces = NO;
    }
    return _contentView;
}

-(UIView *)indicatorView
{
    if ( _indicatorView == nil )
    {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = [UIColor redColor];
    }
    return _indicatorView;
}

-(void)setConfig:(FLYSegmentBarConfig *)config
{
    _config = config;
    
    self.backgroundColor = config.segmentBarBackColor;
    self.indicatorView.backgroundColor = config.indicatorColor;
    
    for (FLYButton * button in self.itemBtns)
    {
        [button setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
        [button setTitleColor:config.itemSelectColor forState:UIControlStateSelected];
        [button setTitleFont:config.itemNormalFont forState:UIControlStateNormal];
        [button setTitleFont:config.itemSelectFont forState:UIControlStateSelected];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (FLYSegmentBarConfig *)config
{
    if (!_config)
    {
        _config = [FLYSegmentBarConfig defaultConfig];
    }
    return _config;
}

-(UIView *)lineView
{
    if ( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORHEX(@"#F1F1F1");
    }
    return _lineView;
}

@end
