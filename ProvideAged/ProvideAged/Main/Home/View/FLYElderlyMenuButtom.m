//
//  FLYElderlyMenuButtom.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYElderlyMenuButtom.h"

@implementation FLYElderlyMenuButtom

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 44) / 2.0, 0, 44, 44);
}



-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 48) / 2.0, 52, 48, 12);
}

@end
