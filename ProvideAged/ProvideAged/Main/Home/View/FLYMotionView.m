//
//  FLYMotionView.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYMotionView.h"
#import "FLYButton.h"

@interface FLYMotionView ()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) FLYButton * moreBtn;

@property (nonatomic, strong) UILabel * stepTLabel;
@property (nonatomic, strong) UILabel * stepCLabel;
@property (nonatomic, strong) UILabel * distanceTLabel;
@property (nonatomic, strong) UILabel * distanceCLabel;

@end

@implementation FLYMotionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        
        //设置初始值
        self.step = @"0";
        self.distance = @"0.0";
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
    
    [self.stepTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.right.equalTo(self.mas_centerX).with.offset(-20);
        make.bottom.equalTo(self).with.offset(-18);
    }];
    
    [self.stepCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.stepTLabel.mas_centerX);
        make.bottom.equalTo(self.stepTLabel.mas_top).with.offset(-5);
    }];

    [self.distanceTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).with.offset(20);
        make.right.equalTo(self).with.offset(-20);
        make.bottom.equalTo(self).with.offset(-18);
    }];

    [self.distanceCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.distanceTLabel.mas_centerX);
        make.bottom.equalTo(self.distanceTLabel.mas_top).with.offset(-5);
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
    [self addSubview:self.stepTLabel];
    [self addSubview:self.stepCLabel];
    [self addSubview:self.distanceTLabel];
    [self addSubview:self.distanceCLabel];
}



#pragma mark - event handler

- (void)moreClick:(UIButton *)button
{
    !self.moreBlock ?: self.moreBlock();
}



#pragma mark - setters and getters

-(void)setStep:(NSString *)step
{
    _step = step;
    
    NSString * string = [NSString stringWithFormat:@"%@ 步", step];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_S(20),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]} range:NSMakeRange(0, string.length - 2)];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_R(10),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#666666"]} range:NSMakeRange(string.length - 2, 2)];
     
    self.stepCLabel.attributedText = attributedText;

}

-(void)setDistance:(NSString *)distance
{
    _distance = distance;
    
    NSString * string = [NSString stringWithFormat:@"%@ km", distance];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_S(20),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#2BB9A0"]} range:NSMakeRange(0, string.length - 3)];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_R(10),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#666666"]} range:NSMakeRange(string.length - 3, 3)];
     
    self.distanceCLabel.attributedText = attributedText;
}

- (UIImageView *)iconView
{
    if( _iconView == nil )
    {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = IMAGENAME(@"xiaoren");
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
        _statusLabel.text = @"运动统计";
    }
    return _statusLabel;
}

- (FLYButton *)moreBtn
{
    if( _moreBtn == nil )
    {
        _moreBtn = [FLYButton buttonWithImage:IMAGENAME(@"lvse_jiantou") title:@"更多" titleColor:COLORHEX(@"#49C8B2")  font:FONT_R(10)];
        [_moreBtn setImagePosition:(FLYImagePositionRight) spacing:1.5];
        [_moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UILabel *)stepTLabel
{
    if( _stepTLabel == nil )
    {
        _stepTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stepTLabel.font = FONT_M(12);
        _stepTLabel.textColor = COLORHEX(@"#333333");
        _stepTLabel.textAlignment = NSTextAlignmentCenter;
        _stepTLabel.text = @"今日步数";
    }
    return _stepTLabel;
}

- (UILabel *)stepCLabel
{
    if( _stepCLabel == nil )
    {
        _stepCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stepCLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stepCLabel;
}

- (UILabel *)distanceTLabel
{
    if( _distanceTLabel == nil )
    {
        _distanceTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _distanceTLabel.font = FONT_M(12);
        _distanceTLabel.textColor = COLORHEX(@"#333333");
        _distanceTLabel.textAlignment = NSTextAlignmentCenter;
        _distanceTLabel.text = @"距离";
    }
    return _distanceTLabel;
}

- (UILabel *)distanceCLabel
{
    if( _distanceCLabel == nil )
    {
        _distanceCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _distanceCLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _distanceCLabel;
}

@end
