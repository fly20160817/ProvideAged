//
//  FLYElderlyMenuView.h
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYElderlyMenuView : UIView

@property (nonatomic, copy) void(^selectBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
