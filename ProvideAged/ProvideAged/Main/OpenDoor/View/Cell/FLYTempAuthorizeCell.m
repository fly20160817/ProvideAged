//
//  FLYTempAuthorizeCell.m
//  ProvideAged
//
//  Created by fly on 2021/12/24.
//

#import "FLYTempAuthorizeCell.h"

@interface FLYTempAuthorizeCell ()

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIImageView * relationIconView;
@property (nonatomic, strong) UILabel * relationLabel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UILabel * nameTLabel;
@property (nonatomic, strong) UILabel * nameCLabel;
@property (nonatomic, strong) UILabel * phoneTLabel;
@property (nonatomic, strong) UILabel * phoneCLabel;
@property (nonatomic, strong) UIImageView * passwordIconView;
@property (nonatomic, strong) UIImageView * cardIconView;

@end

@implementation FLYTempAuthorizeCell

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
    self.contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.contentView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0,3);
    self.contentView.layer.shadowOpacity = 1;
    self.contentView.layer.shadowRadius = 12;
    self.contentView.layer.cornerRadius = 10;
    
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.relationIconView];
    [self.contentView addSubview:self.relationLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.nameTLabel];
    [self.contentView addSubview:self.nameCLabel];
    [self.contentView addSubview:self.phoneTLabel];
    [self.contentView addSubview:self.phoneCLabel];
    [self.contentView addSubview:self.passwordIconView];
    [self.contentView addSubview:self.cardIconView];
    
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [self.relationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    
    [self.relationIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.relationLabel.mas_left).with.offset(-5.5);
        make.centerY.equalTo(self.relationLabel.mas_centerY);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(42);
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.nameTLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(14);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [self.nameCLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(14);
        make.left.equalTo(self.nameTLabel.mas_right).with.offset(10);
    }];
    
    [self.phoneTLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTLabel.mas_bottom).with.offset(11);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [self.phoneCLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTLabel.mas_bottom).with.offset(11);
        make.left.equalTo(self.phoneTLabel.mas_right).with.offset(10);
    }];
    
    [self.cardIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(29);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    
    [self.passwordIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(29);
        if ( self.cardIconView.hidden )
        {
            make.right.equalTo(self.contentView).with.offset(-15);
        }
        else
        {
            make.right.equalTo(self.cardIconView.mas_left).with.offset(-27);
        }
    }];
}



#pragma mark - setters and getters

-(void)setAuthorizeModel:(FLYAuthorizeModel *)authorizeModel
{
    _authorizeModel = authorizeModel;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@~%@", authorizeModel.startTime, authorizeModel.endTime];
    self.nameCLabel.text = authorizeModel.name;
    self.phoneCLabel.text = authorizeModel.phone;
    self.relationLabel.text = authorizeModel.typeDesc;
    self.cardIconView.hidden = [authorizeModel.openTypeList containsObject:@(3)] ? NO : YES;
    self.passwordIconView.hidden = [authorizeModel.openTypeList containsObject:@(1)] ? NO : YES;
    
    [self makeConstraints];
}

-(void)setOpenRecordModel:(FLYOpenRecordModel *)openRecordModel
{
    _openRecordModel = openRecordModel;
    
    self.timeLabel.text = openRecordModel.openTime;
    self.nameCLabel.text = openRecordModel.name;
    self.phoneCLabel.text = openRecordModel.phone;
    self.relationLabel.text = openRecordModel.typeDesc;
    self.passwordIconView.hidden = YES;
    
    if ( openRecordModel.openType == 1 )
    {
        self.cardIconView.image = IMAGENAME(@"liebiao_mima");
    }
    else if ( openRecordModel.openType == 2 )
    {
        //指纹暂时没有图片，如果以后有图片了，图片直接用"liebiao_zhiwen"命名
        self.cardIconView.image = IMAGENAME(@"liebiao_zhiwen");
    }
    else if ( openRecordModel.openType == 3 )
    {
        self.cardIconView.image = IMAGENAME(@"liebiao_ic");
    }
    else if ( openRecordModel.openType == 4 )
    {
        self.cardIconView.image = IMAGENAME(@"liebiao_lanya");
    }
    
    if ( openRecordModel.type == 1 )
    {
        self.relationIconView.image = IMAGENAME(@"guanxi_laoren");
    }
    else if ( openRecordModel.type == 2 )
    {
        self.relationIconView.image = IMAGENAME(@"guanxi_jiashu");
    }
    else if ( openRecordModel.type == 3 )
    {
        self.relationIconView.image = IMAGENAME(@"guanxi_linshi");
    }
    
    [self makeConstraints];
}

- (UILabel *)timeLabel
{
    if( _timeLabel == nil )
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = FONT_R(13);
        _timeLabel.textColor = COLORHEX(@"#333333");
    }
    return _timeLabel;
}

- (UIImageView *)relationIconView
{
    if( _relationIconView == nil )
    {
        _relationIconView = [[UIImageView alloc] init];
        _relationIconView.image = IMAGENAME(@"guanxi_jiashu");
    }
    return _relationIconView;
}

- (UILabel *)relationLabel
{
    if( _relationLabel == nil )
    {
        _relationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _relationLabel.font = FONT_R(14);
        _relationLabel.textColor = COLORHEX(@"#2BB9A0");
        _relationLabel.text = @"亲属";
    }
    return _relationLabel;
}

- (UIView *)lineView
{
    if( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORHEX(@"#F1F1F1");
    }
    return _lineView;
}

- (UILabel *)nameTLabel
{
    if( _nameTLabel == nil )
    {
        _nameTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameTLabel.font = FONT_R(15);
        _nameTLabel.textColor = COLORHEX(@"#666666");
        _nameTLabel.text = @"授权人：";
    }
    return _nameTLabel;
}

- (UILabel *)nameCLabel
{
    if( _nameCLabel == nil )
    {
        _nameCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameCLabel.font = FONT_R(15);
        _nameCLabel.textColor = COLORHEX(@"#333333");
    }
    return _nameCLabel;
}

- (UILabel *)phoneTLabel
{
    if( _phoneTLabel == nil )
    {
        _phoneTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneTLabel.font = FONT_R(15);
        _phoneTLabel.textColor = COLORHEX(@"#666666");
        _phoneTLabel.text = @"手机号：";
    }
    return _phoneTLabel;
}

- (UILabel *)phoneCLabel
{
    if( _phoneCLabel == nil )
    {
        _phoneCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneCLabel.font = FONT_R(15);
        _phoneCLabel.textColor = COLORHEX(@"#333333");
    }
    return _phoneCLabel;
}

- (UIImageView *)passwordIconView
{
    if( _passwordIconView == nil )
    {
        _passwordIconView = [[UIImageView alloc] init];
        _passwordIconView.image = IMAGENAME(@"liebiao_mima");
    }
    return _passwordIconView;
}

- (UIImageView *)cardIconView
{
    if( _cardIconView == nil )
    {
        _cardIconView = [[UIImageView alloc] init];
        _cardIconView.image = IMAGENAME(@"liebiao_ic");
    }
    return _cardIconView;
}



@end
