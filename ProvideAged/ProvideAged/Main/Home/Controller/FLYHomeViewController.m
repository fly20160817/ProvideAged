//
//  FLYHomeViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYHomeViewController.h"
#import "FLYSegmentBar.h"
#import "FLYPersonalHomeViewController.h"
#import "UIView+FLYLayer.h"
#import "FLYDeviceManager.h"
#import "FLYElderModel.h"

@interface FLYHomeViewController () < UIScrollViewDelegate, FLYSegmentBarDelegate >

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) NSArray<FLYElderModel *> * elderArray;//老人列表
@property (nonatomic, strong) FLYSegmentBar * segmentBar;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIButton * callPhoneBtn;

@end

@implementation FLYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    [self.callPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(STATUSBAR_HEIGHT + 18);
        make.right.equalTo(self.view).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(87, 30));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.callPhoneBtn);
        make.left.equalTo(self.view).with.offset(20);
    }];
    
    [self.segmentBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(25);
        make.left.equalTo(self.view).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 80, 33));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentBar.mas_bottom).with.offset(0);
        make.left.bottom.right.equalTo(self.view);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    [self getElderListNetwork];
}

- (void)refreshData
{
    /*
     1.移除子视图子、控制器
     2.给segmentBar重新复制
     */
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj.view removeFromSuperview];
        [obj removeFromParentViewController];
    }];
    
    
    [self getElderListNetwork];
}



#pragma NETWORK

- (void)getElderListNetwork
{
    [FLYNetworkTool postRawWithPath:API_ELDERLIST params:nil success:^(id json) {
        
        self.elderArray = [FLYElderModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        
    } failure:^(id obj) {
        
        NSLog(@"失败： %@", obj);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationBarHidden = YES;
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:82/255.0 green:205/255.0 blue:184/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:48/255.0 green:187/255.0 blue:163/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0f)];
    [self.view.layer addSublayer:gl];
    
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.callPhoneBtn];
    [self.view addSubview:self.segmentBar];
}



#pragma mark - event handler

- (void)calClick:(UIButton *)button
{
    NSString * phone = [self.elderArray[self.segmentBar.selectIndex] phone];
    [FLYDeviceManager callPhone:phone];
    
    NSLog(@"phone = %ld", (long)self.segmentBar.selectIndex);
    
}



#pragma mark - FLYSegmentBarDelegate

-(void)segmentBar:(FLYSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    [self showChildVCViewsAtIndex:toIndex];
    
    
    //保存当前的老人id
    FLYElderModel * elderModel = self.elderArray[toIndex];
    [FLYUser sharedUser].oldManInfoId = elderModel.idField;
    [FLYUser saveUser];
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger idx = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.segmentBar.selectIndex = idx;
    [self showChildVCViewsAtIndex:idx];
    
    
    //保存当前的老人id
    FLYElderModel * elderModel = self.elderArray[idx];
    [FLYUser sharedUser].oldManInfoId = elderModel.idField;
    [FLYUser saveUser];
}



#pragma mark - private methods

- (void)showChildVCViewsAtIndex: (NSInteger)index
{
    // 数据过滤
    if ( index < 0 || index >= self.childViewControllers.count )
    {
        return;
    }
        
    FLYPersonalHomeViewController * vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.segmentBar.frame) - TABBER_HEIGHT);
    vc.refreshBlock = ^{
        [self refreshData];
    };
    [self.scrollView addSubview:vc.view];
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}



#pragma mark - setters and getters

-(void)setElderArray:(NSArray<FLYElderModel *> *)elderArray
{
    _elderArray = elderArray;
        
    
    NSMutableArray * titleNames = [NSMutableArray array];
    [elderArray enumerateObjectsUsingBlock:^(FLYElderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleNames addObject:obj.name];
    }];
    
    self.segmentBar.titleNames = titleNames;
    
    
    for ( int i = 0; i < self.elderArray.count; i++ )
    {
        FLYPersonalHomeViewController * vc = [[FLYPersonalHomeViewController alloc] init];
        vc.oldManInfoId = [self.elderArray[i] idField];
        [self addChildViewController:vc];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.elderArray.count, 0);
    
    //展示第一个页面
    self.segmentBar.selectIndex = 0;
    [self showChildVCViewsAtIndex:0];
}

-(FLYSegmentBar *)segmentBar
{
    if ( _segmentBar == nil )
    {
        _segmentBar = [[FLYSegmentBar alloc] init];
        _segmentBar.delegate = self;
        
        FLYSegmentBarConfig *config = [FLYSegmentBarConfig defaultConfig];
        config.segmentBarBackColor = [UIColor clearColor];
        config.itemNormalColor = [UIColor colorWithWhite:1 alpha:0.8];
        config.itemSelectColor = [UIColor whiteColor];
        config.itemNormalFont = FONT_R(12);
        config.itemSelectFont = FONT_M(16);
        config.indicatorColor = [UIColor whiteColor];
        config.indicatorHeight = 1.5;
        config.indicatorWidth = 60;
        _segmentBar.config = config;

    }
    return _segmentBar;
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

-(UIButton *)callPhoneBtn
{
    if ( _callPhoneBtn == nil )
    {
        _callPhoneBtn = [UIButton buttonWithTitle:@"语音通话" titleColor:COLORHEX(@"#2BB9A0") font:FONT_M(13)];
        _callPhoneBtn.backgroundColor = [UIColor whiteColor];
        _callPhoneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5.5, 0, 5.5);
        [_callPhoneBtn roundCorner:15];
        [_callPhoneBtn shadow:[UIColor colorWithWhite:0 alpha:0.1] opacity:1 radius:5 offset:CGSizeMake(0,3)];
        [_callPhoneBtn addTarget:self action:@selector(calClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _callPhoneBtn;
}

-(UILabel *)titleLabel
{
    if ( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = FONT_S(20);
        _titleLabel.text = @"智爱云看护";
    }
    return _titleLabel;
}

@end
