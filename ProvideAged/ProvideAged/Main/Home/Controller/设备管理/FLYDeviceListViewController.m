//
//  FLYDeviceListViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYDeviceListViewController.h"
#import "UITableView+FLYRefresh.h"
#import "FLYDeviceListCell.h"
#import "FLYFilterDeviceView.h"
#import "FLYDeviceDetailViewController.h"
#import "FLYDeviceStatusModel.h"
#import "FLYDeviceModel.h"

@interface FLYDeviceListViewController () < UITableViewDelegate, UITableViewDataSource >
{
    NSString * _deviceType;
}
@property (nonatomic, strong) FLYFilterDeviceView * filterView;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation FLYDeviceListViewController

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
    
    [self.filterView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).with.offset(0);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom).with.offset(0);
        make.left.bottom.right.equalTo(self.view).with.offset(0);
    }];
}



#pragma mark - DATA

- (void)initVariable
{
    _deviceType = @"";
    
    self.filterView.address = self.elderModel.houseAddress;
}

- (void)loadData
{
    [self getDeviceStatusNetwork];
    
    [self getDeviceListNetwork];
}



#pragma mark - NETWORK

- (void)getDeviceListNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.elderModel.idField, @"type" : _deviceType, @"useType" : @(self.useType) };
    
    [FLYNetworkTool postRawWithPath:API_DEVICELIST params:params success:^(id json) {
        NSArray * array = [FLYDeviceModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        
        [self.tableView loadDataSuccess:array];
        
    } failure:^(id obj) {
        
        [self.tableView loadDataFailed:obj];
    }];
    
}

- (void)getDeviceStatusNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.elderModel.idField, @"useType" : @(self.useType) };
    
    [FLYNetworkTool postRawWithPath:API_DEVICESTATUSE params:params success:^(id json) {
        
        NSMutableArray * array = [FLYDeviceStatusModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        
        NSMutableArray * houseArray = [NSMutableArray array];
        NSMutableArray * personalArray = [NSMutableArray array];
        
        [array enumerateObjectsUsingBlock:^(FLYDeviceStatusModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            switch ( [model.idField integerValue] )
            {
                case 0:
                {
                    [houseArray addObject:model];
                    [personalArray addObject:model];
                }
                    break;
                    
                case 1:
                {
                    [houseArray addObject:model];
                }
                    break;
                    
                case 2:
                {
                    [houseArray addObject:model];
                }
                    break;
                    
                case 3:
                {
                    [houseArray addObject:model];
                }
                    break;
                    
                case 4:
                {
                    [houseArray addObject:model];
                }
                    break;
                    
                case 5:
                {
                    [houseArray addObject:model];
                }
                    break;
                    
                case 6:
                {
                    [houseArray addObject:model];
                }
                    break;
                    
                case 7:
                {
                    [personalArray addObject:model];
                }
                    break;
                    
                case 8:
                {
                    [personalArray addObject:model];
                }
                    break;
                    
                case 9:
                {
                    [personalArray addObject:model];
                }
                    break;
                    
                case 10:
                {
                    [personalArray addObject:model];
                }
                    break;
                    
                case 11:
                {
                    [personalArray addObject:model];
                }
                    break;
                    
                case 12:
                {
                    [houseArray addObject:model];
                }
                    break;
                    
                case 13:
                {
                    [houseArray addObject:model];
                }
                    break;
                    
                case 14:
                {
                    [houseArray addObject:model];
                }
                    break;
                    
                case 15:
                {
                    [houseArray addObject:model];
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        
        NSArray * tempArray = self.useType == 1 ? houseArray.copy : personalArray.copy;
        
        self.filterView.deviceStatusList = tempArray;
        
    } failure:^(id obj) {
        
        FLYLog(@"失败：%@", obj);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"设备管理";
    
    
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.tableView];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLYDeviceListCell * cell = [tableView dequeueReusableCellWithIdentifier:_tableView.cellReuseIdentifier forIndexPath:indexPath];
    cell.deviceModel = self.tableView.dataList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLYDeviceDetailViewController * vc = [[FLYDeviceDetailViewController alloc] init];
    vc.deviceModel = self.tableView.dataList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - setters and getters

-(FLYFilterDeviceView *)filterView
{
    if ( _filterView == nil )
    {
        WeakSelf
        StrongSelf
        _filterView = [[FLYFilterDeviceView alloc] init];
        _filterView.selectBlock = ^(NSString * _Nonnull idField) {
            
            strongSelf -> _deviceType = idField;
            
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _filterView;
}

-(UITableView *)tableView
{
    if ( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 99;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _tableView.separatorColor = COLORHEX(@"#EAEAEA");
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[FLYDeviceListCell class] forCellReuseIdentifier:_tableView.cellReuseIdentifier];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView addRefreshingTarget:self action:@selector(loadData)];
    }
    return _tableView;
}


@end
