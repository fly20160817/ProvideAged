//
//  FLYElderlyMenuView.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYElderlyMenuView.h"
#import "FLYElderlyMenuButtom.h"
#import "UIButton+FLYExtension.h"

@interface FLYElderlyMenuView ()

@property (nonatomic, strong) FLYElderlyMenuButtom * fileBtn;
@property (nonatomic, strong) FLYElderlyMenuButtom * trajectoryBtn;
@property (nonatomic, strong) FLYElderlyMenuButtom * recordBtn;
@property (nonatomic, strong) FLYElderlyMenuButtom * callBtn;

@end

@implementation FLYElderlyMenuView

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
    
    
    CGFloat spacing = (self.width - 20 * 2 - 48 * 4) / 3;
    
    [self.fileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(16);
        make.left.equalTo(self).with.offset(20);
        make.bottom.equalTo(self).with.offset(-15);
        make.width.mas_equalTo(48);
    }];
    
    [self.trajectoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(16);
        make.left.equalTo(self.fileBtn.mas_right).with.offset(spacing);
        make.bottom.equalTo(self).with.offset(-15);
        make.width.mas_equalTo(48);
    }];
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(16);
        make.left.equalTo(self.trajectoryBtn.mas_right).with.offset(spacing);
        make.bottom.equalTo(self).with.offset(-15);
        make.width.mas_equalTo(48);
    }];
    
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(16);
        make.left.equalTo(self.recordBtn.mas_right).with.offset(spacing);
        make.bottom.equalTo(self).with.offset(-15);
        make.width.mas_equalTo(48);
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
    
    
    [self addSubview:self.fileBtn];
    [self addSubview:self.trajectoryBtn];
    [self addSubview:self.recordBtn];
    [self addSubview:self.callBtn];
    
}



#pragma mark - event handler

- (void)buttonClick:(UIButton *)button
{
    !self.selectBlock ?: self.selectBlock(button.tag);
}



#pragma mark - setters and getters

-(FLYButton *)fileBtn
{
    if ( _fileBtn == nil )
    {
        _fileBtn = [FLYElderlyMenuButtom buttonWithImage:IMAGENAME(@"home_jiankang") title:@"健康档案" titleColor:COLORHEX(@"#333333") font:FONT_M(12)];
        [_fileBtn setImagePosition:(FLYImagePositionTop) spacing:8];
        _fileBtn.tag = 0;
        [_fileBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _fileBtn;
}

-(FLYButton *)trajectoryBtn
{
    if ( _trajectoryBtn == nil )
    {
        _trajectoryBtn = [FLYElderlyMenuButtom buttonWithImage:IMAGENAME(@"home_shipin") title:@"视频监护" titleColor:COLORHEX(@"#333333") font:FONT_M(12)];
        [_trajectoryBtn setImagePosition:(FLYImagePositionTop) spacing:8];
        _trajectoryBtn.tag = 1;
        [_trajectoryBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _trajectoryBtn;
}

-(FLYButton *)recordBtn
{
    if ( _recordBtn == nil )
    {
        _recordBtn = [FLYElderlyMenuButtom buttonWithImage:IMAGENAME(@"home_fuwu") title:@"服务记录" titleColor:COLORHEX(@"#333333") font:FONT_M(12)];
        [_recordBtn setImagePosition:(FLYImagePositionTop) spacing:8];
        _recordBtn.tag = 2;
        [_recordBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _recordBtn;
}

-(FLYButton *)callBtn
{
    if ( _callBtn == nil )
    {
        _callBtn = [FLYElderlyMenuButtom buttonWithImage:IMAGENAME(@"home_lianxi") title:@"联系老人" titleColor:COLORHEX(@"#333333") font:FONT_M(12)];
        [_callBtn setImagePosition:(FLYImagePositionTop) spacing:8];
        _callBtn.tag = 3;
        [_callBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _callBtn;
}

@end
