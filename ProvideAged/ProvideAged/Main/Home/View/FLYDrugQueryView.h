//
//  FLYDrugQueryView.h
//  ProvideAged
//
//  Created by fly on 2022/12/21.
//

#import <UIKit/UIKit.h>
#import "FLYTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYDrugQueryView : UIView

@property (nonatomic, strong) FLYTextField * textField;
@property (nonatomic, strong) UILabel * specsLabel;
@property (nonatomic, strong) UILabel * brandLabel;
@property (nonatomic, strong) UILabel * numberLabel;

@property (nonatomic, copy) void(^showBlock)(void);

@end

NS_ASSUME_NONNULL_END
