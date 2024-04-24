//
//  FLYOpenDoorView.h
//  ProvideAged
//
//  Created by fly on 2021/12/23.
//

#import <UIKit/UIKit.h>
#import "FLYOpenLockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYOpenDoorView : UIView

@property (nonatomic, strong) FLYOpenLockModel * lockModel;
@property (nonatomic, copy) void(^openDoorBlock)(FLYOpenLockModel * lockModel);

@end

NS_ASSUME_NONNULL_END
