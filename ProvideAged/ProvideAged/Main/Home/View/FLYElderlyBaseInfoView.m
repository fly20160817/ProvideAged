//
//  FLYElderlyBaseInfoView.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYElderlyBaseInfoView.h"
#import "FLYCircularView.h"

@interface FLYElderlyBaseInfoView ()

@property (nonatomic, strong) FLYCircularView * oximetryView;
@property (nonatomic, strong) FLYCircularView * pressureView;
@property (nonatomic, strong) FLYCircularView * temperatureView;

@property (nonatomic, strong) UIView * line1View;
@property (nonatomic, strong) UIView * line2View;

@property (nonatomic, strong) NSArray * circularViewList;

@end

@implementation FLYElderlyBaseInfoView

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
    
    CGFloat spacing = (self.width - 20 * 2 - self.height * 3 - 1 * 2) / 4.0;
    
    [self.oximetryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(self.height, self.height));
    }];
    
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(14);
        make.bottom.equalTo(self).with.offset(-14);
        make.left.equalTo(self.oximetryView.mas_right).with.offset(spacing);
        make.width.mas_equalTo(1);
    }];
    
    [self.pressureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.line1View.mas_right).with.offset(spacing);
        make.size.mas_equalTo(CGSizeMake(self.height, self.height));
    }];
    
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(14);
        make.bottom.equalTo(self).with.offset(-14);
        make.left.equalTo(self.pressureView.mas_right).with.offset(spacing);
        make.width.mas_equalTo(1);
    }];
    
    [self.temperatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.line2View.mas_right).with.offset(spacing);
        make.size.mas_equalTo(CGSizeMake(self.height, self.height));
    }];
}



#pragma mark - UI

- (void)initUI
{
    [self addSubview:self.oximetryView];
    [self addSubview:self.line1View];
    [self addSubview:self.pressureView];
    [self addSubview:self.line2View];
    [self addSubview:self.temperatureView];
}



#pragma mark - event handler

- (void)actionClick:(UIView *)view
{
    FLYHealthModel * healthModel = self.healthList[view.tag];
    
    !self.clickBlock ?: self.clickBlock(healthModel);
}



#pragma mark - setters and getters

-(void)setHealthList:(NSArray<FLYHealthModel *> *)healthList
{
    _healthList = healthList;
    
    if ( healthList.count < 3 )
    {
        return;
    }
    
    for ( int i = 0; i < 3; i++ )
    {
        FLYHealthModel * healthModel = healthList[i];
        
        FLYCircularView * view = self.circularViewList[i];
        view.title = healthModel.healthTypeName;
        view.unit = healthModel.unit;
        view.content = healthModel.healthValue;
        if ( healthModel.healthType == 6 )
        {
            view.content = [NSString stringWithFormat:@"%@/%@", healthModel.healthValue2, healthModel.healthValue];
        }
        else
        {
            view.content = healthModel.healthValue;
        }
        
        
        switch ( healthModel.healthType )
        {
            case 1:
            {

                view.iconName = @"shouye_xueye";
            }
                break;
                
            case 2:
            {
                view.iconName = @"shouye_huxi";
            }
                break;
                
            case 3:
            {
                view.iconName = @"shouye_xuetang";
            }
                break;
                
            case 4:
            {
                view.iconName = @"shouye_tiwen";
            }
                break;
                
            case 5:
            {
                view.iconName = @"shouye_xueyang";
            }
                break;
                
            case 6:
            {
                view.iconName = @"shouye_xueya";
            }
                break;
                
            default:
                break;
        }
        
    }
}

- (FLYCircularView *)oximetryView
{
    if( _oximetryView == nil )
    {
        _oximetryView = [[FLYCircularView alloc] init];
        _oximetryView.tag = 0;
        [_oximetryView addTarget:self action:@selector(actionClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _oximetryView;
}

- (FLYCircularView *)pressureView
{
    if( _pressureView == nil )
    {
        _pressureView = [[FLYCircularView alloc] init];
        _pressureView.tag = 1;
        [_pressureView addTarget:self action:@selector(actionClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _pressureView;
}

- (FLYCircularView *)temperatureView
{
    if( _temperatureView == nil )
    {
        _temperatureView = [[FLYCircularView alloc] init];
        _temperatureView.tag = 2;
        [_temperatureView addTarget:self action:@selector(actionClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _temperatureView;
}

- (UIView *)line1View
{
    if( _line1View == nil )
    {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    }
    return _line1View;
}

- (UIView *)line2View
{
    if( _line2View == nil )
    {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    }
    return _line2View;
}

-(NSArray *)circularViewList
{
    if ( _circularViewList == nil )
    {
        _circularViewList = @[self.oximetryView, self.pressureView, self.temperatureView];
    }
    return _circularViewList;
}

@end
