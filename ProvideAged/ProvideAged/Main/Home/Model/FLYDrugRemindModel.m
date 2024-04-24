//
//  FLYDrugRemindModel.m
//  ProvideAged
//
//  Created by fly on 2022/12/29.
//

#import "FLYDrugRemindModel.h"

@implementation FLYDrugRemindModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{ @"remindDetailInfoVoList" : [FLYRemindDetailModel class]
    };
}

-(NSString *)timePoint1
{
    FLYRemindDetailModel * model = self.remindDetailInfoVoList.firstObject;
    
    return model.arrangeTypeDesc;
}

-(NSString *)timePoint2
{
    NSString * string = @"";
    
    for (int i = 1; i < self.remindDetailInfoVoList.count; i++)
    {
        FLYRemindDetailModel * model = self.remindDetailInfoVoList[i];
        
        if ( string.length == 0 )
        {
            string = model.arrangeTypeDesc;
        }
        else
        {
            string = [NSString stringWithFormat:@"%@ %@", string, model.arrangeTypeDesc];
        }
    }
    
    return string;
}

@end


@implementation FLYRemindDetailModel

@end
