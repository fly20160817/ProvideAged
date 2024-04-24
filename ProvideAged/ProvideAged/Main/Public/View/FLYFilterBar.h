//
//  FLYFilterBar.h
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import <UIKit/UIKit.h>

@class FLYFilterBar;

NS_ASSUME_NONNULL_BEGIN

@protocol FLYFilterBarDelegate <NSObject>


/// 点击按钮后执行
/// @param filterBar filterBar
/// @param index 选中的按钮索引
/// @param selectStatus 是否选中 (点击一次选中，再点一次取消选中)
- (void)filterBar:(FLYFilterBar *)filterBar didSelectIndex: (NSInteger)index selectStatus:(BOOL)selectStatus;

@end

@interface FLYFilterBar : UIView

@property (nonatomic, weak) id<FLYFilterBarDelegate> delegate;

@property (nonatomic, strong) NSArray * titleNames;


- (instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titleNames;


/// 刷新按钮的选中状态 (设置为全部未选中)
- (void)refreshButtonStatus;

/// 改变按钮的title (选中状态的那个按钮)
- (void)changeButtonTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
