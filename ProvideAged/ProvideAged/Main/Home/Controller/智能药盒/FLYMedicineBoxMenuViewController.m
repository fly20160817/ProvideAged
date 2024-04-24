//
//  FLYMedicineBoxMenuViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYMedicineBoxMenuViewController.h"
#import "UICollectionView+FLYRefresh.h"
#import "FLYBoxMenuCell.h"
#import "FLYBoxMenuModel.h"
#import "FLYBoxSetupTimeViewController.h"
#import "FLYMedicationRecordViewController.h"
#import "FLYDrugListViewController.h"
#import "FLYDrugRemindViewController.h"
#import "FLYDeviceModel.h"

@interface FLYMedicineBoxMenuViewController () < UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) FLYDeviceModel * deviceModel;

@end

@implementation FLYMedicineBoxMenuViewController

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
    [self getMedicineBoxNetwork];
    
    
    
    FLYBoxMenuModel * model1 = [[FLYBoxMenuModel alloc] init];
    model1.imageName = @"box_qingdan";
    model1.title = @"药品清单";
    
    FLYBoxMenuModel * model2 = [[FLYBoxMenuModel alloc] init];
    model2.imageName = @"box_shijian";
    model2.title = @"服药时间";
    
    FLYBoxMenuModel * model3 = [[FLYBoxMenuModel alloc] init];
    model3.imageName = @"box_tixing";
    model3.title = @"用药提醒";
    
    FLYBoxMenuModel * model4 = [[FLYBoxMenuModel alloc] init];
    model4.imageName = @"box_jilu";
    model4.title = @"服药记录";
    
    self.collectionView.dataList = @[model1, model2, model3, model4].mutableCopy;
    
    [self.collectionView reloadData];
}



#pragma mark - NETWORK

- (void)getMedicineBoxNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"type" : @"16" };
    
    [FLYNetworkTool postRawWithPath:API_DEVICELIST params:params success:^(id  _Nonnull json) {
        
        NSArray * array = [FLYDeviceModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        self.deviceModel = array.firstObject;
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
    }];
    
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"智能药盒";
    
    [self.view addSubview:self.collectionView];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionView.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYBoxMenuCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionView.cellReuseIdentifier forIndexPath:indexPath];
    
    cell.model = self.collectionView.dataList[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.item == 0 )
    {
        FLYDrugListViewController * vc = [[FLYDrugListViewController alloc] init];
        vc.oldManInfoId = self.oldManInfoId;
        vc.deviceId = self.deviceModel.idField == nil ? @"" : self.deviceModel.idField;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( indexPath.item == 1 )
    {
        FLYBoxSetupTimeViewController * vc = [[FLYBoxSetupTimeViewController alloc] init];
        vc.oldManInfoId = self.oldManInfoId;
        vc.deviceId = self.deviceModel.idField == nil ? @"" : self.deviceModel.idField;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( indexPath.item == 2 )
    {
        FLYDrugRemindViewController * vc = [[FLYDrugRemindViewController alloc] init];
        vc.oldManInfoId = self.oldManInfoId;
        vc.deviceId = self.deviceModel.idField == nil ? @"" : self.deviceModel.idField;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( indexPath.item == 3 )
    {
        FLYMedicationRecordViewController * vc = [[FLYMedicationRecordViewController alloc] init];
        vc.oldManInfoId = self.oldManInfoId;
        vc.deviceId = self.deviceModel.idField == nil ? @"" : self.deviceModel.idField;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        _collectionView.backgroundColor = COLORHEX(@"#F9F9F9");
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FLYBoxMenuCell class] forCellWithReuseIdentifier:_collectionView.cellReuseIdentifier];
    }
    return _collectionView;
}



@end

