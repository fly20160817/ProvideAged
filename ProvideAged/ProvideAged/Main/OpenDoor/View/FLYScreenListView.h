//
//  FLYScreenListView.h
//  dorm
//
//  Created by fly on 2021/11/22.
//

#import <UIKit/UIKit.h>
#import "FLYKeyValueModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYScreenListView : UIView

@property (nonatomic, strong) NSArray<FLYKeyValueModel *> * dataList;

@property (nonatomic, copy) void(^cancelBlock)(void);
@property (nonatomic, copy) void(^confirmBlock)(FLYKeyValueModel * keyValueModel);

@end

NS_ASSUME_NONNULL_END
