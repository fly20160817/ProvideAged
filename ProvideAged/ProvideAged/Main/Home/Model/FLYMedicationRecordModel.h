//
//  FLYMedicationRecordModel.h
//  ProvideAged
//
//  Created by fly on 2022/12/28.
//

#import "FLYModel.h"

@class FLYDrugRecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface FLYMedicationRecordModel : FLYModel

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * medicationDate;
@property (nonatomic, assign) NSInteger arrangeType;
@property (nonatomic, strong) NSString * arrangeTime;
@property (nonatomic, strong) NSArray<FLYDrugRecordModel *> * content;
@property (nonatomic, assign) NSInteger isMedication;// 是否服药   1已服药  2未服用  3漏服


@property (nonatomic, strong) NSString * arrangeString;

@end

@interface FLYDrugRecordModel : FLYModel

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * drugsName;
@property (nonatomic, strong) NSString * dose;

@end

NS_ASSUME_NONNULL_END
