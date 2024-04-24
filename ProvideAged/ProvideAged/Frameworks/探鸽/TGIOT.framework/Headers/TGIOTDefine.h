//
//  TGIOTDefine.h
//  TGIOT
//
//  Created by Darren on 2021/3/5.
//  Copyright © 2021 Darren. All rights reserved.
//

#ifndef TGIOTDefine_h
#define TGIOTDefine_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TGIOTErrorCode) {
    TGIOTErrorCode_Success = 0,
    TGIOTErrorCode_TokenInValid,
    TGIOTErrorCode_NotInit,
    TGIOTErrorCode_UuidNotFind,
    TGIOTErrorCode_ConnectModeError,
    TGIOTErrorCode_UuidInvalid,
    TGIOTErrorCode_DeviceAddFailed,
    TGIOTErrorCode_UnKnownError
};

typedef NS_ENUM(NSInteger, TGDeviceConnectMode) {
    TGDeviceConnectMode_Remote,
    TGDeviceConnectMode_Local
};

extern NSString * const TGIOTDidRemoveDeviceSuccessNotification;
extern NSString * const TGIOTDidAddDeviceSuccessNotification;
extern NSString * const TGIOTDidUserTokenInvalidNotification;

#endif /* TGIOTDefine_h */
