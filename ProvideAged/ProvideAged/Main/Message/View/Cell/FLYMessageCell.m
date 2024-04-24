//
//  FLYMessageCell.m
//  ProvideAged
//
//  Created by fly on 2021/9/10.
//

#import "FLYMessageCell.h"
#import "FLYButton.h"
#import "UIView+FLYLayoutConstraint.h"

@interface FLYMessageCell ()

@property (nonatomic, strong) UIView * redDotView;
@property (nonatomic, strong) UIImageView * typeIconView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * addressLable;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) FLYButton * callBtn;

@end

@implementation FLYMessageCell

-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 20;
    frame.size.width -= 40;
    
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,3);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 9;
    self.layer.cornerRadius = 4;
    
    
    [self.contentView addSubview:self.redDotView];
    [self.contentView addSubview:self.typeIconView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.addressLable];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.callBtn];
    
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(-2);
        make.left.equalTo(self.contentView).with.offset(-2);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
    
    [self.typeIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(22);
        make.left.equalTo(self.contentView).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.left.equalTo(self.typeIconView.mas_right).with.offset(10);
        make.height.mas_equalTo(13);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.left.equalTo(self.nameLabel.mas_right).with.offset(20);
    }];
    
    [self.nameLabel huggingPriority];
    [self.timeLabel compressionResistancePriority];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(40);
        make.right.equalTo(self.contentView.mas_right).with.offset(-17);
        make.height.mas_equalTo(12);
    }];
    
    
    [self.callBtn sizeToFit];
    [self.callBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(35);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        make.width.mas_equalTo(self.callBtn.width + 10);
    }];
        
    [self.addressLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.typeIconView.mas_right).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(-16);
        if(self.callBtn.hidden == YES )
        {
            make.right.equalTo(self.statusLabel.mas_left).with.offset(-10);
        }
        else
        {
            make.right.equalTo(self.callBtn.mas_left).with.offset(-10);
        }
    }];
    
    [self.addressLable huggingPriority];
    [self.statusLabel compressionResistancePriority];
}


#pragma mark - event handler

- (void)callClick:(UIButton *)button
{
    !self.callBlock ?: self.callBlock(self.messageModel);
}



#pragma mark - getters and getters

-(void)setMessageModel:(FLYMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    
    NSString * imageName = @"sos_24";
    
    switch (messageModel.deviceType)
    {
        case 1:
            imageName = @"sos_24";
            break;
            
        case 2:
            imageName = @"menci_24";
            break;
            
        case 3:
            imageName = @"yangan_24";
            break;
            
        case 4:
            imageName = @"ranqi_24";
            break;
            
        case 5:
            imageName = @"shuijin_24";
            break;
            
        case 6:
            imageName = @"gongwai_24";
            break;
            
        case 7:
            imageName = @"shouhuan_24";
            break;
            
        case 8:
            imageName = @"chuangdian_24";
            break;
            
        case 9:
            imageName = @"xuetangyi_24";
            break;
            
        case 10:
            imageName = @"yiyangka_24";
            break;
            
        case 11:
            imageName = @"xueyaji_24";
            break;
            
        case 12:
            imageName = @"mensuo_24";
            break;
            
        case 13:
            imageName = @"shexiangtou_24";
            break;
            
        case 14:
            imageName = @"leida_24";
            break;
            
        case 15:
            imageName = @"shengguang_24";
            break;
            
        default:
            break;
    }
    
    self.redDotView.hidden = messageModel.isRead == 2 ? NO : YES;
    self.typeIconView.image = IMAGENAME(imageName);
    self.nameLabel.text = messageModel.deviceName;
    self.addressLable.text = messageModel.businessName;
    self.timeLabel.text = messageModel.alarmTime;
    
    //报警状态(0=无、1=报警、2=防拆报警、3=电池低压、4=内部通讯异常、5=探测器故障、6=温度超上限报警、7=温度超下限报警、8=湿度超上限报警、9=湿度超下限报警、10=设备故障、11=无线信号弱、12=长时间开门、13=长时间关门、14=sos预警、15=跌倒预警、16=脱手预警、17=久坐预警、18=低电预警、19=家庭医生、20=房颤预警、21=开门、22=关门)
    if ( [self.messageModel.type containsString:@"警"] || [self.messageModel.type containsString:@"长时间"] || [self.messageModel.type containsString:@"紧急呼叫"] || ![self.messageModel.type containsString:@"低电"] )
    {
        self.callBtn.hidden = NO;
        self.statusLabel.hidden = YES;
        [self.callBtn setTitle:self.messageModel.type forState:(UIControlStateNormal)];
    }
    else
    {
        self.callBtn.hidden = YES;
        self.statusLabel.hidden = NO;
        self.statusLabel.text = self.messageModel.type;
    }
    
    
    [self makeConstraints];
}

- (UIView *)redDotView
{
    if( _redDotView == nil )
    {
        _redDotView = [[UIView alloc] init];
        _redDotView.backgroundColor = COLORHEX(@"#FF443F");
        _redDotView.layer.cornerRadius = 2;
    }
    return _redDotView;
}

- (UIImageView *)typeIconView
{
    if( _typeIconView == nil )
    {
        _typeIconView = [[UIImageView alloc] init];
    }
    return _typeIconView;
}

- (UILabel *)nameLabel
{
    if( _nameLabel == nil )
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT_M(13);
        _nameLabel.textColor = COLORHEX(@"#333333");
    }
    return _nameLabel;
}

- (UILabel *)addressLable
{
    if( _addressLable == nil )
    {
        _addressLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressLable.font = FONT_R(12);
        _addressLable.textColor = COLORHEX(@"#333333");
        _addressLable.numberOfLines = 0;
    }
    return _addressLable;
}

- (UILabel *)timeLabel
{
    if( _timeLabel == nil )
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = FONT_R(12);
        _timeLabel.textColor = COLORHEX(@"#999999");
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)statusLabel
{
    if( _statusLabel == nil )
    {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = FONT_M(12);
        _statusLabel.textColor = COLORHEX(@"#999999");
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (FLYButton *)callBtn
{
    if( _callBtn == nil )
    {
        _callBtn = [FLYButton buttonWithImage:IMAGENAME(@"hongdianhua_16") title:@"红外报警" titleColor:COLORHEX(@"#E17F7E")  font:FONT_M(12)];
        [_callBtn setImagePosition:(FLYImagePositionRight) spacing:10];
        [_callBtn addTarget:self action:@selector(callClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _callBtn;
}


@end
