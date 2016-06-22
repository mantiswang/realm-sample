//
//  MessageCell.h
//  realm-sample
//
//  Created by onecat on 16/6/21.
//  Copyright © 2016年 onecat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;

@interface MessageCell : UITableViewCell

@property (nonatomic, strong)Message *entity;

@end
