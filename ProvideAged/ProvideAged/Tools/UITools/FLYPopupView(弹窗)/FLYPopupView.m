//
//  FLYPopupView.m
//  axz
//
//  Created by fly on 2021/3/12.
//

#import "FLYPopupView.h"

@interface FLYPopupView () < UIGestureRecognizerDelegate >

/** 遮罩的颜色 */
@property (nonatomic, strong) UIColor * maskColor;
@property (nonatomic, strong) UIView * contentView;
/** 一定不能用window命名，不然会和UIView的window属性重名，
 会出现莫名其妙的问题，比如输入框无法输入 */
@property (nonatomic, strong) UIWindow * flyWindow;

@end

@implementation FLYPopupView

+ (instancetype)popupView
{
    FLYPopupView * view = [[FLYPopupView alloc] init];
    return view;
}

+ (instancetype)popupView:(UIView *)view
{
    return [self popupView:view animationType:FLYPopupAnimationTypeNone];
}

+ (instancetype)popupView:(UIView *)view animationType:(FLYPopupAnimationType)animationType
{
    return [self popupView:view animationType:animationType maskType:FLYPopupMaskTypeBlack];
}

+ (instancetype)popupView:(UIView *)view animationType:(FLYPopupAnimationType)animationType maskType:(FLYPopupMaskType)maskType
{
    FLYPopupView * popupView = [[FLYPopupView alloc] init];
    [popupView.contentView addSubview:view];
    popupView.animationType = animationType;
    popupView.maskType = maskType;
    return popupView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

//如果FLYPopupView不是全屏的，比如需要漏出导航栏部分，那么点击导航栏返回，FLYPopupView也不会消失。这里判断一下，如果没点在FLYPopupView上，就直接dissmiss。
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //转换坐标
    CGPoint tempPoint = [self convertPoint:point fromView:self];
    
    //判断点击的点不在自己的区域
    if (CGRectContainsPoint(self.bounds, tempPoint) == NO)
    {
        
        //是否消失
        BOOL isDissmiss = YES;
        
        //判断是否在不想dissmiss的数组里
        for ( UIView * view in self.noDissmissViews )
        {
            CGPoint temp1Point = [self convertPoint:point toView:view];
            if (CGRectContainsPoint(view.bounds, temp1Point) == YES)
            {
                isDissmiss = NO;
                break;
            }
        }
        
        if ( isDissmiss == YES )
        {
            //hitTest:方法会调用两次，所以dissmiss也调用两次，导致dissmiss动画失效。不过没影响，点击导航栏的时候就是让它秒消失，不是回到上一页后，它还没消失完。
            [self dissmiss];
        }
    }
    
    
    return [super hitTest:point withEvent:event];
}



#pragma mark - UI

- (void)initUI
{
    self.clipsToBounds = YES;
    
    self.interactionEnabled = YES;
    self.animationType = FLYPopupAnimationTypeNone;
    self.maskType = FLYPopupMaskTypeBlack;
    
    [self addSubview:self.contentView];
}



#pragma mark - UIGestureRecognizerDelegate

//是否开启手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if ( touch.view == self.contentView && self.interactionEnabled )
    {
        return YES;
    }
    
    return NO;
}



#pragma mark - public methods

- (void)show
{
    //判断是否正在显示
    if( [self isShowing] )
    {
        return;
    }
    
    //添加到窗口
    //[self.flyWindow addSubview:self];
    
    //添加到rootViewController的view上（因为添加到window上，如果有输入框可能会被键盘遮住，IQKeyboardManager无法解决window上的输入框被遮挡的问题)
    [self.flyWindow.rootViewController.view addSubview:self];

    //动画
    [self showAnimation];
}

- (void)dissmiss
{
    [self dissmissAnimation];
    
    !self.dissmissBlock ?: self.dissmissBlock();
}



#pragma mark - private methods

//判断是否正在显示
- (BOOL)isShowing
{
    for (UIView * view in self.flyWindow.rootViewController.view.subviews)
    {
        if ( [view isKindOfClass:[self class]] )
        {
            return YES;
        }
    }
    
    return NO;
}

//show动画
- (void)showAnimation
{
    if( self.animationType == FLYPopupAnimationTypeTop )
    {
        //初始状态
        self.backgroundColor = [UIColor clearColor];
        self.contentView.y = -self.contentView.height;
        
        //动画
        [UIView animateWithDuration:0.25 animations:^{
            
            self.backgroundColor = self.maskColor;
            self.contentView.y = 0;
        }];
    }
    else if( self.animationType == FLYPopupAnimationTypeLeft )
    {
        //初始状态
        self.backgroundColor = [UIColor clearColor];
        self.contentView.x = -self.contentView.width;
        
        //动画
        [UIView animateWithDuration:0.25 animations:^{
            
            self.backgroundColor = self.maskColor;
            self.contentView.x = 0;
        }];
    }
    else if( self.animationType == FLYPopupAnimationTypeRight )
    {
        //初始状态
        self.backgroundColor = [UIColor clearColor];
        self.contentView.x = self.contentView.width;
        
        //动画
        [UIView animateWithDuration:0.25 animations:^{
            
            self.backgroundColor = self.maskColor;
            self.contentView.x = 0;
        }];
    }
    else if( self.animationType == FLYPopupAnimationTypeBottom )
    {
        //初始状态
        self.backgroundColor = [UIColor clearColor];
        self.contentView.y = self.contentView.height;
        
        //动画
        [UIView animateWithDuration:0.25 animations:^{
            
            self.backgroundColor = self.maskColor;
            self.contentView.y = 0;
        }];
    }
    else if( self.animationType == FLYPopupAnimationTypeMiddle )
    {
        //初始状态
        self.backgroundColor = [UIColor clearColor];
        self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 0.7, 0.7);
        
        //动画
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundColor = self.maskColor;
            self.contentView.transform = CGAffineTransformIdentity;
        }];
    }
    else if( self.animationType == FLYPopupAnimationTypeCustom )
    {
        !self.customShowAnimationBlock ?: self.customShowAnimationBlock(self, self.contentView);
    }
}

//dissmiss动画
- (void)dissmissAnimation
{
    if( self.animationType == FLYPopupAnimationTypeTop )
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.backgroundColor = [UIColor clearColor];
            self.contentView.y = -self.contentView.height;
            
        }completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
    else if( self.animationType == FLYPopupAnimationTypeLeft )
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.backgroundColor = [UIColor clearColor];
            self.contentView.x = -self.contentView.width;
            
        }completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
    else if( self.animationType == FLYPopupAnimationTypeRight )
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.backgroundColor = [UIColor clearColor];
            self.contentView.x = self.contentView.width;
            
        }completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
    else if ( self.animationType == FLYPopupAnimationTypeBottom )
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.backgroundColor = [UIColor clearColor];
            self.contentView.y = self.contentView.height;
            
        }completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
    else if ( self.animationType == FLYPopupAnimationTypeMiddle )
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.backgroundColor = [UIColor clearColor];
            self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 0.7, 0.7);
            
        }completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
    else if ( self.animationType == FLYPopupAnimationTypeCustom )
    {
        self.customDissmissAnimationBlock ? self.customDissmissAnimationBlock(self, self.contentView) : [self removeFromSuperview];
    }
    else
    {
        [self removeFromSuperview];
    }
    
}



#pragma mark - setters and getter

-(void)setMaskType:(FLYPopupMaskType)maskType
{
    _maskType = maskType;
    
    if ( maskType == FLYPopupMaskTypeBlack )
    {
        self.maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    else if ( maskType == FLYPopupMaskTypeClear )
    {
        self.maskColor = [UIColor clearColor];
    }
    
    self.backgroundColor = self.maskColor;
}

-(UIView *)contentView
{
    if ( _contentView == nil )
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _contentView.backgroundColor = [UIColor clearColor];


        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)];
        tap.delegate = self;
        [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}

-(UIWindow *)flyWindow
{
    if ( _flyWindow == nil )
    {
        NSArray  *windows = [[UIApplication sharedApplication] windows];
        _flyWindow = windows.lastObject;
        for ( UIWindow * window in windows )
        {
            if ( window.isKeyWindow )
            {
                _flyWindow = window;
            }
        }
    }
    return _flyWindow;
}


@end

