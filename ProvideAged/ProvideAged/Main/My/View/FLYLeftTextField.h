//
//  FLYLeftTextField.h
//  05-封装UITextField
//
//  Created by fly on 2017/5/17.
//  Copyright © 2017年 fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLYLeftTextField : UITextField

@property (nonatomic, copy) NSString * leftImgName;

-(instancetype)initWithFrame:(CGRect)frame leftImgName:(NSString *)leftImgName;

@end

