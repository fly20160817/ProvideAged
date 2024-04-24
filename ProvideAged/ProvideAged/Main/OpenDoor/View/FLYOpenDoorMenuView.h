//
//  FLYOpenDoorMenuView.h
//  ProvideAged
//
//  Created by fly on 2021/12/23.
//

#import <UIKit/UIKit.h>
#import "FLYOpenLockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYOpenDoorMenuView : UIView

@property (nonatomic, strong) FLYOpenLockModel * lockModel;
@property (nonatomic, copy) void(^menuBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
