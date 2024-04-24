//
//  FLYLabel.m
//  FLYKit
//
//  Created by fly on 2021/9/2.
//

#import "FLYLabel.h"

@implementation FLYLabel


-(void)drawTextInRect:(CGRect)rect {

    /************ 设置边距 ***********/
    
    CGFloat x = rect.origin.x + self.textEdgeInset.left;
    CGFloat y = rect.origin.y + self.textEdgeInset.top;
    CGFloat width = rect.size.width - (self.textEdgeInset.left + self.textEdgeInset.right);
    CGFloat height = rect.size.height - (self.textEdgeInset.top + self.textEdgeInset.bottom);
    rect = CGRectMake(x, y, width, height);
    
    
    
    /************ 设置居上或居下 ***********/
    
    if ( self.textVerticalAlignment == FLYTextVerticalAlignmentTop )
    {
        rect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    }
    else if ( self.textVerticalAlignment == FLYTextVerticalAlignmentBottom )
    {
        CGRect newRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
        newRect.origin.y = rect.size.height - newRect.size.height;
        
        rect = newRect;
    }

    [super drawTextInRect:rect];
}


@end

