//
//  FLYSendMessageViewController.h
//  ProvideAged
//
//  Created by fly on 2021/11/5.
//

/********** 从下往上滚动的tableView **********
 
 1.下拉加载更多，每次下拉，加载新的数据，保存进数组
 2.每次加载完，让tableView滚到相对的位置
 
 ******************************************/


#import "FLYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYSendMessageViewController : FLYBaseViewController

@property (nonatomic, strong) NSString * oldManInfoId;

@end

NS_ASSUME_NONNULL_END
