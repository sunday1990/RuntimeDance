//
//  TestCategory.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "TestCategory.h"

@implementation TestCategory

- (NSString *)testMethod{
    NSLog(@"origin test category method");
    return @"origin test category method";
}

- (void)testMethod1{
    NSLog(@"origin test category method1");

}

- (void)testMethodwithParam:(NSString *)p1{
    NSLog(@"origin p1 is %@",p1);
}

- (NSString *)testMethodwithParam:(NSString *)p1 param2:(NSString *)p2{
    NSLog(@"origin p1 is %@ \n p2 is %@",p1,p2);
    return @"origin p1 is  \n p2 is";
}

@end
