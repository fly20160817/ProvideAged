//
//  FLYUser.h
//  ProvideAged
//
//  Created by fly on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYUser : NSObject 

@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger loginType;//登录类型(0=默认pc端、1=家属小程序、2=安装工小程序、3=家属APP)
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * roleId;
@property (nonatomic, strong) NSString * roleName;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * userName;

//当前选择的老人id
@property (nonatomic, strong) NSString * oldManInfoId;

+ (instancetype)sharedUser;

//判断是否自动登录
+ (BOOL)isAutoLogin;

//保存用户信息
+ (void)saveUser;

//清除用户信息
+ (void)clearUser;

@end

NS_ASSUME_NONNULL_END
