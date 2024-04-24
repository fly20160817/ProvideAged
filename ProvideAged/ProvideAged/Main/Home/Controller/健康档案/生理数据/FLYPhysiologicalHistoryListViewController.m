//
//  FLYPhysiologicalHistoryListViewController.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYPhysiologicalHistoryListViewController.h"
#import "UITableView+FLYRefresh.h"
#import "FLYPhysiologicalHistoryCell.h"
#import "FLYYearMonthHeaderView.h"
#import "FLYYearMonthGroupModel.h"

@interface FLYPhysiologicalHistoryListViewController () < UITableViewDelegate, UITableViewDataSource >

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation FLYPhysiologicalHistoryListViewController

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
        make.top.left.bottom.right.equalTo(self.view);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark - NETWORK

- (void)getPhysiologicalListNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.healthModel.oldManInfoId, @"healthType" : @(self.healthModel.healthType), @"pageNo" : @(self.tableView.pageNum), @"pageSize" : @(self.tableView.pageSize) };
    
    [FLYNetworkTool postRawWithPath:API_HEALTHHISTORY params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:YES success:^(id json) {
        
        //服务器返回的是没有分租的数据，并且还是分页的
        /***************** 本地分组逻辑 ********************
         if（ 不是上组的 ）
         {
             if（ 上一个不存在（这个就是第一个））
             {
                 放到数组里
                 记录lastModel
             }
             else
             {
                 保存上组的数组
                 清空组
                 将这条的数据添加到数组（新的一组）
                 记录lastModel
             }
             
         }
         //上组的
         else
         {
             放到数组里
             记录lastModel
         }


         if ( 是不是最后一个 )
         {
             保存组的
         }
         ************************************************/
        
        NSArray * array = [FLYHealthModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA][@"list"]];
        
        NSMutableArray<FLYYearMonthGroupModel *> * dataList = [NSMutableArray array];
        NSMutableArray<FLYHealthModel *> * groupList = [NSMutableArray array];
        FLYHealthModel * lastModel;
        
        //加了不等于第一页，是因为可能已经加载了好几个页面，dataList也早就有值了，这时执行下拉刷新操作，此时数据还没清空，但lastModel不应该有值，所以加个!= 1过滤下
        if( self.tableView.dataList.count > 0 && self.tableView.pageNum != 1 )
        {
            FLYYearMonthGroupModel * groupModel = self.tableView.dataList.lastObject;
            groupList = groupModel.list;
            lastModel = groupList.lastObject;
        }
        
        for (int i = 0; i < array.count; i++)
        {
            FLYHealthModel * stepModel = array[i];
            
            //2021.11.09 切分成数组
            NSArray * dateArray = [stepModel.createTime componentsSeparatedByString:@"-"];
            NSArray * lastDateArray = [lastModel.createTime componentsSeparatedByString:@"-"];
            
            //拼接成"11月 2021年"格式的字符串
            NSString * date = [NSString stringWithFormat:@"%@月 %@年", dateArray[1], dateArray[0]];
            NSString * lastDate = [NSString stringWithFormat:@"%@月 %@年", lastDateArray[1], lastDateArray[0]];
            
            
            //是否和上一个是同一组 (判断年月是否相同)
            BOOL sameGroup = [date isEqualToString:lastDate];
            
            //如果和上一个不是同一组
            if( sameGroup == NO )
            {
                //上一个不存在（这个就是第一个）
                if ( lastModel == nil )
                {
                    [groupList addObject:stepModel];
                    lastModel = stepModel;
                }
                else
                {
                    //保存上一组的
                    FLYYearMonthGroupModel * groupModel = [[FLYYearMonthGroupModel alloc] init];
                    groupModel.isOpen = YES;
                    groupModel.date = lastDate;
                    groupModel.list = groupList.mutableCopy;
                    [dataList addObject:groupModel];
                    
                    //清空groupList数组
                    [groupList removeAllObjects];
                    //将这条的数据添加进去 （新的一组）
                    [groupList addObject:stepModel];
                    lastModel = stepModel;
                }
            }
            //和上组是同一组
            else
            {
                [groupList addObject:stepModel];
                lastModel = stepModel;
            }
            
            
            //如果是最后一个了，保存本组
            if( i == array.count - 1 )
            {
                FLYYearMonthGroupModel * groupModel = [[FLYYearMonthGroupModel alloc] init];
                groupModel.isOpen = YES;
                groupModel.date = date;
                groupModel.list = groupList.mutableCopy;
                [dataList addObject:groupModel];
            }
        }
        
        
        [self.tableView.dataList removeAllObjects];
        [self.tableView loadDataSuccess:dataList total:[json[SERVER_DATA][@"total"] integerValue]];
        
        
    } failure:^(id obj) {
        
        [self.tableView loadDataFailed:obj];
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@历史数据", self.healthModel.healthTypeName];
    self.showNavLine = YES;
    
    [self.view addSubview:self.tableView];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableView.dataList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FLYYearMonthGroupModel * groupModel = self.tableView.dataList[section];
    
    if ( !groupModel.isOpen )
    {
        return 0;
    }
    return groupModel.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLYPhysiologicalHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:_tableView.cellReuseIdentifier];
    FLYYearMonthGroupModel * groupModel = self.tableView.dataList[indexPath.section];
    FLYHealthModel * healthModel = groupModel.list[indexPath.row];
    cell.healthModel = healthModel;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WeakSelf
    
    FLYYearMonthHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"historyHeaderViewIdentifier"];
    headerView.groupModel = self.tableView.dataList[section];
    headerView.clickBlock = ^(FLYYearMonthGroupModel * groupModel) {
        
        NSUInteger index = [self.tableView.dataList indexOfObject:groupModel];
        //刷新点击的那一组
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    };
    return headerView;
}



#pragma mark - setters and getters

-(UITableView *)tableView
{
    if ( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 60;
        _tableView.sectionHeaderHeight = 40;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FLYPhysiologicalHistoryCell class] forCellReuseIdentifier:_tableView.cellReuseIdentifier];
        [_tableView registerClass:[FLYYearMonthHeaderView class] forHeaderFooterViewReuseIdentifier:@"historyHeaderViewIdentifier"];
        [_tableView addRefreshingTarget:self action:@selector(getPhysiologicalListNetwork)];
    }
    return _tableView;
}


@end
