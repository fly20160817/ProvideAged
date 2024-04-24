//
//  FLYDeviceStatusModel.m
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import "FLYDeviceStatusModel.h"

@implementation FLYDeviceStatusModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idField" : @"id",
             @"descriptionField" : @"description",
             };
}

@end
