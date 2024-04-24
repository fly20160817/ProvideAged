//
//  FLYOptionCell.h
//  ProvideAged
//
//  Created by fly on 2021/12/27.
//

#import <UIKit/UIKit.h>
#import "FLYModel.h"

@class FLYOptionModel;

NS_ASSUME_NONNULL_BEGIN

@interface FLYOptionCell : UITableViewCell

@property (nonatomic, strong) FLYOptionModel * optionModel;
@property (nonatomic, copy) void (^optionBlock)(FLYOptionModel * optionModel);

@end



@interface FLYOptionModel : FLYModel

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * option1Title;
@property (nonatomic, strong) NSString * option2Title;
//选项1是否选中
@property (nonatomic, assign) BOOL option1Select;
//选项2是否选中
@property (nonatomic, assign) BOOL option2Select;
//是否显示线 (默认yes)
@property (nonatomic, assign) BOOL showLine;
//是否允许编辑 (默认yes)
@property (nonatomic, assign) BOOL isEdit;

@end

NS_ASSUME_NONNULL_END
