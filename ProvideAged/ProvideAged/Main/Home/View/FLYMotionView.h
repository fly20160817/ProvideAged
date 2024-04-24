//
//  FLYMotionView.h
//  ProvideAged
//
//  Created by fly on 2021/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYMotionView : UIView

@property (nonatomic, strong) NSString * step;
@property (nonatomic, strong) NSString * distance;

@property (nonatomic, copy) void(^moreBlock)(void);

@end

NS_ASSUME_NONNULL_END
