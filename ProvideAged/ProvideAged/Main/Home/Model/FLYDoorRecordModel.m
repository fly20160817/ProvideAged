//
//  FLYDoorRecordModel.m
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import "FLYDoorRecordModel.h"

@implementation FLYDoorRecordModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idField" : @"id",
             @"descriptionField" : @"description",
             };
}

@end
