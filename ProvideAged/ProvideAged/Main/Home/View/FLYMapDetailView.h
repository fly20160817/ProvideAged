//
//  FLYMapDetailView.h
//  ProvideAged
//
//  Created by fly on 2021/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYMapDetailView : UIView

// 0 智能手表    1 颐养卡
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * step;
@property (nonatomic, strong) NSString * distance;

//切换类型
@property (nonatomic, copy) void(^changeTypeBlock)(NSInteger type);
@property (nonatomic, copy) void(^moreBlock)(void);
@property (nonatomic, copy) void(^navigationBlock)(void);

@end

NS_ASSUME_NONNULL_END
