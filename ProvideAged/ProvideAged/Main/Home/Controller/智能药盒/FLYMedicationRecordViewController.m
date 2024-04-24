//
//  FLYMedicationRecordViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYMedicationRecordViewController.h"
#import "UICollectionView+FLYRefresh.h"
#import "FLYMedicationRecordCell.h"
#import "FLYBoxTimeModel.h"
#import "BRDatePickerView.h"
#import "FLYTime.h"
#import "UIBarButtonItem+FLYExtension.h"
#import "FLYMedicationRecordModel.h"

@interface FLYMedicationRecordViewController () < UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation FLYMedicationRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(23);
        make.height.mas_equalTo(54);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(0);
        make.left.bottom.right.equalTo(self.view).with.offset(0);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    [self setMedicationRecordListNetwork];
}



#pragma mark - NETWORK

- (void)setMedicationRecordListNetwork
{
    NSString * startTime = [NSString stringWithFormat:@"%@ 00:00:00", self.timeLabel.text];
    NSString * endTime = [NSString stringWithFormat:@"%@ 23:59:59", self.timeLabel.text];
    
    NSDictionary * params = @{ @"deviceId" : self.deviceId, @"oldManInfoId" : self.oldManInfoId, @"pageNo" : @"1", @"pageSize" : @"99", @"startTime" : startTime, @"endTime" : endTime };
    
    [FLYNetworkTool postRawWithPath:API_MEDICATIONRECORD params:params success:^(id  _Nonnull json) {
        
        if ( [json[@"content"] isKindOfClass:[NSArray class]] == NO )
        {
            [self.collectionView loadDataSuccess:@[]];
            return;
        }
        
        NSArray * array = json[@"content"];
        NSDictionary * dic = array.firstObject;
        NSArray * dicModelList = dic[@"medicationRecordInfoByDetailVoList"];
        
        NSArray * modelList = [FLYMedicationRecordModel mj_objectArrayWithKeyValuesArray:dicModelList];
        
        [self.collectionView loadDataSuccess:modelList];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        [self.collectionView loadDataFailed:error];
        
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"用药记录";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"box_riqi" target:self action:@selector(dateClick:)];
    
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.collectionView];
}



#pragma mark - event handler

- (void)dateClick:(UIBarButtonItem *)item
{
    [BRDatePickerView showDatePickerWithMode:(BRDatePickerModeYMD) title:nil selectValue:nil resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        
        self.timeLabel.text = selectValue;
        
        //请求接口刷新数据
        [self setMedicationRecordListNetwork];
    }];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionView.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYMedicationRecordCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionView.cellReuseIdentifier forIndexPath:indexPath];
    
    cell.recordModel = self.collectionView.dataList[indexPath.row];
    
    return cell;
}



#pragma mark - setters and getters


- (UILabel *)timeLabel
{
    if( _timeLabel == nil )
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = FONT_R(16);
        _timeLabel.textColor = COLORHEX(@"#333333");
        _timeLabel.text = [FLYTime dateToStringWithDate:[NSDate date] dateFormat:(FLYDateFormatTypeYMD)];
    }
    return _timeLabel;
}


-(UICollectionView *)collectionView
{
    if ( _collectionView == nil )
    {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumInteritemSpacing = 0;
        flow.minimumInteritemSpacing = 14;
        flow.estimatedItemSize = CGSizeMake(SCREEN_WIDTH - 40, 100);
        flow.sectionInset = UIEdgeInsetsMake(0, 20, 20, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = COLORHEX(@"#F9F9F9");
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FLYMedicationRecordCell class] forCellWithReuseIdentifier:_collectionView.cellReuseIdentifier];
    }
    return _collectionView;
}


@end

