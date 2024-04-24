//
//  FLYButton.m
//  axz
//
//  Created by fly on 2021/3/19.
//

#import "FLYButton.h"

@interface FLYButton ()

@property (nonatomic, strong) UIColor * backgroundColor_normal;
@property (nonatomic, strong) UIColor * backgroundColor_highlighted;
@property (nonatomic, strong) UIColor * backgroundColor_disabled;
@property (nonatomic, strong) UIColor * backgroundColor_selected;

@property (nonatomic, strong) UIColor * borderColor_normal;
@property (nonatomic, strong) UIColor * borderColor_highlighted;
@property (nonatomic, strong) UIColor * borderColor_disabled;
@property (nonatomic, strong) UIColor * borderColor_selected;

@property (nonatomic, strong) UIFont * titleFont_normal;
@property (nonatomic, strong) UIFont * titleFont_highlighted;
@property (nonatomic, strong) UIFont * titleFont_disabled;
@property (nonatomic, strong) UIFont * titleFont_selected;


@property (nonatomic, assign) FLYImagePosition postion;
@property (nonatomic, assign) CGFloat spacing;

@end

@implementation FLYButton


#pragma mark - life cycle

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //防止设置的时候，没有赋值图片和文字，或者中间修改了图片和文字，所以在这里在在调用一下。
    [self setImagePosition:self.postion spacing:self.spacing];
}



#pragma mark - 状态变化

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
        
    if ( self.backgroundColor_selected )
    {
        self.backgroundColor = selected ? self.backgroundColor_selected : self.backgroundColor_normal;
    }
    
    if ( self.borderColor_selected )
    {
        self.layer.borderColor = selected ? self.borderColor_selected.CGColor : self.borderColor_normal.CGColor;
    }
    
    if ( self.titleFont_selected )
    {
        self.titleLabel.font = selected ? self.titleFont_selected : self.titleFont_normal;
    }
}

//当按钮高亮的时候，这个方法会被一直调用。
-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    
    
    if ( self.backgroundColor_highlighted )
    {
        self.backgroundColor = highlighted ? self.backgroundColor_highlighted : (self.selected ? self.backgroundColor_selected : self.backgroundColor_normal);
    }
    
    if ( self.borderColor_highlighted )
    {
        self.layer.borderColor = highlighted ? self.borderColor_highlighted.CGColor : (self.selected ? self.borderColor_selected.CGColor : self.borderColor_normal.CGColor);
    }
    
    if ( self.titleFont_highlighted )
    {
        self.titleLabel.font = highlighted ? self.titleFont_highlighted : (self.selected ? self.titleFont_selected : self.titleFont_normal);
    }
}

-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    
    if ( self.backgroundColor_disabled )
    {
        self.backgroundColor = enabled == NO ? self.backgroundColor_disabled : (self.selected ? self.backgroundColor_selected : self.backgroundColor_normal);
    }
    
    if ( self.borderColor_disabled )
    {
        self.layer.borderColor = enabled == NO ? self.borderColor_disabled.CGColor : (self.selected ? self.borderColor_selected.CGColor : self.borderColor_normal.CGColor);
    }
    
    if ( self.titleFont_disabled )
    {
        self.titleLabel.font = enabled == NO ? self.titleFont_disabled : (self.selected ? self.titleFont_selected : self.titleFont_normal);
    }
}



#pragma mark - 颜色

/** 设置不同状态的背景颜色 */
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    if ( self.state == state )
    {
        self.backgroundColor = color;
    }
    
    
    switch (state)
    {
        case UIControlStateNormal:
        {
            self.backgroundColor_normal = color;
        }
            break;
            
        case UIControlStateHighlighted:
        {
            self.backgroundColor_highlighted = color;
        }
            break;
            
        case UIControlStateDisabled:
        {
            self.backgroundColor_disabled = color;
        }
            break;
            
        case UIControlStateSelected:
        {
            self.backgroundColor_selected = color;
        }
            break;
            
        default:
            break;
    }
}


/** 设置不同状态的边框颜色 */
- (void)setBorderColor:(UIColor *)color forState:(UIControlState)state
{
    if ( self.state == state )
    {
        self.layer.borderColor = color.CGColor;
    }
    
    
    switch (state)
    {
        case UIControlStateNormal:
        {
            self.borderColor_normal = color;
        }
            break;
            
        case UIControlStateHighlighted:
        {
            self.borderColor_highlighted = color;
        }
            break;
            
        case UIControlStateDisabled:
        {
            self.borderColor_disabled = color;
        }
            break;
            
        case UIControlStateSelected:
        {
            self.borderColor_selected = color;
        }
            break;
            
        default:
            break;
    }
}

/** 设置不同状态的字体 */
- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state
{
    if ( self.state == state )
    {
        self.titleLabel.font = font;
    }
    
    
    switch (state)
    {
        case UIControlStateNormal:
        {
            self.titleFont_normal = font;
        }
            break;
            
        case UIControlStateHighlighted:
        {
            self.titleFont_highlighted = font;
        }
            break;
            
        case UIControlStateDisabled:
        {
            self.titleFont_disabled = font;
        }
            break;
            
        case UIControlStateSelected:
        {
            self.titleFont_selected = font;
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - 排版

/** 设置图片的 位置 和 与文字的间距 */
- (void)setImagePosition:(FLYImagePosition)postion spacing:(CGFloat)spacing
{
    /**
     *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    self.postion = postion;
    self.spacing = spacing;
    
    
    //文字和图片一人挪一半
    CGFloat spacing_half = spacing / 2.0;
    
    CGFloat imageView_W = self.imageView.frame.size.width;
    CGFloat imageView_H = self.imageView.frame.size.height;
    CGFloat titleLabel_W = self.titleLabel.frame.size.width;
    CGFloat titleLabel_H = self.titleLabel.frame.size.height;
    
    //image中心移动的x距离
    CGFloat imageOffsetX = (imageView_W + titleLabel_W) / 2 - imageView_W / 2;
    //image中心移动的y距离
    CGFloat imageOffsetY = imageView_H / 2 + spacing / 2;
    //label中心移动的x距离
    CGFloat labelOffsetX = (imageView_W + titleLabel_W / 2) - (imageView_W + titleLabel_W) / 2;
    //label中心移动的y距离
    CGFloat labelOffsetY = titleLabel_H / 2 + spacing / 2;
    
    
    //如果是上图下字，或着上字下图，titleLabel直接和button一样宽，x直接写0，x不需要设置EdgeInsets了
    if( postion == FLYImagePositionTop || postion == FLYImagePositionBottom )
    {
        labelOffsetX = 0;
        self.titleLabel.x = 0;
        self.titleLabel.width = self.width;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    
    
    
    switch (postion)
    {
        case FLYImagePositionLeft:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing_half, 0, -spacing_half);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing_half, 0, spacing_half);
        }
            break;
            
        case FLYImagePositionRight:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageView_W - spacing_half, 0, imageView_W + spacing_half);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleLabel_W + spacing_half, 0, -titleLabel_W - spacing_half);
        }
            break;
            
        case FLYImagePositionTop:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
        }
            break;
            
        case FLYImagePositionBottom:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
        }
            break;
            
        default:
            break;
    }
}


@end

