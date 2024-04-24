//
//  FLYPhysiologicalCircleView.h
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import <UIKit/UIKit.h>
#import "FLYHealthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYPhysiologicalCircleView : UIView

@property (nonatomic, strong) FLYHealthModel * healthModel;
@property (nonatomic, copy) void(^historyBlock)(void);

@end

NS_ASSUME_NONNULL_END
