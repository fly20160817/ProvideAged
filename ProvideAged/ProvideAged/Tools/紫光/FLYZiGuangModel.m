//
//  FLYZiGuangModel.m
//  ProvideAged
//
//  Created by fly on 2021/12/22.
//

#import "FLYZiGuangModel.h"

@implementation FLYZiGuangModel

-(NSString *)keyID
{
    NSString * string = [NSString stringWithFormat:@"%@%@", self.lockerSuperAdminId, self.lockerSuperAdminId];
    return string;
}

@end
