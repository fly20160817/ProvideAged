//
//  FLYDoorLockModel.h
//  ProvideAged
//
//  Created by fly on 2022/1/4.
//

#import "FLYModel.h"
#import "FLYOpenLockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYDoorLockModel : FLYModel

@property (nonatomic, strong) NSArray<FLYOpenLockModel *> * houseLockVoList;
@property (nonatomic, strong) NSString * houseName;
@property (nonatomic, strong) NSString * idField;

@end

NS_ASSUME_NONNULL_END
