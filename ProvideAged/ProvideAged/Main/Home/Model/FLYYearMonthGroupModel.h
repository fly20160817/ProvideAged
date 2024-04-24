//
//  FLYYearMonthGroupModel.h
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYYearMonthGroupModel : NSObject

@property (nonatomic, copy) NSString * date;
@property (nonatomic, strong) NSMutableArray * list;

@property (nonatomic, assign) BOOL isOpen;//判断分组是否展开

@end

NS_ASSUME_NONNULL_END
