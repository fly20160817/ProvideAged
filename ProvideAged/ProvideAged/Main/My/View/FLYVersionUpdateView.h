//
//  FLYVersionUpdateView.h
//  ProvideAged
//
//  Created by fly on 2021/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYVersionUpdateView : UIView

//是否强制更新
@property (nonatomic, assign) BOOL isForcedUpdate;

@property (nonatomic, copy) void(^cancelBlock)(void);
@property (nonatomic, copy) void(^confirmBlock)(void);

@end

NS_ASSUME_NONNULL_END
