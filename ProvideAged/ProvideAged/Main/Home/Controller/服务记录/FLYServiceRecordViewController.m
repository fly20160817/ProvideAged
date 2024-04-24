//
//  FLYServiceRecordViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYServiceRecordViewController.h"
#import "FLYFilterBar.h"
#import "FLYFilterItemView.h"
#import "FLYPopupView.h"
#import "FLYFilterTimeView.h"
#import "UIView+FLYExtension.h"
#import "UITableView+FLYRefresh.h"
#import "FLYServiceRecordCell.h"
#import "FLYSysDicModel.h"
#import "FLYServiceModel.h"

@interface FLYServiceRecordViewController () < FLYFilterBarDelegate, UITableViewDelegate, UITableViewDataSource >
{
    NSString * _startTime;
    NSString * _endTime;
    NSString * _serviceType;
}
@property (nonatomic, strong) FLYFilterBar * filterBar;

@property (nonatomic, strong) FLYFilterItemView * itemView;
@property (nonatomic, strong) FLYFilterTimeView * timeView;
@property (nonatomic, strong) FLYPopupView * popupView;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation FLYServiceRecordViewController

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
        make.height.mas_equalTo(32);
    }];
    
    CGFloat y = STATUSADDNAV_HEIGHT + self.filterBar.height;
    self.popupView.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}



#pragma mark - DATA

- (void)initVariable
{
    _startTime = @"";
    _endTime = @"";
    _serviceType = @"";
}

- (void)loadData
{
    [self getServiceListNework];
    
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark - NETWORK

- (void)getServiceRecordNetwork
{
 
    NSDictionary * params = @{ @"pageNo" : @(self.tableView.pageNum), @"pageSize" : @(self.tableView.pageSize), @"oldManInfoId" : self.elderModel.idField, @"startDate" : _startTime, @"endDate" : _endTime, @"serviceContent" : _serviceType };
    
    [FLYNetworkTool postRawWithPath:API_SERVICERECORDLIST params:params success:^(id json) {
        
        NSArray * array = [FLYServiceModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA][@"list"]];
        
        NSInteger total = [json[SERVER_DATA][@"total"] integerValue];
        [self.tableView loadDataSuccess:array total:total];
        
    } failure:^(id obj) {
        
        [self.tableView loadDataFailed:obj];
        
    }];
}

//获取筛选条件
- (void)getServiceListNework
{
    NSDictionary * params = @{ @"type" : @"9" };
    [FLYNetworkTool postRawWithPath:API_SYSDICT params:params success:^(id json) {
        
        NSArray * array = [FLYSysDicModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        
        
        NSMutableArray * tmpArray = [NSMutableArray array];
        
        FLYKeyValueModel * model = [[FLYKeyValueModel alloc] init];
        model.key = @"";
        model.value = @"全部";
        [tmpArray addObject:model];
        
        [array enumerateObjectsUsingBlock:^(FLYSysDicModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            FLYKeyValueModel * model = [[FLYKeyValueModel alloc] init];
            model.key = obj.idField;
            model.value = obj.name;
            
            [tmpArray addObject:model];
            
        }];
        
        self.itemView.itemModels = tmpArray;
        
    } failure:^(id obj) {
        
        FLYLog(@"失败：%@", obj);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"服务记录";
    
    [self.view addSubview:self.filterBar];
    [self.view addSubview:self.tableView];
}



#pragma mark - FLYFilterBarDelegate

-(void)filterBar:(FLYFilterBar *)filterBar didSelectIndex:(NSInteger)index selectStatus:(BOOL)selectStatus
{
    if ( index == 0 )
    {
        if ( selectStatus )
        {
            [self.popupView.contentView removeAllSubviews];
            [self.popupView.contentView addSubview:self.itemView];
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



#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableView.dataList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLYServiceRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:self.tableView.cellReuseIdentifier forIndexPath:indexPath];
    cell.serviceModel = self.tableView.dataList[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 12 : 10;
}



#pragma mark - setters and getters

-(FLYFilterBar *)filterBar
{
    if ( _filterBar == nil )
    {
        _filterBar = [[FLYFilterBar alloc] initWithFrame:CGRectZero titleNames:@[@"服务内容", @"服务时间"]];
        _filterBar.delegate = self;
    }
    return _filterBar;
}

-(FLYFilterItemView *)itemView
{
    if ( _itemView == nil )
    {
        
        WeakSelf
        StrongSelf
        _itemView = [[FLYFilterItemView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 169)];
        _itemView.confirmBlock = ^(NSArray * _Nonnull selectModels) {
            
            FLYKeyValueModel * model = selectModels.lastObject;
            strongSelf -> _serviceType = model.key;
            

            NSString * string = [model.value isEqualToString:@"全部"] ? @"服务内容" : model.value;
            [weakSelf.filterBar changeButtonTitle:string];
            [weakSelf.filterBar refreshButtonStatus];
            [weakSelf.popupView dissmiss];
            
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _itemView;
}

-(FLYFilterTimeView *)timeView
{
    if ( _timeView == nil )
    {
        WeakSelf
        StrongSelf
        _timeView = [[FLYFilterTimeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 152)];
        _timeView.title = @"选择服务记录时间段";
        _timeView.confirmBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime) {
            
            strongSelf -> _startTime = startTime;
            strongSelf->_endTime = endTime;

            
            [weakSelf.filterBar refreshButtonStatus];
            [weakSelf.popupView dissmiss];
            
            [weakSelf.tableView.mj_header beginRefreshing];
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
        _popupView.dissmissBlock = ^{
            
            [weakSelf.filterBar refreshButtonStatus];
        };
    }
    return _popupView;
}

-(UITableView *)tableView
{
    if ( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = COLORHEX(@"#F9F9F9");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.estimatedRowHeight = 160;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[FLYServiceRecordCell class] forCellReuseIdentifier:_tableView.cellReuseIdentifier];
        [_tableView addRefreshingTarget:self action:@selector(getServiceRecordNetwork)];
    }
    return _tableView;
}

@end
