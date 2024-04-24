//
//  FLYQueryListView.h
//  ProvideAged
//
//  Created by fly on 2022/12/22.
//

#import <UIKit/UIKit.h>
#import "FLYDrugModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYQueryListView : UIView

@property (nonatomic, strong) NSArray<FLYDrugModel *> * dataList;

@property (nonatomic, copy) void(^selectBlock)(FLYDrugModel *model);

@end

NS_ASSUME_NONNULL_END
