//
//  FLYPhysiologicalCircleView.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYPhysiologicalCircleView.h"
#import "UIButton+FLYExtension.h"
#import "FLYButton.h"

@interface FLYPhysiologicalCircleView ()

@property (nonatomic, strong) UILabel * normalValueTLabel;
@property (nonatomic, strong) UILabel * normalValueCLabel;
@property (nonatomic, strong) UILabel * normalValueC2Label;
@property (nonatomic, strong) FLYButton * historyBtn;
@property (nonatomic, strong) UIView * circleView;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * valueLabel;
@property (nonatomic, strong) UILabel * unitLabel;
@property (nonatomic, strong) UILabel * timeLabel;

@end

@implementation FLYPhysiologicalCircleView

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
    
    
    [self.normalValueTLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(self.normalValueC2Label.text.length == 0 ? 26 : 10);
        make.left.equalTo(self).with.offset(20);
    }];
    
    [self.normalValueCLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.normalValueTLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self).with.offset(20);
    }];
    
    [self.normalValueC2Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.normalValueCLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self).with.offset(20);
    }];
    
    [self.historyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(34);
        make.right.equalTo(self).with.offset(-10);
        make.width.mas_equalTo(80);
    }];
    
    [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(75);
        make.size.mas_equalTo(CGSizeMake(174, 174));
        make.centerX.equalTo(self);
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.mas_top).with.offset(47);
        make.centerX.equalTo(self);
    }];
    
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.circleView.mas_centerY).with.offset(6);
        make.centerX.equalTo(self);
    }];
    
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.circleView.mas_bottom).with.offset(-43);
        make.centerX.equalTo(self);
    }];
    
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.mas_bottom).with.offset(20);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(128, 26));
    }];
}



#pragma mark - UI

- (void)initUI
{
    [self addSubview:self.normalValueTLabel];
    [self addSubview:self.normalValueCLabel];
    [self addSubview:self.normalValueC2Label];
    [self addSubview:self.historyBtn];
    [self addSubview:self.circleView];
    [self addSubview:self.statusLabel];
    [self addSubview:self.valueLabel];
    [self addSubview:self.unitLabel];
    [self addSubview:self.timeLabel];
    
    
    self.backgroundColor = COLORHEX(@"#2BB9A0");
}



#pragma mark - event handler

- (void)historyClick:(UIButton *)button
{
    !self.historyBlock ?: self.historyBlock();
}



#pragma mark - setters and getters

- (void)setHealthModel:(FLYHealthModel *)healthModel
{
    _healthModel = healthModel;
    
    self.unitLabel.text = healthModel.unit;
    self.timeLabel.text = healthModel.createTime;
    
    if ( healthModel.status == 1 )
    {
        self.backgroundColor = COLORHEX(@"#2BB9A0");
        self.timeLabel.textColor = COLORHEX(@"#2BB9A0");
        self.statusLabel.text = @"正常";
    }
    else if ( healthModel.status == 2 )
    {
        self.backgroundColor = COLORHEX(@"#5F96F1");
        self.timeLabel.textColor = COLORHEX(@"#5F96F1");
        self.statusLabel.text = @"偏低";
    }
    else if ( healthModel.status == 3 )
    {
        self.backgroundColor = COLORHEX(@"#DD6E6F");
        self.timeLabel.textColor = COLORHEX(@"#DD6E6F");
        self.statusLabel.text = @"偏高";
    }
    
    
    if ( healthModel.healthType == 6 )
    {
        self.valueLabel.text = [NSString stringWithFormat:@"%@/%@", healthModel.healthValue2, healthModel.healthValue];
    }
    else
    {
        self.valueLabel.text = healthModel.healthValue;
    }
        
    
    switch ( healthModel.healthType )
    {
        case 1:
        {
            self.normalValueCLabel.text = @"60bpm-100bpm";
        }
            break;
            
        case 2:
        {
            self.normalValueCLabel.text = @"13次/分-20次/分";
        }
            break;
            
        case 3:
        {
            self.normalValueCLabel.text = @"空腹：3.92～6.16mmol/L";
            self.normalValueC2Label.text = @"餐后：5.1~7.0mmol/L";
        }
            break;
            
        case 4:
        {
            self.normalValueCLabel.text = @"36.0℃-37.7℃";
        }
            break;
            
        case 5:
        {
            self.normalValueCLabel.text = @"95SpO-100SpO";
        }
            break;
            
        case 6:
        {
            self.normalValueCLabel.text = @"收缩压90mmHg-140mmHg";
            self.normalValueC2Label.text = @"舒张压60mmHg-90mmHg";
        }
            break;
            
        default:
            break;
    }
    
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UILabel *)normalValueTLabel
{
    if( _normalValueTLabel == nil )
    {
        _normalValueTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _normalValueTLabel.font = FONT_R(13);
        _normalValueTLabel.textColor = COLORHEX(@"#FFFFFF");
        _normalValueTLabel.text = @"正常值范围";
    }
    return _normalValueTLabel;
}

- (UILabel *)normalValueCLabel
{
    if( _normalValueCLabel == nil )
    {
        _normalValueCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _normalValueCLabel.font = FONT_R(13);
        _normalValueCLabel.textColor = COLORHEX(@"#FFFFFF");
    }
    return _normalValueCLabel;
}

- (UILabel *)normalValueC2Label
{
    if( _normalValueC2Label == nil )
    {
        _normalValueC2Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _normalValueC2Label.font = FONT_R(13);
        _normalValueC2Label.textColor = COLORHEX(@"#FFFFFF");
    }
    return _normalValueC2Label;
}

- (FLYButton *)historyBtn
{
    if( _historyBtn == nil )
    {
        _historyBtn = [FLYButton buttonWithImage:IMAGENAME(@"xiaoshizhong_16") title:@"历史数据" titleColor:COLORHEX(@"#FFFFFF") font:FONT_R(13)];
        [_historyBtn setImagePosition:(FLYImagePositionLeft) spacing:4];
        [_historyBtn addTarget:self action:@selector(historyClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _historyBtn;
}

- (UIView *)circleView
{
    if( _circleView == nil )
    {
        _circleView = [[UIView alloc] init];
        _circleView.backgroundColor = [UIColor clearColor];
        _circleView.layer.borderWidth = 13;
        _circleView.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.8].CGColor;
        _circleView.layer.cornerRadius = 174.0 / 2.0;
    }
    return _circleView;
}

- (UILabel *)statusLabel
{
    if( _statusLabel == nil )
    {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = FONT_M(15);
        _statusLabel.textColor = COLORHEX(@"#FFFFFF");
        _statusLabel.text = @"--";
    }
    return _statusLabel;
}

- (UILabel *)valueLabel
{
    if( _valueLabel == nil )
    {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.font = FONT_M(35);
        _valueLabel.textColor = COLORHEX(@"#FFFFFF");
        _valueLabel.text = @"--";
    }
    return _valueLabel;
}

- (UILabel *)unitLabel
{
    if( _unitLabel == nil )
    {
        _unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unitLabel.font = FONT_M(15);
        _unitLabel.textColor = COLORHEX(@"#FFFFFF");
    }
    return _unitLabel;
}

- (UILabel *)timeLabel
{
    if( _timeLabel == nil )
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = FONT_R(13);
        _timeLabel.textColor = COLORHEX(@"#2BB9A0");
        _timeLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _timeLabel.layer.cornerRadius = 13;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}




@end
