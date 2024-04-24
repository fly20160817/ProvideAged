//
//  FLYSwitchCell.h
//  ProvideAged
//
//  Created by fly on 2021/12/30.
//

#import <UIKit/UIKit.h>
#import "FLYModel.h"

@class FLYSwitchModel;

NS_ASSUME_NONNULL_BEGIN

@interface FLYSwitchCell : UITableViewCell

@property (nonatomic, strong) FLYSwitchModel * switchModel;
@property (nonatomic, copy) void(^switchBlock)(FLYSwitchModel * switchModel);

@end



@interface FLYSwitchModel : FLYModel

@property (nonatomic, strong) NSString * title;
//是否打开 (默认no)
@property (nonatomic, assign) BOOL isOpen;
//是否显示线 (默认yes)
@property (nonatomic, assign) BOOL showLine;
//是否允许编辑 (默认yes)
@property (nonatomic, assign) BOOL isEdit;

@end

NS_ASSUME_NONNULL_END
