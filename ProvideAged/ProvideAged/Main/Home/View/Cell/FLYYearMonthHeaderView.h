//
//  FLYYearMonthHeaderView.h
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import <UIKit/UIKit.h>
#import "FLYYearMonthGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYYearMonthHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) FLYYearMonthGroupModel * groupModel;

@property (nonatomic, copy) void(^clickBlock)(FLYYearMonthGroupModel *groupModel);

@end

NS_ASSUME_NONNULL_END
