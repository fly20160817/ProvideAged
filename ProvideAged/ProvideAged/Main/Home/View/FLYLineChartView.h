//
//  FLYLineChartView.h
//  ProvideAged
//
//  Created by fly on 2021/11/15.
//

#import <UIKit/UIKit.h>
#import "FLYHealthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYLineChartView : UIView

@property (nonatomic, strong) UIColor * styleColor;
@property (nonatomic, strong) NSArray<FLYHealthModel *> * healthModels;

@end

NS_ASSUME_NONNULL_END
