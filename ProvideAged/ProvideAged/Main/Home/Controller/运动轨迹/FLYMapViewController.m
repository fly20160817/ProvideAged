//
//  FLYMapViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import "FLYMapViewController.h"
#import <MapKit/MapKit.h>
#import "FLYAnnotationModel.h"
#import "FLYMapDetailView.h"
#import "UIButton+FLYExtension.h"
#import "FLYStepHistoryViewController.h"
#import "FLYElderModel.h"
#import "FLYDeviceLocationModel.h"

@interface FLYMapViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) FLYMapDetailView * mapDetailView;
@property (nonatomic, strong) UIButton * regionBtn;
@property (nonatomic, strong) UIButton * refreshBtn;

@property (nonatomic, strong) FLYDeviceLocationModel * watchInfoModel;
@property (nonatomic, strong) FLYDeviceLocationModel * cardInfoModel;

@end

@implementation FLYMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    [self.mapDetailView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.bottom.equalTo(self.view).with.offset(-18);
        make.right.equalTo(self.view).with.offset(-20);
        CGFloat height = self.mapDetailView.type == 0 ? 198 : 168;
        make.height.mas_equalTo(height);
    }];
    
    [self.regionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-15);
        make.bottom.equalTo(self.mapDetailView.mas_top).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-15);
        make.bottom.equalTo(self.regionBtn.mas_top).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}



#pragma mark - DATA

- (void)loadData
{
    [self getWatchInfoNetwork];
    
    [self getCardInfoNetwork];
}

//填充数据
- (void)fillData
{
    if ( self.mapDetailView.type == 0 )
    {
        self.mapDetailView.address = self.watchInfoModel.address;
        self.mapDetailView.step = [@(self.watchInfoModel.pedometer) stringValue];
        self.mapDetailView.distance = self.watchInfoModel.distance;
    }
    else
    {
        self.mapDetailView.address = self.cardInfoModel.address;
        self.mapDetailView.step = [@(self.cardInfoModel.pedometer) stringValue];
        self.mapDetailView.distance = self.cardInfoModel.distance;
    }
    
    
    //添加大头针(老人的位置)
    [self addAnnotation];
    
    //设置显示的区域
    [self setRegion];
}


#pragma mark - NETWORK

- (void)getWatchInfoNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"deviceType" : @"7" };
    
    [FLYNetworkTool postRawWithPath:API_CARDLOCATION params:params success:^(id json) {
        
        self.watchInfoModel = [FLYDeviceLocationModel mj_objectWithKeyValues:json[SERVER_DATA]];
        
        if (self.mapDetailView.type == 0 )
        {
            [self fillData];
        }

        
    } failure:^(id obj) {
        
        NSLog(@"失败： %@", obj);
    }];
}

- (void)getCardInfoNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"deviceType" : @"10" };
    
    [FLYNetworkTool postRawWithPath:API_CARDLOCATION params:params success:^(id json) {
        
        self.cardInfoModel = [FLYDeviceLocationModel mj_objectWithKeyValues:json[SERVER_DATA]];
        
        if (self.mapDetailView.type == 1 )
        {
            [self fillData];
        }
        
    } failure:^(id obj) {
        
        NSLog(@"失败： %@", obj);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"运动轨迹";
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.mapDetailView];
    [self.view addSubview:self.regionBtn];
    [self.view addSubview:self.refreshBtn];
}

//添加大头针
- (void)addAnnotation
{
    //移除所有大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    //添加大头针
    double latitude = self.mapDetailView.type == 0 ? [self.watchInfoModel.latitude doubleValue] : [self.cardInfoModel.latitude doubleValue];
    double longitude = self.mapDetailView.type == 0 ? [self.watchInfoModel.longitude doubleValue] : [self.cardInfoModel.longitude doubleValue];
    
    if ( latitude == 0 && longitude == 0 )
    {
        return;
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    FLYAnnotationModel * annotationModel = [[FLYAnnotationModel alloc] init];
    annotationModel.coordinate = coordinate;
    annotationModel.title = @"老人位置";
    [self.mapView addAnnotation:annotationModel];
}

//设置显示的区域
- (void)setRegion
{
    double latitude = self.mapDetailView.type == 0 ? [self.watchInfoModel.latitude doubleValue] : [self.cardInfoModel.latitude doubleValue];
    double longitude = self.mapDetailView.type == 0 ? [self.watchInfoModel.longitude doubleValue] : [self.cardInfoModel.longitude doubleValue];
    
    if ( latitude == 0 && longitude == 0 )
    {
        return;
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    //设置当前地图显示的区域
    MKCoordinateSpan span = MKCoordinateSpanMake(0.026256, 0.017767);
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
}



#pragma mark - event handler

- (void)regionClick:(UIButton *)button
{
    double latitude = self.mapDetailView.type == 0 ? [self.watchInfoModel.latitude doubleValue] : [self.cardInfoModel.latitude doubleValue];
    double longitude = self.mapDetailView.type == 0 ? [self.watchInfoModel.longitude doubleValue] : [self.cardInfoModel.longitude doubleValue];
    
    if ( latitude == 0 && longitude == 0 )
    {
        return;
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    //设置当前地图显示的区域
    MKCoordinateSpan span = MKCoordinateSpanMake(0.026256, 0.017767);
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
}

- (void)refreshClick:(UIButton *)button
{
    [self loadData];
}

//跳转导航
- (void)jumpNavigation
{
    double latitude = self.mapDetailView.type == 0 ? [self.watchInfoModel.latitude doubleValue] : [self.cardInfoModel.latitude doubleValue];
    double longitude = self.mapDetailView.type == 0 ? [self.watchInfoModel.longitude doubleValue] : [self.cardInfoModel.longitude doubleValue];
    
    if ( latitude == 0 && longitude == 0 )
    {
        [SVProgressHUD showImage:nil status:@"位置信息缺失"];
        return;
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    
    //MKPlacemark 继承 CLPlacemark
    //1.创建MKPlacemark (可以通过经纬度或CLPlacemark来创建)
    MKPlacemark * placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate];
    
    //2.创建起点位置 (获取当前位置)
    MKMapItem * sourceItem = [MKMapItem mapItemForCurrentLocation];
    
    //3.创建MKMapItem -->终点的位置  (MKMapItem 地图上的一个点)
    MKMapItem * destinationItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    destinationItem.name = @"老人位置";
    
    //4.打开系统自带地图导航 (WithItems:要去的目的地 launchOptions:导航参数)
    NSDictionary * launchOption = @{ MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey : [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey : @(YES) };
    
    [MKMapItem openMapsWithItems:@[sourceItem, destinationItem] launchOptions:launchOption];
}



#pragma mark - setters and getters

-(MKMapView *)mapView
{
    if ( _mapView == nil )
    {
        _mapView = [[MKMapView alloc] init];
    }
    return _mapView;
}

-(FLYMapDetailView *)mapDetailView
{
    if ( _mapDetailView == nil )
    {
        WeakSelf
        _mapDetailView = [[FLYMapDetailView alloc] init];
        _mapDetailView.type = 0;
        _mapDetailView.changeTypeBlock = ^(NSInteger type) {
            [weakSelf.view setNeedsLayout];
            [weakSelf.view layoutIfNeeded];
            
            [weakSelf fillData];
        };
        _mapDetailView.moreBlock = ^{
            
            FLYStepHistoryViewController * vc = [[FLYStepHistoryViewController alloc] init];
            vc.oldManInfoId = weakSelf.oldManInfoId;
            if (weakSelf.mapDetailView.type == 0 )
            {
                vc.deviceInfoId = weakSelf.watchInfoModel.idField;
            }
            else if (weakSelf.mapDetailView.type == 1 )
            {
                vc.deviceInfoId = weakSelf.cardInfoModel.idField;
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _mapDetailView.navigationBlock = ^{
            
            [weakSelf jumpNavigation];
        };
    }
    return _mapDetailView;
}



-(UIButton *)regionBtn
{
    if ( _regionBtn == nil )
    {
        _regionBtn = [UIButton buttonWithImage:IMAGENAME(@"dituweizhi")];
        [_regionBtn addTarget:self action:@selector(regionClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _regionBtn;
}

-(UIButton *)refreshBtn
{
    if ( _refreshBtn == nil )
    {
        _refreshBtn = [UIButton buttonWithImage:IMAGENAME(@"weizhishuaxin")];
        [_refreshBtn addTarget:self action:@selector(refreshClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _refreshBtn;
}

@end
