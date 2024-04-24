//
//  DatePickerView.h
//  WatchHealth
//
//  Created by fly on 2022/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatePickerView : UIView

@property (nonatomic, copy) void(^dayBlock)(NSString * time);
@property (nonatomic, copy) void(^weekBlock)(NSString * startTime, NSString * endTime);
@property (nonatomic, copy) void(^confirmBlock)(void);

@end

NS_ASSUME_NONNULL_END
