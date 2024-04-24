//
//  FLYUserAction.m
//  ElevatorStandard
//
//  Created by fly on 2020/6/1.
//  Copyright © 2020 fly. All rights reserved.
//

#import "FLYUserAction.h"
#import "FLYTabBarController.h"
#import "FLYLoginViewController.h"
#import "FLYNetwork.h"
//#import "JPUSHService.h"

@implementation FLYUserAction

+ (void)loginAction:(FLYUserModel *)info;
{
    //保存用户信息
    [self saveUserInfo:info];
    
    //设置token
    [FLYNetwork setTokenHTTPHeaders:[FLYUser sharedUser].token];
    
//    //设置别名
//    NSString * alias = [NSString stringWithFormat:@"%@", [FLYUser sharedUser].uid];
//    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//
//        if ( iResCode == 0 )
//        {
//            FLYLog(@"别名设置成功: %@", iAlias);
//        }
//        else
//        {
//            FLYLog(@"别名设置失败：iResCode = %ld, iAlias = %@", (long)iResCode, iAlias);
//        }
//
//    } seq:100];
}


+ (void)exitAction
{
    //清空用户信息
    [FLYUser clearUser];
    
    //清空setToken
    [FLYNetwork setTokenHTTPHeaders:nil];
    
//    //删除别名
//    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        if ( iResCode == 0 )
//        {
//            FLYLog(@"别名删除成功!");
//        }
//        else
//        {
//            FLYLog(@"别名删除失败：iResCode = %ld, iAlias = %@", (long)iResCode, iAlias);
//        }
//    } seq:100];
    
    
    FLYLoginViewController * vc = [[FLYLoginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}



#pragma mark - private methods

+ (void)saveUserInfo:(FLYUserModel *)userModel
{
    FLYUser * user = [FLYUser sharedUser];
    user.token = userModel.token;
    user.idField = userModel.userData.idField;
    user.loginType = userModel.userData.loginType;
    user.name = userModel.userData.name;
    user.phone = userModel.userData.phone;
    user.roleId = userModel.userData.roleId;
    user.roleName = userModel.userData.roleName;
    user.type = userModel.userData.type;
    user.userName = userModel.userData.userName;
    [FLYUser saveUser];
}

@end
