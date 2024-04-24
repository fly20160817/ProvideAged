//
//  FLYOpenDoorResultView.h
//  ProvideAged
//
//  Created by fly on 2022/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FLYOpenDoorStatus)
{
    FLYOpenDoorStatusFailure = 0,  //开门失败
    FLYOpenDoorStatusSuccess = 1,  //开门成功
};

@interface FLYOpenDoorResultView : UIView

@property (nonatomic, assign) FLYOpenDoorStatus status;

@end

NS_ASSUME_NONNULL_END
