//
//  FLYBoxTimeModel.h
//  ProvideAged
//
//  Created by fly on 2022/12/21.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYBoxTimeModel : FLYModel

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger arrangeType;
@property (nonatomic, strong) NSString * arrangeTypeDesc;
@property (nonatomic, strong) NSString * arrangeTime;
@property (nonatomic, strong) NSString * oldManInfoId;
@property (nonatomic, strong) NSString * deviceId;


@end

NS_ASSUME_NONNULL_END
