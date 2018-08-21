//
//  TestMsgSend.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/21.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "TestMsgSend.h"

@implementation TestMsgSend

- (void)selector0{
    NSLog(@"call no param method");
}

- (NSString *)selector0WithIntParam:(int)a{
    NSLog(@"selector0WithIntParam");
    return @"hahaha";
}

- (int)selector1WithIntParam:(int)a{
    return a;
}


- (void)selector1WithP0:(NSString *)p0 p1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3{
    NSLog(@"call instance method mul params method \n p0:%@ \n p1:%@ \n p2:%@ \n p3:%@\n",p0,p1,p2,p3);
}

+ (void)selector1WithP0:(NSString *)p0 p1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3{
    NSLog(@"call class method mul params method \n p0:%@ \n p1:%@ \n p2:%@ \n p3:%@\n",p0,p1,p2,p3);

}

@end
