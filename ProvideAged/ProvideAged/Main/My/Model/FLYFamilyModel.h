//
//  FLYFamilyModel.h
//  ProvideAged
//
//  Created by fly on 2021/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYFamilyModel : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString * doctorId;
@property (nonatomic, assign) NSInteger editFamily;//权限 1可编辑 2不可编辑 
@property (nonatomic, assign) NSInteger familyCount;
@property (nonatomic, strong) NSString * houseAddress;
@property (nonatomic, strong) NSString * houseBedId;
@property (nonatomic, strong) NSString * houseInfoId;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * relationship;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger type;// 1老人  2管理员  3其他
@property (nonatomic, assign) NSInteger isBindLock;//是否绑定门锁(1=是、2=否)

@end

NS_ASSUME_NONNULL_END
