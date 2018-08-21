//
//  TestCategory+Ext.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "TestCategory+Ext.h"

@implementation TestCategory (Ext)

- (NSString *)testMethod{
    //如何在分类中，调用原有类的方法
    NSLog(@"category test category method");
    return @"category test category method";
}

- (void)testMethodwithParam:(NSString *)p1{
    NSLog(@"category p1 is %@",p1);
}

- (NSString *)testMethodwithParam:(NSString *)p1 param2:(NSString *)p2{
    NSLog(@"category p1 is %@ \n p2 is %@",p1,p2);
    return @"category p1 is  \n p2 is ";
}


@end
