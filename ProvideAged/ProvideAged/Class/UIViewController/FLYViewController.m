//
//  FLYViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYViewController.h"

@interface FLYViewController ()

@end

@implementation FLYViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //判断父视图是不是导航栏控制器，因为子控制器.navigationController获取到的是父控制器的导航栏，所以要过滤掉子控制器调用
    if ( self.parentViewController == self.navigationController )
    {
        [self.navigationController setNavigationBarHidden:_navigationBarHidden animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ( self.parentViewController == self.navigationController )
    {
        //获取即将显示的控制器
        FLYViewController *viewController = self.navigationController.viewControllers.lastObject;
        //上一个页面或者下一个页面不一定是继承FLYBaseViewController的，可能没有navigationBarHidden这个属性，所以要判断下类
        if ( [viewController isKindOfClass:[self class]] )
        {
            [self.navigationController setNavigationBarHidden:viewController.navigationBarHidden animated:animated];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)dealloc
{
    FLYLog(@"%@销毁咯",self);
}



#pragma mark - UITouch

//点击空白收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
