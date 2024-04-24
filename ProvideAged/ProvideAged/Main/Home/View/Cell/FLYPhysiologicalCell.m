//
//  FLYPhysiologicalCell.m
//  ProvideAged
//
//  Created by fly on 2021/11/3.
//

#import "FLYPhysiologicalCell.h"
#import "FLYTime.h"

@interface FLYPhysiologicalCell ()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * unitLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * deviceLabel;
@property (nonatomic, strong) UILabel * statusLabel;

@end

@implementation FLYPhysiologicalCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,3);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 12;
    self.layer.cornerRadius = 10;
    
    
    
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.unitLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.deviceLabel];
    [self.contentView addSubview:self.statusLabel];
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(17);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(39, 39));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(2);
        make.left.equalTo(self.iconView.mas_right).with.offset(13);
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconView.mas_bottom).with.offset(0);
        make.left.equalTo(self.iconView.mas_right).with.offset(13);
    }];
    
    [self.deviceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).with.offset(0);
        make.bottom.equalTo(self.iconView.mas_bottom).with.offset(0);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_right).with.offset(4.5);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-24);
        make.centerY.equalTo(self.contentView);
    }];
}



#pragma mark - setters and getters

-(void)setHealthModel:(FLYHealthModel *)healthModel
{
    _healthModel = healthModel;
    
    
    NSDate * date = [FLYTime stringToDateWithString:healthModel.createTime dateFormat:(FLYDateFormatTypeYMDHMS)];
    
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString * string = [dateFormat stringFromDate:date];
    
    healthModel.createTime = string;
    
    
    self.titleLabel.text = healthModel.healthTypeName;
    self.timeLabel.text = healthModel.createTime;
    self.deviceLabel.text = healthModel.deviceTypeDesc;
    self.unitLabel.text = healthModel.unit;
    
    
    if ( healthModel.healthType == 6 )
    {
        self.contentLabel.text = [NSString stringWithFormat:@"%@/%@", healthModel.healthValue2, healthModel.healthValue];
    }
    else
    {
        self.contentLabel.text = healthModel.healthValue;
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
    
    
    switch ( healthModel.healthType )
    {
        case 1:
        {
            self.iconView.image = IMAGENAME(@"xinlv_39");
        }
            break;
            
        case 2:
        {
            self.iconView.image = IMAGENAME(@"huxi_39");
        }
            break;
            
        case 3:
        {
            self.iconView.image = IMAGENAME(@"xuetang_39");
        }
            break;
            
        case 4:
        {
            self.iconView.image = IMAGENAME(@"tiwen_39");
        }
            break;
            
        case 5:
        {
            self.iconView.image = IMAGENAME(@"xueyang_39");
        }
            break;
            
        case 6:
        {
            self.iconView.image = IMAGENAME(@"xueya_39");
        }
            break;
            
        default:
            break;
    }
    
    [self makeConstraints];
}

- (UIImageView *)iconView
{
    if( _iconView == nil )
    {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_M(14);
        _titleLabel.textColor = COLORHEX(@"#333333");
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if( _contentLabel == nil )
    {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = FONT_M(14);
        _contentLabel.textColor = COLORHEX(@"#333333");
    }
    return _contentLabel;
}

- (UILabel *)unitLabel
{
    if( _unitLabel == nil )
    {
        _unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unitLabel.font = FONT_R(11);
        _unitLabel.textColor = COLORHEX(@"#999999");
    }
    return _unitLabel;
}

- (UILabel *)timeLabel
{
    if( _timeLabel == nil )
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = FONT_R(11);
        _timeLabel.textColor = COLORHEX(@"#999999");
    }
    return _timeLabel;
}

- (UILabel *)deviceLabel
{
    if( _deviceLabel == nil )
    {
        _deviceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _deviceLabel.font = FONT_R(11);
        _deviceLabel.textColor = COLORHEX(@"#999999");
    }
    return _deviceLabel;
}

- (UILabel *)statusLabel
{
    if( _statusLabel == nil )
    {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = FONT_R(14);
        _statusLabel.textColor = COLORHEX(@"#2BB9A0");
    }
    return _statusLabel;
}



@end
