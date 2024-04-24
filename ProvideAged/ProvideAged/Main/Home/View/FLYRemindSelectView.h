//
//  FLYRemindSelectView.h
//  ProvideAged
//
//  Created by fly on 2022/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYRemindSelectView : UIView

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * contentId;

@property (nonatomic, copy) void(^clickBlock)(void);

@end

NS_ASSUME_NONNULL_END
