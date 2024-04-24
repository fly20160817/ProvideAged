//
//  FLYTempAuthorizeCell.h
//  ProvideAged
//
//  Created by fly on 2021/12/24.
//

#import <UIKit/UIKit.h>
#import "FLYAuthorizeModel.h"
#import "FLYOpenRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYTempAuthorizeCell : UICollectionViewCell

//临时授权model
@property (nonatomic, strong) FLYAuthorizeModel * authorizeModel;
//开门记录model
@property (nonatomic, strong) FLYOpenRecordModel * openRecordModel;

@end

NS_ASSUME_NONNULL_END
