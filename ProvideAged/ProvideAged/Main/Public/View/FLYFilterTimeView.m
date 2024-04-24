//
//  FLYFilterTimeView.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYFilterTimeView.h"
#import "BRDatePickerView.h"
#import "FLYTime.h"
#import "NSDate+FLYExtension.h"

@interface FLYFilterTimeView () < UITextFieldDelegate >

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * startTF;
@property (nonatomic, strong) UIImageView * arrow1View;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UILabel * endLabel;
@property (nonatomic, strong) UITextField * endTF;
@property (nonatomic, strong) UIImageView * arrow2View;

@property (nonatomic, strong) UIButton * resetBtn;
@property (nonatomic, strong) UIButton * confirmBtn;

@end

@implementation FLYFilterTimeView

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
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self).with.offset(10);
    }];
    
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(45);
        make.left.equalTo(self).with.offset(13);
        make.width.mas_equalTo(80);
    }];
    
    [self.arrow1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startLabel);
        make.right.equalTo(self).with.offset(-32);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [self.startTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrow1View.mas_left).with.offset(-5);
        make.centerY.equalTo(self.startLabel);
        make.left.equalTo(self.startLabel.mas_right).with.offset(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(68);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(12);
        make.left.equalTo(self).with.offset(13);
        make.width.mas_equalTo(80);
    }];
    
    [self.arrow2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.endLabel);
        make.right.equalTo(self).with.offset(-32);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [self.endTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrow2View.mas_left).with.offset(-5);
        make.centerY.equalTo(self.endLabel);
        make.left.equalTo(self.endLabel.mas_right).with.offset(20);
    }];
    
    
    [self.resetBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(SCREEN_WIDTH / 2.0);
    }];
    
    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(SCREEN_WIDTH / 2.0);
    }];
    
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.startLabel];
    [self addSubview:self.startTF];
    [self addSubview:self.arrow1View];
    [self addSubview:self.lineView];
    [self addSubview:self.endLabel];
    [self addSubview:self.endTF];
    [self addSubview:self.arrow2View];
    
    [self addSubview:self.resetBtn];
    [self addSubview:self.confirmBtn];
}



#pragma mark -event handler

//重置
- (void)resetClick:(UIButton *)button
{
    self.startTF.text = @"";
    self.endTF.text = @"";
}

//确认
- (void)confirmClick:(UIButton *)button
{
    //可以两个时间都为空，但不能一个填了另一个没填。
    
    if ( self.startTF.text.length == 0 && self.endTF.text.length != 0 )
    {
        [SVProgressHUD showImage:nil status:@"请选择开始时间"];
        return;
    }
    else if ( self.endTF.text.length == 0 && self.startTF.text.length != 0 )
    {
        [SVProgressHUD showImage:nil status:@"请选择结束时间"];
        return;
    }
    
    
    if ( [self judgeDate] == NO )
    {
        [SVProgressHUD showImage:nil status:@"结束时间必须大于开始时间"];
        return;
    }
    
    NSString * startTime = @"";
    NSString * endTime = @"";
    if ( self.startTF.text.length > 0 )
    {
        startTime = [NSString stringWithFormat:@"%@ 00:00:00", self.startTF.text];
    }
    if ( self.endTF.text.length > 0 )
    {
        endTime = [NSString stringWithFormat:@"%@ 23:59:59", self.endTF.text];
    }
    
    !self.confirmBlock ?: self.confirmBlock(startTime, endTime);
}



#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMD title:@"选择日期" selectValue:textField.text minDate:nil maxDate:[NSDate date] isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        
        textField.text = selectValue;
        
    }];
    
    return NO;
}



#pragma mark - private methods

//结束时间必须大于开始时间的判断
- (BOOL)judgeDate
{
    NSDate * startDate = [FLYTime stringToDateWithString:self.startTF.text dateFormat:(FLYDateFormatTypeYMD)];
    NSDate * endDate = [FLYTime stringToDateWithString:self.endTF.text dateFormat:(FLYDateFormatTypeYMD)];
    
    NSComparisonResult result = [NSDate compareDate:startDate targetDate:endDate unitFlag:(FLYCalendarUnitDay)];
    if ( result == 1 )
    {
        return NO;
    }
    
    return YES;
}



#pragma mark - setters and getters

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

-(UIButton *)resetBtn
{
    if ( _resetBtn == nil )
    {
        _resetBtn = [UIButton buttonWithTitle:@"重置" titleColor:COLORHEX(@"#333333") font:FONT_R(13)];
        _resetBtn.backgroundColor = [UIColor whiteColor];
        [_resetBtn addTarget:self action:@selector(resetClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        CALayer * layer = [CALayer layer];
        layer.backgroundColor = COLORHEX(@"#EBEBEB").CGColor;
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2.0, 0.5);
        [_resetBtn.layer addSublayer:layer];
    }
    return _resetBtn;
}

-(UIButton *)confirmBtn
{
    if ( _confirmBtn == nil )
    {
        _confirmBtn = [UIButton buttonWithTitle:@"确认" titleColor:[UIColor whiteColor] font:FONT_M(13)];
        _confirmBtn.backgroundColor = COLORHEX(@"#2BB9A0");
        [_confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmBtn;
}

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_M(13);
        _titleLabel.textColor = COLORHEX(@"#333333");
    }
    return _titleLabel;
}

- (UILabel *)startLabel
{
    if( _startLabel == nil )
    {
        _startLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _startLabel.font = FONT_R(12);
        _startLabel.textColor = COLORHEX(@"#999999");
        _startLabel.text = @"开始时间选择";
    }
    return _startLabel;
}

- (UITextField *)startTF
{
    if( _startTF == nil )
    {
        _startTF = [[UITextField alloc] init];
        _startTF.delegate = self;
        _startTF.placeholder = @"选择日期";
        _startTF.textColor = COLORHEX(@"#999999");
        _startTF.font = FONT_R(12);
        _startTF.textAlignment = NSTextAlignmentRight;
    }
    return _startTF;
}

- (UIImageView *)arrow1View
{
    if( _arrow1View == nil )
    {
        _arrow1View = [[UIImageView alloc] init];
        _arrow1View.image = IMAGENAME(@"home_genduo");
    }
    return _arrow1View;
}

- (UIView *)lineView
{
    if( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORHEX(@"#EBEBEB");
    }
    return _lineView;
}

- (UILabel *)endLabel
{
    if( _endLabel == nil )
    {
        _endLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _endLabel.font = FONT_R(12);
        _endLabel.textColor = COLORHEX(@"#999999");
        _endLabel.text = @"结束时间选择";
    }
    return _endLabel;
}

- (UITextField *)endTF
{
    if( _endTF == nil )
    {
        _endTF = [[UITextField alloc] init];
        _endTF.delegate = self;
        _endTF.placeholder = @"选择日期";
        _endTF.textColor = COLORHEX(@"#999999");
        _endTF.font = FONT_R(12);
        _endTF.textAlignment = NSTextAlignmentRight;
    }
    return _endTF;
}

- (UIImageView *)arrow2View
{
    if( _arrow2View == nil )
    {
        _arrow2View = [[UIImageView alloc] init];
        _arrow2View.image = IMAGENAME(@"home_genduo");
    }
    return _arrow2View;
}


@end

