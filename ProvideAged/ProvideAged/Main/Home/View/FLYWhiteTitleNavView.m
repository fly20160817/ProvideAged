//
//  FLYWhiteTitleNavView.m
//  ProvideAged
//
//  Created by fly on 2022/12/21.
//

#import "FLYWhiteTitleNavView.h"

@interface FLYWhiteTitleNavView ()

@property (nonatomic, strong) UIButton * returnBtn;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation FLYWhiteTitleNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = COLORHEX(@"#31BBA3");
        
        [self addSubview:self.returnBtn];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(STATUSBAR_HEIGHT);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(49, NAVBAR_HEIGHT));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(STATUSBAR_HEIGHT);
        make.bottom.centerX.equalTo(self);
    }];
}



#pragma mark -event handler

- (void)returnClick:(UIButton *)button
{
    [[FLYTools currentViewController].navigationController popViewControllerAnimated:YES];
}



#pragma mark - setters and getters

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

-(UIButton *)returnBtn
{
    if ( _returnBtn == nil )
    {
        _returnBtn = [UIButton buttonWithImage:IMAGENAME(@"white_return")];
        [_returnBtn addTarget:self action:@selector(returnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _returnBtn;
}

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_M(16);
        _titleLabel.textColor = COLORHEX(@"#FFFFFF");
    }
    return _titleLabel;
}


@end
