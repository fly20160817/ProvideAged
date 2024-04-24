//
//  FLYTrackViewController.m
//  ProvideAged
//
//  Created by fly on 2021/11/9.
//

#import "FLYTrackViewController.h"
#import "FLYTrackModel.h"
#import <MapKit/MapKit.h>
#import "FLYTrackView.h"

@interface FLYTrackViewController () < MKMapViewDelegate >

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSArray * dataList;

@property (nonatomic, strong) FLYTrackView * trackView;

@end

@implementation FLYTrackViewController

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
    
    [self.trackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.bottom.equalTo(self.view).with.offset(-18);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(50);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    [self getTrackListNetwork];
    
    self.trackView.step = self.step;
    self.trackView.distance = self.distance;
    self.trackView.time = self.searchDate;
}



#pragma mark - NETWIRK

- (void)getTrackListNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"deviceInfoId" : self.deviceInfoId, @"searchDate" : self.searchDate };
    
    [FLYNetworkTool postRawWithPath:API_TRACK params:params success:^(id  _Nonnull json) {
        
        self.dataList = [FLYTrackModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        
        [self drawLine];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"运动轨迹";
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.trackView];
}



#pragma mark - private methods

- (void)drawLine
{
    /******画线******/
    //CLLocationCoordinate2D pointToUse[array.count];
    CLLocationCoordinate2D * pointToUse = malloc([self.dataList count] * sizeof(CLLocationCoordinate2D));
    
    for ( NSInteger i = 0; i < self.dataList.count; i++ )
    {
        FLYTrackModel * trackModel = self.dataList[i];
        
        NSString *lon = trackModel.lon;
        NSString *lat = trackModel.lat;
  
        //创建经纬度CLLocationCoordinate2D，并放入数组
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
        pointToUse[i] = coordinate;
    }
    //画线
    MKPolyline * myPolyline = [MKPolyline polylineWithCoordinates:pointToUse count:self.dataList.count];
    [self.mapView addOverlay:myPolyline];
    
    free(pointToUse);
    
    
    
    /******设置地图在可见范围******/
    MKMapRect mapRect = MKMapRectNull;
    for ( NSInteger i = 0; i < self.dataList.count; i++ )
    {
        FLYTrackModel * trackModel = self.dataList[i];
        
        NSString *lon = trackModel.lon;
        NSString *lat = trackModel.lat;
                
        CLLocationDegrees longitude = [lon doubleValue];
        CLLocationDegrees latitude  = [lat doubleValue];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(mapRect))
        {
            mapRect = pointRect;
        }
        else
        {
            mapRect = MKMapRectUnion(mapRect, pointRect);
        }
    }
    const CGFloat screenEdgeInset = 20;
    UIEdgeInsets mapInset = UIEdgeInsetsMake(screenEdgeInset, screenEdgeInset, screenEdgeInset * 8, screenEdgeInset);
    //mapRect = [self.mapView mapRectThatFits:mapRect edgePadding:mapInset];
    mapRect = [self.mapView mapRectThatFits:mapRect];
    [self.mapView setVisibleMapRect:mapRect edgePadding:mapInset animated:YES];
    
}



#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        
        polylineRenderer.lineWidth = 2.5;
        polylineRenderer.strokeColor = [UIColor colorWithHexString:@"#0068b7"];
        polylineRenderer.lineJoin = kCGLineJoinRound;
        polylineRenderer.lineCap = kCGLineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}



#pragma mark - setters and getters

-(MKMapView *)mapView
{
    if ( _mapView == nil )
    {
        _mapView = [[MKMapView alloc] init];
        _mapView.delegate = self;
    }
    return _mapView;
}

-(FLYTrackView *)trackView
{
    if ( _trackView == nil )
    {
        _trackView = [[FLYTrackView alloc] init];
    }
    return _trackView;
}

@end
