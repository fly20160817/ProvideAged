//
//  FLYOpenRecordListViewController.m
//  ProvideAged
//
//  Created by fly on 2021/12/23.
//

#import "FLYOpenRecordListViewController.h"
#import "UICollectionView+FLYRefresh.h"
#import "FLYTempAuthorizeCell.h"
#import "FLYTempAuthorizeViewController.h"
#import "FLYAuthorizeDetailViewController.h"
#import "FLYFilterBar.h"
#import "FLYPopupView.h"
#import "FLYFilterTimeView.h"
#import "UIView+FLYExtension.h"
#import "FLYScreenListView.h"
#import "FLYOpenRecordModel.h"

@interface FLYOpenRecordListViewController () < UICollectionViewDataSource, UICollectionViewDelegate, FLYFilterBarDelegate >
{
    NSString * _startTime;
    NSString * _endTime;
    NSString * _authorizeType;
    NSString * _openMode;
}
@property (nonatomic, strong) FLYFilterBar * filterBar;
@property (nonatomic, strong) FLYScreenListView * screenListview;
@property (nonatomic, strong) FLYFilterTimeView * timeView;
@property (nonatomic, strong) FLYPopupView * popupView;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSArray * authorizeTypeList;
@property (nonatomic, strong) NSArray * openModeList;

@end

@implementation FLYOpenRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initVariable];
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.filterBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(52);
    }];
    
    CGFloat y = STATUSADDNAV_HEIGHT + self.filterBar.height;
    self.popupView.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y);
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}



#pragma mark - DATA

- (void)initVariable
{
    _startTime = @"";
    _endTime = @"";
    _authorizeType = @"";
    _openMode = @"";
}

- (void)loadData
{
    [self.collectionView.mj_header beginRefreshing];
}



#pragma mark - NETWORK

- (void)getAuthorizeListNetwork
{
    NSDictionary * params = @{ @"deviceInfoId" : self.deviceInfoId, @"type" : _authorizeType, @"openType" : _openMode, @"startDate" : _startTime, @"endDate" : _endTime };

    [FLYNetworkTool postRawWithPath:API_OPENDOORRECORD params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:YES success:^(id  _Nonnull json) {
        
        NSArray * array = [FLYOpenRecordModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA][@"list"]];
        [self.collectionView loadDataSuccess:array total:[json[SERVER_DATA][@"total"] integerValue]];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self.collectionView loadDataFailed:error];
        
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"开门记录";
    
    [self.view addSubview:self.filterBar];
    [self.view addSubview:self.collectionView];
}



#pragma mark - FLYFilterBarDelegate

-(void)filterBar:(FLYFilterBar *)filterBar didSelectIndex:(NSInteger)index selectStatus:(BOOL)selectStatus
{
    if ( index == 0 )
    {
        if ( selectStatus )
        {
            self.screenListview.dataList = self.authorizeTypeList;
            
            [self.popupView.contentView removeAllSubviews];
            [self.popupView.contentView addSubview:self.screenListview];
            [self.popupView show];
        }
        else
        {
            [self.popupView dissmiss];
        }
    }
    else if ( index == 1 )
    {
        if ( selectStatus )
        {
            self.screenListview.dataList = self.openModeList;
            
            [self.popupView.contentView removeAllSubviews];
            [self.popupView.contentView addSubview:self.screenListview];
            [self.popupView show];
        }
        else
        {
            [self.popupView dissmiss];
        }
    }
    else if ( index == 2 )
    {
        if ( selectStatus )
        {
            [self.popupView.contentView removeAllSubviews];
            [self.popupView.contentView addSubview:self.timeView];
            [self.popupView show];
        }
        else
        {
            [self.popupView dissmiss];
        }
    }
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionView.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYTempAuthorizeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionView.cellReuseIdentifier forIndexPath:indexPath];
    cell.openRecordModel = self.collectionView.dataList[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYAuthorizeDetailViewController * vc = [[FLYAuthorizeDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - setters and getters

-(FLYFilterBar *)filterBar
{
    if ( _filterBar == nil )
    {
        _filterBar = [[FLYFilterBar alloc] initWithFrame:CGRectZero titleNames:@[@"授权类型", @"开门方式", @"日期"]];
        _filterBar.backgroundColor= [UIColor whiteColor];
        _filterBar.delegate = self;
    }
    return _filterBar;
}

-(FLYFilterTimeView *)timeView
{
    if ( _timeView == nil )
    {
        WeakSelf
        StrongSelf
        _timeView = [[FLYFilterTimeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 152)];
        _timeView.title = @"选择日期";
        _timeView.confirmBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime) {
            
            strongSelf -> _startTime = startTime;
            strongSelf -> _endTime = endTime;
            
            [weakSelf.filterBar refreshButtonStatus];
            [weakSelf.popupView dissmiss];
            [weakSelf.collectionView.mj_header beginRefreshing];
        };
    }
    return _timeView;
}

-(FLYPopupView *)popupView
{
    if ( _popupView == nil )
    {
        WeakSelf
        _popupView = [FLYPopupView popupView];
        _popupView.animationType = FLYPopupAnimationTypeTop;
        _popupView.maskType = FLYPopupMaskTypeBlack;
        _popupView.noDissmissViews = @[self.filterBar];
        _popupView.dissmissBlock = ^{
            
            [weakSelf.filterBar refreshButtonStatus];
        };
    }
    return _popupView;
}

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

-(NSArray *)authorizeTypeList
{
    if ( _authorizeTypeList == nil )
    {
        NSMutableArray * tempArray = [NSMutableArray array];
        
        FLYKeyValueModel * keyValueModel1 = [[FLYKeyValueModel alloc] init];
        keyValueModel1.key = @"";
        keyValueModel1.value = @"默认";
        [tempArray addObject:keyValueModel1];
        
        FLYKeyValueModel * keyValueModel2 = [[FLYKeyValueModel alloc] init];
        keyValueModel2.key = @"1";
        keyValueModel2.value = @"老人";
        [tempArray addObject:keyValueModel2];
        
        FLYKeyValueModel * keyValueModel3 = [[FLYKeyValueModel alloc] init];
        keyValueModel3.key = @"2";
        keyValueModel3.value = @"亲属";
        [tempArray addObject:keyValueModel3];
        
        FLYKeyValueModel * keyValueModel4 = [[FLYKeyValueModel alloc] init];
        keyValueModel4.key = @"3";
        keyValueModel4.value = @"临时授权";
        [tempArray addObject:keyValueModel4];
       
        _authorizeTypeList = tempArray.copy;
    }
    return _authorizeTypeList;
}

-(NSArray *)openModeList
{
    if ( _openModeList == nil )
    {
        NSMutableArray * tempArray = [NSMutableArray array];
        
        FLYKeyValueModel * keyValueModel1 = [[FLYKeyValueModel alloc] init];
        keyValueModel1.key = @"";
        keyValueModel1.value = @"默认";
        [tempArray addObject:keyValueModel1];
        
        FLYKeyValueModel * keyValueModel2 = [[FLYKeyValueModel alloc] init];
        keyValueModel2.key = @"1";
        keyValueModel2.value = @"密码";
        [tempArray addObject:keyValueModel2];
        
        FLYKeyValueModel * keyValueModel3 = [[FLYKeyValueModel alloc] init];
        keyValueModel3.key = @"2";
        keyValueModel3.value = @"指纹";
        [tempArray addObject:keyValueModel3];
        
        FLYKeyValueModel * keyValueModel4 = [[FLYKeyValueModel alloc] init];
        keyValueModel4.key = @"3";
        keyValueModel4.value = @"门卡";
        [tempArray addObject:keyValueModel4];
        
        FLYKeyValueModel * keyValueModel5 = [[FLYKeyValueModel alloc] init];
        keyValueModel5.key = @"4";
        keyValueModel5.value = @"蓝牙";
        [tempArray addObject:keyValueModel5];
        
        _openModeList = tempArray.copy;
    }
    return _openModeList;
}

-(FLYScreenListView *)screenListview
{
    if ( _screenListview == nil )
    {
        WeakSelf
        StrongSelf
        _screenListview = [[FLYScreenListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225)];
        _screenListview.cancelBlock = ^{
            
            [weakSelf.popupView dissmiss];
        };
        _screenListview.confirmBlock = ^(FLYKeyValueModel * _Nonnull keyValueModel) {
            
            if ( weakSelf.screenListview.dataList == weakSelf.authorizeTypeList )
            {
                strongSelf->_authorizeType = keyValueModel.key;
                
                [weakSelf.filterBar changeButtonTitle:keyValueModel.key.length == 0 ? @"授权类型" : keyValueModel.value];
            }
            else if ( weakSelf.screenListview.dataList == weakSelf.openModeList )
            {
                strongSelf->_openMode = keyValueModel.key;
                [weakSelf.filterBar changeButtonTitle:keyValueModel.key.length == 0 ? @"开门方式" : keyValueModel.value];
            }
            
            
            [weakSelf.collectionView.mj_header beginRefreshing];
            
            [weakSelf.popupView dissmiss];
        };
    }
    
    return _screenListview;
}

@end


