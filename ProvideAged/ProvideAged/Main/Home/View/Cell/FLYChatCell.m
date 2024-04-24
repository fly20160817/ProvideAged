//
//  FLYChatCell.m
//  ProvideAged
//
//  Created by fly on 2021/11/17.
//

#import "FLYChatCell.h"
#import "FLYLabel.h"
#import "FLYTools.h"

@interface FLYChatCell ()

@property (nonatomic, strong) FLYLabel * timeLabel;
@property (nonatomic, strong) FLYLabel * contentLabel;
@property (nonatomic, strong) FLYLabel * statusLabel;

@end

@implementation FLYChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ( self )
    {
        [self initUI];
    }
    
    return self;
}



#pragma mark - UI

- (void)initUI
{
    self.contentView.backgroundColor = COLORHEX(@"#F9F9F9");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.statusLabel];
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(23);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(136, 20));
    }];
    
    
    CGFloat height = [FLYTools heightForText:self.contentLabel.text font:self.contentLabel.font width:SCREEN_WIDTH - 64 - (self.contentLabel.textEdgeInset.left + self.contentLabel.textEdgeInset.right)];
    CGFloat width = [FLYTools widthForText:self.contentLabel.text font:self.contentLabel.font height:height];
        
    height = height + self.contentLabel.textEdgeInset.top + self.contentLabel.textEdgeInset.bottom;
    width = width + self.contentLabel.textEdgeInset.left + self.contentLabel.textEdgeInset.right;
    if ( width > SCREEN_WIDTH - 64 )
    {
        width = SCREEN_WIDTH - 64;
    }
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView);
    }];
}



#pragma mark - setters and getters

-(void)setChatRecordModel:(FLYChatRecordModel *)chatRecordModel
{
    _chatRecordModel = chatRecordModel;
    
    self.timeLabel.text = chatRecordModel.createTime;
    self.contentLabel.text = chatRecordModel.information;
    self.statusLabel.text = chatRecordModel.isRead == 1 ? @"已读" : @"未读";
    self.statusLabel.textColor = COLORHEX(chatRecordModel.isRead == 1 ? @"#BFBFBF" : @"#2BB9A0");
    
    [self makeConstraints];
}

-(FLYLabel *)timeLabel
{
    if( _timeLabel == nil )
    {
        _timeLabel = [[FLYLabel alloc] init];
        _timeLabel.textColor = COLORHEX(@"#BFBFBF");
        _timeLabel.font = FONT_R(12);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.03];
        _timeLabel.layer.cornerRadius = 10;
        _timeLabel.layer.masksToBounds = YES;
    }
    return _timeLabel;
}

-(FLYLabel *)contentLabel
{
    if( _contentLabel == nil )
    {
        _contentLabel = [[FLYLabel alloc] init];
        _contentLabel.textColor = COLORHEX(@"#FFFFFF");
        _contentLabel.font = FONT_R(15);
        _contentLabel.backgroundColor = COLORHEX(@"#2BB9A0");
        _contentLabel.layer.cornerRadius = 10;
        _contentLabel.textEdgeInset = UIEdgeInsetsMake(15, 20, 15, 20);
        _contentLabel.layer.masksToBounds = YES;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

-(FLYLabel *)statusLabel
{
    if ( _statusLabel == nil )
    {
        _statusLabel = [[FLYLabel alloc] init];
        _statusLabel.textColor = COLORHEX(@"#2BB9A0");
        _statusLabel.font = FONT_R(14);
    }
    return _statusLabel;
}

@end
