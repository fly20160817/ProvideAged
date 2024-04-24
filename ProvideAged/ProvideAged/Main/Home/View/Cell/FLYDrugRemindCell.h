//
//  FLYDrugRemindCell.h
//  ProvideAged
//
//  Created by fly on 2022/12/21.
//

#import <UIKit/UIKit.h>
#import "FLYDrugRemindModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYDrugRemindCell : UICollectionViewCell

@property (nonatomic, strong) FLYDrugRemindModel * model;

@property (nonatomic, copy) void(^switchBlock)(FLYDrugRemindModel *model, BOOL isOpen);
@property (nonatomic, copy) void(^deleteBlock)(FLYDrugRemindModel *model);

@end

NS_ASSUME_NONNULL_END
