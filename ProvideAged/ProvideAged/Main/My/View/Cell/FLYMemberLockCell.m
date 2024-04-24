//
//  FLYMemberLockCell.m
//  ProvideAged
//
//  Created by fly on 2021/12/30.
//

#import "FLYMemberLockCell.h"

@interface FLYMemberLockCell ()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * modelLabel;

@end

@implementation FLYMemberLockCell

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
    self.contentView.layer.shadowColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:0.1].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0,4);
    self.contentView.layer.shadowOpacity = 1;
    self.contentView.layer.shadowRadius = 14;
    self.contentView.layer.cornerRadius = 5;
    
    
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.modelLabel];
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(23);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 27));
    }];
    
    [self.modelLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).with.offset(3);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-20);
    }];
}



#pragma mark - setters and getters

-(void)setHouseLockModel:(FLYHouseLockModel *)houseLockModel
{
    _houseLockModel = houseLockModel;
    
    self.modelLabel.text = houseLockModel.deviceName;
    
    [self makeConstraints];
}

- (UIImageView *)iconView
{
    if( _iconView == nil )
    {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = IMAGENAME(@"chengyuan_suo");
    }
    return _iconView;
}

- (UILabel *)modelLabel
{
    if( _modelLabel == nil )
    {
        _modelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _modelLabel.font = FONT_R(14);
        _modelLabel.textColor = COLORHEX(@"#333333");
        _modelLabel.textAlignment = NSTextAlignmentRight;
    }
    return _modelLabel;
}



@end
