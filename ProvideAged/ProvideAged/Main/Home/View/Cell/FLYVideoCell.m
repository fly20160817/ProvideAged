//
//  FLYVideoCell.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYVideoCell.h"

@interface FLYVideoCell ()

@property (nonatomic, strong) UIImageView * pictureView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * setupView;
@property (nonatomic, strong) UIImageView * arrowView;

@end

@implementation FLYVideoCell

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
    self.contentView.layer.shadowColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:0.15].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0,3);
    self.contentView.layer.shadowOpacity = 1;
    self.contentView.layer.shadowRadius = 14;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.pictureView];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.setupView];
    [self.contentView addSubview:self.arrowView];
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.pictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(180);
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictureView.mas_bottom).with.offset(18);
        make.left.equalTo(self.contentView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(15, 17));
    }];
    
    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-15);
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.setupView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowView.mas_left).with.offset(-20);
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).with.offset(10);
        make.right.equalTo(self.setupView.mas_left).with.offset(-20);
        make.centerY.equalTo(self.iconView.mas_centerY);
    }];
}



#pragma mark - setters and getters

-(void)setVideoModel:(FLYVideoModel *)videoModel
{
    _videoModel = videoModel;
    
    self.nameLabel.text = videoModel.name;
}

- (UIImageView *)pictureView
{
    if( _pictureView == nil )
    {
        _pictureView = [[UIImageView alloc] init];
        _pictureView.backgroundColor = [UIColor lightGrayColor];
    }
    return _pictureView;
}

- (UIImageView *)iconView
{
    if( _iconView == nil )
    {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = IMAGENAME(@"shexiangtou");
    }
    return _iconView;
}

- (UILabel *)nameLabel
{
    if( _nameLabel == nil )
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT_R(15);
        _nameLabel.textColor = COLORHEX(@"#666666");
    }
    return _nameLabel;
}

- (UIImageView *)setupView
{
    if( _setupView == nil )
    {
        _setupView = [[UIImageView alloc] init];
        _setupView.image = IMAGENAME(@"shexiangtou_shezhi");
    }
    return _setupView;
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
