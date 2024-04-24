//
//  DatePickerView.m
//  WatchHealth
//
//  Created by fly on 2022/10/26.
//

#import "DatePickerView.h"
#import "BRDatePickerView.h"
#import "FLYTime.h"
#import "UIView+FLYLayer.h"

@interface DatePickerView ()
{
    NSString * _time;
    NSString * _startTime;
    NSString * _endTime;
}
@property (nonatomic, strong) UIView * ovalView;
@property (nonatomic, strong) FLYButton * dayBtn;
@property (nonatomic, strong) FLYButton * weekBtn;

@property (nonatomic, strong) BRDatePickerView * pickerView;

@property (nonatomic, strong) UIButton * confirmBtn;

@end

@implementation DatePickerView

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
    
    [self roundCorner:19 rectCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    
    if ( self.ovalView.superview == nil )
    {
        return;
    }
    
    [self.ovalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(7);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    
    [self.dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.ovalView);
        make.size.mas_equalTo(CGSizeMake(50, 25));
    }];
    
    [self.weekBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.ovalView);
        make.size.mas_equalTo(CGSizeMake(50, 25));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-18);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(34);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.pickerView addPickerToView:self];
    
    [self addSubview:self.ovalView];
    [self.ovalView addSubview:self.dayBtn];
    [self.ovalView addSubview:self.weekBtn];
    
    [self addSubview:self.confirmBtn];
    
 
    _time = [FLYTime dateToStringWithDate:[NSDate date] dateFormat:(FLYDateFormatTypeYMD)];
    NSArray * dataList = [self getFirstAndLastDayOfThisWeek];
    _startTime = [FLYTime dateToStringWithDate:dataList.firstObject dateFormat:FLYDateFormatTypeYMD];
    _endTime = [FLYTime dateToStringWithDate:dataList.lastObject dateFormat:FLYDateFormatTypeYMD];
    
}



#pragma mark - event handler

- (void)dayClick:(UIButton *)button
{
    self.weekBtn.selected = NO;
    self.dayBtn.selected = YES;
    
    self.pickerView.pickerMode = BRDatePickerModeDate;
}

- (void)weekClick:(UIButton *)button
{
    self.dayBtn.selected = NO;
    self.weekBtn.selected = YES;
    
    self.pickerView.pickerMode = BRDatePickerModeYMW;
}

- (void)confirmClick:(UIButton *)button
{
    if ( self.dayBtn.selected == YES )
    {
        !self.dayBlock ?: self.dayBlock(_time);
    }
    else
    {
        !self.weekBlock ?: self.weekBlock(_startTime, _endTime);
    }
    
    !self.confirmBlock ?: self.confirmBlock();
}



#pragma mark - private methods

// 得到这个周的第一天和最后一天
- (NSArray *)getFirstAndLastDayOfThisWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger weekday = [dateComponents weekday];   //第几天(从sunday开始)
    NSInteger firstDiff,lastDiff;
    if (weekday == 1) {
        firstDiff = 0;
        lastDiff = +6;
    }else {
        firstDiff = -weekday + 1;
        lastDiff = 7 - weekday;
    }
    NSInteger day = [dateComponents day];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [firstComponents setDay:day+firstDiff];
    NSDate *firstDay = [calendar dateFromComponents:firstComponents];
    
    NSDateComponents *lastComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [lastComponents setDay:day+lastDiff];
    NSDate *lastDay = [calendar dateFromComponents:lastComponents];
    return [NSArray arrayWithObjects:firstDay,lastDay, nil];
}




#pragma mark - setters and getters

- (UIView *)ovalView
{
    if( _ovalView == nil )
    {
        _ovalView = [[UIView alloc] init];
        _ovalView.backgroundColor = COLORHEX(@"#F8F8F8");
        _ovalView.layer.cornerRadius = 12.5;
    }
    return _ovalView;
}

- (FLYButton *)dayBtn
{
    if( _dayBtn == nil )
    {
        _dayBtn = [FLYButton buttonWithTitle:@"日" titleColor:COLORHEX(@"#98A4A8") font:FONT_R(13)];
        [_dayBtn setTitleColor:COLORHEX(@"#FFFFFF") forState:(UIControlStateSelected)];
        [_dayBtn setBackgroundColor:COLORHEX(@"#F8F8F8") forState:(UIControlStateNormal)];
        [_dayBtn setBackgroundColor:COLORHEX(@"#20C690") forState:(UIControlStateSelected)];
        [_dayBtn roundCorner:12.5];
        _dayBtn.selected = YES;
        [_dayBtn addTarget:self action:@selector(dayClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _dayBtn;
}

- (FLYButton *)weekBtn
{
    if( _weekBtn == nil )
    {
        _weekBtn = [FLYButton buttonWithTitle:@"周" titleColor:COLORHEX(@"#98A4A8") font:FONT_R(13)];
        [_weekBtn setTitleColor:COLORHEX(@"#FFFFFF") forState:(UIControlStateSelected)];
        [_weekBtn setBackgroundColor:COLORHEX(@"#F8F8F8") forState:(UIControlStateNormal)];
        [_weekBtn setBackgroundColor:COLORHEX(@"#20C690") forState:(UIControlStateSelected)];
        [_weekBtn roundCorner:12.5];
        [_weekBtn addTarget:self action:@selector(weekClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _weekBtn;
}

-(BRDatePickerView *)pickerView
{
    if ( _pickerView == nil )
    {
        WeakSelf
        StrongSelf
        _pickerView = [[BRDatePickerView alloc] init];
        _pickerView.pickerMode = BRDatePickerModeYMD;
        _pickerView.isAutoSelect = YES;

        _pickerView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {

            if ( weakSelf.dayBtn.isSelected)
            {
                strongSelf->_time = selectValue;
            }
            
        };
        _pickerView.resultRangeBlock = ^(NSDate * _Nullable selectStartDate, NSDate * _Nullable selectEndDate, NSString * _Nullable selectValue) {
            
            if ( weakSelf.weekBtn.isSelected )
            {
                NSString *format = @"yyyy-MM-dd";
                
                NSString *startTime = [NSDate br_stringFromDate:selectStartDate dateFormat:format];
                NSString *endTime = [NSDate br_stringFromDate:selectEndDate dateFormat:format];
                
                strongSelf->_startTime = startTime;
                strongSelf->_endTime = endTime;
            }
            
        };
    }
    return _pickerView;
}

- (UIButton *)confirmBtn
{
    if( _confirmBtn == nil )
    {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:COLORHEX(@"#FFFFFF") forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = FONT_R(13);
        _confirmBtn.backgroundColor = COLORHEX(@"#20C690");
        [_confirmBtn roundCorner:17];
        [_confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}



@end
