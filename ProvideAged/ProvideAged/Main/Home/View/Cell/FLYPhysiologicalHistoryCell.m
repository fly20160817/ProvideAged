//
//  FLYPhysiologicalHistoryCell.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYPhysiologicalHistoryCell.h"
#import "FLYTime.h"

@interface FLYPhysiologicalHistoryCell ()

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * valueLabel;
@property (nonatomic, strong) UILabel * unitLabel;
@property (nonatomic, strong) UILabel * deviceLabel;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UIView * lineView;

@end

@implementation FLYPhysiologicalHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ( self )
    {
        [self initUI];
    }
    
    return self;
}



#pragma mark - UI

- (void)initUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.unitLabel];
    [self.contentView addSubview:self.deviceLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.lineView];
    

    [self makeConstraints];
    
}

- (void)makeConstraints
{
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(24);
        make.bottom.equalTo(self.contentView).with.offset(-26);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(SCREEN_WIDTH * (150.0 / 375));
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.valueLabel.mas_right).with.offset(0);
        make.bottom.equalTo(self.valueLabel.mas_bottom).with.offset(-2);
    }];
    
    [self.deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(SCREEN_WIDTH * (150.0 / 375));
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-29);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}



#pragma mark - setters and getters

-(void)setHealthModel:(FLYHealthModel *)healthModel
{
    _healthModel = healthModel;
    
    NSDate * date = [FLYTime stringToDateWithString:healthModel.createTime dateFormat:(FLYDateFormatTypeYMDHMS)];
    
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd日 HH:mm"];
    NSString * string = [dateFormat stringFromDate:date];
    
    
    NSDictionary * dic1 = @{ NSFontAttributeName : FONT_M(18), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"] };
    NSDictionary * dic2 = @{ NSFontAttributeName : FONT_R(9), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"] };
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    //range 手动计算也行， NSMakeRange(0, 2) 第几位开始，往后几位
    [attributedText addAttributes:dic1 range:NSMakeRange(0, string.length - 7)];
    [attributedText addAttributes:dic2 range:NSMakeRange(string.length - 7, 7)];
     
    self.timeLabel.attributedText = attributedText;
    
   
    self.unitLabel.text = healthModel.unit;
    self.deviceLabel.text = healthModel.deviceTypeDesc;
    
    if ( healthModel.healthType == 6 )
    {
        self.valueLabel.text = [NSString stringWithFormat:@"%@/%@", healthModel.healthValue2, healthModel.healthValue];
    }
    else
    {
        self.valueLabel.text = healthModel.healthValue;
    }
    
    
    if ( healthModel.status == 1 )
    {
        self.statusLabel.textColor = COLORHEX(@"#2BB9A0");
        self.statusLabel.text = @"正常";
        
    }
    else if ( healthModel.status == 2 )
    {
        self.statusLabel.textColor = COLORHEX(@"#5F96F1");
        self.statusLabel.text = @"偏低";
    }
    else
    {
        self.statusLabel.textColor = COLORHEX(@"#DD6E6F");
        self.statusLabel.text = @"偏高";
    }
    
    
    [self makeConstraints];
}

- (UILabel *)timeLabel
{
    if( _timeLabel == nil )
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = FONT_R(9);
        _timeLabel.textColor = COLORHEX(@"#333333");
    }
    return _timeLabel;
}

- (UILabel *)valueLabel
{
    if( _valueLabel == nil )
    {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.font = FONT_R(18);
        _valueLabel.textColor = COLORHEX(@"#333333");
    }
    return _valueLabel;
}

- (UILabel *)unitLabel
{
    if( _unitLabel == nil )
    {
        _unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unitLabel.font = FONT_R(12);
        _unitLabel.textColor = COLORHEX(@"#333333");
    }
    return _unitLabel;
}

- (UILabel *)deviceLabel
{
    if( _deviceLabel == nil )
    {
        _deviceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _deviceLabel.font = FONT_R(9);
        _deviceLabel.textColor = COLORHEX(@"#666666");
    }
    return _deviceLabel;
}

- (UILabel *)statusLabel
{
    if( _statusLabel == nil )
    {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = FONT_M(12);
        _statusLabel.textColor = COLORHEX(@"#2CB59C");
    }
    return _statusLabel;
}

- (UIView *)lineView
{
    if( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORHEX(@"#EAEAEA");
    }
    return _lineView;
}


@end
