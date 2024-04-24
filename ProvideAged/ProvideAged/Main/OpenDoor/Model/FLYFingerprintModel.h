//
//  FLYFingerprintModel.h
//  ProvideAged
//
//  Created by fly on 2023/9/12.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYFingerprintModel : FLYModel

@property (nonatomic, strong) NSString * batchId;
@property (nonatomic, strong) NSString * businessId;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * deviceInfoId;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, strong) NSString * houseInfoId;
@property (nonatomic, strong) NSString * icCardNo;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * lockPawId;
@property (nonatomic, strong) NSString * lockUserId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger openType;
@property (nonatomic, strong) NSObject * openTypeDesc;
@property (nonatomic, strong) NSObject * openTypeList;
@property (nonatomic, strong) NSObject * openTypeMergeStr;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * purpose;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * typeDesc;

@end

NS_ASSUME_NONNULL_END
