//
//  FLYOpenDoorResultView.m
//  ProvideAged
//
//  Created by fly on 2022/1/5.
//

#import "FLYOpenDoorResultView.h"

@interface FLYOpenDoorResultView ()

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * label;

@end

@implementation FLYOpenDoorResultView

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
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(22.5);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-26);
        make.centerX.equalTo(self);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.cornerRadius = 10;
    
    
    [self addSubview:self.imageView];
    [self addSubview:self.label];
}



#pragma mark - setters and getters

-(void)setStatus:(FLYOpenDoorStatus)status
{
    _status = status;
    
    self.imageView.image = status == FLYOpenDoorStatusSuccess ? IMAGENAME(@"kaisuochenggong") : IMAGENAME(@"kaisuoshibai");
    self.label.text = status == FLYOpenDoorStatusSuccess ? @"开锁成功" : @"开锁失败";
}

- (UIImageView *)imageView
{
    if( _imageView == nil )
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)label
{
    if( _label == nil )
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = FONT_R(18);
        _label.textColor = COLORHEX(@"#333333");
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}


@end
