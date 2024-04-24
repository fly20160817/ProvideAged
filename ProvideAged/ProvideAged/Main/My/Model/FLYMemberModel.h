//
//  FLYMemberModel.h
//  ProvideAged
//
//  Created by fly on 2021/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYMemberModel : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * oldManInfoId;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * relationship;
@property (nonatomic, assign) NSInteger type;// 1老人  2管理员  3其他

@end

NS_ASSUME_NONNULL_END
