//
//  FLYSelectCell.m
//  ProvideAged
//
//  Created by fly on 2021/12/27.
//

#import "FLYSelectCell.h"
#import "FLYTextField.h"
#import "UIView+FLYLayoutConstraint.h"

@interface FLYSelectCell () < UITextFieldDelegate >

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * arrowView;
@property (nonatomic, strong) FLYTextField * textField;
@property (nonatomic, strong) UIView * lineView;

@end

@implementation FLYSelectCell

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
    [self.contentView addSubview:self.arrowView];
    [self.contentView addSubview:self.lineView];
    
    [self makeConstraints];
}
    

- (void)makeConstraints
{

    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(44);
    }];
    
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.centerY.equalTo(self.textField);
        make.right.equalTo(self.textField.mas_left).with.offset(-10);
    }];
    
    [self.textField huggingPriority];
    [self.titleLabel compressionResistancePriority];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(1);
    }];

}



#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    !self.selectBlock ?: self.selectBlock(self.selectModel);
    return NO;
}



#pragma mark - setters and getters

-(void)setSelectModel:(FLYSelectModel *)selectModel
{
    _selectModel = selectModel;
    
    self.titleLabel.text = selectModel.title;
    self.textField.text = selectModel.selectTitle;
    self.textField.placeholder = selectModel.placeholder;
    self.lineView.hidden = !selectModel.showLine;
    self.textField.enabled = selectModel.isEdit;
    
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

-(UIImageView *)arrowView
{
    if ( _arrowView == nil )
    {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = IMAGENAME(@"home_genduo");
    }
    return _arrowView;
}

-(FLYTextField *)textField
{
    if ( _textField == nil )
    {
        _textField = [[FLYTextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = COLORHEX(@"#0E0E0E");
        _textField.font = FONT_M(13);
        _textField.rightViewMode = 32;
        _textField.delegate = self;
    }
    return _textField;
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



@implementation FLYSelectModel

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
