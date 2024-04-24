//
//  FLYTrackViewController.h
//  ProvideAged
//
//  Created by fly on 2021/11/9.
//

#import "FLYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYTrackViewController : FLYBaseViewController

@property (nonatomic, strong) NSString * oldManInfoId;
@property (nonatomic, strong) NSString * deviceInfoId;
//查询日期：格式（yyyy.MM.dd）
@property (nonatomic, strong) NSString * searchDate;
@property (nonatomic, strong) NSString * step;
@property (nonatomic, strong) NSString * distance;

@end

NS_ASSUME_NONNULL_END
