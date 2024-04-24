//
//  FLYTrackView.m
//  ProvideAged
//
//  Created by fly on 2021/11/5.
//

#import "FLYTrackView.h"

@interface FLYTrackView ()

@property (nonatomic, strong) UILabel * stepTLabel;
@property (nonatomic, strong) UILabel * stepCLabel;
@property (nonatomic, strong) UILabel * distanceTLabel;
@property (nonatomic, strong) UILabel * distanceCLabel;
@property (nonatomic, strong) UILabel * timeLabel;

@end

@implementation FLYTrackView

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
    
    
    [self.stepTLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.centerY.equalTo(self);
    }];
    
    [self.stepCLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stepTLabel.mas_right).with.offset(10);
        make.centerY.equalTo(self);
    }];
    
    [self.distanceTLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(130);
        make.centerY.equalTo(self);
    }];
    
    [self.distanceCLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.distanceTLabel.mas_right).with.offset(10);
        make.centerY.equalTo(self);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-20);
        make.centerY.equalTo(self);
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
    self.layer.cornerRadius = 5;

    
    [self addSubview:self.stepTLabel];
    [self addSubview:self.stepCLabel];
    [self addSubview:self.distanceTLabel];
    [self addSubview:self.distanceCLabel];
    [self addSubview:self.timeLabel];
}



#pragma mark - setters and getters

-(void)setTime:(NSString *)time
{
    _time = time;
    
    self.timeLabel.text = time;
}

-(void)setStep:(NSString *)step
{
    _step = step;
    
    
    NSDictionary * dic1 = @{ NSFontAttributeName : FONT_R(16), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"] };
    NSDictionary * dic2 = @{ NSFontAttributeName : FONT_R(12), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"] };
    
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
    
    
    NSDictionary * dic1 = @{ NSFontAttributeName : FONT_R(16), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"] };
    NSDictionary * dic2 = @{ NSFontAttributeName : FONT_R(12), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"] };
    
    NSString * string = [NSString stringWithFormat:@"%@km", distance];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    //range 手动计算也行， NSMakeRange(0, 2) 第几位开始，往后几位
    [attributedText addAttributes:dic1 range:NSMakeRange(0, string.length - 2)];
    [attributedText addAttributes:dic2 range:NSMakeRange(string.length - 2, 2)];
    
    self.distanceCLabel.attributedText = attributedText;
}


- (UILabel *)stepTLabel
{
    if( _stepTLabel == nil )
    {
        _stepTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stepTLabel.font = FONT_R(10);
        _stepTLabel.textColor = COLORHEX(@"#666666");
        _stepTLabel.text = @"步数";
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
        _distanceTLabel.font = FONT_R(14);
        _distanceTLabel.textColor = COLORHEX(@"#666666");
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

-(UILabel *)timeLabel
{
    if ( _timeLabel == nil )
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = FONT_R(14);
        _timeLabel.textColor = COLORHEX(@"#333333");
    }
    return _timeLabel;
}



@end
