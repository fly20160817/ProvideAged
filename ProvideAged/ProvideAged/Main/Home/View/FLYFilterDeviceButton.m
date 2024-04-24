//
//  FLYFilterDeviceButton.m
//  ProvideAged
//
//  Created by fly on 2021/9/9.
//

#import "FLYFilterDeviceButton.h"

@interface FLYFilterDeviceButton ()

@property (nonatomic, strong) UIView * redDotView;

@end

@implementation FLYFilterDeviceButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self).with.offset(-2);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 32) / 2.0, 0, 32, 32);
}


-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 40, contentRect.size.width, 12);
}



#pragma mark - UI

- (void)initUI
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.redDotView];
}



#pragma mark - setters and getters

-(void)setNewStatus:(BOOL)newStatus
{
    _newStatus = newStatus;
    
    self.redDotView.hidden = !newStatus;
}

-(UIView *)redDotView
{
    if ( _redDotView == nil )
    {
        _redDotView = [[UIView alloc] init];
        _redDotView.backgroundColor = COLORHEX(@"#FF443F");
        _redDotView.layer.cornerRadius = 2;
        _redDotView.hidden = YES;
    }
    return _redDotView;
}

@end
