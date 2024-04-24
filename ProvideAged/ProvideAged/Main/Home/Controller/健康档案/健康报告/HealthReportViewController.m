//
//  HealthReportViewController.m
//  WatchHealth
//
//  Created by fly on 2022/10/25.
//

#import "HealthReportViewController.h"
#import <WebKit/WebKit.h>
#import "HealthTitleView.h"
#import "DatePickerView.h"
#import "UIBarButtonItem+FLYExtension.h"
#import "FLYPopupView.h"
#import "FLYTime.h"

@interface HealthReportViewController ()
{
    NSInteger _type; //1=日报、2=周报
    NSString * _date;
    NSString * _startDate;
    NSString * _endDate;
}

@property (strong, nonatomic) WKWebView * webView;
@property (nonatomic, strong) HealthTitleView * titleView;

@property (nonatomic, strong) DatePickerView * pickerView;
@property (nonatomic, strong) FLYPopupView * popupView;

@end

@implementation HealthReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initVariable];
    
    [self initUI];
    
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
    
}



#pragma mark - UI

- (void)initUI
{
    //self.navigationItem.title = @"健康报告";
    self.navigationItem.titleView = self.titleView;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"riqi" target:self action:@selector(timeClick)];
    
    [self.view addSubview:self.webView];
}



#pragma mark - DATA

- (void)initVariable
{
    _type = 1;
    _date = [FLYTime dateToStringWithDate:[NSDate date] dateFormat:FLYDateFormatTypeYMD];
    _startDate = @"";
    _endDate = @"";
    
    self.titleView.time = _date;
}

- (void)loadData
{
    [self getUrlNetwork];
}



#pragma mark - NETWORK

- (void)getUrlNetwork
{
    NSMutableDictionary * params = @{ @"oldManInfoId" : [FLYUser sharedUser].oldManInfoId, @"reportType" : @(_type) }.mutableCopy;
    
    if ( _type == 1 )
    {
        params[@"date"] = _date;
    }
    else
    {
        params[@"startDate"] = _startDate;
        params[@"endDate"] = _endDate;
    }
    
    [FLYNetworkTool postRawWithPath:@"familyApplets/generateMobileHealthReportUrl" params:params success:^(id  _Nonnull json) {
        
        NSLog(@"json = %@", json);
        
        NSString * urlString = json[@"content"];
        NSURL * url = [NSURL URLWithString:urlString];
        
    
        // 判断是否是第一次加载，还是选择日期后的重新加载
        if ( self.webView.URL == nil )
        {
            
            //第一次加载会不成功，还会有报错弹窗。所以我们先加载一次，从屏幕上移除就看不见报错弹窗了。然后一秒之后再加载一次，并添加到屏幕上。
            
            [self.webView removeFromSuperview];
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.view addSubview:self.webView];
                [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
             });
        }
        else
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
       
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}




#pragma mark - event handler

- (void)timeClick
{
    [self.popupView show];
}



#pragma mark - setters and getters

-(WKWebView *)webView
{
    if ( _webView == nil )
    {
        _webView = [[WKWebView alloc] init];
    }
    return _webView;
}

-(HealthTitleView *)titleView
{
    if ( _titleView == nil )
    {
        _titleView = [[HealthTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, NAVBAR_HEIGHT)];
    }
    return _titleView;
}

-(DatePickerView *)pickerView
{
    if ( _pickerView == nil )
    {
        WeakSelf
        StrongSelf
        _pickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 306)];
        _pickerView.dayBlock = ^(NSString * _Nonnull time) {
            
            strongSelf->_type = 1;
            strongSelf->_date = time;
            
            strongSelf.titleView.time = time;
            
            [weakSelf getUrlNetwork];
        };
        _pickerView.weekBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime) {
            
            strongSelf->_type = 2;
            strongSelf->_startDate = startTime;
            strongSelf->_endDate = endTime;
            
            strongSelf.titleView.time = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
            
            [weakSelf getUrlNetwork];
        };
        _pickerView.confirmBlock = ^{
            [weakSelf.popupView dissmiss];
        };
    }
    return _pickerView;
}

-(FLYPopupView *)popupView
{
    if( _popupView == nil )
    {
        _popupView = [FLYPopupView popupView:self.pickerView animationType:(FLYPopupAnimationTypeTop) maskType:(FLYPopupMaskTypeBlack)];
        _popupView.frame = CGRectMake(0, STATUSADDNAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSADDNAV_HEIGHT);
    }
    return _popupView;
}

@end
