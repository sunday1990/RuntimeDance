//
//  TestCategory.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestCategory : NSObject

- (NSString *)testMethod;
- (void)testMethod1;
- (void)testMethodwithParam:(NSString *)p1;
- (NSString *)testMethodwithParam:(NSString *)p1 param2:(NSString *)p2;


@end
