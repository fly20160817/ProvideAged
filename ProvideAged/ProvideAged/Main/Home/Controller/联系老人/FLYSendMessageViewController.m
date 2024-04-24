//
//  FLYSendMessageViewController.m
//  ProvideAged
//
//  Created by fly on 2021/11/5.
//

#import "FLYSendMessageViewController.h"
#import "FLYChatRecordModel.h"
#import "FLYTextView.h"
#import "FLYTools.h"
#import "IQKeyboardManager.h"
#import "FLYChatCell.h"
#import "FLYTime.h"

@interface FLYSendMessageViewController () < UITableViewDelegate, UITableViewDataSource, UITextViewDelegate >
{
    CGFloat _autoHeight;
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) FLYTextView * textView;
@property (nonatomic, strong) UIButton * sendBtn;

@end

@implementation FLYSendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(_autoHeight == 0 ? 55 + [FLYTools safeAreaInsets].bottom : _autoHeight);
    }];
    
    [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_top).with.offset(17);
        make.right.equalTo(self.view).with.offset(-22);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.textView.mas_top);
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    IQKeyboardManager * keyboardManager = [IQKeyboardManager sharedManager];
    //设置键盘与文本字段的距离
    keyboardManager.keyboardDistanceFromTextField = 0;
    keyboardManager.enableAutoToolbar = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    IQKeyboardManager * keyboardManager = [IQKeyboardManager sharedManager];
    //设置键盘与文本字段的距离
    keyboardManager.keyboardDistanceFromTextField = 10;
    keyboardManager.enableAutoToolbar = YES;
}



#pragma mark - DATA

- (void)loadData
{
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark - NETWORK

- (void)getChatRecordNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"pageNo" : @(self.tableView.pageNum), @"pageSize" : @(self.tableView.pageSize), @"sorts" : @[@{@"name" : @"createTime", @"order" : @"ASC"}] };
    
    [FLYNetworkTool postRawWithPath:API_CHATRECORD params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:YES success:^(id  _Nonnull json) {
                
        [self.tableView.mj_header endRefreshing];
        
        NSMutableArray * array = [FLYChatRecordModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA][@"list"]];
        
        if ( array.count == 0 )
        {
            return;
        }
        
        NSMutableArray * tempArray = [NSMutableArray array];
        [tempArray addObjectsFromArray:array];
        [tempArray addObjectsFromArray:self.tableView.dataList];
        self.tableView.dataList = tempArray;
        
    
        if ( self.tableView.dataList.count > 0 )
        {
            [UIView animateWithDuration:0 animations:^{
                
                [self.tableView reloadData];
                
            } completion:^(BOOL finished) {
                
                NSIndexPath * index = [NSIndexPath indexPathForRow:array.count - 1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
            }];
        }
        
        self.tableView.pageNum += 1;
        
    } failure:^(NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)sendMessageNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"information" : self.textView.text };

    [FLYNetworkTool postRawWithPath:API_SENDMESSAGE params:params loadingType:(FLYNetworkLoadingTypeInteraction) loadingTitle:@"发送中" isHandle:YES success:^(id  _Nonnull json) {

        //发完之后要更新列表
        FLYChatRecordModel * chatRecordModel = [[FLYChatRecordModel alloc] init];
        chatRecordModel.isRead = 2;
        chatRecordModel.information = self.textView.text;
        chatRecordModel.createTime = [FLYTime dateToStringWithDate:[NSDate date] dateFormat:(FLYDateFormatTypeYMDHMS)];
        [self.tableView.dataList addObject:chatRecordModel];
        
        [UIView animateWithDuration:0 animations:^{
            
            [self.tableView reloadData];
            
        } completion:^(BOOL finished) {
            
            NSIndexPath * index = [NSIndexPath indexPathForRow:self.tableView.dataList.count - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }];
        
        self.textView.text = @"";
        
    } failure:^(NSError * _Nonnull error) {

        NSLog(@"error = %@", error);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"联系老人";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.sendBtn];
}



#pragma mark - event handler

- (void)sendClick:(UIButton *)button
{
    [self.textView resignFirstResponder];
    
    if ( self.textView.text.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"内容不能为空"];
        return;
    }
    
    [self sendMessageNetwork];
    
    
}



#pragma mark - UITextViewDelegate

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableView.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLYChatCell * cell = [tableView dequeueReusableCellWithIdentifier:self.tableView.cellReuseIdentifier forIndexPath:indexPath];
    
    cell.chatRecordModel = self.tableView.dataList[indexPath.row];
    
    return cell;
}



#pragma mark - setters and getters

-(UITableView *)tableView
{
    if( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.backgroundColor = COLORHEX(@"#F9F9F9");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 133;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FLYChatCell class] forCellReuseIdentifier:_tableView.cellReuseIdentifier];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getChatRecordNetwork)];
    }
    return _tableView;
}

-(FLYTextView *)textView
{
    if ( _textView == nil )
    {
        WeakSelf
        StrongSelf
        _textView = [[FLYTextView alloc] init];
        _textView.delegate = self;
        _textView.placeholder = @"这是一条信息编辑栏";
        _textView.placeholderColor = COLORHEX(@"#BFBFBF");
        _textView.font = FONT_R(15);
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.enterEndEditing = YES;
        _textView.textEdgeInset = UIEdgeInsetsMake(18, 25, 18 + [FLYTools safeAreaInsets].bottom, 66);
        [_textView autoWrapWithMaxHeight:200 heightDidChange:^(CGFloat newHeight) {
            strongSelf ->_autoHeight = newHeight;
        }];
    }
    return _textView;
}

-(UIButton *)sendBtn
{
    if ( _sendBtn == nil )
    {
        _sendBtn = [UIButton buttonWithImage:IMAGENAME(@"send")];
        [_sendBtn addTarget:self action:@selector(sendClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sendBtn;
}

@end
