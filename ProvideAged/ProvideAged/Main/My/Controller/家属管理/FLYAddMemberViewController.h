//
//  FLYAddMemberViewController.h
//  ProvideAged
//
//  Created by fly on 2021/9/13.
//

#import "FLYBaseViewController.h"
#import "FLYFamilyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYAddMemberViewController : FLYBaseViewController

//是否是管理员
@property (nonatomic, assign) BOOL isAdmin;
@property (nonatomic, strong) FLYFamilyModel * familyModel;

@end

NS_ASSUME_NONNULL_END
