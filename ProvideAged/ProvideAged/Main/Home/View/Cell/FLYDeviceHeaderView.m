//
//  FLYDeviceHeaderView.m
//  ProvideAged
//
//  Created by fly on 2021/9/10.
//

#import "FLYDeviceHeaderView.h"

@interface FLYDeviceHeaderView ()

@property (nonatomic, strong) UIView * colorView;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation FLYDeviceHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if ( self )
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.colorView];
        [self.contentView addSubview:self.titleLabel];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.contentView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(2, 13));
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.colorView.mas_right).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-16.5);
        make.centerY.equalTo(self.colorView);
    }];
}



#pragma mark - setters and getters

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (UIView *)colorView
{
    if( _colorView == nil )
    {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = COLORHEX(@"#2BB9A0");
    }
    return _colorView;
}

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_R(15);
        _titleLabel.textColor = COLORHEX(@"#2BB9A0");
    }
    return _titleLabel;
}


@end
