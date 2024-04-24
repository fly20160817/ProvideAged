//
//  FLYDeviceStatusView.h
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYDeviceStatusView : UIView

@property (nonatomic, strong) NSString * total;
@property (nonatomic, strong) NSString * online;
@property (nonatomic, strong) NSString * alarm;
@property (nonatomic, assign) BOOL newStatus;

@property (nonatomic, copy) void(^moreBlock)(void);

@end

NS_ASSUME_NONNULL_END
