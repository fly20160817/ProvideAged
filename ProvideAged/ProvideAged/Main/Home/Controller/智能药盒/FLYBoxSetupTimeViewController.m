//
//  FLYBoxSetupTimeViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYBoxSetupTimeViewController.h"
#import "UICollectionView+FLYRefresh.h"
#import "FLYBoxTimeCell.h"
#import "FLYBoxTimeModel.h"
#import "BRDatePickerView.h"

@interface FLYBoxSetupTimeViewController () < UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * confirmBtn;

@end

@implementation FLYBoxSetupTimeViewController

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
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.view).with.offset(-([FLYTools safeAreaInsets].bottom + 17));
    }];
}



#pragma mark - DATA

- (void)loadData
{
    [self getTimeListNetwork];
}



#pragma mark - NETWORK

- (void)getTimeListNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"deviceId" : self.deviceId };

    [FLYNetworkTool postRawWithPath:API_DRUGTIMELIST params:params success:^(id  _Nonnull json) {
        
        NSMutableArray * array = [FLYBoxTimeModel mj_objectArrayWithKeyValuesArray:json[@"content"]];
        
        self.collectionView.dataList = array;
        [self.collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
    }];
}

- (void)updateTimeNetwork
{
    NSArray * array = [FLYBoxTimeModel mj_keyValuesArrayWithObjectArray:self.collectionView.dataList];
   
    NSDictionary * params = @{ @"list" : array };
    
    [FLYNetworkTool postRawWithPath:API_UPDATEDRUGTIME params:params success:^(id  _Nonnull json) {
        
        [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"服药时间";
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.confirmBtn];
}



#pragma mark - event handler

- (void)confirmClick:(UIButton *)button
{
    //时间大小顺序判断

    
    [self updateTimeNetwork];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionView.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYBoxTimeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionView.cellReuseIdentifier forIndexPath:indexPath];
    
    cell.model = self.collectionView.dataList[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [BRDatePickerView showDatePickerWithMode:(BRDatePickerModeHM) title:nil selectValue:nil resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        
        FLYBoxTimeModel * model = self.collectionView.dataList[indexPath.item];
        model.arrangeTime = selectValue;
        [self.collectionView reloadData];
        
    }];
}



#pragma mark - setters and getters

-(UICollectionView *)collectionView
{
    if ( _collectionView == nil )
    {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumInteritemSpacing = 0;
        flow.minimumInteritemSpacing = 10;
        flow.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 42);
        flow.sectionInset = UIEdgeInsetsMake(25, 20, 20, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = COLORHEX(@"#F9F9F9");
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FLYBoxTimeCell class] forCellWithReuseIdentifier:_collectionView.cellReuseIdentifier];
    }
    return _collectionView;
}

-(UIButton *)confirmBtn
{
    if ( _confirmBtn == nil )
    {
        _confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        _confirmBtn.backgroundColor = COLORHEX(@"#31BBA3");
        _confirmBtn.layer.cornerRadius = 4;
        [_confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmBtn;
}


@end

