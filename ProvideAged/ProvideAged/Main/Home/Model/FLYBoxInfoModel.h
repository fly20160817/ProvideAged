//
//  FLYBoxInfoModel.h
//  ProvideAged
//
//  Created by fly on 2022/12/28.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYBoxInfoModel : FLYModel

@property (nonatomic, strong) NSString * arrangeType;
@property (nonatomic, strong) NSString * medicationDate;
@property (nonatomic, strong) NSString * arrangeTime;
@property (nonatomic, strong) NSString * dose;
@property (nonatomic, strong) NSString * drugsName;

@end

NS_ASSUME_NONNULL_END
