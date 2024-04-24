//
//  FLYFilterDeviceView.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYFilterDeviceView.h"
#import "FLYFilterDeviceButton.h"

@interface FLYFilterDeviceView ()

@property (nonatomic, strong) UILabel * addressLabel;

@property (nonatomic, strong) NSMutableArray * btnArray;

@end

@implementation FLYFilterDeviceView

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
    
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = COLORHEX(@"#F9F9F9");
    
    [self initButtons];
    [self initAddressView];
}

- (void)initButtons
{
    __block NSInteger selectIndex = 0;
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ( button.selected )
        {
            selectIndex = button.tag;
        }
        
        [button removeFromSuperview];
    }];
    [self.btnArray removeAllObjects];
    
    
    
    //边距
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(16, 5, 0, 5);
    //列数
    NSInteger column = 5;
    //按钮之间的间距
    CGFloat spacing = 0;
    //按钮上下之间的间距
    CGFloat upAndDownSpacing = 15;
    //按钮的高度
    CGFloat height = 52;
    //按钮宽度
    CGFloat width = (SCREEN_WIDTH - spacing * (column - 1) - edgeInsets.left - edgeInsets.right ) / column;
    
    
    for ( int i = 0; i < self.deviceStatusList.count; i++ )
    {
        FLYDeviceStatusModel * model = self.deviceStatusList[i];
                
        FLYFilterDeviceButton * button = [FLYFilterDeviceButton buttonWithImage:IMAGENAME(([NSString stringWithFormat:@"%@_n", model.name])) title:model.name titleColor:COLORHEX(@"#666666") font:FONT_R(12)];
        [button setTitleColor:COLORHEX(@"#2BB9A0") forState:(UIControlStateSelected)];
        [button setImage:IMAGENAME(([NSString stringWithFormat:@"%@_s", model.name])) forState:UIControlStateSelected];
        [button setTitleFont:FONT_R(12) forState:(UIControlStateNormal)];
        [button setTitleFont:FONT_M(12) forState:(UIControlStateSelected)];
        button.tag = i;
        button.newStatus = [model.warningCount integerValue] > 0 ? YES : NO;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
        [self.btnArray addObject:button];

        if ( i == selectIndex )
        {
            button.selected = YES;
        }
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(width, height));
            
            CGFloat x = (i % column) * width + (i % column) * spacing + edgeInsets.left;
            make.left.equalTo(self).with.offset(x);
            
            
            CGFloat y = (i / column) * (height + upAndDownSpacing) + edgeInsets.top;
            make.top.equalTo(self).with.offset(y);
            
            if ( i == self.deviceStatusList.count - 1 )
            {
                make.bottom.mas_equalTo(self).with.offset(-84);
            }
        }];
        
    }

}

- (void)initAddressView
{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,-3);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 9;
    view.layer.cornerRadius = 24;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(24);
        make.height.mas_equalTo(60 + 24);
    }];
    
    
    [view addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(20);
        make.centerX.equalTo(view);
        make.height.mas_equalTo(14);
    }];

    
    UIView * colorView = [[UIView alloc] init];
    colorView.backgroundColor = [UIColor colorWithRed:43/255.0 green:185/255.0 blue:160/255.0 alpha:0.2];
    colorView.layer.cornerRadius = 3.7;
    [view addSubview:colorView];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_top).with.offset(11);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(100, 7.5));
    }];
}



#pragma mark - event handler

- (void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( btn != button )
        {
            btn.selected = NO;
        }
    }];
    
    
    FLYDeviceStatusModel * model = self.deviceStatusList[button.tag];
    !self.selectBlock ?: self.selectBlock(button.selected ? model.idField : @"");
}



#pragma mark - setters and getters

-(void)setDeviceStatusList:(NSArray<FLYDeviceStatusModel *> *)deviceStatusList
{
    _deviceStatusList = deviceStatusList;
    
    [self initButtons];
}

-(void)setAddress:(NSString *)address
{
    _address = address;
    
    self.addressLabel.text = address;
}

-(NSMutableArray *)btnArray
{
    if ( _btnArray == nil )
    {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

-(UILabel *)addressLabel
{
    if ( _addressLabel == nil )
    {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = COLORHEX(@"#333333");
        _addressLabel.font = FONT_S(14);
        _addressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addressLabel;
}

@end
