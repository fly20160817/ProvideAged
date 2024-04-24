//
//  FLYQueryListView.m
//  ProvideAged
//
//  Created by fly on 2022/12/22.
//

#import "FLYQueryListView.h"

@interface FLYQueryListView () < UITableViewDelegate, UITableViewDataSource >

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation FLYQueryListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.tableView];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLYDrugModel * model = self.dataList[indexPath.row];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableView.cellReuseIdentifier];
    cell.textLabel.text = model.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    !self.selectBlock ?: self.selectBlock(self.dataList[indexPath.row]);
}



#pragma mark - setters and getters

-(void)setDataList:(NSArray<FLYDrugModel *> *)dataList
{
    _dataList = dataList;
    
    [self.tableView reloadData];
}

-(UITableView *)tableView
{
    if ( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_tableView.cellReuseIdentifier];
    }
    return _tableView;
}

@end
