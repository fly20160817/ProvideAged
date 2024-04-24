//
//  FLYVideoListViewController.m
//  ProvideAged
//
//  Created by fly on 2021/12/24.
//

#import "FLYVideoListViewController.h"
#import "UICollectionView+FLYRefresh.h"
#import "FLYVideoCell.h"
#import <TGIOT/TGIOT.h>

@interface FLYVideoListViewController () < UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation FLYVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //导航栏遮挡UIViewController的问题
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    navigationBar.translucent = NO;
}



#pragma mark - DATA

- (void)loadData
{
    [self.collectionView.mj_header beginRefreshing];
}



#pragma mark - NETWORK

- (void)getVideoListNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId };
    
    [FLYNetworkTool postRawWithPath:API_VIDEOLIST params:params success:^(id  _Nonnull json) {
        
        NSArray * array = [FLYVideoModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        [self.collectionView loadDataSuccess:array];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self.collectionView loadDataFailed:error];
    }];
}

//获取摄像头token
- (void)getCameraToken:(FLYVideoModel *)videoModel
{
    NSDictionary * params = @{ @"userid" : self.houseInfoId };
    
    [FLYNetworkTool postRawWithPath:API_CAMERALOGIN params:params success:^(id  _Nonnull json) {
        
        NSString * token = json[SERVER_DATA];
        [self initSDK:token videoModel:videoModel];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"视频监控";
    
    [self.view addSubview:self.collectionView];
}



#pragma mark - event handler

- (void)openCamera:(FLYVideoModel *)videoModel
{
    [self getCameraToken:videoModel];
}



#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

/**** 如果子类重写了下面方法，这里的就不会执行了 ****/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionView.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYVideoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionView.cellReuseIdentifier forIndexPath:indexPath];
    cell.videoModel = self.collectionView.dataList[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYVideoModel * videoModel = self.collectionView.dataList[indexPath.item];
    [self openCamera:videoModel];
}



#pragma mark - 摄像头

- (void)initSDK:(NSString *)token videoModel:(FLYVideoModel *)videoModel
{
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"TGIOTConfig" ofType:@"plist"];
    
    [TGIOTManager initSDKWithAppId:TGAPPID token:token configPath:configPath callBack:^(TGIOTErrorCode code, NSError * _Nullable error) {
        
        NSLog(@"探鸽初始化结果：%ld, error = %@", (long)code, error);
        
        [self openDevice:videoModel];
    }];
}

- (void)openDevice:(FLYVideoModel *)videoModel
{
    [TGIOTManager openDeviceWithController:self deviceUuid:videoModel.imei callBack:^(TGIOTErrorCode code, NSError * _Nullable error) {
        
        NSLog(@"code = %ld", (long)code);
        
        if ( code != TGIOTErrorCode_Success )
        {
            [SVProgressHUD showErrorWithStatus:@"摄像头打开失败"];
        }
    }];
}



#pragma mark - setters and getters

-(UICollectionView *)collectionView
{
    if ( _collectionView == nil )
    {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        //最小列间距
        flow.minimumInteritemSpacing = 0;
        //最小行间距
        flow.minimumLineSpacing = 12;
        flow.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 235);
        flow.sectionInset = UIEdgeInsetsMake(12, 20, 12, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FLYVideoCell class] forCellWithReuseIdentifier:_collectionView.cellReuseIdentifier];
        [_collectionView addRefreshingTarget:self action:@selector(getVideoListNetwork)];
    }
    return _collectionView;
}


@end
