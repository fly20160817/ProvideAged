//
//  FLYCircularView.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYCircularView.h"
#import "FLYButton.h"
#import "UIButton+FLYExtension.h"

@interface FLYCircularView ()

@property (nonatomic, strong) FLYButton * titleBtn;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * unitLabel;

@end

@implementation FLYCircularView

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
    
    self.layer.cornerRadius = self.width / 2.0;
    
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-12);
        make.centerX.equalTo(self);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).with.offset(4);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.unitLabel.mas_top).with.offset(-2);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    
    [self addSubview:self.titleBtn];
    [self addSubview:self.contentLabel];
    [self addSubview:self.unitLabel];
}



#pragma mark - setters and getters

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    [self.titleBtn setTitle:title forState:(UIControlStateNormal)];
}

-(void)setIconName:(NSString *)iconName
{
    _iconName = iconName;
    
    [self.titleBtn setImage:IMAGENAME(iconName) forState:UIControlStateNormal];
}

-(void)setContent:(NSString *)content
{
    _content = content;
    
    self.contentLabel.text = content;
}

-(void)setUnit:(NSString *)unit
{
    _unit = unit;
    
    self.unitLabel.text = unit;
}

- (FLYButton *)titleBtn
{
    if( _titleBtn == nil )
    {
        _titleBtn = [FLYButton buttonWithImage:nil title:nil titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(12)];
        [_titleBtn setImagePosition:(FLYImagePositionLeft) spacing:3];
    }
    return _titleBtn;
}

- (UILabel *)contentLabel
{
    if( _contentLabel == nil )
    {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = FONT_S(15);
        _contentLabel.textColor = COLORHEX(@"#FFFFFF");
    }
    return _contentLabel;
}

- (UILabel *)unitLabel
{
    if( _unitLabel == nil )
    {
        _unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unitLabel.font = FONT_R(9);
        _unitLabel.textColor = COLORHEX(@"#FFFFFF");
    }
    return _unitLabel;
}

@end
