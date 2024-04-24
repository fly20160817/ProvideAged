//
//  FLYMedicineBoxView.h
//  ProvideAged
//
//  Created by fly on 2022/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYMedicineBoxView : UIView

@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * eatTime;
@property (nonatomic, strong) NSString * medicineName;

@property (nonatomic, copy) void(^moreBlock)(void);

@end

NS_ASSUME_NONNULL_END
