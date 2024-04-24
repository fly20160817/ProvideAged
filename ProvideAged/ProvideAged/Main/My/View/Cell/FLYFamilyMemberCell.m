//
//  FLYFamilyMemberCell.m
//  ProvideAged
//
//  Created by fly on 2021/9/10.
//

#import "FLYFamilyMemberCell.h"

@interface FLYFamilyMemberCell ()

@property (nonatomic, strong) UILabel * nameTLabel;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * phoneNumTLable;
@property (nonatomic, strong) UILabel * phoneNumLable;
@property (nonatomic, strong) UILabel * relationshipTLabel;
@property (nonatomic, strong) UILabel * relationshipLabel;
@property (nonatomic, strong) FLYButton * typeView;

@end

@implementation FLYFamilyMemberCell

-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 20;
    frame.size.width -= 40;
    
    [super setFrame:frame];
}

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
    
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,3);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 12;
    self.layer.cornerRadius = 10;
    
    
    [self.contentView addSubview:self.nameTLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneNumTLable];
    [self.contentView addSubview:self.phoneNumLable];
    [self.contentView addSubview:self.relationshipTLabel];
    [self.contentView addSubview:self.relationshipLabel];
    [self.contentView addSubview:self.typeView];
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.nameTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(16);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(16);
        make.left.equalTo(self.contentView).with.offset(100);
    }];
 
    [self.phoneNumTLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [self.phoneNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(100);
    }];
    
    [self.relationshipTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(-16);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [self.relationshipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(-16);
        make.left.equalTo(self.contentView).with.offset(100);
    }];
    
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
}



#pragma mark - getters and getters

-(void)setMemberModel:(FLYMemberModel *)memberModel
{
    _memberModel = memberModel;
    
    self.nameLabel.text = memberModel.name;
    self.phoneNumLable.text = memberModel.phone;
    self.relationshipLabel.text = memberModel.relationship;
    
    self.typeView.hidden = (memberModel.type == 1 || memberModel.type == 2) ? NO : YES;
    if ( memberModel.type == 1 )
    {
        [self.typeView setTitle:@"老人" forState:(UIControlStateNormal)];
        [self.typeView setImage:IMAGENAME(@"laoren") forState:UIControlStateNormal];
    }
    else if ( memberModel.type == 2 )
    {
        [self.typeView setTitle:@"管理员" forState:(UIControlStateNormal)];
        [self.typeView setImage:IMAGENAME(@"guanliyuan") forState:UIControlStateNormal];
    }
    
    [self makeConstraints];
}

-(UILabel *)nameTLabel
{
    if ( _nameTLabel == nil )
    {
        _nameTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameTLabel.font = FONT_R(15);
        _nameTLabel.textColor = COLORHEX(@"#666666");
        _nameTLabel.text = @"授权人：";
    }
    return _nameTLabel;
}

- (UILabel *)nameLabel
{
    if( _nameLabel == nil )
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT_R(15);
        _nameLabel.textColor = COLORHEX(@"#333333");
    }
    return _nameLabel;
}

-(UILabel *)phoneNumTLable
{
    if ( _phoneNumTLable == nil )
    {
        _phoneNumTLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneNumTLable.font = FONT_R(15);
        _phoneNumTLable.textColor = COLORHEX(@"#666666");
        _phoneNumTLable.text = @"手机号：";
    }
    return _phoneNumTLable;
}


- (UILabel *)phoneNumLable
{
    if( _phoneNumLable == nil )
    {
        _phoneNumLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneNumLable.font = FONT_R(15);
        _phoneNumLable.textColor = COLORHEX(@"#333333");
    }
    return _phoneNumLable;
}

-(UILabel *)relationshipTLabel
{
    if ( _relationshipTLabel == nil )
    {
        _relationshipTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _relationshipTLabel.font = FONT_R(15);
        _relationshipTLabel.textColor = COLORHEX(@"#666666");
        _relationshipTLabel.text = @"亲属关系：";
    }
    return _relationshipTLabel;
}

- (UILabel *)relationshipLabel
{
    if( _relationshipLabel == nil )
    {
        _relationshipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _relationshipLabel.font = FONT_R(15);
        _relationshipLabel.textColor = COLORHEX(@"#333333");
    }
    return _relationshipLabel;
}

-(FLYButton *)typeView
{
    if ( _typeView == nil )
    {
        _typeView = [FLYButton buttonWithImage:IMAGENAME(@"guanliyuan") title:@"管理员" titleColor:COLORHEX(@"#2BB9A0") font:FONT_R(14)];
        [_typeView setImagePosition:(FLYImagePositionLeft) spacing:6];
    }
    return _typeView;
}


@end
