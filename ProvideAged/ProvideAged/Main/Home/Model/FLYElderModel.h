//
//  FLYElderModel.h
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYElderModel : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger alertCount;
@property (nonatomic, strong) NSString * careLevel;
@property (nonatomic, strong) NSString * careLevelName;
@property (nonatomic, assign) NSInteger deviceCount;
@property (nonatomic, strong) NSString * houseAddress;
@property (nonatomic, strong) NSString * houseInfoId;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger isBindRoom;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger onlineCount;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * statusName;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, strong) NSString * bloodType;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, strong) NSString * height;
@property (nonatomic, assign) NSInteger houseEquipmentAlertCount;
@property (nonatomic, assign) NSInteger houseEquipmentCount;
@property (nonatomic, strong) NSString * lat;
@property (nonatomic, strong) NSString * lon;
@property (nonatomic, assign) NSInteger pedometer;
@property (nonatomic, assign) NSInteger personalEquipmentAlertCount;
@property (nonatomic, assign) NSInteger personalEquipmentCount;
@property (nonatomic, strong) NSString * weight;

@end

NS_ASSUME_NONNULL_END
