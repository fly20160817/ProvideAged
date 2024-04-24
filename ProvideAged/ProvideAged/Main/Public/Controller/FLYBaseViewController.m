//
//  FLYBaseViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYBaseViewController.h"
#import "FLYNavigationController.h"

@interface FLYBaseViewController ()

@end

@implementation FLYBaseViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    ((FLYNavigationController *)self.navigationController).isLine = self.showNavLine;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    ((FLYNavigationController *)self.navigationController).isLine = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLORHEX(@"#F9F9F9");
}


@end
