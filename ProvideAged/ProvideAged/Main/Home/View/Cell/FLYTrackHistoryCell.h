//
//  FLYTrackHistoryCell.h
//  ProvideAged
//
//  Created by fly on 2021/11/5.
//

#import <UIKit/UIKit.h>
#import "FLYStepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYTrackHistoryCell : UITableViewCell

@property (nonatomic, strong) FLYStepModel * stepModel;
@property (nonatomic, copy) void(^trackBlock)(void);

@end

NS_ASSUME_NONNULL_END
