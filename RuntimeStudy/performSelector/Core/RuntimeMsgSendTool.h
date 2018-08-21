//
//  RuntimeMsgSendTool.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/21.
//  Copyright © 2018年 zhugefang. All rights reserved.
//  支持任意参数的调用

#import <Foundation/Foundation.h>

@interface NSObject (RuntimeMsgSend)
//类方法
+ (id)callSelector:(SEL)selector error:(NSError *__autoreleasing *)error,... NS_REQUIRES_NIL_TERMINATION;
//实例方法
- (id)callSelector:(SEL)selector error:(NSError *__autoreleasing *)error,... NS_REQUIRES_NIL_TERMINATION;

@end
