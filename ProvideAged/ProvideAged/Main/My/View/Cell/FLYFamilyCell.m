//
//  FLYFamilyCell.m
//  ProvideAged
//
//  Created by fly on 2021/9/10.
//

#import "FLYFamilyCell.h"
#import "UIView+FLYLayoutConstraint.h"

@interface FLYFamilyCell ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * addressLable;
@property (nonatomic, strong) UILabel * numberLabel;

@end

@implementation FLYFamilyCell

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
    
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.addressLable];
    [self.contentView addSubview:self.numberLabel];
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(16);
        make.left.equalTo(self.contentView).with.offset(20);
    }];
 
    [self.addressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView).with.offset(-17);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12);
    }];
}



#pragma mark - getters and getters

-(void)setFamilyModel:(FLYFamilyModel *)familyModel
{
    _familyModel = familyModel;
    
    
    NSString * string = [NSString stringWithFormat:@"%@ 的家庭", familyModel.name];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_M(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]} range:NSMakeRange(0, string.length - 3)];
    [attributedText addAttributes:@{NSFontAttributeName: FONT_R(12),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#666666"]} range:NSMakeRange(string.length - 3, 3)];
    self.nameLabel.attributedText = attributedText;
    
    
    self.addressLable.text = familyModel.houseAddress;
    
    self.numberLabel.text = [NSString stringWithFormat:@"共 %ld 人", (long)familyModel.familyCount];
    

    
    [self makeConstraints];
}

- (UILabel *)nameLabel
{
    if( _nameLabel == nil )
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _nameLabel;
}

- (UILabel *)addressLable
{
    if( _addressLable == nil )
    {
        _addressLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressLable.font = FONT_R(12);
        _addressLable.textColor = COLORHEX(@"#666666");
    }
    return _addressLable;
}

- (UILabel *)numberLabel
{
    if( _numberLabel == nil )
    {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.font = FONT_M(16);
        _numberLabel.textColor = COLORHEX(@"#2DB9A0");
    }
    return _numberLabel;
}


@end
