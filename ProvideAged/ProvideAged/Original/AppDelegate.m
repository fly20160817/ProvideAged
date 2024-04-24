//
//  AppDelegate.m
//  ProvideAged
//
//  Created by fly on 2021/9/6.
//

#import "AppDelegate.h"
#import "FLYTabBarController.h"
#import "FLYLoginViewController.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "FLYVersionModel.h"
#import "FLYVersionUpdateView.h"
#import "FLYPopupView.h"
#import <ICINSmartLockSDK/ICINSmartLockManage.h>

@interface AppDelegate () < JPUSHRegisterDelegate >

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //[FLYUser sharedUser].token = @"";
    
    
    //判断是否登录
    if ( [FLYUser isAutoLogin] == YES )
    {
        FLYTabBarController * tabVC = [[FLYTabBarController alloc] init];
        self.window.rootViewController = tabVC;
    }
    else
    {
        FLYLoginViewController * loginVC = [[FLYLoginViewController alloc] init];
        self.window.rootViewController = loginVC;
    }
    
    
    
    //极光推送
    [self setupJPush:launchOptions];
    
    
    //检测版本更新
    [self versionUpdate];
    
    
    //紫光初始化
    [ICINSmartLockManage icin_initManage];
    
    //去掉iOS15 tabelView 的 sectionHeader 上面多出来的部分
    if (@available(iOS 15.0, *))
    {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
    
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSLog(@"deviceToken = %@", deviceToken);
}
    
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"注册 APNs 失败: %@", error);

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"已经变成活跃状态 %s",__FUNCTION__);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}



#pragma mark - JPUSH

- (void)setupJPush:(NSDictionary *)launchOptions
{
    //【注册通知】通知回调代理（可选）
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    //【初始化sdk】
    [JPUSHService setupWithOption:launchOptions appKey:@"ba4b1ace69c7d93650d6bbc3"
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:nil];
}



#pragma mark- JPUSHRegisterDelegate

//iOS10之后，前台运行收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler API_AVAILABLE(ios(10.0))
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    NSLog(@"userInfo = %@", notification.request.content.userInfo);
    
    //[self changeViewControllerWithNotification:userInfo];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else
    {
        // 本地通知
    }
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//iOS10之后，后台运行及程序退出收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"userInfo = %@", userInfo);
    
    [self changeViewControllerWithNotification:userInfo];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else
    {
        // 本地通知
    }
    
    // 系统要求执行这个方法
    completionHandler();
}

//监测通知授权状态返回的结果
- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info
{
    NSLog(@"接收通知授权状态:%lu，信息:%@", (unsigned long)status, info);
}

//切换控制器
- (void)changeViewControllerWithNotification:(NSDictionary *)userInfo
{
    FLYTabBarController * tabVC = (FLYTabBarController *)(self.window.rootViewController);
    if ( tabVC.selectedIndex >= 2 )
    {
        tabVC.selectedIndex = 2;
    }
}



#pragma mark - 检测版本更新

- (void)versionUpdate
{
    NSDictionary * params = @{ @"type ": @"1" };
    
    [FLYNetworkTool postRawWithPath:API_APPVERSION params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {
        
        if ( [json[SERVER_STATUS] integerValue] == 200 )
        {
            FLYVersionModel * versionModel = [FLYVersionModel mj_objectWithKeyValues:json[SERVER_DATA]];
            
            if ( [versionModel.version isEqualToString:APP_VERSION] )
            {
                return;
            }
            
            
            FLYVersionUpdateView * versionUpdateView = [[FLYVersionUpdateView alloc] init];
            versionUpdateView.isForcedUpdate = versionModel.isToUpdate == 1 ? YES : NO;
            
            FLYPopupView * popupView = [FLYPopupView popupView:versionUpdateView animationType:(FLYPopupAnimationTypeNone) maskType:(FLYPopupMaskTypeBlack)];
            [versionUpdateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(popupView);
                make.size.mas_equalTo(CGSizeMake(284, 183));
            }];
            popupView.interactionEnabled = NO;
            [popupView show];
            
            versionUpdateView.cancelBlock = ^{
                [popupView dissmiss];
            };
            
            versionUpdateView.confirmBlock = ^{
                
                NSURL * url = [NSURL URLWithString:versionModel.downloadUrl];
                
                if([[UIApplication sharedApplication] canOpenURL:url])
                {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            };
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
    }];
}


@end
