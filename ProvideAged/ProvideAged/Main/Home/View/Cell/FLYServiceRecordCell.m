//
//  FLYPersonalBaseInfoCell.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYServiceRecordCell.h"
#import "FLYButton.h"
#import "FLYDeviceManager.h"

@interface FLYServiceRecordCell ()

@property (nonatomic, strong) UIView * colorView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * nameTLabel;
@property (nonatomic, strong) FLYButton * nameBtn;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UILabel * remarkTLabel;
@property (nonatomic, strong) UILabel * remarkCLabel;

@end

@implementation FLYServiceRecordCell

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
    
    [self.contentView addSubview:self.colorView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.nameTLabel];
    [self.contentView addSubview:self.nameBtn];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.remarkTLabel];
    [self.contentView addSubview:self.remarkCLabel];
    

    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(20);
        make.left.equalTo(self.contentView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(1.5, 20));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.colorView.mas_right).with.offset(6);
        make.centerY.equalTo(self.colorView);
        make.width.mas_equalTo(100);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-24);
        make.centerY.equalTo(self.colorView);
    }];
    
    [self.nameTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(22);
        make.left.equalTo(self.contentView).with.offset(25);
        make.width.mas_equalTo(100);
    }];
    
    [self.nameBtn sizeToFit];
    [self.nameBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-23);
        make.centerY.equalTo(self.nameTLabel);
        make.width.mas_equalTo(self.nameBtn.width + 5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTLabel.mas_bottom).with.offset(15);
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.remarkTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(15);
        make.left.equalTo(self.contentView).with.offset(25);
    }];
    
    [self.remarkCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkTLabel.mas_bottom).with.offset(12);
        make.left.equalTo(self.contentView).with.offset(25);
        make.right.equalTo(self.contentView).with.offset(-25);
        make.bottom.equalTo(self.contentView).with.offset(-20);
    }];
}



#pragma mark - event handler

- (void)callClick:(UIButton *)button
{
    [FLYDeviceManager callPhone:self.serviceModel.doctorPhone];
}



#pragma mark - setters and getters

-(void)setServiceModel:(FLYServiceModel *)serviceModel
{
    _serviceModel = serviceModel;
    
    self.titleLabel.text = serviceModel.serviceContent;
    self.timeLabel.text = serviceModel.serviceDate;
    [self.nameBtn setTitle:serviceModel.doctorName forState:(UIControlStateNormal)];
    self.remarkCLabel.text = serviceModel.serviceRemark;
    
    [self makeConstraints];
}

- (UIView *)colorView
{
    if( _colorView == nil )
    {
        _colorView = [[UIView alloc] init];
        _colorView.layer.cornerRadius = 0.8;
        _colorView.backgroundColor = COLORHEX(@"#2BB9A0");
    }
    return _colorView;
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

- (UILabel *)timeLabel
{
    if( _timeLabel == nil )
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = FONT_R(12);
        _timeLabel.textColor = COLORHEX(@"#999999");
    }
    return _timeLabel;
}

- (UILabel *)nameTLabel
{
    if( _nameTLabel == nil )
    {
        _nameTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameTLabel.font = FONT_R(12);
        _nameTLabel.textColor = COLORHEX(@"#333333");
        _nameTLabel.text = @"服务医生";
    }
    return _nameTLabel;
}

-(FLYButton *)nameBtn
{
    if ( _nameBtn == nil )
    {
        _nameBtn = [FLYButton buttonWithImage:IMAGENAME(@"dianhua16") title:@"姓名" titleColor:COLORHEX(@"#999999") font:FONT_R(12)];
        
        [_nameBtn setImagePosition:(FLYImagePositionRight) spacing:5];
        [_nameBtn addTarget:self action:@selector(callClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nameBtn;
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

- (UILabel *)remarkTLabel
{
    if( _remarkTLabel == nil )
    {
        _remarkTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _remarkTLabel.font = FONT_R(12);
        _remarkTLabel.textColor = COLORHEX(@"#333333");
        _remarkTLabel.text = @"备注";
    }
    return _remarkTLabel;
}

- (UILabel *)remarkCLabel
{
    if( _remarkCLabel == nil )
    {
        _remarkCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _remarkCLabel.font = FONT_R(12);
        _remarkCLabel.textColor = COLORHEX(@"#999999");
    }
    return _remarkCLabel;
}



@end
