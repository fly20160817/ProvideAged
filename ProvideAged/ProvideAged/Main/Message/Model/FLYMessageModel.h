//
//  FLYMessageModel.h
//  ProvideAged
//
//  Created by fly on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYMessageModel : NSObject

@property (nonatomic, strong) NSString * alarmTime;
@property (nonatomic, strong) NSString * areaName;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, strong) NSString * deviceName;
@property (nonatomic, assign) NSInteger deviceType;
@property (nonatomic, strong) NSString * deviceTypeDesc;
@property (nonatomic, strong) NSString * doctorPhone;
@property (nonatomic, assign) NSInteger electricity;
@property (nonatomic, strong) NSString * familyInfoId;
@property (nonatomic, strong) NSString * houseName;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * imei;
@property (nonatomic, assign) NSInteger isRead;//是否已读(1=已读、2=未读)
@property (nonatomic, strong) NSString * model;
@property (nonatomic, strong) NSString * oldManId;
@property (nonatomic, strong) NSString * oldManPhone;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, assign) NSInteger warningStatus;
@property (nonatomic, strong) NSString * businessName;

@end

NS_ASSUME_NONNULL_END
