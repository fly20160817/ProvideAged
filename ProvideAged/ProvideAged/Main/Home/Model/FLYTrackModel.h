//
//  FLYTrackModel.h
//  ProvideAged
//
//  Created by fly on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYTrackModel : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, strong) NSString * lat;
@property (nonatomic, strong) NSString * lon;
@property (nonatomic, strong) NSString * oldManInfoId;

@end

NS_ASSUME_NONNULL_END
