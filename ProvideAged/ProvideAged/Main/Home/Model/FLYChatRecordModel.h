//
//  FLYChatRecordModel.h
//  ProvideAged
//
//  Created by fly on 2021/11/17.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYChatRecordModel : FLYModel

@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, strong) NSString * familyInfoId;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * information;
//是否已读(1=已读、2=未读)
@property (nonatomic, assign) NSInteger isRead;
@property (nonatomic, strong) NSString * oldManInfoId;

@end

NS_ASSUME_NONNULL_END
