//
//  TestCategory+Ext.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "TestCategory.h"

@interface TestCategory (Ext)
- (NSString *)testMethod;
- (void)testMethodwithParam:(NSString *)p1;
- (NSString *)testMethodwithParam:(NSString *)p1 param2:(NSString *)p2;
@end
