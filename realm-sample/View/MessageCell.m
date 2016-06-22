//
//  MessageCell.m
//  realm-sample
//
//  Created by onecat on 16/6/21.
//  Copyright © 2016年 onecat. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"

@interface MessageCell()
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 内容 */
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
/** 日期 */
@property (nonatomic, weak) IBOutlet UILabel *datetimeLabel;
/** 发布人 */
@property (nonatomic, weak) IBOutlet UILabel *creatorLabel;
@end

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEntity:(Message *)entity
{
    _entity = entity;
    
    self.titleLabel.text = entity.title;
    self.contentLabel.text = entity.content;
    self.creatorLabel.text = entity.creator;
    self.datetimeLabel.text = entity.datetime ;
}

@end
