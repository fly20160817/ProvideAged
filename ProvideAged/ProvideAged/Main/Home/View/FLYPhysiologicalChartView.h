//
//  FLYPhysiologicalChartView.h
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import <UIKit/UIKit.h>
#import "FLYHealthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYPhysiologicalChartView : UIView

@property (nonatomic, strong) FLYHealthModel * healthModel;
@property (nonatomic, strong) NSArray<FLYHealthModel *> * healthModels;
@property (nonatomic, copy) void(^weekBlock)(void);
@property (nonatomic, copy) void(^monthBlock)(void);

@end

NS_ASSUME_NONNULL_END
