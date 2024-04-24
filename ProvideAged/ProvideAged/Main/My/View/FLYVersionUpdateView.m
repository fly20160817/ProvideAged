//
//  FLYVersionUpdateView.m
//  ProvideAged
//
//  Created by fly on 2021/11/26.
//

#import "FLYVersionUpdateView.h"
#import "UIView+FLYLayer.h"

@interface FLYVersionUpdateView ()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) FLYButton * cancelBtn;
@property (nonatomic, strong) FLYButton * confirmBtn;

@end

@implementation FLYVersionUpdateView

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
        make.top.equalTo(self).with.offset(24);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).with.offset(20);
        make.centerX.equalTo(self);
    }];
    
    if( self.isForcedUpdate )
    {
        [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(0.5);
            make.height.mas_equalTo(49);
        }];
    }
    else
    {
        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_centerX);
            make.bottom.equalTo(self).with.offset(0.5);
            make.height.mas_equalTo(49);
        }];
        
        [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX);
            make.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(0.5);
            make.height.mas_equalTo(49);
        }];
    }
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.cornerRadius = 10;
    
    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.confirmBtn];
}



#pragma mark - event handler

- (void)cancelClick:(UIButton *)button
{
    !self.cancelBlock ?: self.cancelBlock();
}

- (void)confirmClick:(UIButton *)button
{
    !self.confirmBlock ?: self.confirmBlock();
}



#pragma mark - setters and getters

-(void)setIsForcedUpdate:(BOOL)isForcedUpdate
{
    _isForcedUpdate = isForcedUpdate;
    
    
    self.cancelBtn.hidden = isForcedUpdate;
        
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UIImageView *)iconView
{
    if( _iconView == nil )
    {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = IMAGENAME(@"banbenshengji");
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_M(15);
        _titleLabel.textColor = COLORHEX(@"#333333");
        _titleLabel.text = @"发现新版本";
    }
    return _titleLabel;
}

- (FLYButton *)cancelBtn
{
    if( _cancelBtn == nil )
    {
        _cancelBtn = [FLYButton buttonWithTitle:@"取消" titleColor:COLORHEX(@"#666666") font:FONT_M(14)];
        [_cancelBtn border:0.5 color:COLORHEX(@"#CDCDCD")];
        [_cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

- (FLYButton *)confirmBtn
{
    if( _confirmBtn == nil )
    {
        _confirmBtn = [FLYButton buttonWithTitle:@"确认" titleColor:COLORHEX(@"#2BB9A0") font:FONT_M(14)];
        [_confirmBtn border:0.5 color:COLORHEX(@"#CDCDCD")];
        [_confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmBtn;
}


@end
