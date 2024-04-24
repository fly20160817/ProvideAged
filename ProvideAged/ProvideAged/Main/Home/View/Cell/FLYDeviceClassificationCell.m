//
//  FLYDeviceClassificationCell.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYDeviceClassificationCell.h"

@interface FLYDeviceClassificationCell ()

@property (nonatomic, strong) UIView * redDotView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subtitleLabel;
@property (nonatomic, strong) UILabel * numLabel;
@property (nonatomic, strong) UIImageView * arrowView;

@end

@implementation FLYDeviceClassificationCell

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
    
    
    [self.contentView addSubview:self.redDotView];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.arrowView];
    
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.redDotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(7, 7));
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(18);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).with.offset(8);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-57);
        make.top.equalTo(self.contentView).with.offset(25);
    }];
    
    [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.subtitleLabel.mas_centerX);
        make.top.equalTo(self.subtitleLabel.mas_bottom).with.offset(7);
    }];
}



#pragma mark - setters and getters

-(void)setModel:(FLYDeviceClassificationModel *)model
{
    _model = model;
    
    self.redDotView.hidden = !model.warning;
    self.iconView.image = IMAGENAME(model.iconName);
    self.titleLabel.text = model.title;
    self.numLabel.text = [NSString stringWithFormat:@"%@台", model.number];
    
    [self makeConstraints];
}

- (UIView *)redDotView
{
    if( _redDotView == nil )
    {
        _redDotView = [[UIView alloc] init];
        _redDotView.backgroundColor = COLORHEX(@"#FF443F");
        _redDotView.layer.cornerRadius = 7.0 / 2.0;
        _redDotView.layer.masksToBounds = YES;
    }
    return _redDotView;
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
        _titleLabel.font = FONT_R(15);
        _titleLabel.textColor = COLORHEX(@"#666666");
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if( _subtitleLabel == nil )
    {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.font = FONT_R(11);
        _subtitleLabel.textColor = COLORHEX(@"#999999");
        _subtitleLabel.text = @"设备总数";
    }
    return _subtitleLabel;
}

- (UILabel *)numLabel
{
    if( _numLabel == nil )
    {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numLabel.font = FONT_R(14);
        _numLabel.textColor = COLORHEX(@"#2DB9A0");
    }
    return _numLabel;
}

- (UIImageView *)arrowView
{
    if( _arrowView == nil )
    {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = IMAGENAME(@"home_genduo");
    }
    return _arrowView;
}


@end
