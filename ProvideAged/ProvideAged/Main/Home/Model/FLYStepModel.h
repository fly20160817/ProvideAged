//
//  FLYStepModel.h
//  ProvideAged
//
//  Created by fly on 2021/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYStepModel : NSObject

@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * oldManInfoId;
@property (nonatomic, assign) NSInteger pedometer;

@end

NS_ASSUME_NONNULL_END
