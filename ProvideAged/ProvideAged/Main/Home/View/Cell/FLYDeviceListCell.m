//
//  FLYPersonalBaseInfoCell.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYDeviceListCell.h"
#import "UIView+FLYLayoutConstraint.h"

@interface FLYDeviceListCell ()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * alarmLabel;
@property (nonatomic, strong) UILabel * modelTLabel;
@property (nonatomic, strong) UILabel * modelCLabel;
@property (nonatomic, strong) UILabel * statusTLabel;
@property (nonatomic, strong) UILabel * statusCLabel;

@end

@implementation FLYDeviceListCell

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
    
    
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.alarmLabel];
    [self.contentView addSubview:self.modelTLabel];
    [self.contentView addSubview:self.modelCLabel];
    [self.contentView addSubview:self.statusTLabel];
    [self.contentView addSubview:self.statusCLabel];
    
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.left.equalTo(self.contentView).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).with.offset(5);
        make.centerY.equalTo(self.iconView);
    }];
    
    [self.alarmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-24);
        make.centerY.equalTo(self.iconView);
    }];
    
    [self.nameLabel huggingPriority];
    [self.alarmLabel compressionResistancePriority];
    
    [self.modelTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).with.offset(15);
        make.left.equalTo(self.contentView).with.offset(24);
        make.width.mas_equalTo(100);
    }];
    
    [self.modelCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.modelTLabel.mas_right).with.offset(20);
        make.centerY.equalTo(self.modelTLabel);
        make.right.equalTo(self.contentView).with.offset(-24);
    }];
    
    [self.statusTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modelTLabel.mas_bottom).with.offset(6);
        make.left.equalTo(self.contentView).with.offset(24);
        make.width.mas_equalTo(100);
    }];
    
    [self.statusCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusTLabel.mas_right).with.offset(20);
        make.centerY.equalTo(self.statusTLabel);
        make.right.equalTo(self.contentView).with.offset(-24);
    }];
}



#pragma mark - setters and getters

-(void)setDeviceModel:(FLYDeviceModel *)deviceModel
{
    _deviceModel = deviceModel;
    
    
    NSString * imageName = @"";
    
    switch (deviceModel.type)
    {
        case 1:
            imageName = @"SOS_16";
            break;
            
        case 2:
            imageName = @"menci_16";
            break;
            
        case 3:
            imageName = @"yangan_16";
            break;
            
        case 4:
            imageName = @"ranqi_16";
            break;
            
        case 5:
            imageName = @"shuijin_16";
            break;
            
        case 6:
            imageName = @"hongwai_16";
            break;
            
        case 7:
            imageName = @"shouhuan_16";
            break;
            
        case 8:
            imageName = @"chuangdian_16";
            break;
            
        case 9:
            imageName = @"xuetangyi_16";
            break;
            
        case 10:
            imageName = @"yiyangka_16";
            break;
            
        case 11:
            imageName = @"xueya_16";
            break;
            
        case 12:
            imageName = @"mensuo_16";
            break;
            
        case 13:
            imageName = @"shexiangtou_16";
            break;
            
        default:
            break;
    }
    
    //warningStatus 报警状态(0=无、1=报警、2=防拆报警、3=电池低压、4=内部通讯异常、5=探测器故障、6=温度超上限报警、7=温度超下限报警、8=湿度超上限报警、9=湿度超下限报警、10=设备故障、11=无线信号弱、12=长时间开门、13=长时间关门、14=sos预警、15=跌倒预警、16=脱手预警、17=久坐预警、18=低电预警、19=家庭医生、20=房颤预警、21=开门、22=关门)
    
    self.iconView.image = IMAGENAME(imageName);
    self.nameLabel.text = deviceModel.name;
    self.alarmLabel.text = [deviceModel.warningStatusDesc isEqualToString:@"-"] ? @"" : deviceModel.warningStatusDesc;
    self.alarmLabel.textColor = [deviceModel.warningStatusDesc containsString:@"警"]
    ? COLORHEX(@"#E17F7E") : COLORHEX(@"#FFBB51");
    self.modelCLabel.text = deviceModel.model;
    self.statusCLabel.text = deviceModel.statusDesc;
    self.statusCLabel.textColor = deviceModel.status == 2 ? COLORHEX(@"#999999") : COLORHEX(@"#333333");
    
    
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

- (UILabel *)nameLabel
{
    if( _nameLabel == nil )
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT_M(12);
        _nameLabel.textColor = COLORHEX(@"#333333");
    }
    return _nameLabel;
}

- (UILabel *)alarmLabel
{
    if( _alarmLabel == nil )
    {
        _alarmLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _alarmLabel.font = FONT_M(12);
        _alarmLabel.textColor = COLORHEX(@"#E17F7E");
        _alarmLabel.textAlignment = NSTextAlignmentRight;
    }
    return _alarmLabel;
}

- (UILabel *)modelTLabel
{
    if( _modelTLabel == nil )
    {
        _modelTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _modelTLabel.font = FONT_M(12);
        _modelTLabel.textColor = COLORHEX(@"#999999");
        _modelTLabel.text = @"设备型号";
    }
    return _modelTLabel;
}

- (UILabel *)modelCLabel
{
    if( _modelCLabel == nil )
    {
        _modelCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _modelCLabel.font = FONT_M(12);
        _modelCLabel.textColor = COLORHEX(@"#333333");
        _modelCLabel.textAlignment = NSTextAlignmentRight;
    }
    return _modelCLabel;
}

- (UILabel *)statusTLabel
{
    if( _statusTLabel == nil )
    {
        _statusTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusTLabel.font = FONT_M(12);
        _statusTLabel.textColor = COLORHEX(@"#999999");
        _statusTLabel.text = @"设备状态";
    }
    return _statusTLabel;
}

- (UILabel *)statusCLabel
{
    if( _statusCLabel == nil )
    {
        _statusCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusCLabel.font = FONT_M(12);
        _statusCLabel.textColor = COLORHEX(@"#333333");
        _statusCLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusCLabel;
}



@end
