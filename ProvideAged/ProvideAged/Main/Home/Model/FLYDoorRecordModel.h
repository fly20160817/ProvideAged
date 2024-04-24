//
//  FLYDoorRecordModel.h
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYDoorRecordModel : NSObject

@property (nonatomic, strong) NSString * areaId;
@property (nonatomic, strong) NSString * areaName;
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, strong) NSString * deviceName;
@property (nonatomic, strong) NSString * deviceTypeDesc;
@property (nonatomic, assign) NSInteger electricity;
@property (nonatomic, strong) NSString * houseName;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * imei;
@property (nonatomic, strong) NSString * model;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * operateTime;
@property (nonatomic, strong) NSString * parentIds;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * type;

@property (nonatomic, strong) NSString * openTypeDesc;
@property (nonatomic, strong) NSString * openTime;

@end

NS_ASSUME_NONNULL_END
