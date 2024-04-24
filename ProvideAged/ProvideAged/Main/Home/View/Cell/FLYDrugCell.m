//
//  FLYDrugCell.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYDrugCell.h"

@interface FLYDrugCell ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UILabel * brandTLabel;
@property (nonatomic, strong) UILabel * brandLabel;
@property (nonatomic, strong) UILabel * specsTLabel;
@property (nonatomic, strong) UILabel * specsLabel;
@property (nonatomic, strong) UILabel * numberTLabel;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UIButton * addBtn;
@property (nonatomic, strong) UIButton * deleteBtn;

@end

@implementation FLYDrugCell

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
    
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.brandTLabel];
    [self.contentView addSubview:self.brandLabel];
    [self.contentView addSubview:self.specsTLabel];
    [self.contentView addSubview:self.specsLabel];
    [self.contentView addSubview:self.numberTLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.addBtn];
    [self.contentView addSubview:self.deleteBtn];
    
    
    [self makeConstraints];
    
}

- (void)makeConstraints
{
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(20);
        make.left.equalTo(self.contentView).with.offset(16);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(47);
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.brandTLabel sizeToFit];
    [self.brandTLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(self.brandTLabel.width);
    }];

    [self.brandLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.brandTLabel);
        make.left.equalTo(self.brandTLabel.mas_right).offset(0);
    }];
    
    [self.specsTLabel sizeToFit];
    [self.specsTLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView.mas_centerX).offset(20);
        make.width.mas_equalTo(self.specsTLabel.width);
    }];

    [self.specsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.specsTLabel);
        make.left.equalTo(self.specsTLabel.mas_right).offset(0);
    }];
    
    [self.numberTLabel sizeToFit];
    [self.numberTLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.brandTLabel.mas_bottom).offset(12);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(self.numberTLabel.width);
    }];

    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.numberTLabel);
        make.left.equalTo(self.numberTLabel.mas_right).offset(0);
    }];
    
    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(-16);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(84, 32));
    }];
    
    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(-16);
        make.right.equalTo(self.deleteBtn.mas_left).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(84, 32));
    }];
}



#pragma mark - event handler

- (void)addClick:(UIButton *)button
{
    !self.addBlock ?: self.addBlock(self.model);
}

- (void)deleteClick:(UIButton *)button
{
    !self.deleteBlock ?: self.deleteBlock(self.model);
}



#pragma mark - setters and getters

-(void)setModel:(FLYDrugModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.name;
    self.brandLabel.text = model.brand;
    self.specsLabel.text = model.specs;
    self.numberLabel.text = model.surplus;
    
    [self makeConstraints];
}


- (UILabel *)nameLabel
{
    if( _nameLabel == nil )
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT_R(14);
        _nameLabel.textColor = COLORHEX(@"#666666");
    }
    return _nameLabel;
}

- (UIView *)lineView
{
    if( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORHEX(@"#F7F5F5");
    }
    return _lineView;
}

- (UILabel *)brandTLabel
{
    if( _brandTLabel == nil )
    {
        _brandTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _brandTLabel.font = FONT_R(12);
        _brandTLabel.textColor = COLORHEX(@"#B4B8BB");
        _brandTLabel.text = @"品牌：";
    }
    return _brandTLabel;
}

- (UILabel *)brandLabel
{
    if( _brandLabel == nil )
    {
        _brandLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _brandLabel.font = FONT_R(12);
        _brandLabel.textColor = COLORHEX(@"#333333");
    }
    return _brandLabel;
}

- (UILabel *)specsTLabel
{
    if( _specsTLabel == nil )
    {
        _specsTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _specsTLabel.font = FONT_R(12);
        _specsTLabel.textColor = COLORHEX(@"#B4B8BB");
        _specsTLabel.text = @"规格：";
    }
    return _specsTLabel;
}

- (UILabel *)specsLabel
{
    if( _specsLabel == nil )
    {
        _specsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _specsLabel.font = FONT_R(12);
        _specsLabel.textColor = COLORHEX(@"#333333");
    }
    return _specsLabel;
}

- (UILabel *)numberTLabel
{
    if( _numberTLabel == nil )
    {
        _numberTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberTLabel.font = FONT_R(12);
        _numberTLabel.textColor = COLORHEX(@"#B4B8BB");
        _numberTLabel.text = @"剩余：";
    }
    return _numberTLabel;
}

- (UILabel *)numberLabel
{
    if( _numberLabel == nil )
    {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.font = FONT_R(12);
        _numberLabel.textColor = COLORHEX(@"#333333");
    }
    return _numberLabel;
}

- (UIButton *)addBtn
{
    if( _addBtn == nil )
    {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"补充药品" forState:UIControlStateNormal];
        [_addBtn setTitleColor:COLORHEX(@"#FFFFFF") forState:UIControlStateNormal];
        _addBtn.titleLabel.font = FONT_R(14);
        _addBtn.backgroundColor = [UIColor colorWithRed:49/255.0 green:187/255.0 blue:163/255.0 alpha:1.0];
        _addBtn.layer.cornerRadius = 16;
        [_addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)deleteBtn
{
    if( _deleteBtn == nil )
    {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除药品" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:COLORHEX(@"#31BBA3") forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = FONT_R(14);
        _deleteBtn.layer.cornerRadius = 16;
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        _deleteBtn.layer.borderWidth = 0.5;
        _deleteBtn.layer.borderColor = COLORHEX(@"#31BBA3").CGColor;
        [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}


@end
