//
//  FLYNavigationController.m
//  ProvideAged
//
//  Created by fly on 2021/9/6.
//

#import "FLYNavigationController.h"
#import "UIImage+FLYExtension.h"
#import "UIBarButtonItem+FLYExtension.h"

@interface FLYNavigationController () < UIGestureRecognizerDelegate >


@end

@implementation FLYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //设置系统的滑动手势代理为自己
    self.interactivePopGestureRecognizer.delegate = self;
    
    //设置导航栏不透明，内容就会自动从导航栏下面开始
    self.navigationBar.translucent = NO;
    
    
    if (@available(iOS 15.0, *))
    {
        UINavigationBarAppearance * barAppearance = [[UINavigationBarAppearance alloc] init];
        //bar的背景颜色
        barAppearance.backgroundColor = [UIColor whiteColor];
        
        //底下线的颜色
        barAppearance.shadowColor = [UIColor clearColor];
        
        //设置导航条标题的字体、颜色
        NSDictionary * dic = @{ NSFontAttributeName : FONT_M(16), NSForegroundColorAttributeName : COLORHEX(@"#333333") };
        barAppearance.titleTextAttributes = dic;
        
        self.navigationBar.scrollEdgeAppearance = barAppearance;
        self.navigationBar.standardAppearance = barAppearance;
    }
    else
    {
        //bar的背景颜色
        self.navigationBar.barTintColor = COLORHEX(@"#FFFFFF");
            
        //底下线的颜色
        self.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(SCREEN_WIDTH, 1)];
        
        //设置导航条标题的字体、颜色
        NSDictionary * dic = @{ NSFontAttributeName : FONT_M(16), NSForegroundColorAttributeName : COLORHEX(@"#333333") };
        self.navigationBar.titleTextAttributes = dic;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( self.viewControllers.count > 0 )
    {
        //自定义返回按钮        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"icon_return" target:self action:@selector(backAction)];
        
        //隐藏底部tabBer
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:animated];
}

- (void)backAction
{
    if ( [self.fly_delegate respondsToSelector:@selector(didClickBackAtNavController:)])
    {
        [self.fly_delegate didClickBackAtNavController:self];
        
        //执行完代理就解除，不然外界在代理方法里执行了返回，控制器被释放，导致fly_delegate指向野指针，导致闪退
        self.fly_delegate = nil;
    }
    else
    {
        [self popViewControllerAnimated:YES];
    }
}



#pragma mark - UIGestureRecognizerDelegate

//手势是否触发
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //根控制器不触发手势
    return self.childViewControllers.count > 1;
}



#pragma mark - setters and getters

-(void)setIsLine:(BOOL)isLine
{
    _isLine = isLine;
    
    if (@available(iOS 15.0, *))
    {
        self.navigationBar.scrollEdgeAppearance.shadowColor = isLine ? COLORHEX(@"#EAEAEA") : [UIColor clearColor];
        self.navigationBar.standardAppearance.shadowColor = isLine ? COLORHEX(@"#EAEAEA") : [UIColor clearColor];
    }
    else
    {
        self.navigationBar.shadowImage = [UIImage imageWithColor: isLine ? COLORHEX(@"#EAEAEA") : [UIColor clearColor] size:CGSizeMake(SCREEN_WIDTH, 1)];
    }
}


@end
