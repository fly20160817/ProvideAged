//
//  FLYPersonalHomeViewController.h
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYPersonalHomeViewController : FLYBaseViewController

@property (nonatomic, strong) NSString * oldManInfoId;

@property (nonatomic, copy) void(^refreshBlock)(void);

@end

NS_ASSUME_NONNULL_END
