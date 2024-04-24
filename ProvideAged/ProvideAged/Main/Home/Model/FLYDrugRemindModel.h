//
//  FLYDrugRemindModel.h
//  ProvideAged
//
//  Created by fly on 2022/12/29.
//

#import "FLYModel.h"

@class FLYRemindDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface FLYDrugRemindModel : FLYModel

@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, assign) NSInteger dose;
@property (nonatomic, strong) NSString * drugsId;
@property (nonatomic, strong) NSString * drugsName;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger durationType;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger isUsed;
@property (nonatomic, assign) NSInteger medicationDays;
@property (nonatomic, assign) NSInteger medicationInterval;
@property (nonatomic, strong) NSString * oldManInfoId;
@property (nonatomic, strong) NSArray<FLYRemindDetailModel *> * remindDetailInfoVoList;
@property (nonatomic, strong) NSString * specs;
@property (nonatomic, strong) NSString * startTime;


@property (nonatomic, strong) NSString * timePoint1;
@property (nonatomic, strong) NSString * timePoint2;

@end


@interface FLYRemindDetailModel : FLYModel

@property (nonatomic, strong) NSString * arrangeTime;
@property (nonatomic, assign) NSInteger arrangeType;
@property (nonatomic, strong) NSString * arrangeTypeDesc;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * medicationRemindId;
@property (nonatomic, strong) NSString * workRestId;

@end

NS_ASSUME_NONNULL_END
