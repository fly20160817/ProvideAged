//
//  FLYUserModel.h
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import <Foundation/Foundation.h>

@class FLYUserData;

NS_ASSUME_NONNULL_BEGIN

@interface FLYUserModel : NSObject

@property (nonatomic, strong) NSString * menuData;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) FLYUserData * userData;

@end


@interface FLYUserData : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger loginType;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * roleId;
@property (nonatomic, strong) NSString * roleName;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * userName;

@end

NS_ASSUME_NONNULL_END
