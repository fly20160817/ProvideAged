//
//  FLYAddDrugRemindViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYAddDrugRemindViewController.h"
#import "FLYWhiteTitleNavView.h"
#import "FLYDrugQueryView.h"
#import "FLYRemindSelectView.h"
#import "BRPickerView.h"
#import "FLYTimePointView.h"
#import "FLYQueryListView.h"
#import "FLYPopupView.h"
#import "FLYDrugModel.h"
#import "FLYBoxTimeModel.h"
#import "FLYTime.h"

@interface FLYAddDrugRemindViewController ()

@property (nonatomic, strong) FLYWhiteTitleNavView * navView;
@property (nonatomic, strong) FLYDrugQueryView * queryView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) FLYRemindSelectView * intervalView;
@property (nonatomic, strong) FLYTimePointView * timePointView;
@property (nonatomic, strong) FLYRemindSelectView * numberView;
@property (nonatomic, strong) FLYRemindSelectView * timeView;
@property (nonatomic, strong) FLYRemindSelectView * durationView;

@property (nonatomic, strong) UIButton * confirmBtn;

@property (nonatomic, strong) FLYPopupView * popupView;
@property (nonatomic, strong) FLYQueryListView * queryListView;

@property (nonatomic, strong) NSArray * drugList;

@property (nonatomic, strong) FLYDrugModel * drugModel;

@end

@implementation FLYAddDrugRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    [self.queryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(152);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.queryView.mas_bottom).offset(25);
        make.left.equalTo(self.view).offset(20);
    }];
    
    [self.intervalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.queryView.mas_bottom).offset(58);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(42);
    }];
    
    [self.timePointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.intervalView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(100);
    }];
    
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timePointView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(42);
    }];
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(42);
    }];
    
    [self.durationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(42);
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
    [self getDrugListNetwork];
    
    [self getTimeListNetwork];
}



#pragma mark - NETWORK

- (void)getDrugListNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"deviceId" : self.deviceId };

    [FLYNetworkTool postRawWithPath:APISEARCHDRUGS params:params success:^(id  _Nonnull json) {
        
        NSArray * array = [FLYDrugModel mj_objectArrayWithKeyValuesArray:json[@"content"]];
        self.drugList = array;
        self.queryListView.dataList = array;
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
    }];
}

- (void)searchDrugs:(NSString *)searchName
{
    if ( searchName.length == 0 )
    {
        [self.popupView dissmiss];
        
        //输入为空时，把列表赋值为全部数据，输入框没内容的时候点击展开显示的就是全部。
        self.queryListView.dataList = self.drugList;
        
        return;
    }
    
    
    
    NSMutableArray * searchArray = [NSMutableArray array];
    
    for (FLYDrugModel * model in self.drugList)
    {
        if ( [model.name containsString:searchName] )
        {
            [searchArray addObject:model];
        }
    }
    
    self.queryListView.dataList = searchArray;
    
    if ( searchArray.count > 0 )
    {
        [self.popupView show];
    }
    else
    {
        [self.popupView dissmiss];
    }
}

- (void)addRemindNetwork
{
    NSString * duration = [self.durationView.content stringByReplacingOccurrencesOfString:@"个" withString:@""];
    NSString * durationType = [duration substringFromIndex:duration.length-1];
    duration = [duration stringByReplacingOccurrencesOfString:durationType withString:@""];
    
    if ( [durationType isEqualToString:@"天"] )
    {
        durationType = @"1";
    }
    else if ( [durationType isEqualToString:@"月"] )
    {
        durationType = @"2";
    }
    else if ( [durationType isEqualToString:@"年"] )
    {
        durationType = @"3";
    }
    
    
    NSMutableArray * array = [NSMutableArray array];
    for (FLYBoxTimeModel * model in self.timePointView.selectModels)
    {
        NSDictionary * dic = @{ @"arrangeType" : @(model.arrangeType), @"arrangeTime" : model.arrangeTime };
        [array addObject:dic];
    }
    
    NSDictionary * params = @{ @"drugsId" : self.drugModel.idField, @"deviceId" : self.deviceId, @"oldManInfoId" : self.oldManInfoId, @"medicationInterval" : self.intervalView.contentId, @"dose" : self.numberView.contentId, @"startTime" : self.timeView.content, @"duration" : duration, @"durationType" : durationType, @"remindDetailInfoInsertList" : array };
    
    [FLYNetworkTool postRawWithPath:APIADDREMIND params:params success:^(id  _Nonnull json) {
        
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        NSLog(@"成功：%@", json);
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
    }];
}

- (void)getTimeListNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"deviceId" : self.deviceId };

    [FLYNetworkTool postRawWithPath:API_DRUGTIMELIST params:params success:^(id  _Nonnull json) {
        
        NSMutableArray * array = [FLYBoxTimeModel mj_objectArrayWithKeyValuesArray:json[@"content"]];
        
        self.timePointView.dataList = array;
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationBarHidden = YES;
    
    self.view.backgroundColor = COLORHEX(@"#F9F9F9");
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.queryView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.intervalView];
    [self.view addSubview:self.timePointView];
    [self.view addSubview:self.numberView];
    [self.view addSubview:self.timeView];
    [self.view addSubview:self.durationView];
    [self.view addSubview:self.confirmBtn];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    
}



#pragma mark - event handler

- (void)confirmClick:(UIButton *)button
{
    if ( self.drugModel == nil )
    {
        [SVProgressHUD showImage:nil status:@"请先输入药品名称"];
        return;
    }
    
    [self addRemindNetwork];
}



#pragma mark - NSNotification

- (void)textDidChangeNotification:(NSNotification *)notify
{
    UITextField * textField = notify.object;
    
    [self searchDrugs:textField.text];
}



#pragma mark - setters and getters

-(FLYWhiteTitleNavView *)navView
{
    if ( _navView == nil )
    {
        _navView = [[FLYWhiteTitleNavView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUSADDNAV_HEIGHT)];
        _navView.title = @"添加用药提醒";
    }
    return _navView;
}

-(FLYDrugQueryView *)queryView
{
    if ( _queryView == nil )
    {
        WeakSelf
        _queryView = [[FLYDrugQueryView alloc] init];
        _queryView.showBlock = ^{
            
            if ( weakSelf.queryListView.dataList.count > 0)
            {
                [weakSelf.popupView show];
            }
        };
    }
    return _queryView;
}


- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_R(16);
        _titleLabel.textColor = COLORHEX(@"#333333");
        _titleLabel.text = @"提醒设置";
    }
    return _titleLabel;
}

- (FLYRemindSelectView *)intervalView
{
    if( _intervalView == nil )
    {
        WeakSelf
        _intervalView = [[FLYRemindSelectView alloc] init];
        _intervalView.title = @"服药间隔";
        _intervalView.content = @"每日";
        _intervalView.contentId = @"0";
        _intervalView.clickBlock = ^{
            
            NSArray * array = @[ @"每日", @"隔日", @"隔7日", @"隔20日" ];
            
            [BRStringPickerView showPickerWithTitle:nil dataSourceArr:array selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
                
                weakSelf.intervalView.content = resultModel.value;
                
                if ( [resultModel.value isEqualToString:@"每日"] )
                {
                    weakSelf.intervalView.contentId = @"0";
                }
                else if ( [resultModel.value isEqualToString:@"隔日"] )
                {
                    weakSelf.intervalView.contentId = @"1";
                }
                else if ( [resultModel.value isEqualToString:@"隔7日"] )
                {
                    weakSelf.intervalView.contentId = @"7";
                }
                else if ( [resultModel.value isEqualToString:@"隔20日"] )
                {
                    weakSelf.intervalView.contentId = @"20";
                }
                
            }];
            
        };
    }
    return _intervalView;
}

- (FLYRemindSelectView *)numberView
{
    if( _numberView == nil )
    {
        WeakSelf
        _numberView = [[FLYRemindSelectView alloc] init];
        _numberView.title = @"服药剂量";
        _numberView.content = @"1";
        _numberView.contentId = @"1";
        _numberView.clickBlock = ^{
            
            NSArray * array = @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59", @"60", @"61", @"62", @"63", @"64", @"65", @"66", @"67", @"68", @"69", @"70", @"71", @"72", @"73", @"74", @"75", @"76", @"77", @"78", @"79", @"80", @"81", @"82", @"83", @"84", @"85", @"86", @"87", @"88", @"89", @"90", @"91", @"92", @"93", @"94", @"95", @"96", @"97", @"98", @"99", @"100" ];
            
            [BRStringPickerView showPickerWithTitle:nil dataSourceArr:array selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
                
                weakSelf.numberView.content = resultModel.value;
                weakSelf.numberView.contentId = resultModel.value;
            }];
            
        };
    }
    return _numberView;
}

- (FLYRemindSelectView *)timeView
{
    if( _timeView == nil )
    {
        WeakSelf
        _timeView = [[FLYRemindSelectView alloc] init];
        _timeView.title = @"起始时间";
        _timeView.content = [FLYTime dateToStringWithDate:[NSDate date] dateFormat:(FLYDateFormatTypeYMD)];
        _timeView.contentId = @"";
        _timeView.clickBlock = ^{
            
            [BRDatePickerView showDatePickerWithMode:(BRDatePickerModeYMD) title:nil selectValue:nil resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                weakSelf.timeView.content = selectValue;
            }];
            
        };
    }
    return _timeView;
}

- (FLYRemindSelectView *)durationView
{
    if( _durationView == nil )
    {
        WeakSelf
        _durationView = [[FLYRemindSelectView alloc] init];
        _durationView.title = @"持续时间";
        _durationView.content = @"1天";
        _durationView.contentId = @"";
        _durationView.clickBlock = ^{
            
            NSArray * array = @[ @"1天", @"2天", @"3天", @"4天", @"5天", @"6天", @"7天", @"8天", @"9天", @"10天", @"11天", @"12天", @"13天", @"14天", @"15天", @"16天", @"17天", @"18天", @"19天", @"20天", @"21天", @"22天", @"23天", @"24天", @"25天", @"26天", @"27天", @"28天", @"29天", @"30天", @"2个月", @"3个月", @"1年" ];
            
            [BRStringPickerView showPickerWithTitle:nil dataSourceArr:array selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
                
                weakSelf.durationView.content = resultModel.value;
                weakSelf.durationView.contentId = @"";
            }];
            
        };
    }
    return _durationView;
}

-(FLYTimePointView *)timePointView
{
    if ( _timePointView == nil )
    {
        _timePointView = [[FLYTimePointView alloc] init];
    }
    return _timePointView;
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

-(FLYQueryListView *)queryListView
{
    if ( _queryListView == nil )
    {
        WeakSelf
        _queryListView = [[FLYQueryListView alloc] initWithFrame:CGRectMake(20, STATUSADDNAV_HEIGHT + 80, SCREEN_WIDTH - 40, 200)];
        _queryListView.selectBlock = ^(FLYDrugModel * _Nonnull model) {
            
            [weakSelf.popupView dissmiss];
            
            weakSelf.drugModel = model;
            
            weakSelf.queryView.textField.text = model.name;
            weakSelf.queryView.specsLabel.text = [NSString stringWithFormat:@"规格：%@", model.specs];
            weakSelf.queryView.brandLabel.text = [NSString stringWithFormat:@"品牌：%@", model.brand];
            weakSelf.queryView.numberLabel.text = [NSString stringWithFormat:@"剩余：%@", model.surplus];
        };
    }
    return _queryListView;
}

-(FLYPopupView *)popupView
{
    if ( _popupView == nil )
    {
        _popupView = [FLYPopupView popupView:self.queryListView animationType:(FLYPopupAnimationTypeNone) maskType:(FLYPopupMaskTypeClear)];
    }
    return _popupView;
}

@end

