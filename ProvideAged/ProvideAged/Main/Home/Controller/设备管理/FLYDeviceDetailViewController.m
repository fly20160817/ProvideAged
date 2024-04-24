//
//  FLYDeviceDetailViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYDeviceDetailViewController.h"
#import "UITableView+FLYRefresh.h"
#import "FLYDeviceDetailCell.h"
#import "FLYKeyValueModel.h"
#import "FLYDeviceHeaderView.h"
#import "FLYWarningModel.h"
#import "FLYDoorRecordModel.h"
#import "FLYDeviceSegmentBar.h"
#import "FLYDeviceRecordCell.h"
#import "FLYBedRecordModel.h"
#import "UIBarButtonItem+FLYExtension.h"
#import "HealthReportViewController.h"

static NSString * deviceHeaderIdentifier = @"FLYDeviceHeaderView";
static NSString * alarmCellIdentifier = @"alarmCellIdentifier";
static NSString * doorCellIdentifier = @"doorCellIdentifier";
static NSString * bedCellIdentifier = @"bedCellIdentifier";

@interface FLYDeviceDetailViewController () < UITableViewDelegate, UITableViewDataSource, FLYDeviceSegmentBarDelegate >

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) FLYDeviceSegmentBar * segmentBar;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITableView * alarmTableView;
@property (nonatomic, strong) UITableView * doorTableView;
@property (nonatomic, strong) UITableView * bedTableView;

@property (nonatomic, strong) NSArray * titleList;

@property (nonatomic, strong) NSArray<FLYKeyValueModel *> * infoList;

@end

@implementation FLYDeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(193);
    }];
    
    if( self.titleList.count > 0)
    {
        [self.segmentBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom).with.offset(15);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(49);
        }];
        
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.segmentBar.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
        
        self.alarmTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.height);
        
        if ( self.deviceModel.type == 2 || self.deviceModel.type == 12 )
        {
            self.doorTableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
        }
        else if ( self.deviceModel.type == 8 )
        {
            self.bedTableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
        }
    }
}



#pragma mark - DATA

- (void)loadData
{
    //血糖仪没有告警记录
    if ( self.deviceModel.type != 9 )
    {
        [self getWarningListNetwork];
    }
    
    //只有门磁和门锁才显示开门记录
    if ( self.deviceModel.type == 2 || self.deviceModel.type == 12 )
    {
        [self getDoorRecord];
    }
    
    //只有床垫才显示在床记录
    if ( self.deviceModel.type == 8 )
    {
        [self getBedRecordListNetwork];
    }
}



#pragma mark - NETWORK

//告警记录
- (void)getWarningListNetwork
{
    NSDictionary * params = @{ @"deviceId" : self.deviceModel.idField, @"pageNo" : @(1), @"pageSize" : @(10) };
    
    [FLYNetworkTool postRawWithPath:API_WARNINGLIST params:params success:^(id json) {
        
        NSArray * array = [FLYWarningModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA][@"list"]];
        
        
        NSMutableArray * tmpArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(FLYWarningModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FLYKeyValueModel * model = [[FLYKeyValueModel alloc] init];
            model.key = obj.type;
            model.value = obj.alarmTime;
            [tmpArray addObject:model];
        }];
        
        
        [self.alarmTableView loadDataSuccess:tmpArray];
        
    } failure:^(id obj) {
        
        [self.alarmTableView loadDataFailed:obj];
    }];
}

- (void)getDoorRecord
{
    if ( self.deviceModel.type == 2  )
    {
        [self getDoorRecordListNetwork];
    }
    else if ( self.deviceModel.type == 12 )
    {
        [self getLockRecordListNetwork];
    }
}

//门磁开门记录
- (void)getDoorRecordListNetwork
{
    NSDictionary * params = @{ @"deviceId" : self.deviceModel.idField, @"pageNo" : @(self.doorTableView.pageNum), @"pageSize" : @(self.doorTableView.pageSize) };
    
    [FLYNetworkTool postRawWithPath:API_DOORRECORD params:params success:^(id json) {
        
        NSArray * array = [FLYDoorRecordModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA][@"list"]];
        
        NSMutableArray * tmpArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(FLYDoorRecordModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FLYKeyValueModel * model = [[FLYKeyValueModel alloc] init];
            model.key = obj.type;
            model.value = obj.operateTime;
            [tmpArray addObject:model];
        }];
        
        
        [self.doorTableView loadDataSuccess:tmpArray];
        
    } failure:^(id obj) {
        
        [self.doorTableView loadDataFailed:obj];
    }];
}

//门锁开门记录
- (void)getLockRecordListNetwork
{
    NSDictionary * params = @{ @"deviceInfoId" : self.deviceModel.idField, @"pageNo" : @(self.doorTableView.pageNum), @"pageSize" : @(self.doorTableView.pageSize) };
    
    [FLYNetworkTool postRawWithPath:API_LOCKRECORD params:params success:^(id json) {
        
        NSArray * array = [FLYDoorRecordModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA][@"list"]];
        
        NSMutableArray * tmpArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(FLYDoorRecordModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FLYKeyValueModel * model = [[FLYKeyValueModel alloc] init];
            if ( self.deviceModel.type == 2 )
            {
                model.key = obj.type;
                model.value = obj.operateTime;
            }
            else
            {
                model.key = obj.openTypeDesc;
                model.value = obj.openTime;
            }
            [tmpArray addObject:model];
        }];
        
        
        [self.doorTableView loadDataSuccess:tmpArray];
        
    } failure:^(id obj) {
        
        [self.doorTableView loadDataFailed:obj];
    }];
}

- (void)getBedRecordListNetwork
{
    NSDictionary * params = @{ @"deviceId" : self.deviceModel.idField, @"pageNo" : @(self.doorTableView.pageNum), @"pageSize" : @(self.doorTableView.pageSize) };
    
    [FLYNetworkTool postRawWithPath:API_BEDRECORD params:params success:^(id json) {
        
        NSArray * array = [FLYBedRecordModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA][@"list"]];
        
        NSMutableArray * tmpArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(FLYBedRecordModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FLYKeyValueModel * model = [[FLYKeyValueModel alloc] init];
            model.key = obj.bedsDesc;
            model.value = obj.createTime;
            [tmpArray addObject:model];
        }];
        
        
        [self.bedTableView loadDataSuccess:tmpArray];
        
    } failure:^(id obj) {
        
        [self.bedTableView loadDataFailed:obj];
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"设备详情";
    
    [self.view addSubview:self.tableView];
    
    if( self.titleList.count > 0)
    {
        [self.view addSubview:self.segmentBar];
        [self.view addSubview:self.scrollView];
        [self.scrollView addSubview:self.alarmTableView];
        
        if ( self.deviceModel.type == 2 || self.deviceModel.type == 12 )
        {
            [self.scrollView addSubview:self.doorTableView];
        }
        else if ( self.deviceModel.type == 8 )
        {
            [self.scrollView addSubview:self.bedTableView];
        }
    }
    
    
    // 手表有健康报告
    if ( [self.deviceModel.modelKey isEqualToString:@"wlL16"] || [self.deviceModel.modelKey isEqualToString:@"wlL17"] || [self.deviceModel.modelKey isEqualToString:@"wlL18"] )
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"健康报告" font:FONT_S(15) titleColor:COLORHEX(@"#333333") target:self action:@selector(rightClick:)];
    }
}



#pragma mark - event handler

- (void)rightClick:(UIBarButtonItem *)item
{
    HealthReportViewController * vc = [[HealthReportViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.tableView )
    {
        return self.infoList.count;
    }
    
    if ( tableView == self.alarmTableView )
    {
        return self.alarmTableView.dataList.count;
    }
    
    if ( tableView == self.doorTableView )
    {
        return self.doorTableView.dataList.count;
    }
    
    if ( tableView == self.bedTableView )
    {
        return self.bedTableView.dataList.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( tableView == self.tableView )
    {
        FLYDeviceDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:_tableView.cellReuseIdentifier forIndexPath:indexPath];
        cell.model = self.infoList[indexPath.row];
        return cell;
    }
    
    if ( tableView == self.alarmTableView )
    {
        FLYDeviceRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:alarmCellIdentifier forIndexPath:indexPath];
        cell.model = self.alarmTableView.dataList[indexPath.row];
        return cell;
    }
    
    if ( tableView == self.doorTableView )
    {
        FLYDeviceRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:doorCellIdentifier forIndexPath:indexPath];
        cell.model = self.doorTableView.dataList[indexPath.row];
        return cell;
    }
    
    if ( tableView == self.bedTableView )
    {
        FLYDeviceRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:bedCellIdentifier forIndexPath:indexPath];
        cell.model = self.bedTableView.dataList[indexPath.row];
        return cell;
    }
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( tableView == self.tableView )
    {
        NSArray * titles = @[@"设备信息"];
        
        FLYDeviceHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:deviceHeaderIdentifier];
        headerView.title = titles[section];
        return headerView;
    }
    
    return nil;
}



#pragma mark - FLYDeviceSegmentBarDelegate

-(void)segmentBar:(FLYDeviceSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:YES];
}



#pragma mark - setters and getters

-(UITableView *)tableView
{
    if ( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = COLORHEX(@"#FFFFFF");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 28;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 40;
        _tableView.sectionFooterHeight = 10;
        [_tableView registerClass:[FLYDeviceDetailCell class] forCellReuseIdentifier:_tableView.cellReuseIdentifier];
        [_tableView registerClass:[FLYDeviceHeaderView class] forHeaderFooterViewReuseIdentifier:deviceHeaderIdentifier];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

-(NSArray<FLYKeyValueModel *> *)infoList
{
    if ( _infoList == nil )
    {
        FLYKeyValueModel * model1 = [[FLYKeyValueModel alloc] init];
        model1.key = @"设备名称";
        model1.value = self.deviceModel.name;
        
        FLYKeyValueModel * model2 = [[FLYKeyValueModel alloc] init];
        model2.key = @"设备型号";
        model2.value = self.deviceModel.model;
        
        FLYKeyValueModel * model3 = [[FLYKeyValueModel alloc] init];
        model3.key = @"设备IMEI";
        model3.value = self.deviceModel.imei;
        
        FLYKeyValueModel * model4 = [[FLYKeyValueModel alloc] init];
        model4.key = @"设备状态";
        model4.value = self.deviceModel.statusDesc;
        
        FLYKeyValueModel * model5 = [[FLYKeyValueModel alloc] init];
        model5.key = @"告警状态";
        model5.value = self.deviceModel.warningStatusDesc;
        
        _infoList = @[model1, model2, model3, model4, model5];
    }
    
    return _infoList;
}

-(NSArray *)titleList
{
    if ( _titleList == nil )
    {
        NSMutableArray * titleArray = [NSMutableArray array];
        
        if ( self.deviceModel.type != 9 )
        {
            [titleArray addObject:@"告警记录"];
        }
        
        if ( self.deviceModel.type == 2 || self.deviceModel.type == 12 )
        {
            [titleArray addObject:@"开门记录"];
        }
        
        if ( self.deviceModel.type == 8 )
        {
            [titleArray addObject:@"在床状态"];
        }
        
        _titleList = titleArray.copy;
    }
    return _titleList;
}

-(FLYDeviceSegmentBar *)segmentBar
{
    if ( _segmentBar == nil )
    {
        _segmentBar = [[FLYDeviceSegmentBar alloc] initWithFrame:CGRectZero titleNames:self.titleList];
        _segmentBar.delegate = self;
        
        FLYSegmentBarConfig * config = [FLYSegmentBarConfig defaultConfig];
        config.segmentBarBackColor = COLORHEX(@"#FFFFFF");
        config.itemNormalColor = COLORHEX(@"#999999");
        config.itemSelectColor = COLORHEX(@"#2BB9A0");
        config.itemNormalFont = FONT_R(15);
        config.itemSelectFont = FONT_R(15);
        config.indicatorColor = COLORHEX(@"#2BB9A0");
        config.indicatorHeight = 3;
        config.indicatorWidth = 40;
        _segmentBar.config = config;
        
    }
    return _segmentBar;
}

-(UIScrollView *)scrollView
{
    if ( _scrollView == nil )
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = COLORHEX(@"FFFFFF");
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        //解决滑动的时候自动向下偏移20pt的问题
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titleList.count, 0);
    }
    return _scrollView;
}

-(UITableView *)alarmTableView
{
    if ( _alarmTableView == nil )
    {
        _alarmTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _alarmTableView.backgroundColor = COLORHEX(@"#FFFFFF");
        _alarmTableView.delegate = self;
        _alarmTableView.dataSource = self;
        _alarmTableView.rowHeight = 40;
        _alarmTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _alarmTableView.sectionHeaderHeight = CGFLOAT_MIN;
        _alarmTableView.sectionFooterHeight = CGFLOAT_MIN;
        [_alarmTableView registerClass:[FLYDeviceRecordCell class] forCellReuseIdentifier:alarmCellIdentifier];
        _alarmTableView.tableFooterView = [[UIView alloc] init];
        [_alarmTableView addRefreshingTarget:self action:@selector(getWarningListNetwork)];
    }
    return _alarmTableView;
}

-(UITableView *)doorTableView
{
    if ( _doorTableView == nil )
    {
        _doorTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _doorTableView.backgroundColor = COLORHEX(@"#FFFFFF");
        _doorTableView.delegate = self;
        _doorTableView.dataSource = self;
        _doorTableView.rowHeight = 40;
        _doorTableView.sectionHeaderHeight = CGFLOAT_MIN;
        _doorTableView.sectionFooterHeight = CGFLOAT_MIN;
        _doorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_doorTableView registerClass:[FLYDeviceRecordCell class] forCellReuseIdentifier:doorCellIdentifier];
        _doorTableView.tableFooterView = [[UIView alloc] init];
        [_doorTableView addRefreshingTarget:self action:@selector(getDoorRecord)];
    }
    return _doorTableView;
}

-(UITableView *)bedTableView
{
    if ( _bedTableView == nil )
    {
        _bedTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _bedTableView.backgroundColor = COLORHEX(@"#FFFFFF");
        _bedTableView.delegate = self;
        _bedTableView.dataSource = self;
        _bedTableView.rowHeight = 40;
        _bedTableView.sectionHeaderHeight = CGFLOAT_MIN;
        _bedTableView.sectionFooterHeight = CGFLOAT_MIN;
        _bedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_bedTableView registerClass:[FLYDeviceRecordCell class] forCellReuseIdentifier:bedCellIdentifier];
        _bedTableView.tableFooterView = [[UIView alloc] init];
        [_bedTableView addRefreshingTarget:self action:@selector(getBedRecordListNetwork)];
    }
    return _bedTableView;
}

@end
