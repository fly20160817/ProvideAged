//
//  HealthTitleView.m
//  WatchHealth
//
//  Created by fly on 2022/10/25.
//

#import "HealthTitleView.h"

@interface HealthTitleView ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * timeLabel;

@end

@implementation HealthTitleView

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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.centerX.equalTo(self);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1);
        make.centerX.equalTo(self);
    }];
}



#pragma mark - UI

- (void)initUI
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
}



#pragma mark - setters and getters

-(void)setTime:(NSString *)time
{
    _time = time;
    
    self.timeLabel.text = time;
}

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_M(14);
        _titleLabel.textColor = COLORHEX(@"#333333");
        _titleLabel.text = @"健康报告";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if( _timeLabel == nil )
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = FONT_R(11);
        _timeLabel.textColor = COLORHEX(@"#8B9598");
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}


@end
