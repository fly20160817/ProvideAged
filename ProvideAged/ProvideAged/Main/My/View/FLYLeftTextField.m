//
//  FLYLeftTextField.m
//  05-封装UITextField
//
//  Created by fly on 2017/5/17.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "FLYLeftTextField.h"

@interface FLYLeftTextField ()

@property (nonatomic, strong) UIImageView * leftImgView;

@end

@implementation FLYLeftTextField

#pragma mark - setter and getter

-(UIImageView *)leftImgView
{
    if ( _leftImgView == nil )
    {
        _leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 48)];
        _leftImgView.contentMode = UIViewContentModeCenter;
    }
    
    return _leftImgView;
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        //以下的代码不写在自定义方法里是为了实现两个初始化方法都可以执行
        
        self.clearButtonMode = UITextFieldViewModeAlways;
        
        self.leftView = self.leftImgView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return self;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds
{
    bounds = CGRectMake(0, 0, 44, 48);
    return bounds;
}


-(instancetype)initWithFrame:(CGRect)frame leftImgName:(NSString *)leftImgName
{
    self = [self initWithFrame:frame];
    
    self.leftImgName = leftImgName;
    
    return self;
}



-(void)setLeftImgName:(NSString *)leftImgName
{
    _leftImgName = leftImgName;
    
    self.leftImgView.image = [UIImage imageNamed:leftImgName];
}


@end
