//
//  TGIOTManager.h
//  TGIOT
//
//  Created by Darren on 2021/3/8.
//  Copyright © 2021 Darren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TGIOTManager : NSObject

+ (void)initAppWithConfigPath:(NSString *)path controller:(nullable UIViewController *)controller;
+ (BOOL)handleOpenUniversalLinkWithActivity:(NSUserActivity *)userActivity;
+ (void)handleOpenUrl:(NSURL *)url options:(NSDictionary <UIApplicationOpenURLOptionsKey,id> *)options;
+ (void)registerNotificationsWithDeviceToken:(NSData *)deviceToken;
+ (void)initSDKWithAppId:(NSString *)appId token:(NSString *)token configPath:(NSString *)path callBack:(nullable void(^)(TGIOTErrorCode code, NSError * _Nullable error))callBack;
+ (void)openDeviceWithController:(UIViewController *)controller deviceUuid:(NSString *)uuid callBack:(nullable void(^)(TGIOTErrorCode code, NSError * _Nullable error))callBack;
+ (void)openDeviceWithController:(UIViewController *)controller deviceUuid:(NSString *)uuid connectMode:(TGDeviceConnectMode)connectMode callBack:(nullable void(^)(TGIOTErrorCode code, NSError * _Nullable error))callBack;
+ (void)add4GDeviceWithController:(UIViewController *)controller deviceUuid:(NSString *)uuid callBack:(nullable void(^)(TGIOTErrorCode code, NSError * _Nullable error))callBack;
+ (void)addWifiDeviceByHotspotWithController:(UIViewController *)controller callBack:(nullable void(^)(TGIOTErrorCode code, NSError * _Nullable error))callBack;
+ (void)addWifiDeviceByQRCodeWithController:(UIViewController *)controller callBack:(nullable void(^)(TGIOTErrorCode code, NSError * _Nullable error))callBack;
+ (void)showDeviceMsgWithController:(UIViewController *)controller deviceUuid:(NSString *)uuid callBack:(nullable void(^)(TGIOTErrorCode code, NSError * _Nullable error))callBack;

@end

NS_ASSUME_NONNULL_END
