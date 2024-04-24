//
//  FLYFilterItemView.h
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import <UIKit/UIKit.h>
#import "FLYKeyValueModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYFilterItemView : UIView

@property (nonatomic, strong) NSArray<FLYKeyValueModel *> * itemModels;


/// 是否多选 (默认NO)
@property (nonatomic, assign) BOOL multiple;

/// 返回的是数组，因为可能是多选
@property (nonatomic, copy) void(^confirmBlock)(NSArray * selectModels);

@end

NS_ASSUME_NONNULL_END
