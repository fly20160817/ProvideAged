//
//  FLYDeviceLocationModel.h
//  ProvideAged
//
//  Created by fly on 2023/3/21.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYDeviceLocationModel : FLYModel

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, assign) NSInteger pedometer;

@end

NS_ASSUME_NONNULL_END
