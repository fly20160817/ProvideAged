//
//  FLYDrugModel.h
//  ProvideAged
//
//  Created by fly on 2022/12/28.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYDrugModel : FLYModel

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * brand;
@property (nonatomic, strong) NSString * specs;
@property (nonatomic, strong) NSString * surplus;

@end

NS_ASSUME_NONNULL_END
