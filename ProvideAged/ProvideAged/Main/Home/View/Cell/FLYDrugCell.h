//
//  FLYDrugCell.h
//  ProvideAged
//
//  Created by fly on 2022/12/21.
//

#import <UIKit/UIKit.h>
#import "FLYDrugModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYDrugCell : UICollectionViewCell

@property (nonatomic, strong) FLYDrugModel * model;

@property (nonatomic, copy) void(^addBlock)(FLYDrugModel *model);
@property (nonatomic, copy) void(^deleteBlock)(FLYDrugModel *model);

@end

NS_ASSUME_NONNULL_END
