//
//  FLYOptionCell.m
//  ProvideAged
//
//  Created by fly on 2021/12/27.
//

#import "FLYOptionCell.h"

@interface FLYOptionCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * btnBaseView;
@property (nonatomic, strong) FLYButton * option1Btn;
@property (nonatomic, strong) FLYButton * option2Btn;
@property (nonatomic, strong) UIView * lineView;

@end

@implementation FLYOptionCell

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
    [self.contentView addSubview:self.btnBaseView];
    [self.contentView addSubview:self.option1Btn];
    [self.contentView addSubview:self.option2Btn];
    [self.contentView addSubview:self.lineView];
}
    

- (void)makeConstraints
{
    [self.btnBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(11);
        make.bottom.equalTo(self.contentView).with.offset(-11);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(115, 26));
    }];
    
    [self.option1Btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnBaseView.mas_top).with.offset(0);
        make.left.equalTo(self.btnBaseView.mas_left).with.offset(0);
        make.bottom.equalTo(self.btnBaseView.mas_bottom).with.offset(0);
        make.right.equalTo(self.btnBaseView.mas_centerX);
    }];
    
    [self.option2Btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnBaseView.mas_top).with.offset(0);
        make.left.equalTo(self.btnBaseView.mas_centerX).with.offset(0);
        make.bottom.equalTo(self.btnBaseView.mas_bottom).with.offset(0);
        make.right.equalTo(self.btnBaseView.mas_right);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.centerY.equalTo(self.btnBaseView);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(1);
    }];

}



#pragma mark - event handler

- (void)optionClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    if ( button == self.option1Btn )
    {
        self.optionModel.option1Select = button.selected;
    }
    else if ( button == self.option2Btn )
    {
        self.optionModel.option2Select = button.selected;
    }
    
    
    self.optionModel.option1Select = self.option1Btn.selected;
    self.optionModel.option2Select = self.option2Btn.selected;
    !self.optionBlock ?: self.optionBlock(self.optionModel);
}



#pragma mark - setters and getters

-(void)setOptionModel:(FLYOptionModel *)optionModel
{
    _optionModel = optionModel;
    
    self.titleLabel.text = optionModel.title;
    
    [self.option1Btn setTitle:optionModel.option1Title forState:(UIControlStateNormal)];
    [self.option2Btn setTitle:optionModel.option2Title forState:UIControlStateNormal];
    
    self.option1Btn.selected = optionModel.option1Select;
    self.option2Btn.selected = optionModel.option2Select;
    
    self.option1Btn.enabled = optionModel.isEdit;
    self.option2Btn.enabled = optionModel.isEdit;
    
    self.lineView.hidden = !optionModel.showLine;
    
    
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

-(UIView *)btnBaseView
{
    if ( _btnBaseView == nil )
    {
        _btnBaseView = [[UIView alloc] init];
        _btnBaseView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        _btnBaseView.layer.cornerRadius = 3;
    }
    return _btnBaseView;
}

-(FLYButton *)option1Btn
{
    if ( _option1Btn == nil )
    {
        _option1Btn = [FLYButton buttonWithTitle:@"" titleColor:COLORHEX(@"#333333") font:FONT_R(13)];
        [_option1Btn setTitleColor:COLORHEX(@"#FFFFFF") forState:(UIControlStateSelected)];
        [_option1Btn setBackgroundColor:[UIColor clearColor] forState:(UIControlStateNormal)];
        [_option1Btn setBackgroundColor:COLORHEX(@"#2BB9A0") forState:(UIControlStateSelected)];
        _option1Btn.layer.cornerRadius = 3;
        _option1Btn.tag = 0;
        [_option1Btn addTarget:self action:@selector(optionClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _option1Btn;
}

-(FLYButton *)option2Btn
{
    if ( _option2Btn == nil )
    {
        _option2Btn = [FLYButton buttonWithTitle:@"" titleColor:COLORHEX(@"#333333") font:FONT_R(13)];
        [_option2Btn setTitleColor:COLORHEX(@"#FFFFFF") forState:(UIControlStateSelected)];
        [_option2Btn setBackgroundColor:[UIColor clearColor] forState:(UIControlStateNormal)];
        [_option2Btn setBackgroundColor:COLORHEX(@"#2BB9A0") forState:(UIControlStateSelected)];
        _option2Btn.layer.cornerRadius = 3;
        _option2Btn.tag = 1;
        [_option2Btn addTarget:self action:@selector(optionClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _option2Btn;
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



@implementation FLYOptionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.title = @"";
        self.option1Title = @"";
        self.option2Title = @"";
        self.option1Select = NO;
        self.option2Select = NO;
        self.showLine = YES;
        self.isEdit = YES;
    }
    return self;
}

@end
