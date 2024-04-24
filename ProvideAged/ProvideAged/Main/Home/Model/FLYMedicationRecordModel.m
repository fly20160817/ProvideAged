//
//  FLYMedicationRecordModel.m
//  ProvideAged
//
//  Created by fly on 2022/12/28.
//

#import "FLYMedicationRecordModel.h"

@implementation FLYMedicationRecordModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{ @"content" : [FLYDrugRecordModel class]
    };
}


-(NSString *)arrangeString
{
    NSString * string = @"";
    
    switch ( self.arrangeType )
    {
        case 1:
            string = @"晨起";
            break;
            
        case 2:
            string = @"早餐前";
            break;
            
        case 3:
            string = @"早餐后";
            break;
            
        case 4:
            string = @"午餐前";
            break;
            
        case 5:
            string = @"午餐后";
            break;
            
        case 6:
            string = @"晚餐前";
            break;
            
        case 7:
            string = @"晚餐后";
            break;
            
        case 8:
            string = @"睡前";
            break;
            
        default:
            break;
    }
    
    return string;
}


@end


@implementation FLYDrugRecordModel

@end
