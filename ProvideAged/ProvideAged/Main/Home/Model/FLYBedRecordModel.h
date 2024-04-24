//
//  FLYBedRecordModel.h
//  ProvideAged
//
//  Created by fly on 2021/11/29.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYBedRecordModel : FLYModel

@property (nonatomic, assign) NSInteger beds;
@property (nonatomic, strong) NSString * bedsDesc;
@property (nonatomic, strong) NSString * blood;
@property (nonatomic, assign) NSInteger breath;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, assign) NSInteger dbq;
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, assign) NSInteger heart;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger oxygen;
@property (nonatomic, assign) NSInteger sbq;
@property (nonatomic, strong) NSString * temperature;

@end

NS_ASSUME_NONNULL_END
