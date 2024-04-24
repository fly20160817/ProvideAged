//
//  FLYCountdownButton.m
//  Paint
//
//  Created by fly on 2019/9/18.
//  Copyright © 2019 fly. All rights reserved.
//

#import "FLYCountdownButton.h"

@interface FLYCountdownButton ()
{
    NSDate * _startDate;//记录计时器开始的Date
    NSUInteger _seconds;//倒计时的秒数
}

@property (nonatomic, strong) NSTimer * timer;

@end

@implementation FLYCountdownButton

+ (instancetype)countdownButton
{
    FLYCountdownButton * countdownBtn = [FLYCountdownButton buttonWithType:UIButtonTypeCustom];
    [countdownBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [countdownBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    countdownBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    return countdownBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [self stopTimer];
}



#pragma mark - event handler

- (void)countdownAction
{
    //获取开始时间到现在的时间间隔
    NSTimeInterval differenceTime = [[NSDate date] timeIntervalSinceDate:_startDate];
   
    //剩余时间 = 总时间 - 时间间隔  (间隔是double类型，使用roundf四舍五入取整)
    NSInteger remainingSeconds = _seconds - roundf(differenceTime);
    
    if ( remainingSeconds >= 0 )
    {
        self.enabled = NO;
        
        NSString * title = [NSString stringWithFormat:@"%zd s", remainingSeconds];
        [self setTitle:title forState:UIControlStateDisabled];
    }
    else
    {
        self.enabled = YES;
        [self setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        
        [self stopTimer];
    }
}



#pragma mark - Timer

- (void)starTimer
{
    _startDate = [NSDate date];
    
    self.timer.fireDate = [NSDate distantPast];
}

- (void)pauseTimer
{
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}



#pragma mark - public methods

-(void)startCountdown:(NSUInteger)seconds
{
    _seconds = seconds;
    
    [self starTimer];
}



#pragma mark - setters and getters

-(NSTimer *)timer
{
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countdownAction) userInfo:nil repeats:YES];
        _timer.fireDate = [NSDate distantFuture];
    }
    return _timer;
}


@end

