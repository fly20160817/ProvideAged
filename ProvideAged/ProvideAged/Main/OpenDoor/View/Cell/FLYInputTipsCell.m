//
//  FLYInputTipsCell.m
//  ProvideAged
//
//  Created by fly on 2021/12/27.
//

#import "FLYInputTipsCell.h"
#import "FLYTextField.h"
#import "UIView+FLYLayoutConstraint.h"

@interface FLYInputTipsCell () < UITextFieldDelegate >

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) FLYTextField * textField;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIImageView * tipsIconView;
@property (nonatomic, strong) UILabel * tipsLabel;

@end

@implementation FLYInputTipsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.tipsIconView];
    [self.contentView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.lineView];
    
    [self makeConstraints];
}
    

- (void)makeConstraints
{
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.centerY.equalTo(self.textField);
        make.right.equalTo(self.textField.mas_left).with.offset(-10);
    }];
    
    [self.textField huggingPriority];
    [self.titleLabel compressionResistancePriority];
    
    [self.tipsIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).with.offset(1);
        make.left.equalTo(self.contentView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).with.offset(0);
        make.left.equalTo(self.tipsIconView.mas_right).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-30);
        make.bottom.equalTo(self.contentView).with.offset(-15);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(1);
    }];

}



#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    !self.inputBlock ?: self.inputBlock(self.inputTipsModel, textField.text);
}



#pragma mark - setters and getters

-(void)setInputTipsModel:(FLYInputTipsModel *)inputTipsModel
{
    _inputTipsModel = inputTipsModel;
    
    self.titleLabel.text = inputTipsModel.title;
    self.textField.text = inputTipsModel.content;
    self.textField.placeholder = inputTipsModel.placeholder;
    self.tipsLabel.text = inputTipsModel.tips;
    self.lineView.hidden = !inputTipsModel.showLine;
    self.textField.enabled = inputTipsModel.isEdit;
    
    [self makeConstraints];
}

-(UILabel *)titleLabel
{
    if ( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT_M(13);
        _titleLabel.textColor = COLORHEX(@"#333333");
    }
    return _titleLabel;
}

-(FLYTextField *)textField
{
    if ( _textField == nil )
    {
        _textField = [[FLYTextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = COLORHEX(@"#0E0E0E");
        _textField.font = FONT_M(13);
        _textField.delegate = self;
    }
    return _textField;
}

-(UIImageView *)tipsIconView
{
    if ( _tipsIconView == nil )
    {
        _tipsIconView = [[UIImageView alloc] init];
        _tipsIconView.image = IMAGENAME(@"tips_13");
    }
    return _tipsIconView;
}

-(UILabel *)tipsLabel
{
    if ( _tipsLabel == nil )
    {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = FONT_R(11);
        _tipsLabel.textColor = COLORHEX(@"#999999");
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}

-(UIView *)lineView
{
    if ( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORHEX(@"#F1F1F1");
    }
    return _lineView;
}

@end



@implementation FLYInputTipsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.isEdit = YES;
        self.showLine = YES;
    }
    return self;
}

@end
