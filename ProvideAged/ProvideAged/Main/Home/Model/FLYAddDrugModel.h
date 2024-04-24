//
//  FLYAddDrugModel.h
//  ProvideAged
//
//  Created by fly on 2022/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYAddDrugModel : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, assign) BOOL isEditing;

@end

NS_ASSUME_NONNULL_END
