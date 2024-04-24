//
//  FLYMyCell.m
//  ProvideAged
//
//  Created by fly on 2021/9/10.
//

#import "FLYMyCell.h"
#import "UIView+FLYLayoutConstraint.h"

@interface FLYMyCell ()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subtitleLabel;
@property (nonatomic, strong) UIImageView * arrowView;

@end

@implementation FLYMyCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.arrowView];
    
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.iconView.mas_right).with.offset(12);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.left.equalTo(self.titleLabel.mas_right).with.offset(20);
    }];
    
    [self.titleLabel compressionResistancePriority];
    [self.subtitleLabel huggingPriority];
    
}



#pragma mark - setters and getters

-(void)setMyModel:(FLYMyModel *)myModel
{
    _myModel = myModel;
    
    self.iconView.image = IMAGENAME(myModel.iconName);
    self.titleLabel.text = myModel.title;
    self.subtitleLabel.text = myModel.sutitle;
    
    self.arrowView.hidden = !myModel.isArrow;
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
        _titleLabel.textColor = COLORHEX(@"#333333");
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if( _subtitleLabel == nil )
    {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.font = FONT_M(12);
        _subtitleLabel.textColor = COLORHEX(@"#999999");
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subtitleLabel;
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
