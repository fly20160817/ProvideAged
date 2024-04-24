//
//  FLYTempAuthorizeListViewController.m
//  ProvideAged
//
//  Created by fly on 2021/12/23.
//

#import "FLYTempAuthorizeListViewController.h"
#import "UICollectionView+FLYRefresh.h"
#import "FLYTempAuthorizeCell.h"
#import "FLYTempAuthorizeViewController.h"
#import "FLYAuthorizeDetailViewController.h"
#import "FLYAuthorizeModel.h"

@interface FLYTempAuthorizeListViewController () < UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) FLYButton * addBtn;

@end

@implementation FLYTempAuthorizeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAuthorizationListNotification:) name:@"refreshAuthorizationListNotification" object:nil];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.view).with.offset(SAFE_BOTTOM == 0 ? -20 : -SAFE_BOTTOM);
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - DATA

- (void)loadData
{
    [self.collectionView.mj_header beginRefreshing];
}



#pragma mark - NETWORK

- (void)getAuthorizeListNetwork
{
    NSDictionary * params = @{ @"deviceInfoId" : self.deviceInfoId, @"authType" : @"2" };
    
    [FLYNetworkTool postRawWithPath:API_TEMPAUTHORIZELIST params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:YES success:^(id  _Nonnull json) {
        
        NSArray * array = [FLYAuthorizeModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA][@"list"]];
        [self.collectionView loadDataSuccess:array total:[json[SERVER_DATA][@"total"] integerValue]];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self.collectionView loadDataFailed:error];
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"临时授权";
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.addBtn];
}



#pragma mark - event handler

- (void)addClick:(UIButton *)button
{
    FLYTempAuthorizeViewController * vc = [[FLYTempAuthorizeViewController alloc] init];
    vc.deviceInfoId = self.deviceInfoId;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - Notification

- (void)refreshAuthorizationListNotification:(NSNotification *)notification
{
    [self.collectionView.mj_header beginRefreshing];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionView.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYTempAuthorizeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionView.cellReuseIdentifier forIndexPath:indexPath];
    cell.authorizeModel = self.collectionView.dataList[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYAuthorizeDetailViewController * vc = [[FLYAuthorizeDetailViewController alloc] init];
    vc.authorizeModel = self.collectionView.dataList[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
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
        flow.minimumLineSpacing = 15;
        flow.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 123);
        flow.sectionInset = UIEdgeInsetsMake(15, 20, 15, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FLYTempAuthorizeCell class] forCellWithReuseIdentifier:_collectionView.cellReuseIdentifier];
        [_collectionView addRefreshingTarget:self action:@selector(getAuthorizeListNetwork)];
    }
    return _collectionView;
}

-(FLYButton *)addBtn
{
    if ( _addBtn == nil )
    {
        _addBtn = [FLYButton buttonWithTitle:@"新增权限" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        _addBtn.backgroundColor = COLORHEX(@"#2BB9A0");
        _addBtn.layer.cornerRadius = 4;
        [_addBtn addTarget:self action:@selector(addClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addBtn;
}


@end


