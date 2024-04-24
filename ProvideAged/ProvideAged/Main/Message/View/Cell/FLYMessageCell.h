//
//  FLYMessageCell.h
//  ProvideAged
//
//  Created by fly on 2021/9/10.
//

#import <UIKit/UIKit.h>
#import "FLYMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYMessageCell : UITableViewCell

@property (nonatomic, strong) FLYMessageModel * messageModel;
@property (nonatomic, copy) void(^callBlock)(FLYMessageModel * messageModel);

@end

NS_ASSUME_NONNULL_END
