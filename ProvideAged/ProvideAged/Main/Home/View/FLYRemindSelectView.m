//
//  FLYRemindSelectView.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYRemindSelectView.h"

@interface FLYRemindSelectView ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * contentLabel;

@end

@implementation FLYRemindSelectView

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
    
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(120);
        make.centerY.equalTo(self);
    }];
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
    
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
     [self addGestureRecognizer:tap];
}



#pragma mark - event handler

- (void)tapView
{
    !self.clickBlock ?: self.clickBlock();
}



#pragma mark - setters and getters

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

-(void)setContent:(NSString *)content
{
    _content = content;
    
    self.contentLabel.text = content;
}

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_R(12);
        _titleLabel.textColor = COLORHEX(@"#333333");
    }
    return _titleLabel;
}

-(UILabel *)contentLabel
{
    if( _contentLabel == nil )
    {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = FONT_R(12);
        _contentLabel.textColor = COLORHEX(@"#333333");
    }
    return _contentLabel;
}

@end
