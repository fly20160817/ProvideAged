//
//  FLYHealthModel.h
//  ProvideAged
//
//  Created by fly on 2021/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYHealthModel : NSObject

@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, strong) NSString * deviceName;
@property (nonatomic, strong) NSString * deviceTypeDesc;
//(1=心率、2=呼吸、3=血糖、4=体温、5=血氧、6=血压)
@property (nonatomic, assign) NSInteger healthType;
@property (nonatomic, strong) NSString * healthValue;
@property (nonatomic, strong) NSString * healthValue2;
@property (nonatomic, strong) NSString * oldManInfoId;



/** 下面不是接口返回的，自己计算出来的，在get方法赋的值 */

//心率、呼吸、血糖、体温、血氧、血压
@property (nonatomic, strong) NSString * healthTypeName;
//状态 (1正常 2偏低 3偏高)
@property (nonatomic, assign) NSInteger status;
//单位
@property (nonatomic, strong) NSString * unit;

@end

NS_ASSUME_NONNULL_END
