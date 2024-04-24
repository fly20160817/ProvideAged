//
//  FLYDoorLockModel.m
//  ProvideAged
//
//  Created by fly on 2022/1/4.
//

#import "FLYDoorLockModel.h"

@implementation FLYDoorLockModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{ @"houseLockVoList" : [FLYOpenLockModel class]
    };
}

@end
