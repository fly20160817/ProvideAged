//
//  FLYLockAuthorizeViewController.h
//  ProvideAged
//
//  Created by fly on 2021/12/30.
//

#import "FLYBaseTableViewController.h"
#import "FLYHouseLockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYLockAuthorizeViewController : FLYBaseTableViewController

@property (nonatomic, strong) FLYHouseLockModel * houseLockModel;
//家属id (如果传了家属id，内部就会有删除按钮，不穿就没有删除按钮)
@property (nonatomic, strong) NSString * memberIdField;

@end

NS_ASSUME_NONNULL_END
