//
//  FLYSysDicModel.h
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYSysDicModel : NSObject

@property (nonatomic, strong) NSString * descriptionField;
@property (nonatomic, strong) NSString * dictKey;
@property (nonatomic, strong) NSString * dictValue;
@property (nonatomic, strong) NSString * dictValue2;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * typeDesc;

@end

NS_ASSUME_NONNULL_END
