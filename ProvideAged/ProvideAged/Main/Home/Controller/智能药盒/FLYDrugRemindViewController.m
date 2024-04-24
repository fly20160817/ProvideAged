//
//  FLYDrugRemindViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYDrugRemindViewController.h"
#import "UICollectionView+FLYRefresh.h"
#import "FLYDrugRemindCell.h"
#import "FLYAddDrugRemindViewController.h"
#import "FLYDrugRemindModel.h"

@interface FLYDrugRemindViewController () < UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) FLYButton * addBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation FLYDrugRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getDrugRemindListNetwrok];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(70);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addBtn.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(22);
        make.height.mas_equalTo(50);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.left.bottom.right.equalTo(self.view).with.offset(0);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    
}



#pragma mark - NETWORK

- (void)getDrugRemindListNetwrok
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"deviceId" : self.deviceId, @"pageNo" : @"1", @"pageSize" : @"99" };

    
    [FLYNetworkTool postRawWithPath:API_DRUGREMINDLIST params:params success:^(id  _Nonnull json) {
        
        NSMutableArray * array = [FLYDrugRemindModel mj_objectArrayWithKeyValuesArray:json[@"content"][@"list"]];
        
        self.collectionView.dataList = array;
        [self.collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
    }];
}

- (void)switchRemindNetwork:(NSString *)idField isOpen:(BOOL)isOpen
{
    NSDictionary * params = @{ @"id" : idField, @"isUsed" : isOpen ? @"1" : @"2"  };
    
    [FLYNetworkTool postRawWithPath:API_SWITCHREMIND params:params success:^(id  _Nonnull json) {
        
        [self getDrugRemindListNetwrok];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
    }];
}

- (void)deleteRemindNetwork:(NSString *)idField
{
    NSDictionary * params = @{ @"ids" : @[idField] };
    
    [FLYNetworkTool postRawWithPath:API_DELETEREMIND params:params success:^(id  _Nonnull json) {
        
        [self getDrugRemindListNetwrok];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"用药提醒";

    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.collectionView];
}



#pragma mark - event handler

- (void)addClick:(UIButton *)button
{
    FLYAddDrugRemindViewController * vc = [[FLYAddDrugRemindViewController alloc] init];
    vc.deviceId = self.deviceId;
    vc.oldManInfoId = self.oldManInfoId;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionView.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    FLYDrugRemindCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionView.cellReuseIdentifier forIndexPath:indexPath];
    
    cell.model = self.collectionView.dataList[indexPath.row];
    
    cell.switchBlock = ^(FLYDrugRemindModel * _Nonnull model, BOOL isOpen) {
        
        [weakSelf switchRemindNetwork:model.idField isOpen:isOpen];
    };
    
    cell.deleteBlock = ^(FLYDrugRemindModel * _Nonnull model) {
        
        [weakSelf deleteRemindNetwork:model.idField];
    };
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}



#pragma mark - setters and getters


- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_R(16);
        _titleLabel.textColor = COLORHEX(@"#333333");
        _titleLabel.text = @"用药提醒";
    }
    return _titleLabel;
}


-(UICollectionView *)collectionView
{
    if ( _collectionView == nil )
    {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumInteritemSpacing = 0;
        flow.minimumInteritemSpacing = 14;
        flow.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 210);
        flow.sectionInset = UIEdgeInsetsMake(0, 20, 20, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = COLORHEX(@"#F9F9F9");
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FLYDrugRemindCell class] forCellWithReuseIdentifier:_collectionView.cellReuseIdentifier];
    }
    return _collectionView;
}

-(FLYButton *)addBtn
{
    if ( _addBtn == nil )
    {
        _addBtn = [FLYButton buttonWithImage:IMAGENAME(@"drug_add") title:@"添加提醒" titleColor:COLORHEX(@"#ffffff") font:FONT_R(15)];
        _addBtn.backgroundColor = [UIColor colorWithRed:49/255.0 green:187/255.0 blue:163/255.0 alpha:1.0];
        _addBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
        _addBtn.layer.shadowOffset = CGSizeMake(0,3);
        _addBtn.layer.shadowOpacity = 1;
        _addBtn.layer.shadowRadius = 12;
        _addBtn.layer.cornerRadius = 10;
        [_addBtn setImagePosition:(FLYImagePositionLeft) spacing:10];
        [_addBtn addTarget:self action:@selector(addClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addBtn;
}


@end

