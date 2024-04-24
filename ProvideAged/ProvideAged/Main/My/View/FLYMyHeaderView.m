//
//  FLYMyHeaderView.m
//  ProvideAged
//
//  Created by fly on 2021/9/10.
//

#import "FLYMyHeaderView.h"

@interface FLYMyHeaderView ()

@property (nonatomic, strong) UIImageView * avatarView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * phoneNumLabel;

@end

@implementation FLYMyHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(28);
        make.left.equalTo(self).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_top).with.offset(8);
        make.left.equalTo(self.avatarView.mas_right).with.offset(17);
    }];
    
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.avatarView.mas_right).with.offset(17);
    }];
    
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.avatarView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.phoneNumLabel];
}



#pragma mark - setters and getters

-(void)setAvatarUrlString:(NSString *)avatarUrlString
{
    _avatarUrlString = avatarUrlString;
    
}

-(void)setName:(NSString *)name
{
    _name = name;
    
    self.nameLabel.text = name;
}

-(void)setPhoneNum:(NSString *)phoneNum
{
    _phoneNum = phoneNum;
    
    self.phoneNumLabel.text = phoneNum;
}

- (UIImageView *)avatarView
{
    if( _avatarView == nil )
    {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.image = IMAGENAME(@"avatar");
    }
    return _avatarView;
}

- (UILabel *)nameLabel
{
    if( _nameLabel == nil )
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT_R(18);
        _nameLabel.textColor = COLORHEX(@"#333333");
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)phoneNumLabel
{
    if( _phoneNumLabel == nil )
    {
        _phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneNumLabel.font = FONT_R(12);
        _phoneNumLabel.textColor = COLORHEX(@"#666666");
        _phoneNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneNumLabel;
}



@end
