//
//  FLYFilterItemView.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYFilterItemView.h"
#import "FLYButton.h"

@interface FLYFilterItemView ()

@property (nonatomic, strong) NSMutableArray * btnArray;

@property (nonatomic, strong) UIButton * resetBtn;
@property (nonatomic, strong) UIButton * confirmBtn;

//选中的model
@property (nonatomic, strong) NSMutableArray * selectModels;

@end

@implementation FLYFilterItemView

- (instancetype)initWithFrame:(CGRect)frame
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
    
    
    UIButton * button = self.btnArray.lastObject;
    
    [self.resetBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).with.offset(20);
        make.left.equalTo(self);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(SCREEN_WIDTH / 2.0);
    }];
    
    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).with.offset(20);
        make.right.equalTo(self);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(SCREEN_WIDTH / 2.0);
    }];
    
    
    self.height = CGRectGetMaxY(self.resetBtn.frame);
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.resetBtn];
    [self addSubview:self.confirmBtn];
}



#pragma mark -event handler

- (void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    if ( self.multiple == YES )
    {
        if ( button.selected )
        {
            [self.selectModels addObject:self.itemModels[button.tag]];
        }
        else
        {
            [self.selectModels removeObject:self.itemModels[button.tag]];
        }
    }
    else
    {
        [self.btnArray enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( btn != button )
            {
                btn.selected = NO;
            }
        }];
        
        
        [self.selectModels removeAllObjects];
        
        if (button.selected )
        {
            [self.selectModels addObject:self.itemModels[button.tag]];
        }
    }
}

//重置
- (void)resetClick:(UIButton *)button
{
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL * _Nonnull stop) {
        btn.selected = NO;
    }];
    [self.selectModels removeAllObjects];
    
    
    
    //默认选中第一个“全部”
    UIButton * itemBtn = self.btnArray.firstObject;
    itemBtn.selected = YES;
    self.selectModels = @[self.itemModels.firstObject].mutableCopy;
    
}

//确认
- (void)confirmClick:(UIButton *)button
{
    //如果没选，就默认选中第一个“全部”
    if( self.selectModels.count == 0 )
    {
        self.selectModels = @[self.itemModels.firstObject].mutableCopy;
    }
    
    !self.confirmBlock ?: self.confirmBlock(self.selectModels);
}



#pragma mark - setters and getters

-(void)setItemModels:(NSArray<FLYKeyValueModel *> *)itemModels
{
    _itemModels = itemModels;
    
    
    //边距
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(15, 17, 0, 17);
    //列数
    NSInteger column = 3;
    //按钮之间的间距
    CGFloat spacing = 10;
    //按钮上下之间的间距
    CGFloat upAndDownSpacing = 10;
    //按钮的高度
    CGFloat height = 26;
    //按钮宽度
    CGFloat width = (SCREEN_WIDTH - spacing * (column - 1) - edgeInsets.left - edgeInsets.right ) / column;

    
    for ( int i = 0; i < itemModels.count; i++ )
    {
        FLYKeyValueModel * model = itemModels[i];
        FLYButton * button = [FLYButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.value forState:(UIControlStateNormal)];
        [button setTitleColor:COLORHEX(@"#666666") forState:UIControlStateNormal];
        [button setTitleColor:COLORHEX(@"#2BB9A0") forState:UIControlStateSelected];
        [button setTitleFont:FONT_R(11) forState:UIControlStateNormal];
        [button setTitleFont:FONT_M(11) forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor colorWithHexString:@"#EBEBEB" alpha:0.06] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithHexString:@"#2BB9A0" alpha:0.06] forState:UIControlStateSelected];
        [button setBorderColor:COLORHEX(@"#EBEBEB") forState:UIControlStateNormal];
        [button setBorderColor:COLORHEX(@"#2BB9A0") forState:UIControlStateSelected];
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 4;
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
        [self.btnArray addObject:button];
        
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        
            make.size.mas_equalTo(CGSizeMake(width, height));
            
            CGFloat x = (i % column) * width + (i % column) * spacing + edgeInsets.left;
            make.left.equalTo(self).with.offset(x);
            
            
            CGFloat y = (i / column) * (height + upAndDownSpacing) + edgeInsets.top;
            make.top.equalTo(self).with.offset(y);
        }];
    }

}

-(NSMutableArray *)btnArray
{
    if ( _btnArray == nil )
    {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

-(UIButton *)resetBtn
{
    if ( _resetBtn == nil )
    {
        _resetBtn = [UIButton buttonWithTitle:@"重置" titleColor:COLORHEX(@"#333333") font:FONT_R(13)];
        _resetBtn.backgroundColor = [UIColor whiteColor];
        [_resetBtn addTarget:self action:@selector(resetClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        CALayer * layer = [CALayer layer];
        layer.backgroundColor = COLORHEX(@"#EBEBEB").CGColor;
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2.0, 0.5);
        [_resetBtn.layer addSublayer:layer];
    }
    return _resetBtn;
}

-(UIButton *)confirmBtn
{
    if ( _confirmBtn == nil )
    {
        _confirmBtn = [UIButton buttonWithTitle:@"确认" titleColor:[UIColor whiteColor] font:FONT_M(13)];
        _confirmBtn.backgroundColor = COLORHEX(@"#2BB9A0");
        [_confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmBtn;
}

-(NSMutableArray *)selectModels
{
    if ( _selectModels == nil )
    {
        _selectModels = [NSMutableArray array];
    }
    return _selectModels;
}


@end

