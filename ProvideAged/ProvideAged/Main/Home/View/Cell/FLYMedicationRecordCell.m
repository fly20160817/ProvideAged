//
//  FLYMedicationRecordCell.m
//  ProvideAged
//
//  Created by fly on 2021/11/4.
//

#import "FLYMedicationRecordCell.h"

@interface FLYMedicationRecordCell ()

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UILabel * statusLabel;

@property (nonatomic, strong) NSMutableArray<UILabel *> * nameLabels;
@property (nonatomic, strong) NSMutableArray<UILabel *> * numbelLabels;

@end

@implementation FLYMedicationRecordCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,3);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 12;
    self.layer.cornerRadius = 10;
    
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.statusLabel];
    
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(20);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(48);
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).offset(24);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(56, 25));
    }];
    
   
    
    for (int i = 0; i < self.nameLabels.count; i++)
    {
        UILabel * nameLabel = self.nameLabels[i];
        
        [nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if ( i == 0 )
            {
                make.top.equalTo(self.lineView.mas_bottom).offset(16);
            }
            else
            {
                UILabel * lastLabel = self.nameLabels[i-1];
                make.top.equalTo(lastLabel.mas_bottom).offset(16);
            }
            make.left.equalTo(self.contentView).with.offset(16);
            
            if ( i == self.nameLabels.count - 1 )
            {
                make.bottom.equalTo(self.contentView).offset(-18);
            }
        }];
    }
    
    for (int i = 0; i < self.numbelLabels.count; i++)
    {
        UILabel * nameLabel = self.nameLabels[i];
        UILabel * numbelLabel = self.numbelLabels[i];
        
        [numbelLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameLabel);
            make.centerX.equalTo(self.contentView);
        }];
    }
}



#pragma mark - setters and getters

-(void)setRecordModel:(FLYMedicationRecordModel *)recordModel
{
    _recordModel = recordModel;

    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@", recordModel.arrangeString, recordModel.arrangeTime];
    if ( recordModel.isMedication == 2 )
    {
        self.statusLabel.textColor = COLORHEX(@"#FFFFFF");
        self.statusLabel.backgroundColor = COLORHEX(@"#31BBA3");
        self.statusLabel.text = @"未服药";
    }
    else
    {
        self.statusLabel.textColor = COLORHEX(@"#D6DCDD");
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.text = recordModel.isMedication == 3 ? @"漏服" : @"已服药";
    }

    
    
    
    // 先移除
    for (UILabel * nameLabel in self.nameLabels)
    {
        [nameLabel removeFromSuperview];
    }
    [self.nameLabels removeAllObjects];
    
    for (UILabel * numbelLabel in self.numbelLabels)
    {
        [numbelLabel removeFromSuperview];
    }
    [self.numbelLabels removeAllObjects];
    
    // 再添加
    for (FLYDrugRecordModel * model in recordModel.content)
    {
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = FONT_R(13);
        nameLabel.textColor = COLORHEX(@"#333333");
        nameLabel.text = model.drugsName;
        [self.contentView addSubview:nameLabel];
        [self.nameLabels addObject:nameLabel];
        
        UILabel * numbelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        numbelLabel.font = FONT_R(12);
        numbelLabel.textColor = COLORHEX(@"#666666");
        numbelLabel.text = [NSString stringWithFormat:@"x%@", model.dose];
        [self.contentView addSubview:numbelLabel];
        [self.numbelLabels addObject:numbelLabel];
    }
    
    
    [self makeConstraints];
}

- (UILabel *)timeLabel
{
    if( _timeLabel == nil )
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = FONT_R(14);
        _timeLabel.textColor = COLORHEX(@"#666666");
    }
    return _timeLabel;
}

- (UIView *)lineView
{
    if( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORHEX(@"#F7F5F5");
    }
    return _lineView;
}

- (UILabel *)statusLabel
{
    if( _statusLabel == nil )
    {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = FONT_R(13);
        _statusLabel.textColor = COLORHEX(@"#FFFFFF");
        _statusLabel.backgroundColor = COLORHEX(@"#31BBA3");
        _statusLabel.layer.cornerRadius = 2;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

-(NSMutableArray<UILabel *> *)nameLabels
{
    if ( _nameLabels == nil )
    {
        _nameLabels = [NSMutableArray array];
    }
    return _nameLabels;
}

-(NSMutableArray<UILabel *> *)numbelLabels
{
    if ( _numbelLabels == nil )
    {
        _numbelLabels = [NSMutableArray array];
    }
    return _numbelLabels;
}

@end
