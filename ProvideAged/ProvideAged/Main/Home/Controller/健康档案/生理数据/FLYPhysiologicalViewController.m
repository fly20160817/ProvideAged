//
//  FLYPhysiologicalViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYPhysiologicalViewController.h"
#import "UICollectionView+FLYRefresh.h"
#import "FLYPhysiologicalCell.h"
#import "FLYPhysiologicalChartViewController.h"
#import "FLYHealthModel.h"

@interface FLYPhysiologicalViewController () < UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation FLYPhysiologicalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view).with.offset(0);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    [self.collectionView.mj_header beginRefreshing];
}



#pragma mark - NETWORK

- (void)getPhysiologicalListNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"sort" : @"1" };
    
    [FLYNetworkTool postRawWithPath:API_HEALTH params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:YES success:^(id  _Nonnull json) {
        
        NSArray * array = [FLYHealthModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        [self.collectionView loadDataSuccess:array];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.view.backgroundColor = COLORHEX(@"#F9F9F9");
    
    [self.view addSubview:self.collectionView];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionView.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYPhysiologicalCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionView.cellReuseIdentifier forIndexPath:indexPath];
    cell.healthModel = self.collectionView.dataList[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYPhysiologicalChartViewController * vc = [[FLYPhysiologicalChartViewController alloc] init];
    vc.healthModel = self.collectionView.dataList[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - setters and getters

-(UICollectionView *)collectionView
{
    if ( _collectionView == nil )
    {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumInteritemSpacing = 0;
        flow.minimumInteritemSpacing = 13;
        flow.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 76);
        flow.sectionInset = UIEdgeInsetsMake(15, 20, 20, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FLYPhysiologicalCell class] forCellWithReuseIdentifier:_collectionView.cellReuseIdentifier];
        [_collectionView addRefreshingTarget:self action:@selector(getPhysiologicalListNetwork)];
    }
    return _collectionView;
}



@end

