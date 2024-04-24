//
//  FLYLineChartView.m
//  ProvideAged
//
//  Created by fly on 2021/11/15.
//

#import "FLYLineChartView.h"
#import "ProvideAged-Bridging-Header.h"
#import "FLYTime.h"

@interface FLYLineChartView () < ChartViewDelegate >

@property (nonatomic, strong) LineChartView * chartView;

@end

@implementation FLYLineChartView

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
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self).with.offset(0);
    }];
    
}



#pragma mark - UI

- (void)initUI
{
    [self addSubview:self.chartView];
}



#pragma mark - setters and getters

-(void)setHealthModels:(NSArray<FLYHealthModel *> *)healthModels
{
    _healthModels = healthModels;
    
    //外界可能刷新数据重新赋值，所以先清空下
    _chartView.data = nil;
    
    if ( healthModels.count == 0 )
    {
        return;
    }
    
    //如果是血压，交换healthValue和healthValue2的值 （为了先画healthValue2的线）
    if ( [self.healthModels.firstObject healthType] == 6 )
    {
        for (int i = 0; i < healthModels.count; i++ )
        {
            FLYHealthModel * healthModel = healthModels[i];
            NSString * tempValue = healthModel.healthValue;
            healthModel.healthValue = healthModel.healthValue2;
            healthModel.healthValue2 = tempValue;
        }
    }
    
    
    
    //存放DataEntry对象的数组 （DataEntry对象存放的是x轴y轴的数值）
    NSMutableArray * dataEntryArray = [NSMutableArray array];
    
    //存放x轴文字的数组
    NSMutableArray * xTextArray = [NSMutableArray array];
    
    for (int i = 0; i < healthModels.count; i++)
    {
        //获取 Y 轴的值
        FLYHealthModel * healthModel = healthModels[i];
        double yValuel = [healthModel.healthValue doubleValue];
        
        //录入数据 (把x轴和y轴的数值放到DataEntry对象里，然后添加进数组)
        ChartDataEntry * dataEntry = [[ChartDataEntry alloc] initWithX:i y:yValuel];
        [dataEntryArray addObject:dataEntry];
        
        
        //x轴显示的文字
        NSDate * date = [FLYTime stringToDateWithString:healthModel.createTime dateFormat:(FLYDateFormatTypeYMDHMS)];
        NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM.dd"];
        NSString * string = [dateFormat stringFromDate:date];
        
        [xTextArray addObject:string];
    }
    
    //设置x轴直接完成数据填充
    self.chartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc]initWithValues:xTextArray.copy];
    
    //如果图表以前绘制过，那么这里直接重新给data赋值就行了。
    //如果没有，那么要先定义set的属性。
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        //替换条目
        [set1 replaceEntries:dataEntryArray];
        
        //通知data去更新
        [_chartView.data notifyDataChanged];
        
        //通知图表去更新
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithEntries:dataEntryArray];
        //线条颜色
        [set1 setColor:self.styleColor];
        //圆的颜色
        [set1 setCircleColor:self.styleColor];
        //线条宽度
        set1.lineWidth = 3.0;
        //圆的半径
        set1.circleRadius = 5;
        //圆是否空心
        set1.drawCircleHoleEnabled = NO;
        //文字字体
        set1.valueFont = FONT_R(13);
        //文字颜色
        set1.valueTextColor = self.styleColor;
        //是否在拐点处显示数据
        set1.drawValuesEnabled = NO;
        //不启用十字线
        set1.highlightEnabled = NO;
        
        
        /** 填充设置 */
        /*
         //第一种填充样式:单色填充
 //        set1.drawFilledEnabled = YES;//是否填充颜色
 //        set1.fillColor = [UIColor redColor];//填充颜色
 //        set1.fillAlpha = 0.3;//填充颜色的透明度
         
         //第二种填充样式:渐变填充
         set1.drawFilledEnabled = YES;//是否填充颜色
         NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
                                     (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor];
         CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
         set1.fillAlpha = 0.3f;//透明度
         set1.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象
         CGGradientRelease(gradientRef);//释放gradientRef
         */
        
        
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        //如果是血压，添加第二条线
        if ( [self.healthModels.firstObject healthType] == 6 )
        {
            [dataSets addObject:[self bloodPressureLine]];
        }
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        self.chartView.data = data;
        
        //加个动画
        [self.chartView animateWithXAxisDuration:1.0f];

    }
}

//血压的第二根线
- (LineChartDataSet *)bloodPressureLine
{
    //存放DataEntry对象的数组 （DataEntry对象存放的是x轴y轴的数值）
    NSMutableArray * dataEntryArray = [NSMutableArray array];
    
    //存放x轴文字的数组
    NSMutableArray * xTextArray = [NSMutableArray array];
    
    for (int i = 0; i < self.healthModels.count; i++)
    {
        //获取 Y 轴的值
        FLYHealthModel * healthModel = self.healthModels[i];
        double yValuel = [healthModel.healthValue2 doubleValue];
        
        //录入数据 (把x轴和y轴的数值放到DataEntry对象里，然后添加进数组)
        ChartDataEntry * dataEntry = [[ChartDataEntry alloc] initWithX:i y:yValuel];
        [dataEntryArray addObject:dataEntry];
        
        
        //x轴显示的文字
        NSDate * date = [FLYTime stringToDateWithString:healthModel.createTime dateFormat:(FLYDateFormatTypeYMDHMS)];
        NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM.dd"];
        NSString * string = [dateFormat stringFromDate:date];
        
        [xTextArray addObject:string];
    }
    
    //设置x轴直接完成数据填充
    self.chartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc]initWithValues:xTextArray.copy];
    
    //如果图表以前绘制过，那么这里直接重新给data赋值就行了。
    //如果没有，那么要先定义set的属性。
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        //替换条目
        [set1 replaceEntries:dataEntryArray];
        
        //通知data去更新
        [_chartView.data notifyDataChanged];
        
        //通知图表去更新
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithEntries:dataEntryArray];
        //线条颜色
        [set1 setColor:RGB(198, 204, 124, 1)];
        //圆的颜色
        [set1 setCircleColor:RGB(198, 204, 124, 1)];
        //线条宽度
        set1.lineWidth = 3.0;
        //圆的半径
        set1.circleRadius = 5;
        //圆是否空心
        set1.drawCircleHoleEnabled = NO;
        //文字字体
        set1.valueFont = FONT_R(13);
        //文字颜色
        set1.valueTextColor = RGB(198, 204, 124, 1);
        //是否在拐点处显示数据
        set1.drawValuesEnabled = NO;
        //不启用十字线
        set1.highlightEnabled = NO;
    }
    
    return set1;
}


-(LineChartView *)chartView
{
    if ( _chartView == nil )
    {
        _chartView = [[LineChartView alloc] init];
        _chartView.delegate = self;
        _chartView.noDataText = @"暂无数据";
        //是否显示图例 （底部的那块东西）
        _chartView.legend.enabled = NO;

        
        /** 设置交互 */
        
        //取消Y轴缩放
        _chartView.scaleYEnabled = NO;
        //取消双击缩放
        _chartView.doubleTapToZoomEnabled = NO;
        //启用拖拽图标
        _chartView.dragEnabled = YES;
        //拖拽后是否有惯性效果
        _chartView.dragDecelerationEnabled = YES;
        //拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        _chartView.dragDecelerationFrictionCoef = 0.9;
        
        
        /** 设置X轴样式 */

        ChartXAxis *xAxis = _chartView.xAxis;
        //设置X轴线宽
        xAxis.axisLineWidth = 1.0;
        //X轴颜色
        xAxis.axisLineColor = COLORHEX(@"#EEEEEE");
        //X轴的显示位置，默认是显示在上面的
        xAxis.labelPosition = XAxisLabelPositionBottom;
        //不绘制网格线
        xAxis.drawGridLinesEnabled = NO;
        //设置label间隔
        xAxis.spaceMin = 3;
        //label文字颜色
        xAxis.labelTextColor = COLORHEX(@"#B0BBB8");
        //文字字体
        xAxis.labelFont = FONT_R(13);
        xAxis.yOffset = 0;
        //x轴的最小值 （为了让第一个数据贴边，所以设置成了1）
        xAxis.axisMinimum = 1;
        
        /** 设置Y轴样式 */
        //不绘制右边轴
        _chartView.rightAxis.enabled = NO;
        //获取左边Y轴
        ChartYAxis *leftAxis = _chartView.leftAxis;
        //Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.labelCount = 5;
        //是否强制绘制指定数量的label
        leftAxis.forceLabelsEnabled = NO;
        //设置Y轴的最小值
        //leftAxis.axisMinimum = 0;
        //设置Y轴的最大值
        //leftAxis.axisMaxValue = 105;
        //是否将Y轴进行上下翻转
        leftAxis.inverted = NO;
        //Y轴线宽
        leftAxis.axisLineWidth = 1;
        //Y轴颜色
        leftAxis.axisLineColor = COLORHEX(@"#EEEEEE");
        //数字后缀单位
        //leftAxis.valueFormatter.positiveSuffix = @" $";
        //label位置
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
        //文字颜色
        leftAxis.labelTextColor = COLORHEX(@"#B0BBB8");
        //文字字体
        leftAxis.labelFont = FONT_R(13);
        //不绘制网格线
        leftAxis.drawGridLinesEnabled = NO;
        
        
        /** 设置网格样式 */
        
        /*
         
        //设置虚线样式的网格线
        leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];
        //网格线颜色
        leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
        //开启抗锯齿
        leftAxis.gridAntialiasEnabled = YES;
         
         */
        
        
        /** 添加限制线 (可以添加多条) */
        
        /*
         
        ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:80 label:@"限制线"];
        limitLine.lineWidth = 2;
        limitLine.lineColor = [UIColor greenColor];
        //虚线样式
        limitLine.lineDashLengths = @[@5.0f, @5.0f];
        //位置
        limitLine.labelPosition = ChartLimitLabelPositionTopRight;
        //label文字颜色
        limitLine.valueTextColor = COLORHEX(@"#057748");
        //label字体
        limitLine.valueFont = [UIFont systemFontOfSize:12];
        //添加到Y轴上
        [leftAxis addLimitLine:limitLine];
        //设置限制线绘制在折线图的后面
        leftAxis.drawLimitLinesBehindDataEnabled = YES;
         
        */
    }
    return _chartView;
}

@end
