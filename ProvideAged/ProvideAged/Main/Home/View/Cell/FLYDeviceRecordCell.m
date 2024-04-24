//
//  FLYDeviceRecordCell.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYDeviceRecordCell.h"
#import "UIView+FLYLayoutConstraint.h"

@interface FLYDeviceRecordCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * contentLabel;

@end

@implementation FLYDeviceRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    [self.contentView addSubview:self.contentLabel];
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(24);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-24);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentLabel huggingPriority];
    [self.titleLabel compressionResistancePriority];

}



#pragma mark - setters and getters

-(void)setModel:(FLYKeyValueModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.key;
    self.contentLabel.text = model.value;
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

- (UILabel *)contentLabel
{
    if( _contentLabel == nil )
    {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = FONT_R(12);
        _contentLabel.textColor = COLORHEX(@"#999999");
        _contentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _contentLabel;
}

@end


