//
//  FLYMapDetailView.m
//  ProvideAged
//
//  Created by fly on 2021/11/5.
//

#import "FLYMapDetailView.h"
#import "FLYButton.h"
#import "UIButton+FLYExtension.h"

@interface FLYMapDetailView ()

@property (nonatomic, strong) UIButton * watchBtn;
@property (nonatomic, strong) UIButton * watchBgView;
@property (nonatomic, strong) UIView * watchLineView;
@property (nonatomic, strong) UIButton * cardBtn;
@property (nonatomic, strong) UIButton * cardBgView;
@property (nonatomic, strong) UIView * cardLineView;

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) FLYButton * moreBtn;
@property (nonatomic, strong) UILabel * stepTLabel;
@property (nonatomic, strong) UILabel * stepCLabel;
@property (nonatomic, strong) UILabel * distanceTLabel;
@property (nonatomic, strong) UILabel * distanceCLabel;
@property (nonatomic, strong) FLYButton * navigationBtn;

@end

@implementation FLYMapDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.watchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(56);
        make.height.mas_equalTo(36);
    }];
    
    [self.cardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-63);
        make.height.mas_equalTo(36);
    }];
    
    [self.watchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(180);
    }];
    
    [self.cardBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(180);
    }];
    
    [self.watchLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 3));
        make.bottom.equalTo(self.watchBtn.mas_bottom);
        make.centerX.equalTo(self.watchBtn.mas_centerX);
    }];
    
    [self.cardLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 3));
        make.bottom.equalTo(self.watchBtn.mas_bottom);
        make.centerX.equalTo(self.cardBtn.mas_centerX);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.watchBgView.mas_bottom).with.offset(19);
        make.left.equalTo(self).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(17, 21));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-5);
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.width.mas_equalTo(40);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).with.offset(12);
        make.right.equalTo(self.moreBtn.mas_left).with.offset(-5);
        make.centerY.equalTo(self.iconView.mas_centerY);
    }];
    
    [self.navigationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.bottom.equalTo(self).with.offset(-12);
        make.height.mas_equalTo(42);
    }];
    
    [self.stepTLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navigationBtn.mas_top).with.offset(-17);
        make.centerX.equalTo(self.mas_centerX).with.offset( -(self.width / 4.0));
    }];
    
    [self.stepCLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.stepTLabel.mas_centerX);
        make.bottom.equalTo(self.stepTLabel.mas_top).with.offset(-4);
    }];
    
    [self.distanceTLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navigationBtn.mas_top).with.offset(-17);
        make.centerX.equalTo(self.mas_centerX).with.offset( self.width / 4.0);
    }];
    
    [self.distanceCLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.distanceTLabel.mas_centerX);
        make.bottom.equalTo(self.distanceTLabel.mas_top).with.offset(-4);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.18].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,19);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 34;
    self.layer.cornerRadius = 15;

    [self addSubview:self.watchBgView];
    [self addSubview:self.watchBtn];
    [self addSubview:self.watchLineView];
    [self addSubview:self.cardBgView];
    [self addSubview:self.cardBtn];
    [self addSubview:self.cardLineView];
    
    [self addSubview:self.iconView];
    [self addSubview:self.addressLabel];
    [self addSubview:self.moreBtn];
    [self addSubview:self.stepTLabel];
    [self addSubview:self.stepCLabel];
    [self addSubview:self.distanceTLabel];
    [self addSubview:self.distanceCLabel];
    [self addSubview:self.navigationBtn];
}



#pragma mark - event handler

- (void)watchClick:(UIButton *)button
{
    self.type = 0;
    
    !self.changeTypeBlock ?: self.changeTypeBlock(self.type);
}

- (void)cardClick:(UIButton *)button
{
    self.type = 1;
    
    !self.changeTypeBlock ?: self.changeTypeBlock(self.type);
}

- (void)moreClick:(UIButton *)button
{
    !self.moreBlock ?: self.moreBlock();
}

- (void)navigationClick:(UIButton *)button
{
    !self.navigationBlock ?: self.navigationBlock();
}



#pragma mark - setters and getters

-(void)setType:(NSInteger)type
{
    _type = type;
    
    
    if ( type == 0 )
    {
        self.watchBtn.selected = YES;
        self.watchBgView.hidden = YES;
        self.watchLineView.hidden = NO;
        
        self.cardBtn.selected = NO;
        self.cardBgView.hidden = NO;
        self.cardLineView.hidden = YES;
        
        self.stepTLabel.hidden = NO;
        self.stepCLabel.hidden = NO;
        self.distanceTLabel.hidden = NO;
        self.distanceCLabel.hidden = NO;
    }
    else if ( type == 1 )
    {
        self.watchBtn.selected = NO;
        self.watchBgView.hidden = NO;
        self.watchLineView.hidden = YES;
        
        self.cardBtn.selected = YES;
        self.cardBgView.hidden = YES;
        self.cardLineView.hidden = NO;
        
        self.stepTLabel.hidden = YES;
        self.stepCLabel.hidden = YES;
        self.distanceTLabel.hidden = YES;
        self.distanceCLabel.hidden = YES;
    }
}

-(void)setAddress:(NSString *)address
{
    _address = address;
    
    self.addressLabel.text = address;
}

-(void)setStep:(NSString *)step
{
    _step = step;
    
    
    NSDictionary * dic1 = @{ NSFontAttributeName : FONT_R(19), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#6A7376"] };
    NSDictionary * dic2 = @{ NSFontAttributeName : FONT_R(10), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#B9BDBE"] };
    
    NSString * string = [NSString stringWithFormat:@"%@步", step];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    //range 手动计算也行， NSMakeRange(0, 2) 第几位开始，往后几位
    [attributedText addAttributes:dic1 range:NSMakeRange(0, string.length - 1)];
    [attributedText addAttributes:dic2 range:NSMakeRange(string.length - 1, 1)];
    
    self.stepCLabel.attributedText = attributedText;
}

-(void)setDistance:(NSString *)distance
{
    _distance = distance;
    
    
    NSDictionary * dic1 = @{ NSFontAttributeName : FONT_R(19), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#6A7376"] };
    NSDictionary * dic2 = @{ NSFontAttributeName : FONT_R(10), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#B9BDBE"] };
    
    NSString * string = [NSString stringWithFormat:@"%@km", distance == nil ? @"--" : distance];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    //range 手动计算也行， NSMakeRange(0, 2) 第几位开始，往后几位
    [attributedText addAttributes:dic1 range:NSMakeRange(0, string.length - 2)];
    [attributedText addAttributes:dic2 range:NSMakeRange(string.length - 2, 2)];
    
    self.distanceCLabel.attributedText = attributedText;
}

- (UIButton *)watchBtn
{
    if( _watchBtn == nil )
    {
        _watchBtn = [UIButton buttonWithTitle:@"智能手表" titleColor:COLORHEX(@"#73ADA3") font:FONT_R(14)];
        [_watchBtn setTitleColor:COLORHEX(@"#333333") forState:(UIControlStateSelected)];
        _watchBtn.userInteractionEnabled = NO;
    }
    return _watchBtn;
}

- (UIButton *)watchBgView
{
    if( _watchBgView == nil )
    {
        _watchBgView = [[UIButton alloc] init];
        _watchBgView.adjustsImageWhenHighlighted = NO;
        [_watchBgView setImage:IMAGENAME(@"shoubiao_bg") forState:(UIControlStateNormal)];
        [_watchBgView addTarget:self action:@selector(watchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _watchBgView;
}

- (UIView *)watchLineView
{
    if( _watchLineView == nil )
    {
        _watchLineView = [[UIView alloc] init];
        _watchLineView.backgroundColor =COLORHEX(@"#2BB9A0");
    }
    return _watchLineView;
}

- (UIButton *)cardBtn
{
    if( _cardBtn == nil )
    {
        _cardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cardBtn = [UIButton buttonWithTitle:@"颐养卡" titleColor:COLORHEX(@"#73ADA3") font:FONT_R(14)];
        [_cardBtn setTitleColor:COLORHEX(@"#333333") forState:(UIControlStateSelected)];
        _cardBtn.userInteractionEnabled = NO;
    }
    return _cardBtn;
}

- (UIButton *)cardBgView
{
    if( _cardBgView == nil )
    {
        _cardBgView = [[UIButton alloc] init];
        _cardBgView.adjustsImageWhenHighlighted = NO;
        [_cardBgView setImage:IMAGENAME(@"ka_bg") forState:(UIControlStateNormal)];
        [_cardBgView addTarget:self action:@selector(cardClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cardBgView;
}

- (UIView *)cardLineView
{
    if( _cardLineView == nil )
    {
        _cardLineView = [[UIView alloc] init];
        _cardLineView.backgroundColor =COLORHEX(@"#2BB9A0");
    }
    return _cardLineView;
}


- (UIImageView *)iconView
{
    if( _iconView == nil )
    {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = IMAGENAME(@"daohangdingwei");
    }
    return _iconView;
}

- (UILabel *)addressLabel
{
    if( _addressLabel == nil )
    {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressLabel.font = FONT_R(13);
        _addressLabel.textColor = COLORHEX(@"#333333");
    }
    return _addressLabel;
}

- (FLYButton *)moreBtn
{
    if( _moreBtn == nil )
    {
        _moreBtn = [FLYButton buttonWithImage:IMAGENAME(@"lvse_jiantou") title:@"更多" titleColor:COLORHEX(@"#49C8B2") font:FONT_R(10)];
        [_moreBtn setImagePosition:(FLYImagePositionRight) spacing:4];
        [_moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _moreBtn;
}

- (UILabel *)stepTLabel
{
    if( _stepTLabel == nil )
    {
        _stepTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stepTLabel.font = FONT_R(10);
        _stepTLabel.textColor = COLORHEX(@"#B9BDBE");
        _stepTLabel.text = @"今日步数";
    }
    return _stepTLabel;
}

- (UILabel *)stepCLabel
{
    if( _stepCLabel == nil )
    {
        _stepCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stepCLabel.font = FONT_R(19);
        _stepCLabel.textColor = COLORHEX(@"#6A7376");
    }
    return _stepCLabel;
}

- (UILabel *)distanceTLabel
{
    if( _distanceTLabel == nil )
    {
        _distanceTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _distanceTLabel.font = FONT_R(10);
        _distanceTLabel.textColor = COLORHEX(@"#B9BDBE");
        _distanceTLabel.text = @"距离";
    }
    return _distanceTLabel;
}

- (UILabel *)distanceCLabel
{
    if( _distanceCLabel == nil )
    {
        _distanceCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _distanceCLabel.font = FONT_R(19);
        _distanceCLabel.textColor = COLORHEX(@"#6A7376");
    }
    return _distanceCLabel;
}

- (FLYButton *)navigationBtn
{
    if( _navigationBtn == nil )
    {
        _navigationBtn = [FLYButton buttonWithImage:IMAGENAME(@"daohangjiantou") title:@"位置导航" titleColor:COLORHEX(@"#FFFFFF") font:FONT_R(15)];
        _navigationBtn.backgroundColor = [UIColor colorWithRed:43/255.0 green:185/255.0 blue:160/255.0 alpha:1.0];
        _navigationBtn.layer.cornerRadius = 42.0 / 2.0;
        [_navigationBtn setImagePosition:(FLYImagePositionLeft) spacing:8];
        [_navigationBtn addTarget:self action:@selector(navigationClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _navigationBtn;
}



@end
