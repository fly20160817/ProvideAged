//
//  FLYSelectCell.h
//  ProvideAged
//
//  Created by fly on 2021/12/27.
//

#import <UIKit/UIKit.h>
#import "FLYModel.h"

@class FLYSelectModel;

NS_ASSUME_NONNULL_BEGIN

@interface FLYSelectCell : UITableViewCell

@property (nonatomic, strong) FLYSelectModel * selectModel;

@property (nonatomic, copy) void(^selectBlock)(FLYSelectModel * selectModel);

@end


@interface FLYSelectModel : FLYModel

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, strong) NSString * selectTitle;
@property (nonatomic, strong) NSString * selectIdField;
//是否显示线 (默认yes)
@property (nonatomic, assign) BOOL showLine;
//是否允许编辑 (默认yes)
@property (nonatomic, assign) BOOL isEdit;

@end

NS_ASSUME_NONNULL_END
