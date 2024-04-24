//
//  FLYDrugListViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYDrugListViewController.h"
#import "UICollectionView+FLYRefresh.h"
#import "FLYDrugCell.h"
#import "BRDatePickerView.h"
#import "FLYTime.h"
#import "UIBarButtonItem+FLYExtension.h"
#import "FLYAddDrugViewController.h"
#import "FLYDrugModel.h"

@interface FLYDrugListViewController () < UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) FLYButton * addBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation FLYDrugListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getDrugListNetwork];
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

- (void)getDrugListNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"deviceId" : self.deviceId };
    
    [FLYNetworkTool postRawWithPath:API_DRUGLIST params:params success:^(id  _Nonnull json) {
        
        NSArray * array = [FLYDrugModel mj_objectArrayWithKeyValuesArray:json[@"content"][@"list"]];
        
        [self.collectionView loadDataSuccess:array];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
        //[self.collectionView loadDataFailed:error];
    }];
}

- (void)deleteDrugNetwork:(NSString *)idField
{
    NSDictionary * params = @{ @"ids" : @[idField] };
    
    [FLYNetworkTool postRawWithPath:API_DELETEDRUG params:params success:^(id  _Nonnull json) {
        
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self getDrugListNetwork];
        });
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"药品清单";

    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.collectionView];
}



#pragma mark - event handler

- (void)addClick:(UIButton *)button
{
    FLYAddDrugViewController * vc = [[FLYAddDrugViewController alloc] init];
    vc.oldManInfoId = self.oldManInfoId;
    vc.deviceId = self.deviceId;
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
    
    FLYDrugCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionView.cellReuseIdentifier forIndexPath:indexPath];
    
    cell.model = self.collectionView.dataList[indexPath.row];
    
    cell.addBlock = ^(FLYDrugModel * _Nonnull model) {
        
        FLYAddDrugViewController * vc = [[FLYAddDrugViewController alloc] init];
        vc.oldManInfoId = self.oldManInfoId;
        vc.deviceId = self.deviceId;
        vc.type = 1;
        vc.drugModel = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    cell.deleteBlock = ^(FLYDrugModel * _Nonnull model) {
        
        [weakSelf deleteDrugNetwork:model.idField];
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
        _titleLabel.text = @"已添加药品";
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
        flow.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 166);
        flow.sectionInset = UIEdgeInsetsMake(0, 20, 20, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = COLORHEX(@"#F9F9F9");
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FLYDrugCell class] forCellWithReuseIdentifier:_collectionView.cellReuseIdentifier];
    }
    return _collectionView;
}

-(FLYButton *)addBtn
{
    if ( _addBtn == nil )
    {
        _addBtn = [FLYButton buttonWithImage:IMAGENAME(@"drug_add") title:@"添加药品" titleColor:COLORHEX(@"#ffffff") font:FONT_R(15)];
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

