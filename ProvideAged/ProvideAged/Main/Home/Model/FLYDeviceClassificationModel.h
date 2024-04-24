//
//  FLYDeviceClassificationModel.h
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYDeviceClassificationModel : NSObject

@property (nonatomic, strong) NSString * iconName;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * number;
@property (nonatomic, assign) BOOL warning;

@end

NS_ASSUME_NONNULL_END
