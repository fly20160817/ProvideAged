//
//  FLYPhysiologicalChartViewController.m
//  ProvideAged
//
//  Created by fly on 2021/11/3.
//

#import "FLYPhysiologicalChartViewController.h"
#import "FLYPhysiologicalCircleView.h"
#import "FLYPhysiologicalChartView.h"
#import "FLYPhysiologicalHistoryListViewController.h"
#import "FLYHealthModel.h"
#import "FLYTime.h"
#import "NSDate+FLYExtension.h"

@interface FLYPhysiologicalChartViewController ()

@property (nonatomic, strong) FLYPhysiologicalCircleView * circleView;
@property (nonatomic, strong) FLYPhysiologicalChartView * chartView;

@end

@implementation FLYPhysiologicalChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(350);
    }];
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(319);
        make.left.bottom.right.equalTo(self.view);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    [self getHealthListNetwork:1];
}



#pragma mark - NETWORK

//timeType 1周 2月
- (void)getHealthListNetwork:(NSInteger)timeType
{
    NSString * endTime = [FLYTime dateToStringWithDate:[NSDate date] dateFormat:(FLYDateFormatTypeYMDHMS)];
    
    NSString * startTime = @"";
    
    if( timeType == 2 )
    {
        NSDate * date = [NSDate getDateAfter:[NSDate date] unitFlag:(FLYCalendarUnitDay) number:-30];
        startTime = [FLYTime dateToStringWithDate:date dateFormat:(FLYDateFormatTypeYMD)];
        startTime = [NSString stringWithFormat:@"%@ 00:00:00", startTime];
    }
    else
    {
        NSDate * date = [NSDate getDateAfter:[NSDate date] unitFlag:(FLYCalendarUnitDay) number:-7];
        startTime = [FLYTime dateToStringWithDate:date dateFormat:(FLYDateFormatTypeYMD)];
        startTime = [NSString stringWithFormat:@"%@ 00:00:00", startTime];
    }
    
    NSDictionary * params = @{ @"oldManInfoId" : self.healthModel.oldManInfoId, @"healthType" : @(self.healthModel.healthType), @"startDate" : startTime, @"endDate" : endTime };
    
    [FLYNetworkTool postRawWithPath:API_HEALTHLIST params:params success:^(id  _Nonnull json) {
        
        NSArray * array = [FLYHealthModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        //倒叙
        array = [[array reverseObjectEnumerator] allObjects];
        self.chartView.healthModels = array;
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = self.healthModel.healthTypeName;
   
    
    [self.view addSubview:self.circleView];
    [self.view addSubview:self.chartView];
}



#pragma mark - settes and getters

-(FLYPhysiologicalCircleView *)circleView
{
    if ( _circleView == nil )
    {
        WeakSelf
        _circleView = [[FLYPhysiologicalCircleView alloc] init];
        _circleView.healthModel = self.healthModel;
        _circleView.historyBlock = ^{
            
            FLYPhysiologicalHistoryListViewController * vc = [[FLYPhysiologicalHistoryListViewController alloc] init];
            vc.healthModel = weakSelf.healthModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _circleView;
}

-(FLYPhysiologicalChartView *)chartView
{
    if ( _chartView == nil )
    {
        WeakSelf
        _chartView = [[FLYPhysiologicalChartView alloc] init];
        _chartView.healthModel = self.healthModel;
        _chartView.weekBlock = ^{
            [weakSelf getHealthListNetwork:1];
        };
        _chartView.monthBlock = ^{
            [weakSelf getHealthListNetwork:2];
        };
    }
    return _chartView;
}

@end
