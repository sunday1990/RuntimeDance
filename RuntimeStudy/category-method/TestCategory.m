//
//  TestCategory.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "TestCategory.h"

@implementation TestCategory

- (void)testMethod{
    NSLog(@"test category method");
}

- (void)testMethod1{
    NSLog(@"test category method1");

}

- (void)testMethodwithParam:(NSString *)p1{
    NSLog(@"origin p1 is %@",p1);
}



@end
