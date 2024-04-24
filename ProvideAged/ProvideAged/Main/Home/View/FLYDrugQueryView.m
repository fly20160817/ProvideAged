//
//  FLYDrugQueryView.m
//  ProvideAged
//
//  Created by fly on 2022/12/21.
//

#import "FLYDrugQueryView.h"

@interface FLYDrugQueryView ()

@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation FLYDrugQueryView

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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(42);
    }];
    
    [self.specsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(12);
        make.left.equalTo(self).offset(22);
    }];
    
    [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(12);
        make.left.equalTo(self.mas_centerX).offset(0);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.specsLabel.mas_bottom).offset(8);
        make.left.equalTo(self).offset(22);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = COLORHEX(@"#31BBA3");
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    [self addSubview:self.specsLabel];
    [self addSubview:self.brandLabel];
    [self addSubview:self.numberLabel];
}



#pragma mark - event handler

- (void)tapView
{
    !self.showBlock ?: self.showBlock();
}



#pragma mark - setters and getters

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_R(15);
        _titleLabel.textColor = COLORHEX(@"#FFFFFF");
        _titleLabel.text = @"药品名称";
    }
    return _titleLabel;
}

-(FLYTextField *)textField
{
    if ( _textField == nil )
    {
        _textField = [[FLYTextField alloc] init];
        _textField.layer.cornerRadius = 5;
        _textField.backgroundColor = COLORHEX(@"#FFFFFF");
        _textField.font = FONT_R(13);
        _textField.placeholder = @"输入关键字查询";
        _textField.textLeftMargin = 15;
        _textField.textRightMargin = 40;
        _textField.rightImage = IMAGENAME(@"xiajiantou");
        _textField.rightViewRect = CGRectMake(15, 19, 9, 4);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        _textField.rightView.userInteractionEnabled = YES;
         [_textField.rightView addGestureRecognizer:tap];
    }
    return _textField;
}

- (UILabel *)specsLabel
{
    if( _specsLabel == nil )
    {
        _specsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _specsLabel.font = FONT_R(12);
        _specsLabel.textColor = COLORHEX(@"#FFFFFF");
        _specsLabel.text = @"规格：--";
    }
    return _specsLabel;
}

- (UILabel *)brandLabel
{
    if( _brandLabel == nil )
    {
        _brandLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _brandLabel.font = FONT_R(12);
        _brandLabel.textColor = COLORHEX(@"#FFFFFF");
        _brandLabel.text = @"品牌：--";
    }
    return _brandLabel;
}

- (UILabel *)numberLabel
{
    if( _numberLabel == nil )
    {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.font = FONT_R(12);
        _numberLabel.textColor = COLORHEX(@"#FFFFFF");
        _numberLabel.text = @"剩余：--";
    }
    return _numberLabel;
}



@end
