//
//  FLYPersonalBaseInfoViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYPersonalBaseInfoViewController.h"
#import "UITableView+FLYRefresh.h"
#import "FLYPersonalBaseInfoCell.h"
#import "FLYKeyValueModel.h"
#import "FLYElderModel.h"

@interface FLYPersonalBaseInfoViewController () < UITableViewDelegate, UITableViewDataSource >

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray<FLYKeyValueModel *> * dataList;

@property (nonatomic, strong) FLYElderModel * elderModel;

@end

@implementation FLYPersonalBaseInfoViewController

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
        make.top.left.bottom.right.equalTo(self.view).with.offset(0);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    [self getElderInfoNetwork];
}



#pragma mark - NETWORK

- (void)getElderInfoNetwork
{
    NSDictionary * params = @{ @"id" : self.oldManInfoId };
    
    [FLYNetworkTool postRawWithPath:API_ELDERDETAIL params:params success:^(id json) {
        
        self.elderModel = [FLYElderModel mj_objectWithKeyValues:json[SERVER_DATA]];
        
        //清空后重新赋值
        self.dataList = nil;
        [self.tableView reloadData];
        
    } failure:^(id obj) {
        
        NSLog(@"obj = %@", obj);
    }];
}


#pragma mark - UI

- (void)initUI
{
    [self.view addSubview:self.tableView];
    
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLYPersonalBaseInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:_tableView.cellReuseIdentifier forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    return cell;
}



#pragma mark - setters and getters

-(UITableView *)tableView
{
    if ( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.backgroundColor = COLORHEX(@"#F9F9F9");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _tableView.separatorColor = COLORHEX(@"#EAEAEA");
        [_tableView registerClass:[FLYPersonalBaseInfoCell class] forCellReuseIdentifier:_tableView.cellReuseIdentifier];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

-(NSArray<FLYKeyValueModel *> *)dataList
{
    if( _dataList == nil )
    {
        FLYKeyValueModel * model1 = [[FLYKeyValueModel alloc] init];
        model1.key = @"老人姓名";
        model1.value = self.elderModel.name;
        
        FLYKeyValueModel * model2 = [[FLYKeyValueModel alloc] init];
        model2.key = @"性别";
        model2.value = self.elderModel.sex == 1 ? @"男" : @"女";
        
        FLYKeyValueModel * model3 = [[FLYKeyValueModel alloc] init];
        model3.key = @"年龄";
        model3.value = [NSString stringWithFormat:@"%ld 岁", (long)self.elderModel.age];
        
        FLYKeyValueModel * model4 = [[FLYKeyValueModel alloc] init];
        model4.key = @"身高";
        model4.value = self.elderModel.height;
        
        FLYKeyValueModel * model5 = [[FLYKeyValueModel alloc] init];
        model5.key = @"体重";
        model5.value = self.elderModel.weight;
        
        FLYKeyValueModel * model6 = [[FLYKeyValueModel alloc] init];
        model6.key = @"生日";
        model6.value = self.elderModel.birthday;
        
        FLYKeyValueModel * model7 = [[FLYKeyValueModel alloc] init];
        model7.key = @"血型";
        model7.value = self.elderModel.bloodType;
        
        FLYKeyValueModel * model8 = [[FLYKeyValueModel alloc] init];
        model8.key = @"照顾需求等级";
        model8.value = self.elderModel.careLevelName;
        
        FLYKeyValueModel * model9 = [[FLYKeyValueModel alloc] init];
        model9.key = @"老人状态";
        model9.value = self.elderModel.statusName;
        
        _dataList = @[model1, model2, model3, model4, model5, model6, model7, model8, model9];
    }
    return _dataList;
}

@end
