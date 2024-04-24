//
//  FLYInputTipsCell.h
//  ProvideAged
//
//  Created by fly on 2021/12/27.
//

#import <UIKit/UIKit.h>
#import "FLYModel.h"

@class FLYInputTipsModel;

NS_ASSUME_NONNULL_BEGIN

@interface FLYInputTipsCell : UITableViewCell

@property (nonatomic, strong) FLYInputTipsModel * inputTipsModel;

@property (nonatomic, copy) void(^inputBlock)(FLYInputTipsModel * inputTipsModel, NSString *inputContent);

@end


@interface FLYInputTipsModel : FLYModel

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * tips;
//是否显示线 (默认yes)
@property (nonatomic, assign) BOOL showLine;
//是否允许编辑 (默认yes)
@property (nonatomic, assign) BOOL isEdit;

@end

NS_ASSUME_NONNULL_END
