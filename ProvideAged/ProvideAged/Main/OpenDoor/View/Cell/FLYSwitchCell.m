//
//  FLYSwitchCell.m
//  ProvideAged
//
//  Created by fly on 2021/12/27.
//

#import "FLYSwitchCell.h"

@interface FLYSwitchCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UISwitch * sw;
@property (nonatomic, strong) UIView * lineView;

@end

@implementation FLYSwitchCell

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
    [self.contentView addSubview:self.sw];
    [self.contentView addSubview:self.lineView];
}
    

- (void)makeConstraints
{
    [self.sw mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.centerY.equalTo(self.sw);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(1);
    }];

}



#pragma mark - event handler

- (void)switchClick:(UISwitch *)sw
{
    !self.switchBlock ?: self.switchBlock(self.switchModel);
}



#pragma mark - setters and getters

-(void)setSwitchModel:(FLYSwitchModel *)switchModel
{
    _switchModel = switchModel;
    
    self.titleLabel.text = switchModel.title;
    self.sw.on = switchModel.isOpen;
    self.lineView.hidden = !switchModel.showLine;
    
    
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

-(UISwitch *)sw
{
    if ( _sw == nil )
    {
        _sw = [[UISwitch alloc] init];
        _sw.onTintColor = COLORHEX(@"#2DB9A0");
        [_sw addTarget:self action:@selector(switchClick:) forControlEvents:(UIControlEventValueChanged)];
    }
    return _sw;
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



@implementation FLYSwitchModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.title = @"";
        self.showLine = YES;
        self.isEdit = YES;
    }
    return self;
}

@end
