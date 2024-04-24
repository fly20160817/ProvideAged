//
//  FLYExceptionView.h
//  Paint
//
//  Created by fly on 2019/11/25.
//  Copyright © 2019 fly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FLYExceptionStatus)
{
    FLYExceptionStatusNone = 0,       //没有错误
    FLYExceptionStatusNoData,         //无数据
    FLYExceptionStatusServerError,    //服务器错误
    FLYExceptionStatusNetworkError,   //网络错误
};

@interface FLYExceptionView : UIView

@property (nonatomic, assign) FLYExceptionStatus status;

@end

NS_ASSUME_NONNULL_END
