//
//  FLYAuthorizeModel.h
//  ProvideAged
//
//  Created by fly on 2022/1/4.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYAuthorizeModel : FLYModel

@property (nonatomic, strong) NSString * batchId;
@property (nonatomic, strong) NSString * businessId;
@property (nonatomic, strong) NSString * deviceInfoId;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, strong) NSString * houseInfoId;
@property (nonatomic, strong) NSString * icCardNo;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger openType;
@property (nonatomic, strong) NSString * openTypeDesc;
@property (nonatomic, strong) NSArray * openTypeList;
@property (nonatomic, strong) NSString * openTypeMergeStr;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * purpose;
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * typeDesc;

@end

NS_ASSUME_NONNULL_END
