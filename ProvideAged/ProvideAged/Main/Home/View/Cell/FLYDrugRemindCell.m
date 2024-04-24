//
//  FLYDrugRemindCell.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYDrugRemindCell.h"

@interface FLYDrugRemindCell ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UILabel * title1Label;
@property (nonatomic, strong) UILabel * content1Label;
@property (nonatomic, strong) UILabel * title2Label;
@property (nonatomic, strong) UILabel * content2Label;
@property (nonatomic, strong) UILabel * title3Label;
@property (nonatomic, strong) UILabel * content3Label;
@property (nonatomic, strong) UILabel * title4Label;
@property (nonatomic, strong) UILabel * content4Label;
@property (nonatomic, strong) UILabel * title5Label;
@property (nonatomic, strong) UILabel * content5Label;
@property (nonatomic, strong) UILabel * title6Label;
@property (nonatomic, strong) UILabel * content6Label;
@property (nonatomic, strong) UILabel * content6_1Label;

@property (nonatomic, strong) UISwitch * sw;
@property (nonatomic, strong) UIButton * deleteBtn;

@end

@implementation FLYDrugRemindCell

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
    
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.contentView addSubview:self.title1Label];
    [self.contentView addSubview:self.content1Label];
    [self.contentView addSubview:self.title2Label];
    [self.contentView addSubview:self.content2Label];
    [self.contentView addSubview:self.title3Label];
    [self.contentView addSubview:self.content3Label];
    [self.contentView addSubview:self.title4Label];
    [self.contentView addSubview:self.content4Label];
    [self.contentView addSubview:self.title5Label];
    [self.contentView addSubview:self.content5Label];
    [self.contentView addSubview:self.title6Label];
    [self.contentView addSubview:self.content6Label];
    [self.contentView addSubview:self.content6_1Label];
    
    [self.contentView addSubview:self.sw];
    [self.contentView addSubview:self.deleteBtn];
    
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.left.equalTo(self.contentView).with.offset(16);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(47);
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.title1Label sizeToFit];
    [self.title1Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(self.title1Label.width);
    }];

    [self.content1Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title1Label);
        make.left.equalTo(self.title1Label.mas_right).offset(0);
    }];
    
    [self.title2Label sizeToFit];
    [self.title2Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView.mas_centerX).offset(20);
        make.width.mas_equalTo(self.title2Label.width);
    }];

    [self.content2Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title2Label);
        make.left.equalTo(self.title2Label.mas_right).offset(0);
    }];
    
    [self.title3Label sizeToFit];
    [self.title3Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title1Label.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(self.title3Label.width);
    }];

    [self.content3Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title3Label);
        make.left.equalTo(self.title3Label.mas_right).offset(0);
    }];
    
    [self.title4Label sizeToFit];
    [self.title4Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title2Label.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_centerX).offset(20);
        make.width.mas_equalTo(self.title4Label.width);
    }];

    [self.content4Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title4Label);
        make.left.equalTo(self.title4Label.mas_right).offset(0);
    }];
    
    [self.title5Label sizeToFit];
    [self.title5Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title3Label.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(self.title5Label.width);
    }];

    [self.content5Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title5Label);
        make.left.equalTo(self.title5Label.mas_right).offset(0);
    }];
    
    [self.title6Label sizeToFit];
    [self.title6Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title4Label.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_centerX).offset(20);
        make.width.mas_equalTo(self.title6Label.width);
    }];

    [self.content6Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title6Label);
        make.left.equalTo(self.title6Label.mas_right).offset(0);
    }];
    
    [self.content6_1Label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title6Label.mas_bottom).offset(4);
        make.left.equalTo(self.title6Label.mas_left).offset(0);
    }];
    
    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(-16);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(84, 32));
    }];
    
    [self.sw mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.deleteBtn.mas_centerY);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
}



#pragma mark - event handler

- (void)switchClick:(UISwitch *)sw
{
    !self.switchBlock ?: self.switchBlock(self.model, sw.isOn);
}

- (void)deleteClick:(UIButton *)button
{
    !self.deleteBlock ?: self.deleteBlock(self.model);
}



#pragma mark - setters and getters

-(void)setModel:(FLYDrugRemindModel *)model
{
    _model = model;
    
    
    self.nameLabel.text = model.drugsName;
    
    if( model.medicationInterval == 0 )
    {
        self.content1Label.text = @"每日";
    }
    else if( model.medicationInterval == 1 )
    {
        self.content1Label.text = @"隔日";
    }
    else if( model.medicationInterval == 7 )
    {
        self.content1Label.text = @"隔7日";
    }
    else if( model.medicationInterval == 20 )
    {
        self.content1Label.text = @"隔20日";
    }
    else
    {
        self.content1Label.text = @"";
    }
    self.content2Label.text = [NSString stringWithFormat:@"%ld", (long)model.dose];
    self.content3Label.text = model.specs;
    self.content4Label.text = model.startTime;
    NSInteger day = model.duration;
    if( model.durationType == 1 )
    {
        day = model.duration;
    }
    else if( model.durationType == 2 )
    {
        day = model.duration * 30;
    }
    else if( model.durationType == 3 )
    {
        day = model.duration * 365;
    }
    self.content5Label.text = [NSString stringWithFormat:@"%ld/%ld天", (long)model.medicationDays, (long)day];
    self.content6Label.text = model.timePoint1;
    self.content6_1Label.text = model.timePoint2;
    self.sw.on = model.isUsed == 1 ? YES : NO;
    
    [self makeConstraints];
}

- (UILabel *)nameLabel
{
    if( _nameLabel == nil )
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT_R(14);
        _nameLabel.textColor = COLORHEX(@"#666666");
    }
    return _nameLabel;
}

- (UIView *)lineView
{
    if( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORHEX(@"#F7F5F5");
    }
    return _lineView;
}


- (UILabel *)title1Label
{
    if( _title1Label == nil )
    {
        _title1Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _title1Label.font = FONT_R(12);
        _title1Label.textColor = COLORHEX(@"#B4B8BB");
        _title1Label.text = @"服药间隔：";
    }
    return _title1Label;
}

- (UILabel *)content1Label
{
    if( _content1Label == nil )
    {
        _content1Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _content1Label.font = FONT_R(12);
        _content1Label.textColor = COLORHEX(@"#333333");
    }
    return _content1Label;
}

- (UILabel *)title2Label
{
    if( _title2Label == nil )
    {
        _title2Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _title2Label.font = FONT_R(12);
        _title2Label.textColor = COLORHEX(@"#B4B8BB");
        _title2Label.text = @"服药剂量：";
    }
    return _title2Label;
}

- (UILabel *)content2Label
{
    if( _content2Label == nil )
    {
        _content2Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _content2Label.font = FONT_R(12);
        _content2Label.textColor = COLORHEX(@"#333333");
    }
    return _content2Label;
}

- (UILabel *)title3Label
{
    if( _title3Label == nil )
    {
        _title3Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _title3Label.font = FONT_R(12);
        _title3Label.textColor = COLORHEX(@"#B4B8BB");
        _title3Label.text = @"药品规格：";
    }
    return _title3Label;
}

- (UILabel *)content3Label
{
    if( _content3Label == nil )
    {
        _content3Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _content3Label.font = FONT_R(12);
        _content3Label.textColor = COLORHEX(@"#333333");
    }
    return _content3Label;
}

- (UILabel *)title4Label
{
    if( _title4Label == nil )
    {
        _title4Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _title4Label.font = FONT_R(12);
        _title4Label.textColor = COLORHEX(@"#B4B8BB");
        _title4Label.text = @"起始时间：";
    }
    return _title4Label;
}

- (UILabel *)content4Label
{
    if( _content4Label == nil )
    {
        _content4Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _content4Label.font = FONT_R(12);
        _content4Label.textColor = COLORHEX(@"#333333");
    }
    return _content4Label;
}

- (UILabel *)title5Label
{
    if( _title5Label == nil )
    {
        _title5Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _title5Label.font = FONT_R(12);
        _title5Label.textColor = COLORHEX(@"#B4B8BB");
        _title5Label.text = @"持续时间：";
    }
    return _title5Label;
}

- (UILabel *)content5Label
{
    if( _content5Label == nil )
    {
        _content5Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _content5Label.font = FONT_R(12);
        _content5Label.textColor = COLORHEX(@"#333333");
    }
    return _content5Label;
}

- (UILabel *)title6Label
{
    if( _title6Label == nil )
    {
        _title6Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _title6Label.font = FONT_R(12);
        _title6Label.textColor = COLORHEX(@"#B4B8BB");
        _title6Label.text = @"服药时间点：";
    }
    return _title6Label;
}

- (UILabel *)content6Label
{
    if( _content6Label == nil )
    {
        _content6Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _content6Label.font = FONT_R(12);
        _content6Label.textColor = COLORHEX(@"#333333");
    }
    return _content6Label;
}

- (UILabel *)content6_1Label
{
    if( _content6_1Label == nil )
    {
        _content6_1Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _content6_1Label.font = FONT_R(12);
        _content6_1Label.textColor = COLORHEX(@"#333333");
    }
    return _content6_1Label;
}

-(UISwitch *)sw
{
    if ( _sw == nil )
    {
        _sw = [[UISwitch alloc] init];
        [_sw addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _sw;
}

- (UIButton *)deleteBtn
{
    if( _deleteBtn == nil )
    {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除提醒" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:COLORHEX(@"#31BBA3") forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = FONT_R(14);
        _deleteBtn.layer.cornerRadius = 16;
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        _deleteBtn.layer.borderWidth = 0.5;
        _deleteBtn.layer.borderColor = COLORHEX(@"#31BBA3").CGColor;
        [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}


@end
