//
//  FLYInputCell.h
//  ProvideAged
//
//  Created by fly on 2021/12/27.
//

#import <UIKit/UIKit.h>
#import "FLYModel.h"

@class FLYInputModel;

NS_ASSUME_NONNULL_BEGIN

@interface FLYInputCell : UITableViewCell

@property (nonatomic, strong) FLYInputModel * inputModel;

@property (nonatomic, copy) void(^inputBlock)(FLYInputModel * inputModel, NSString *inputContent);

@end


@interface FLYInputModel : FLYModel

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, strong) NSString * content;
//是否安全输入 (默认no)
@property (nonatomic, assign) BOOL secureTextEntry;
//是否显示线 (默认yes)
@property (nonatomic, assign) BOOL showLine;
//是否允许编辑 (默认yes)
@property (nonatomic, assign) BOOL isEdit;
//键盘类型
@property(nonatomic) UIKeyboardType keyboardType;

@end

NS_ASSUME_NONNULL_END
