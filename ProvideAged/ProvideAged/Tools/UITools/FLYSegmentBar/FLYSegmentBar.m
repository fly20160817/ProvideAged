//
//  FLYSegmentBar.m
//  FLYSegmentBar_Example
//
//  Created by fly on 2020/3/11.
//  Copyright © 2020 fly20160817. All rights reserved.
//

#import "FLYSegmentBar.h"
#import "FLYButton.h"

@interface FLYSegmentBar ()
{
    FLYSegmentBarConfig * _config;
    
    BOOL _isFrist;
}
@property (nonatomic, strong) UIScrollView * contentView;
@property (nonatomic, strong) UIView * indicatorView;//指示器（线）

@property (nonatomic, strong) NSMutableArray * itemBtns;
@property (nonatomic, strong) UIButton * lastItem;//存放上一次点击按钮

@end

@implementation FLYSegmentBar

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
     
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.itemBtns.count == 0)
    {
        return;
    }
    
    
    //默认选中 (默认选中只执行一次)
    //(创建的时候没有设置默认选中，因为那时候外界可能还没设置代理，所以在这里设置)
    //（如果外界给selectIndex赋了值，这里选中的就是外界设置的；如果外界没赋值，选中的就是第0个）
    if ( _isFrist == NO )
    {
        _isFrist = YES;
        [self titleClick:self.itemBtns[self.selectIndex]];
    }
    
    
    CGFloat totalBtnWidth = 0;
    totalBtnWidth += self.config.leftMargin;
    
    for (int i = 0; i < self.itemBtns.count; i++ )
    {
        UIButton * button = self.itemBtns[i];
        if ( self.splitEqually == YES )
        {
            CGFloat btnWith = (self.width - self.config.leftMargin - self.config.rightMargin) / self.itemBtns.count;
            button.frame = CGRectMake(btnWith * i + self.config.leftMargin, 0, btnWith, self.height);
            totalBtnWidth += button.width;
        }
        else
        {
            [button sizeToFit];
            button.x = totalBtnWidth;
            button.y = 0;
            button.height = self.height;
            //sizeToFit之后按钮的宽度是紧包着里面的文字，按钮和按钮之间贴在一起，这里增加每个按钮的宽度，让按钮之间有距离感。(itemSpaceWidth是一个按钮左右两边留白的总和)
            button.width += self.config.itemSpaceWidth;
            totalBtnWidth += button.width;
        }
    }
    
    totalBtnWidth += self.config.rightMargin;
    
    self.contentView.frame = self.bounds;
    self.contentView.contentSize = CGSizeMake(totalBtnWidth, 0);
    [self.contentView bringSubviewToFront:self.indicatorView];
    
    
    
    UIButton * button = self.itemBtns[self.selectIndex];
    self.indicatorView.width = self.config.indicatorWidth == FLYSegmentBarIndicatorAutomaticWidth ? button.width : self.config.indicatorWidth;
    self.indicatorView.centerX = button.centerX;
    self.indicatorView.height = self.config.indicatorHeight;
    self.indicatorView.y = self.height - self.indicatorView.height;
}



#pragma mark - UI

- (void)initUI
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.indicatorView];
}



#pragma mark - event handler

- (void)titleClick:(UIButton *)button
{
    if ( [self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:fromIndex:)] )
    {
        [self.delegate segmentBar:self didSelectIndex:button.tag fromIndex:self.lastItem.tag];
    }
        
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
    
    
    //可能按钮点击状态下的字体很大，导致显示不全，所以要重新计算大小
    //self.window如果有值，说明view已经展示在页面上了，所以执行下面的刷新布局；如果window没值，说明view还没展示出来，后面系统自会调用刷新布局，不用我们自己去调了。
    if ( self.window )
    {
        [self setNeedsLayout];
        [self layoutIfNeeded];
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
    
    
    //删除之前添加过的按钮
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

}

-(void)setConfig:(FLYSegmentBarConfig *)config
{
    _config = config;
    
    self.backgroundColor = config.segmentBarBackColor;
    self.indicatorView.backgroundColor = config.indicatorColor;
    self.indicatorView.layer.cornerRadius = config.indicatorCornerRadius;
    self.indicatorView.hidden = config.hiddenIndicator;
    
    for (FLYButton * button in self.itemBtns)
    {
        [button setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
        [button setTitleColor:config.itemSelectColor forState:UIControlStateSelected];
        [button setTitleFont:config.itemNormalFont forState:UIControlStateNormal];
        [button setTitleFont:config.itemSelectFont forState:UIControlStateSelected];
    }
}

- (FLYSegmentBarConfig *)config
{
    if (!_config)
    {
        _config = [FLYSegmentBarConfig defaultConfig];
    }
    return _config;
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

@end

