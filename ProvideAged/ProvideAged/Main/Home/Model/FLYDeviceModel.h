//
//  FLYDeviceModel.h
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYDeviceModel : NSObject

@property (nonatomic, strong) NSString * areaId;
@property (nonatomic, strong) NSString * areaName;
@property (nonatomic, strong) NSString * businessId;
@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, strong) NSString * communityInfoId;
@property (nonatomic, assign) CGFloat electricity;
@property (nonatomic, strong) NSString * houseName;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * imei;
@property (nonatomic, strong) NSString * imsi;
@property (nonatomic, strong) NSString * model;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * parentIds;
@property (nonatomic, assign) NSInteger status;//设备状态(1=正常、2=离线、3=低电量)
@property (nonatomic, strong) NSString * statusDesc;
//设备类型(1=紧急按钮、2=门磁、3=烟感、4=燃气、5=水浸、6=红外、7=手环、8=床垫、9=血糖仪、10=颐养卡、11=血压计、12=门锁、13=摄像头)
@property (nonatomic, assign) NSInteger type;
//报警状态(0=无、1=报警、2=防拆报警、3=电池低压、4=内部通讯异常、5=探测器故障、6=温度超上限报警、7=温度超下限报警、8=湿度超上限报警、9=湿度超下限报警、10=设备故障、11=无线信号弱、12=长时间开门、13=长时间关门、14=sos预警、15=跌倒预警、16=脱手预警、17=久坐预警、18=低电预警、19=家庭医生、20=房颤预警、21=开门、22=关门)
@property (nonatomic, assign) NSInteger warningStatus;
@property (nonatomic, strong) NSString * warningStatusDesc;

// 手表类型 只有是 wlL16、wlL17、wlL18 才显示健康报告
@property (nonatomic, strong) NSString * modelKey;


@end

NS_ASSUME_NONNULL_END
