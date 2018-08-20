//
//  HardForardInvoation.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HardForardInvoation : NSObject

- (void)testWithNoParams;

- (NSString *)returnValuetestWithNoParams;

- (void)testWithParam:(NSString *)p1 param2:(NSString *)p2;

- (void)hardForwardInvocation;

@end
