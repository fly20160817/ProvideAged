//
//  FLYPhysiologicalChartView.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYPhysiologicalChartView.h"
#import "UIView+FLYLayer.h"
#import "FLYLineChartView.h"

@interface FLYPhysiologicalChartView ()

@property (nonatomic, strong) FLYButton * weekBtn;
@property (nonatomic, strong) FLYButton * monthBtn;
@property (nonatomic, strong) UILabel * unitLabel;
@property (nonatomic, strong) FLYLineChartView * chartView;

@end

@implementation FLYPhysiologicalChartView

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
    
    [self roundCorner:20 rectCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    [self.weekBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(18);
        make.right.equalTo(self.mas_centerX).with.offset(-2.5);
        make.size.mas_equalTo(CGSizeMake(50, 24));
    }];
    
    [self.monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(18);
        make.left.equalTo(self.mas_centerX).with.offset(2.5);
        make.size.mas_equalTo(CGSizeMake(50, 24));
    }];
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weekBtn.mas_bottom).with.offset(5);
        make.left.equalTo(self).with.offset(20);
        make.bottom.equalTo(self).with.offset(-20);
        make.right.equalTo(self).with.offset(-20);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chartView.mas_top).with.offset(-10);
        make.left.equalTo(self.chartView);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,3);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 12;
    
    
    [self addSubview:self.weekBtn];
    [self addSubview:self.monthBtn];
    [self addSubview:self.chartView];
    [self addSubview:self.unitLabel];
    
}



#pragma mark - event handler

- (void)weekClick:(UIButton *)button
{
    button.selected = YES;
    
    self.monthBtn.selected = NO;
    
    !self.weekBlock ?: self.weekBlock();
}

- (void)monthClick:(UIButton *)button
{
    button.selected = YES;
    
    self.weekBtn.selected = NO;
    
    !self.monthBlock ?: self.monthBlock();
}



#pragma mark - setters and getters

-(void)setHealthModel:(FLYHealthModel *)healthModel
{
    _healthModel = healthModel;
    
    self.unitLabel.text = healthModel.unit;
    
    if (healthModel.status == 1 )
    {
        [self.weekBtn setBackgroundColor:COLORHEX(@"#2BB9A0") forState:(UIControlStateSelected)];
        self.weekBtn.selected = YES;
        [self.monthBtn setBackgroundColor:COLORHEX(@"#2BB9A0") forState:(UIControlStateSelected)];
        self.unitLabel.textColor = COLORHEX(@"#2BB9A0");
        self.chartView.styleColor = COLORHEX(@"#2BB9A0");
    }
    else if (healthModel.status == 2 )
    {
        [self.weekBtn setBackgroundColor:COLORHEX(@"#5F96F1") forState:(UIControlStateSelected)];
        self.weekBtn.selected = YES;
        [self.monthBtn setBackgroundColor:COLORHEX(@"#5F96F1") forState:(UIControlStateSelected)];
        self.unitLabel.textColor = COLORHEX(@"#5F96F1");
        self.chartView.styleColor = COLORHEX(@"#5F96F1");
    }
    else if (healthModel.status == 3 )
    {
        [self.weekBtn setBackgroundColor:COLORHEX(@"#DD6E6F") forState:(UIControlStateSelected)];
        self.weekBtn.selected = YES;
        [self.monthBtn setBackgroundColor:COLORHEX(@"#DD6E6F") forState:(UIControlStateSelected)];
        self.unitLabel.textColor = COLORHEX(@"#DD6E6F");
        self.chartView.styleColor = COLORHEX(@"#DD6E6F");
    }
}

-(void)setHealthModels:(NSArray<FLYHealthModel *> *)healthModels
{
    _healthModels = healthModels;
    
    self.unitLabel.hidden = healthModels.count == 0 ? YES : NO;
    
    self.chartView.healthModels = healthModels;
}

-(FLYButton *)weekBtn
{
    if ( _weekBtn == nil )
    {
        _weekBtn = [FLYButton buttonWithTitle:@"周" titleColor:COLORHEX(@"#333333") font:FONT_R(13)];
        [_weekBtn setBackgroundColor:COLORHEX(@"#FFFFFF") forState:(UIControlStateNormal)];
        [_weekBtn setBackgroundColor:COLORHEX(@"#2BB9A0") forState:(UIControlStateSelected)];
        [_weekBtn setTitleColor:COLORHEX(@"#333333") forState:UIControlStateNormal];
        [_weekBtn setTitleColor:COLORHEX(@"FFFFFF") forState:UIControlStateSelected];
        _weekBtn.layer.cornerRadius = 12;
        _weekBtn.selected = YES;
        [_weekBtn addTarget:self action:@selector(weekClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _weekBtn;
}

-(FLYButton *)monthBtn
{
    if ( _monthBtn == nil )
    {
        _monthBtn = [FLYButton buttonWithTitle:@"月" titleColor:COLORHEX(@"#333333") font:FONT_R(13)];
        [_monthBtn setBackgroundColor:COLORHEX(@"#FFFFFF") forState:(UIControlStateNormal)];
        [_monthBtn setBackgroundColor:COLORHEX(@"#2BB9A0") forState:(UIControlStateSelected)];
        [_monthBtn setTitleColor:COLORHEX(@"#333333") forState:UIControlStateNormal];
        [_monthBtn setTitleColor:COLORHEX(@"FFFFFF") forState:UIControlStateSelected];
        _monthBtn.layer.cornerRadius = 12;
        [_monthBtn addTarget:self action:@selector(monthClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _monthBtn;
}

-(UILabel *)unitLabel
{
    if ( _unitLabel == nil )
    {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = FONT_R(13);
        _unitLabel.textColor = COLORHEX(@"#2BB9A0");
        _unitLabel.hidden = YES;
    }
    return _unitLabel;
}

-(FLYLineChartView *)chartView
{
    if ( _chartView == nil )
    {
        _chartView = [[FLYLineChartView alloc] init];
    }
    return _chartView;
}

@end
