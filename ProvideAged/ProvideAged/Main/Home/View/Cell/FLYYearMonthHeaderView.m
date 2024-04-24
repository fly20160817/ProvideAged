//
//  FLYYearMonthHeaderView.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYYearMonthHeaderView.h"

@interface FLYYearMonthHeaderView ()

@property (nonatomic, strong) UIView * colorView;
@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) UIButton * arrowView;

@end

@implementation FLYYearMonthHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if ( self )
    {
        [self initUI];
    }
    
    return self;
}



#pragma mark - UI

- (void)initUI
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.contentView addGestureRecognizer:tap];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.colorView];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.arrowView];
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(3, 13));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(27);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(95);
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(7.5, 5.5));
    }];
}



#pragma makr - event handler

- (void)tapAction
{
    self.groupModel.isOpen = !self.groupModel.isOpen;
    
    !self.clickBlock ?: self.clickBlock(self.groupModel);
}



#pragma mark - setters and getters

-(void)setGroupModel:(FLYYearMonthGroupModel *)groupModel
{
    _groupModel = groupModel;
    
    self.arrowView.selected = !self.groupModel.isOpen;
    
    NSString * string = groupModel.date;
    
    NSDictionary * dic1 = @{ NSFontAttributeName : FONT_M(18), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"] };
    NSDictionary * dic2 = @{ NSFontAttributeName : FONT_R(9), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"] };
    

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    //range 手动计算也行， NSMakeRange(0, 2) 第几位开始，往后几位
    [attributedText addAttributes:dic1 range:NSMakeRange(0, string.length - 7)];
    [attributedText addAttributes:dic2 range:NSMakeRange(string.length - 7, 7)];
     
    self.dateLabel.attributedText = attributedText;
    
    
    [self makeConstraints];
}

- (UIView *)colorView
{
    if( _colorView == nil )
    {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = COLORHEX(@"#2BB9A0");
    }
    return _colorView;
}

- (UILabel *)dateLabel
{
    if( _dateLabel == nil )
    {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.font = FONT_R(9);
        _dateLabel.textColor = COLORHEX(@"#333333");
    }
    return _dateLabel;
}

- (UIButton *)arrowView
{
    if( _arrowView == nil )
    {
        _arrowView = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_arrowView setImage:IMAGENAME(@"sanjiao_shang") forState:(UIControlStateSelected)];
        [_arrowView setImage:IMAGENAME(@"sanjiao_xia") forState:(UIControlStateNormal)];
    }
    return _arrowView;
}


@end
