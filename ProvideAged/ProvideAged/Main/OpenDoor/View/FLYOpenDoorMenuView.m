//
//  FLYOpenDoorMenuView.m
//  ProvideAged
//
//  Created by fly on 2021/12/23.
//

#import "FLYOpenDoorMenuView.h"

@interface FLYOpenDoorMenuView ()

@property (nonatomic, strong) FLYButton * authorizeBtn;
@property (nonatomic, strong) FLYButton * openRecordBtn;
@property (nonatomic, strong) FLYButton * forgetBtn;
@property (nonatomic, strong) FLYButton * enterBtn;

@end

@implementation FLYOpenDoorMenuView

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
    
    
    [self.authorizeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(52);
        make.left.equalTo(self).with.offset(40);
        make.size.mas_equalTo(CGSizeMake(50, 62));
    }];
    
    if ( self.lockModel.bluetoothType == 7 && self.lockModel.supportFace == 1 )
    {
        [self.enterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(52);
            make.right.equalTo(self.mas_centerX).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake(50, 62));
        }];
        
        [self.openRecordBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(52);
            make.left.equalTo(self.mas_centerX).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 62));
        }];
    }
    else if ( self.lockModel.bluetoothType == 4 )
    {
        [self.enterBtn setTitle:@"指纹录入" forState:(UIControlStateNormal)];
        [self.enterBtn setImage:IMAGENAME(@"zhiwenluru") forState:UIControlStateNormal];
        
        [self.enterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(52);
            make.right.equalTo(self.mas_centerX).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake(50, 62));
        }];
        
        [self.openRecordBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(52);
            make.left.equalTo(self.mas_centerX).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 62));
        }];
    }
    else
    {
        self.enterBtn.hidden = YES;
        
        [self.openRecordBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(52);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(50, 62));
        }];
    }
    

    
    [self.forgetBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(52);
        make.right.equalTo(self).with.offset(-40);
        make.size.mas_equalTo(CGSizeMake(50, 62));
    }];    
}



#pragma mark - UI

- (void)initUI
{
    [self addSubview:self.authorizeBtn];
    [self addSubview:self.enterBtn];
    [self addSubview:self.openRecordBtn];
    [self addSubview:self.forgetBtn];
}



#pragma mark - event handler

- (void)menuClick:(UIButton *)button
{
    !self.menuBlock ?: self.menuBlock(button.tag);
}



#pragma mark - setters and getters

-(void)setLockModel:(FLYOpenLockModel *)lockModel
{
    _lockModel = lockModel;
    
    self.forgetBtn.hidden = lockModel.isShowForgotPassword == 1 ? NO : YES;
}

-(FLYButton *)authorizeBtn
{
    if ( _authorizeBtn == nil )
    {
        _authorizeBtn = [FLYButton buttonWithImage:IMAGENAME(@"linshishouquan") title:@"临时授权" titleColor:COLORHEX(@"#333333") font:FONT_M(12)];
        [_authorizeBtn setImagePosition:(FLYImagePositionTop) spacing:10];
        _authorizeBtn.tag = 0;
        [_authorizeBtn addTarget:self action:@selector(menuClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _authorizeBtn;
}

-(FLYButton *)openRecordBtn
{
    if ( _openRecordBtn == nil )
    {
        _openRecordBtn = [FLYButton buttonWithImage:IMAGENAME(@"kaimenjilu") title:@"开门记录" titleColor:COLORHEX(@"#333333") font:FONT_M(12)];
        [_openRecordBtn setImagePosition:(FLYImagePositionTop) spacing:10];
        _openRecordBtn.tag = 1;
        [_openRecordBtn addTarget:self action:@selector(menuClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _openRecordBtn;
}

-(FLYButton *)forgetBtn
{
    if ( _forgetBtn == nil )
    {
        _forgetBtn = [FLYButton buttonWithImage:IMAGENAME(@"wangjimima") title:@"忘记密码" titleColor:COLORHEX(@"#333333") font:FONT_M(12)];
        [_forgetBtn setImagePosition:(FLYImagePositionTop) spacing:10];
        _forgetBtn.tag = 2;
        [_forgetBtn addTarget:self action:@selector(menuClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _forgetBtn;
}

-(FLYButton *)enterBtn
{
    if ( _enterBtn == nil )
    {
        _enterBtn = [FLYButton buttonWithImage:IMAGENAME(@"renlianlvru") title:@"人脸录入" titleColor:COLORHEX(@"#333333") font:FONT_M(12)];
        [_enterBtn setImagePosition:(FLYImagePositionTop) spacing:10];
        _enterBtn.tag = 3;
        [_enterBtn addTarget:self action:@selector(menuClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _enterBtn;
}

@end
