//
//  FLYTimePointView.h
//  ProvideAged
//
//  Created by fly on 2022/12/22.
//

#import <UIKit/UIKit.h>
#import "FLYBoxTimeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYTimePointView : UIView

@property (nonatomic, strong) NSArray<FLYBoxTimeModel *> * dataList;

@property (nonatomic, strong) NSArray<FLYBoxTimeModel *> * selectModels;

@end

NS_ASSUME_NONNULL_END
