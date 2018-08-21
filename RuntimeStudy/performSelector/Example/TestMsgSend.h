//
//  TestMsgSend.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/21.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestMsgSend : NSObject

- (void)selector0;

- (void)selector0WithIntParam:(int)a;

- (void)selector1WithP0:(NSString *)p0 p1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3;

+ (void)selector1WithP0:(NSString *)p0 p1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3;

@end
