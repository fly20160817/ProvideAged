//
//  FLYMyModel.m
//  ProvideAged
//
//  Created by fly on 2021/9/10.
//

#import "FLYMyModel.h"

@implementation FLYMyModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.title = @"";
        self.sutitle = @"";
        self.iconName = @"";
        self.isArrow = NO;
        self.isLine = NO;
    }
    return self;
}

@end
