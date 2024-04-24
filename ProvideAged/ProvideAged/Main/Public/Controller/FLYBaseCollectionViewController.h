//
//  FLYBaseCollectionViewController.h
//  ProvideAged
//
//  Created by fly on 2021/12/24.
//

//此类暂时不适合继承，复制出去改改用吧

#import "FLYBaseViewController.h"
#import "UICollectionView+FLYRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYBaseCollectionViewController : FLYBaseViewController < UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) UICollectionView * collectionView;

@end

NS_ASSUME_NONNULL_END
