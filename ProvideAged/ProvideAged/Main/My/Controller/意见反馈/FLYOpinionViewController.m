//
//  FLYOpinionViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYOpinionViewController.h"
#import "FLYTextView.h"

@interface FLYOpinionViewController () < UITextViewDelegate >

@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextField * titleTF;
@property (nonatomic, strong) UIView * line1View;
@property (nonatomic, strong) UILabel * mailboxLabel;
@property (nonatomic, strong) UITextField * mailboxTF;
@property (nonatomic, strong) UIView * line2View;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) FLYTextView * contentTextView;
@property (nonatomic, strong) UILabel * wordNumLabel;
@property (nonatomic, strong) UIButton * submitBtn;

@end

@implementation FLYOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(12);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(241);
    }];
    
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).with.offset(48);
        make.left.equalTo(self.baseView).with.offset(20);
        make.right.equalTo(self.baseView).with.offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).with.offset(25);
        make.bottom.equalTo(self.line1View.mas_top).with.offset(-13);
        make.width.mas_equalTo(100);
    }];
    
    [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).with.offset(20);
        make.right.equalTo(self.baseView).with.offset(-25);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1View.mas_bottom).with.offset(44);
        make.left.equalTo(self.baseView).with.offset(20);
        make.right.equalTo(self.baseView).with.offset(-20);
        make.height.mas_equalTo(1);
    }];

    [self.mailboxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).with.offset(25);
        make.bottom.equalTo(self.line2View.mas_top).with.offset(-13);
        make.width.mas_equalTo(100);
    }];

    [self.mailboxTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mailboxLabel.mas_right).with.offset(20);
        make.right.equalTo(self.baseView).with.offset(-25);
        make.centerY.equalTo(self.mailboxLabel);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).with.offset(25);
        make.top.equalTo(self.line2View.mas_bottom).with.offset(15);
        make.width.mas_equalTo(100);
    }];

    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2View.mas_bottom).with.offset(40);
        make.left.equalTo(self.baseView).with.offset(24);
        make.right.equalTo(self.baseView).with.offset(-20);
        make.height.mas_equalTo(87);
    }];
    
    [self.wordNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView).with.offset(-30);
        make.right.equalTo(self.baseView).with.offset(-30);
    }];
        
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView.mas_bottom).with.offset(30);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(44);
    }];
    
}



#pragma mark - DATA

- (void)loadData
{
    
}



#pragma makr - NETWORK

- (void)submitNetwork
{
    NSDictionary * params = @{ @"title" : self.titleTF.text, @"contactEmail" : self.mailboxTF.text, @"content" : self.contentTextView.text };
    
    [FLYNetworkTool postRawWithPath:API_FEEDBACK params:params success:^(id json) {
        
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(id obj) {
        
        FLYLog(@"提交失败:%@", obj);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"意见反馈";
    
    self.view.backgroundColor = COLORHEX(@"#F9F9F9");
    
    
    [self.view addSubview:self.baseView];
    [self.baseView addSubview:self.titleLabel];
    [self.baseView addSubview:self.titleTF];
    [self.baseView addSubview:self.line1View];
    [self.baseView addSubview:self.mailboxLabel];
    [self.baseView addSubview:self.mailboxTF];
    [self.baseView addSubview:self.line2View];
    [self.baseView addSubview:self.contentLabel];
    [self.baseView addSubview:self.contentTextView];
    [self.contentTextView addSubview:self.wordNumLabel];
    [self.view addSubview:self.submitBtn];
}



#pragma mark - event hander

- (void)addClick:(UIButton *)button
{
    if ( self.titleTF.text.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入反馈标题"];
        return;
    }
    
    [self submitNetwork];
}



#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView
{
    self.wordNumLabel.text = [NSString stringWithFormat:@"%lu/100", (unsigned long)textView.text.length > 100 ? 100 : textView.text.length];
}



#pragma mark - setters and getters

- (UIView *)baseView
{
    if( _baseView == nil )
    {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [UIColor whiteColor];
    }
    return _baseView;
}

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_R(13);
        _titleLabel.textColor = COLORHEX(@"#999999");
        _titleLabel.text = @"*标题";
    }
    return _titleLabel;
}

- (UITextField *)titleTF
{
    if( _titleTF == nil )
    {
        _titleTF = [[UITextField alloc] init];
        _titleTF.placeholder = @"请输入";
        _titleTF.font = FONT_M(13);
        _titleTF.textColor = COLORHEX(@"#0E0E0E");
        _titleTF.textAlignment = NSTextAlignmentRight;
    }
    return _titleTF;
}

-(UIView *)line1View
{
    if ( _line1View == nil )
    {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = COLORHEX(@"#EAEAEA");
    }
    return _line1View;
}

- (UILabel *)mailboxLabel
{
    if( _mailboxLabel == nil )
    {
        _mailboxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _mailboxLabel.font = FONT_R(13);
        _mailboxLabel.textColor = COLORHEX(@"#999999");
        _mailboxLabel.text = @"联系邮箱";
    }
    return _mailboxLabel;
}

- (UITextField *)mailboxTF
{
    if( _mailboxTF == nil )
    {
        _mailboxTF = [[UITextField alloc] init];
        _mailboxTF.placeholder = @"请输入";
        _mailboxTF.font = FONT_M(13);
        _mailboxTF.textColor = COLORHEX(@"#0E0E0E");
        _mailboxTF.textAlignment = NSTextAlignmentRight;
    }
    return _mailboxTF;
}

-(UIView *)line2View
{
    if ( _line2View == nil )
    {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = COLORHEX(@"#EAEAEA");
    }
    return _line2View;
}

- (UILabel *)contentLabel
{
    if( _contentLabel == nil )
    {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = FONT_R(13);
        _contentLabel.textColor = COLORHEX(@"#999999");
        _contentLabel.text = @"反馈内容";
    }
    return _contentLabel;
}

- (FLYTextView *)contentTextView
{
    if( _contentTextView == nil )
    {
        _contentTextView = [[FLYTextView alloc] init];
        _contentTextView.delegate = self;
        _contentTextView.backgroundColor = COLORHEX(@"#F7F7F7");
        _contentTextView.placeholder = @"请详细描述您要反馈的意见";
        _contentTextView.font = FONT_M(13);
        _contentTextView.textColor = COLORHEX(@"#0E0E0E");
        _contentTextView.limitWordNumber = 100;
        _contentTextView.enterEndEditing = YES;
        _contentTextView.textEdgeInset = UIEdgeInsetsMake(10, 10, 33, 10);
    }
    return _contentTextView;
}

-(UILabel *)wordNumLabel
{
    if ( _wordNumLabel == nil )
    {
        _wordNumLabel = [[UILabel alloc] init];
        _wordNumLabel.textColor = COLORHEX(@"#999999");
        _wordNumLabel.font = FONT_R(13);
        _wordNumLabel.textAlignment = NSTextAlignmentRight;
        _wordNumLabel.text = @"0/100";
    }
    return _wordNumLabel;
}

- (UIButton *)submitBtn
{
    if( _submitBtn == nil )
    {
        _submitBtn = [UIButton buttonWithTitle:@"提交" titleColor:[UIColor whiteColor] font:FONT_M(16)];
        [_submitBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.layer.cornerRadius = 4;
        _submitBtn.backgroundColor = COLORHEX(@"#2BB9A0");
    }
    return _submitBtn;
}



@end
