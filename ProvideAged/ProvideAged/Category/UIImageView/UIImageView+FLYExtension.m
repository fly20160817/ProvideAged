//
//  UIImageView+FLYExtension.m
//  FLYKit
//
//  Created by fly on 2021/8/27.
//

#import "UIImageView+FLYExtension.h"
#import <ImageIO/ImageIO.h>
#import <CoreText/CoreText.h>

/*
 ARC下需要手动管理内存的有(Core)
 CT开头,例如：CTRunRef
 CF开头,例如：CTFrameRef
 CG开头,例如：CGImageSourceRef
 */


@implementation UIImageView (FLYExtension)

//创建显示gif的UIImageView
+ (UIImageView *)imageViewWithGIFData:(NSData *)gifData frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    
    // GIF动画图片数组
    NSMutableArray *frames = nil;
    // 图像源引用
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    // 动画时长
    CGFloat animationTime = 0.f;
    
    if (src) {
        // 获取gif图片的帧数
        size_t count = CGImageSourceGetCount(src);
        // 实例化图片数组
        frames = [NSMutableArray arrayWithCapacity:count];
        
        for (size_t i = 0; i < count; i++) {
            // 获取指定帧图像
            CGImageRef image = CGImageSourceCreateImageAtIndex(src, i, NULL);
            
            // 获取GIF动画时长
            NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            
            if (image) {
                [frames addObject:[UIImage imageWithCGImage:image]];
                CGImageRelease(image);
            }
        }
        
        CFRelease(src);
    }
    
    [imageView setImage:[frames objectAtIndex:0]];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setAnimationImages:frames];
    [imageView setAnimationDuration:animationTime];
    [imageView startAnimating];
    
    return imageView;
}


@end
