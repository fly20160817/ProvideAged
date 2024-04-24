//
//  FLYFilterDeviceView.h
//  ProvideAged
//
//  Created by fly on 2021/9/9.
//

#import <UIKit/UIKit.h>
#import "FLYDeviceStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYFilterDeviceView : UIView

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSArray<FLYDeviceStatusModel *> * deviceStatusList;

@property (nonatomic, copy) void(^selectBlock)(NSString * idField);

@end

NS_ASSUME_NONNULL_END
