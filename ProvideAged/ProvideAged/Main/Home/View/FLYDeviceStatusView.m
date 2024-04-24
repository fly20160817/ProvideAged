//
//  FLYDeviceStatusView.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYDeviceStatusView.h"
#import "FLYButton.h"

@interface FLYDeviceStatusView ()

@property (nonatomic, strong) UIView * redDotView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) FLYButton * moreBtn;

@property (nonatomic, strong) UILabel * totalTLabel;
@property (nonatomic, strong) UILabel * totalCLabel;
@property (nonatomic, strong) UILabel * onlineTLabel;
@property (nonatomic, strong) UILabel * onlineCLabel;
@property (nonatomic, strong) UILabel * alarmTLabel;
@property (nonatomic, strong) UILabel * alarmCLabel;

@end

@implementation FLYDeviceStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        
        //设置初始值
        self.total = @"0";
        self.online = @"0";
        self.alarm = @"0";
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(7, 7));
    }];
    
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
    
    [self.totalTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(42);
        make.bottom.equalTo(self).with.offset(-18);
    }];
    
    [self.totalCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.totalTLabel.mas_centerX);
        make.bottom.equalTo(self.totalTLabel.mas_top).with.offset(-5);
    }];

    [self.onlineTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(-18);
    }];

    [self.onlineCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.onlineTLabel.mas_centerX);
        make.bottom.equalTo(self.onlineTLabel.mas_top).with.offset(-5);
    }];

    [self.alarmTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-42);
        make.bottom.equalTo(self).with.offset(-18);
    }];

    [self.alarmCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alarmTLabel.mas_centerX);
        make.bottom.equalTo(self.alarmTLabel.mas_top).with.offset(-5);
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
    
    
    [self addSubview:self.redDotView];
    [self addSubview:self.iconView];
    [self addSubview:self.statusLabel];
    [self addSubview:self.moreBtn];
    [self addSubview:self.totalTLabel];
    [self addSubview:self.totalCLabel];
    [self addSubview:self.onlineTLabel];
    [self addSubview:self.onlineCLabel];
    [self addSubview:self.alarmTLabel];
    [self addSubview:self.alarmCLabel];
}



#pragma mark - event handler

- (void)moreClick:(UIButton *)button
{
    !self.moreBlock ?: self.moreBlock();
}



#pragma mark - setters and getters

-(void)setNewStatus:(BOOL)newStatus
{
    _newStatus = newStatus;
    
    self.redDotView.hidden = !newStatus;
}

-(void)setTotal:(NSString *)total
{
    _total = total;
    
    NSString * string = [NSString stringWithFormat:@"%@ 台", total];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_S(20),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]} range:NSMakeRange(0, string.length - 2)];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_R(10),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#666666"]} range:NSMakeRange(string.length - 2, 2)];
     
    self.totalCLabel.attributedText = attributedText;

}

-(void)setOnline:(NSString *)online
{
    _online = online;
    
    NSString * string = [NSString stringWithFormat:@"%@ 台", online];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_S(20),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#2BB9A0"]} range:NSMakeRange(0, string.length - 2)];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_R(10),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#666666"]} range:NSMakeRange(string.length - 2, 2)];
     
    self.onlineCLabel.attributedText = attributedText;
}

-(void)setAlarm:(NSString *)alarm
{
    _alarm = alarm;
    
    NSString * string = [NSString stringWithFormat:@"%@ 台", alarm];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_S(20),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#E17F7E"]} range:NSMakeRange(0, string.length - 2)];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_R(10),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#666666"]} range:NSMakeRange(string.length - 2, 2)];
     
    self.alarmCLabel.attributedText = attributedText;
}

-(UIView *)redDotView
{
    if ( _redDotView == nil )
    {
        _redDotView = [[UIView alloc] init];
        _redDotView.backgroundColor = COLORHEX(@"#FF443F");
        _redDotView.layer.cornerRadius = 7.0/2.0;
        _redDotView.hidden = YES;
    }
    return _redDotView;
}

- (UIImageView *)iconView
{
    if( _iconView == nil )
    {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = IMAGENAME(@"home_shebei");
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
        _statusLabel.text = @"设备状态";
    }
    return _statusLabel;
}

- (FLYButton *)moreBtn
{
    if( _moreBtn == nil )
    {
        _moreBtn = [FLYButton buttonWithImage:IMAGENAME(@"lvse_jiantou") title:@"更多" titleColor:COLORHEX(@"#49C8B2") font:FONT_R(10)];
        [_moreBtn setImagePosition:(FLYImagePositionRight) spacing:1.5];
        [_moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UILabel *)totalTLabel
{
    if( _totalTLabel == nil )
    {
        _totalTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalTLabel.font = FONT_M(12);
        _totalTLabel.textColor = COLORHEX(@"#333333");
        _totalTLabel.textAlignment = NSTextAlignmentCenter;
        _totalTLabel.text = @"设备总数";
    }
    return _totalTLabel;
}

- (UILabel *)totalCLabel
{
    if( _totalCLabel == nil )
    {
        _totalCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalCLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalCLabel;
}

- (UILabel *)onlineTLabel
{
    if( _onlineTLabel == nil )
    {
        _onlineTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _onlineTLabel.font = FONT_M(12);
        _onlineTLabel.textColor = COLORHEX(@"#333333");
        _onlineTLabel.textAlignment = NSTextAlignmentCenter;
        _onlineTLabel.text = @"房屋设备";
    }
    return _onlineTLabel;
}

- (UILabel *)onlineCLabel
{
    if( _onlineCLabel == nil )
    {
        _onlineCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _onlineCLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _onlineCLabel;
}

- (UILabel *)alarmTLabel
{
    if( _alarmTLabel == nil )
    {
        _alarmTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _alarmTLabel.font = FONT_M(12);
        _alarmTLabel.textColor = COLORHEX(@"#333333");
        _alarmTLabel.textAlignment = NSTextAlignmentCenter;
        _alarmTLabel.text = @"个人设备";
    }
    return _alarmTLabel;
}

- (UILabel *)alarmCLabel
{
    if( _alarmCLabel == nil )
    {
        _alarmCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _alarmCLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _alarmCLabel;
}



@end
