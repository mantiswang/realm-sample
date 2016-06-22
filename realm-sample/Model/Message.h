//
//  Message.h
//  realm-sample
//
//  Created by onecat on 16/6/21.
//  Copyright © 2016年 onecat. All rights reserved.
//

#import <Realm/Realm.h>

@interface Message : RLMObject
/** 消息id */
@property (nonatomic, assign) int id;

/** 消息类型 */
@property (nonatomic, assign) int type;
/** 消息标题 */
@property (nonatomic, strong) NSString *title;
/** 消息内容 */
@property (nonatomic, strong) NSString *content;
/** 消息发布时间 */
@property (nonatomic, strong) NSString *datetime;
/** 消息发布人 */
@property (nonatomic, strong) NSString *creator;
/** 状态 (已读，未读) */
@property (nonatomic, assign) int status;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Message>
RLM_ARRAY_TYPE(Message)
