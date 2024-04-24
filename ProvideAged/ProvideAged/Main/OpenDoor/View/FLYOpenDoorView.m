//
//  FLYOpenDoorView.m
//  ProvideAged
//
//  Created by fly on 2021/12/23.
//

#import "FLYOpenDoorView.h"

@interface FLYOpenDoorView ()

@property (nonatomic, strong) FLYButton * openDoorBtn;
@property (nonatomic, strong) FLYButton * batteryBtn;
@property (nonatomic, strong) FLYButton * signalBtn;
@property (nonatomic, strong) UIView * lineView;

@end

@implementation FLYOpenDoorView

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
    
    [self.openDoorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(97);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(173, 173));
    }];
    
    [self.batteryBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openDoorBtn.mas_bottom).with.offset(66);
        make.right.equalTo(self.mas_centerX).with.offset(-55);
    }];
    
    [self.signalBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openDoorBtn.mas_bottom).with.offset(66);
        make.left.equalTo(self.mas_centerX).with.offset(55);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(35);
        make.right.equalTo(self).with.offset(-35);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self);
    }];
}



#pragma mark - UI

- (void)initUI
{
    [self addSubview:self.openDoorBtn];
    [self addSubview:self.batteryBtn];
    [self addSubview:self.signalBtn];
    [self addSubview:self.lineView];
}



#pragma mark - event handler

- (void)openDoorClick:(UIButton *)button
{
    !self.openDoorBlock ?: self.openDoorBlock(self.lockModel);
}



#pragma mark - setters and getters

-(void)setLockModel:(FLYOpenLockModel *)lockModel
{
    _lockModel = lockModel;
    
    [self.batteryBtn setTitle:[NSString stringWithFormat:@"%.0f%%", lockModel.electricity] forState:(UIControlStateNormal)];
    [self.signalBtn setTitle:[NSString stringWithFormat:@"%@%%", lockModel.lockSignal] forState:(UIControlStateNormal)];
}

-(FLYButton *)openDoorBtn
{
    if ( _openDoorBtn == nil )
    {
        _openDoorBtn = [FLYButton buttonWithImage:IMAGENAME(@"lanyakaisuo") title:@"蓝牙开锁" titleColor:COLORHEX(@"#FFFFFF") font:FONT_R(16)];
        [_openDoorBtn setImagePosition:(FLYImagePositionTop) spacing:19];
        _openDoorBtn.backgroundColor = [UIColor colorWithRed:43/255.0 green:185/255.0 blue:160/255.0 alpha:1.0];
        _openDoorBtn.layer.shadowColor = [UIColor colorWithRed:37/255.0 green:174/255.0 blue:150/255.0 alpha:0.53].CGColor;
        _openDoorBtn.layer.shadowOffset = CGSizeMake(0,4);
        _openDoorBtn.layer.shadowOpacity = 1;
        _openDoorBtn.layer.shadowRadius = 20;
        _openDoorBtn.layer.cornerRadius = 173.0 / 2.0;
        _openDoorBtn.adjustsImageWhenHighlighted = NO;
        [_openDoorBtn addTarget:self action:@selector(openDoorClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _openDoorBtn;
}

-(FLYButton *)batteryBtn
{
    if ( _batteryBtn == nil )
    {
        _batteryBtn = [FLYButton buttonWithImage:IMAGENAME(@"dianliang_100") title:@"100%" titleColor:COLORHEX(@"#333333") font:FONT_R(15)];
        [_batteryBtn setImagePosition:(FLYImagePositionLeft) spacing:10];
    }
    return _batteryBtn;
}

-(FLYButton *)signalBtn
{
    if ( _signalBtn == nil )
    {
        _signalBtn = [FLYButton buttonWithImage:IMAGENAME(@"xinhao_4") title:@"100%" titleColor:COLORHEX(@"#333333") font:FONT_R(15)];
        [_signalBtn setImagePosition:(FLYImagePositionLeft) spacing:10];
    }
    return _signalBtn;
}

-(UIView *)lineView
{
    if ( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORHEX(@"#F1F1F1");
    }
    return _lineView;
}

@end
