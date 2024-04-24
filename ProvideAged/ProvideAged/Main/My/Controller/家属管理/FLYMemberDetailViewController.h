//
//  FLYMemberDetailViewController.h
//  ProvideAged
//
//  Created by fly on 2021/9/13.
//

#import "FLYBaseViewController.h"
#import "FLYMemberModel.h"
#import "FLYFamilyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYMemberDetailViewController : FLYBaseViewController

@property (nonatomic, strong) FLYFamilyModel * familyModel;
@property (nonatomic, strong) FLYMemberModel * memberModel;

@end

NS_ASSUME_NONNULL_END
