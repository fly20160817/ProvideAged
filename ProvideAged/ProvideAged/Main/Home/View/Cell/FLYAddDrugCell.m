//
//  FLYAddDrugCell.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYAddDrugCell.h"

@interface FLYAddDrugCell () < UITextFieldDelegate >

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextField * textField;

@end

@implementation FLYAddDrugCell

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
    
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textField];
    
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(117);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
}



#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.model.content = textField.text;
}



#pragma mark - setters and getters

-(void)setModel:(FLYAddDrugModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.textField.text = model.content;
    self.textField.placeholder = model.placeholder;
    self.textField.enabled = model.isEditing;
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

-(UITextField *)textField
{
    if ( _textField == nil )
    {
        _textField = [[UITextField alloc] init];
        _textField.font = FONT_R(12);
        _textField.textColor = COLORHEX(@"#333333");
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }
    return _textField;
}

@end
