//
//  FLYMedicineBoxView.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYMedicineBoxView.h"
#import "FLYButton.h"

@interface FLYMedicineBoxView ()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) FLYButton * moreBtn;

@property (nonatomic, strong) UILabel * timeLabel;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UIImageView * medicineIconView;
@property (nonatomic, strong) UILabel * eatTimeLabel;
@property (nonatomic, strong) UILabel * medicineNameLabel;
@property (nonatomic, strong) UIImageView * arrowView;

@end

@implementation FLYMedicineBoxView

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
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(16);
        make.left.equalTo(self).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).with.offset(5);
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.width.mas_equalTo(100);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.right.equalTo(self).with.offset(-16);
        make.size.mas_equalTo(CGSizeMake(33, 20));
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).with.offset(18);
        make.left.equalTo(self).with.offset(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).with.offset(42);
        make.left.equalTo(self).with.offset(20);
        make.right.equalTo(self).with.offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.medicineIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(13);
        make.left.equalTo(self).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(15, 11));
    }];
    
    [self.eatTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.medicineIconView);
        make.left.equalTo(self.medicineIconView.mas_right).offset(10);
    }];
    
    [self.medicineNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.medicineIconView);
        make.left.equalTo(self.eatTimeLabel.mas_right).offset(24);
    }];
    
    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.medicineIconView);
        make.right.equalTo(self).with.offset(-20);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,3);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 5;
    self.layer.cornerRadius = 8;
    
    
    [self addSubview:self.iconView];
    [self addSubview:self.statusLabel];
    [self addSubview:self.moreBtn];
    [self addSubview:self.timeLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.medicineIconView];
    [self addSubview:self.eatTimeLabel];
    [self addSubview:self.medicineNameLabel];
    [self addSubview:self.arrowView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
     [self addGestureRecognizer:tap];
}



#pragma mark - event handler

- (void)tapView
{
    !self.moreBlock ?: self.moreBlock();
}



#pragma mark - setters and getters

-(void)setTime:(NSString *)time
{
    _time = time;
    
    self.timeLabel.text = time;
}

-(void)setEatTime:(NSString *)eatTime
{
    _eatTime = eatTime;
    
    self.eatTimeLabel.text = eatTime;
}

-(void)setMedicineName:(NSString *)medicineName
{
    _medicineName = medicineName;
    
    self.medicineNameLabel.text = medicineName;
}

- (UIImageView *)iconView
{
    if( _iconView == nil )
    {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = IMAGENAME(@"shouye_yaoxiang");
    }
    return _iconView;
}

- (UILabel *)statusLabel
{
    if( _statusLabel == nil )
    {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = FONT_M(12);
        _statusLabel.textColor = COLORHEX(@"#333333");
        _statusLabel.text = @"智能药盒";
    }
    return _statusLabel;
}

- (FLYButton *)moreBtn
{
    if( _moreBtn == nil )
    {
        _moreBtn = [FLYButton buttonWithImage:IMAGENAME(@"lvse_jiantou") title:@"更多" titleColor:COLORHEX(@"#49C8B2")  font:FONT_R(10)];
        [_moreBtn setImagePosition:(FLYImagePositionRight) spacing:1.5];
    }
    return _moreBtn;
}

- (UILabel *)timeLabel
{
    if( _timeLabel == nil )
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = FONT_M(13);
        _timeLabel.textColor = COLORHEX(@"#333333");
    }
    return _timeLabel;
}

- (UIView *)lineView
{
    if( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORHEX(@"#F7F5F5");
    }
    return _lineView;
}

- (UIImageView *)medicineIconView
{
    if( _medicineIconView == nil )
    {
        _medicineIconView = [[UIImageView alloc] init];
        _medicineIconView.image = IMAGENAME(@"shouye_yaowan");
    }
    return _medicineIconView;
}

- (UILabel *)eatTimeLabel
{
    if( _eatTimeLabel == nil )
    {
        _eatTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _eatTimeLabel.font = FONT_M(12);
        _eatTimeLabel.textColor = COLORHEX(@"#333333");
    }
    return _eatTimeLabel;
}

- (UILabel *)medicineNameLabel
{
    if( _medicineNameLabel == nil )
    {
        _medicineNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _medicineNameLabel.font = FONT_M(12);
        _medicineNameLabel.textColor = COLORHEX(@"#333333");
    }
    return _medicineNameLabel;
}


- (UIImageView *)arrowView
{
    if( _arrowView == nil )
    {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = IMAGENAME(@"home_genduo");
    }
    return _arrowView;
}


@end
