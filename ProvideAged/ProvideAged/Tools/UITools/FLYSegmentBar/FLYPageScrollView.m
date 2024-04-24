//
//  FLYPageScrollView.m
//  FLYKit
//
//  Created by fly on 2021/12/6.
//

/****************** 关于子控制器的知识点 ******************
 
 *******添加子控制器*******
 
 FLYViewController * vc = [[FLYViewController alloc]init];
 vc.view.frame = self.view.bounds;
 
 //首先将VC添加到控制器上，建立父子关系
 [self addChildViewController:vc];
 
 //将VC控制器的view添加到父控制器上
 [self.view addSubview:vc.view];
 
 //调用VC的didMoveToParentViewController通知VC完成了父子关系建立
 [vc didMoveToParentViewController:self];
 
 
 
 *******移除子控制器*******
 
 //通知子控制器即将解除父子关系
 [vc willMoveToParentViewController:nil];
 
 //将VC的view从父控制器移除
 [vc.view removeFromSuperview];
 
 //解除父子关系
 [vc removeFromParentViewController];
 
 
 
 *******触发子控制器的生命周期*******
 
 //触发子控制器的 viewWillAppear 方法
 [childVC beginAppearanceTransition:YES animated:YES];
 
 //触发子控制器的 viewDidAppear 方法
 [childVC endAppearanceTransition];

 //触发子控制器的 viewWillDisappear 方法
 [childVC beginAppearanceTransition:NO animated:YES];
 
 //触发子控制器的 viewDidDisappear 方法
 [childVC endAppearanceTransition];
 
 
 **************************************/

#import "FLYPageScrollView.h"

@interface FLYPageScrollView () < UIScrollViewDelegate >

@property (nonatomic, strong) UIScrollView *scrollView;

/// 外界父控制器
@property (nonatomic, weak) UIViewController *parentViewController;
/// 存储子控制器
@property (nonatomic, strong) NSArray *childViewControllers;
/// 记录加载的上个子控制器
@property (nonatomic, weak) UIViewController * lastChildVC;
/// 记录加载的上个子控制器的下标
@property (nonatomic, assign) NSInteger lastChildVCIndex;

@end

@implementation FLYPageScrollView


- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        self.parentViewController = parentVC;
        self.childViewControllers = childVCs;
        
        [self initVariable];
        [self initUI];
    }
    
    return self;
}

+ (instancetype)pageScrollViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs
{
    return [[self alloc] initWithFrame:frame parentVC:parentVC childVCs:childVCs];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.width * self.childViewControllers.count, 0);
}



#pragma mark - DATA

- (void)initVariable
{
    self.lastChildVCIndex = -1;
}


#pragma mark - UI

- (void)initUI
{
    [self addSubview:self.scrollView];
}



#pragma mark - UIScrollViewDelegate

//已经结束减速 (手动滚动时调用)
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.frame.size.width;
    
    //如果即将出现的子控制器 就是 上个控制器
    if( index == self.lastChildVCIndex )
    {
        return;
    }

    //如果上一个子控制器存在
    if ( self.lastChildVC != nil )
    {
        //触发上个子控制器的 viewWillDisappear 方法
        [self.lastChildVC beginAppearanceTransition:NO animated:NO];
    }
    
    UIViewController * childVC = self.childViewControllers[index];
    
    //触发子控制器的 viewWillAppear 方法
    [childVC beginAppearanceTransition:YES animated:NO];
    
    //是否添加过这个控制器
    BOOL isFirstAdd = [self.parentViewController.childViewControllers containsObject:childVC] == YES ? NO : YES;
    
    //如果没添加过这个子控制器
    if ( isFirstAdd )
    {
        [self.parentViewController addChildViewController:childVC];
        
        childVC.view.frame = CGRectMake(offsetX, 0, self.width, self.height);
        [self.scrollView addSubview:childVC.view];
    }
    
    //如果上一个子控制器存在
    if ( self.lastChildVC != nil )
    {
        //触发上个子控制器的 viewDidDisappear 方法
        [self.lastChildVC endAppearanceTransition];
    }
    
    //触发子控制器的 viewDidAppear 方法
    [childVC endAppearanceTransition];
    
    if( isFirstAdd )
    {
        //告诉子控制器，已经移动到父控制器 （子控制器内部可以在didMoveToParentViewController:这个方法里添加代码，别忘记调用super）
        [childVC didMoveToParentViewController:self.parentViewController];
    }
    
    
    //代理
    if ( [self.delegate respondsToSelector:@selector(pageScrollView:originalIndex:targetIndex:)] )
    {
        [self.delegate pageScrollView:self originalIndex:self.lastChildVCIndex targetIndex:index];
    }
    
    
    self.lastChildVC = childVC;
    self.lastChildVCIndex = index;
}



#pragma mark - public methods

- (void)selectIndex:(NSInteger)index animated:(BOOL)animated
{
    if( index < 0 || index >= self.childViewControllers.count )
    {
        NSLog(@"下标错误，index = %ld", (long)index);
        return;
    }
    
    
    
    //如果即将出现的子控制器 就是 上个控制器
    if( index == self.lastChildVCIndex )
    {
        return;
    }

    CGFloat offsetX = index * self.width;
    
    //如果上一个子控制器存在
    if ( self.lastChildVC != nil )
    {
        //触发上个子控制器的 viewWillDisappear 方法
        [self.lastChildVC beginAppearanceTransition:NO animated:NO];
    }
    
    UIViewController * childVC = self.childViewControllers[index];
    
    //触发子控制器的 viewWillAppear 方法
    [childVC beginAppearanceTransition:YES animated:NO];
    
    //是否添加过这个控制器
    BOOL isFirstAdd = [self.parentViewController.childViewControllers containsObject:childVC] == YES ? NO : YES;
    
    //如果没添加过这个子控制器
    if ( isFirstAdd )
    {
        [self.parentViewController addChildViewController:childVC];
        
        childVC.view.frame = CGRectMake(offsetX, 0, self.width, self.height);
        [self.scrollView addSubview:childVC.view];
    }
    
    //如果上一个子控制器存在
    if ( self.lastChildVC != nil )
    {
        //触发上个子控制器的 viewDidDisappear 方法
        [self.lastChildVC endAppearanceTransition];
    }
    
    //触发子控制器的 viewDidAppear 方法
    [childVC endAppearanceTransition];
    
    if( isFirstAdd )
    {
        //告诉子控制器，已经移动到父控制器 （子控制器内部可以在didMoveToParentViewController:这个方法里添加代码，别忘记调用super）
        [childVC didMoveToParentViewController:self.parentViewController];
    }
    
    
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
    
    self.lastChildVC = childVC;
    self.lastChildVCIndex = index;
}



#pragma mark - setters and getters

-(NSInteger)currentSelectIndex
{
    return self.lastChildVCIndex;
}

-(void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    
    self.scrollView.scrollEnabled = scrollEnabled;
}

-(UIScrollView *)scrollView
{
    if ( _scrollView == nil )
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        //解决滑动的时候自动向下偏移20pt的问题
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _scrollView;
}

@end
