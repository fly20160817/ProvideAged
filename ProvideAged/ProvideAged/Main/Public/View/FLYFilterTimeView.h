//
//  FLYFilterTimeView.h
//  ProvideAged
//
//  Created by fly on 2021/9/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYFilterTimeView : UIView

@property (nonatomic, strong) NSString * title;

@property (nonatomic, copy) void(^confirmBlock)(NSString * startTime, NSString * endTime);

@end

NS_ASSUME_NONNULL_END
