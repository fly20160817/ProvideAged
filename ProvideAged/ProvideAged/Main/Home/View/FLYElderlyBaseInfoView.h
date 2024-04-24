//
//  FLYElderlyBaseInfoView.h
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import <UIKit/UIKit.h>
#import "FLYHealthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYElderlyBaseInfoView : UIView

@property (nonatomic, strong) NSArray<FLYHealthModel *> * healthList;

@property (nonatomic, copy) void(^clickBlock)(FLYHealthModel * healthModel);

@end

NS_ASSUME_NONNULL_END
