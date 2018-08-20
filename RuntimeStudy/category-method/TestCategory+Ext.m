//
//  TestCategory+Ext.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "TestCategory+Ext.h"

@implementation TestCategory (Ext)

- (void)testMethod{
    //如何在分类中，调用原有类的方法
    NSLog(@"category test category method");
}

- (void)testMethodwithParam:(NSString *)p1{
    NSLog(@"category p1 is %@",p1);
}

@end
