//
//  FLYDeviceModel.m
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import "FLYDeviceModel.h"

@implementation FLYDeviceModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idField" : @"id",
             @"descriptionField" : @"description",
             };
}

@end
