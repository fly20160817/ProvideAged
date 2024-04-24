//
//  FLYDeviceClassificationViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYDeviceClassificationViewController.h"
#import "UICollectionView+FLYRefresh.h"
#import "FLYDeviceClassificationCell.h"
#import "FLYDeviceClassificationModel.h"
#import "FLYDeviceListViewController.h"

@interface FLYDeviceClassificationViewController () < UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation FLYDeviceClassificationViewController

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
    FLYDeviceClassificationModel * model1 = [[FLYDeviceClassificationModel alloc] init];
    model1.iconName = @"fangwushebei";
    model1.title = @"房屋设备";
    model1.number = [@(self.elderModel.houseEquipmentCount) stringValue];
    model1.warning = self.elderModel.houseEquipmentAlertCount == 0 ? NO : YES;
    
    FLYDeviceClassificationModel * model2 = [[FLYDeviceClassificationModel alloc] init];
    model2.iconName = @"gerenshebei";
    model2.title = @"个人设备";
    model2.number = [@(self.elderModel.personalEquipmentCount) stringValue];
    model2.warning = self.elderModel.personalEquipmentAlertCount == 0 ? NO : YES;;
    
    self.collectionView.dataList = @[model1, model2].mutableCopy;
    
    [self.collectionView reloadData];
}



#pragma mark - NETWORK



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"选择设备";
    
    [self.view addSubview:self.collectionView];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionView.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYDeviceClassificationCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionView.cellReuseIdentifier forIndexPath:indexPath];
    
    cell.model = self.collectionView.dataList[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYDeviceListViewController * vc = [[FLYDeviceListViewController alloc] init];
    vc.elderModel = self.elderModel;
    vc.useType = indexPath.row == 0 ? 1 : 2;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - setters and getters

-(UICollectionView *)collectionView
{
    if ( _collectionView == nil )
    {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumInteritemSpacing = 0;
        flow.minimumInteritemSpacing = 15;
        flow.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 86);
        flow.sectionInset = UIEdgeInsetsMake(15, 20, 20, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FLYDeviceClassificationCell class] forCellWithReuseIdentifier:_collectionView.cellReuseIdentifier];
    }
    return _collectionView;
}



@end

