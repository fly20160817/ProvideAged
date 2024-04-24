//
//  FLYHealthRecordViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYHealthRecordViewController.h"
#import "FLYCustomSegmentBar.h"
#import "FLYPhysiologicalViewController.h"
#import "FLYPersonalBaseInfoViewController.h"
#import "FLYPageScrollView.h"

@interface FLYHealthRecordViewController () < FLYPageScrollViewDelegate, FLYSegmentBarDelegate >

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) FLYCustomSegmentBar * segmentBar;
@property (nonatomic, strong) FLYPageScrollView * scrollView;

@end

@implementation FLYHealthRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initUI];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"健康档案";
    
    [self.view addSubview:self.segmentBar];
    [self.view addSubview:self.scrollView];
    
    
    //展示第一个页面
    self.segmentBar.selectIndex = 0;
}



#pragma mark - FLYSegmentBarDelegate

-(void)segmentBar:(FLYSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    [self.scrollView selectIndex:toIndex animated:YES];
}



#pragma mark - FLYPageScrollViewDelegate

-(void)pageScrollView:(FLYPageScrollView *)pageScrollView originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    self.segmentBar.selectIndex = targetIndex;
}



#pragma mark - setters and getters

-(FLYCustomSegmentBar *)segmentBar
{
    if ( _segmentBar == nil )
    {
        _segmentBar = [[FLYCustomSegmentBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 32) titleNames:self.titleArray];
        _segmentBar.delegate = self;
    }
    return _segmentBar;
}

-(NSArray *)titleArray
{
    if( _titleArray == nil )
    {
        _titleArray = @[@"生理数据", @"基本信息"];
    }
    return _titleArray;
}

-(FLYPageScrollView *)scrollView
{
    if ( _scrollView == nil )
    {
        FLYPhysiologicalViewController * vc1 = [[FLYPhysiologicalViewController alloc] init];
        vc1.oldManInfoId = self.oldManInfoId;
        FLYPersonalBaseInfoViewController * vc2 = [[FLYPersonalBaseInfoViewController alloc] init];
        vc2.oldManInfoId = self.oldManInfoId;
        
        _scrollView = [[FLYPageScrollView alloc] initWithFrame:self.view.bounds parentVC:self childVCs:@[vc1, vc2]];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
