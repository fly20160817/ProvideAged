//
//  FLYVersionModel.h
//  ProvideAged
//
//  Created by fly on 2021/11/26.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYVersionModel : FLYModel


//创建日期
@property (nonatomic, strong) NSString * createTime;
//下载地址
@property (nonatomic, strong) NSString * downloadUrl;
//id
@property (nonatomic, strong) NSString * idField;
//是否强制更新(1=强制更新、2=不强制更新)
@property (nonatomic, assign) NSInteger isToUpdate;
//版本备注
@property (nonatomic, strong) NSString * notes;
//软件类型(1=家属iOS、2=家属Android)
@property (nonatomic, assign) NSInteger type;
//版本号
@property (nonatomic, strong) NSString * version;


@end

NS_ASSUME_NONNULL_END

