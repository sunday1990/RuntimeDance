//
//  BayMaxZombieObject.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/14.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "BayMaxZombieObject.h"
#import "BayMaxStubObject.h"

@implementation BayMaxZombieObject
- (instancetype)init {
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    BayMaxStubObject *stub = [BayMaxStubObject shareInstance];
    [stub addFunc:aSelector];
    return [[BayMaxStubObject class] instanceMethodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : DangLingPointer .",
                        [self class], NSStringFromSelector(_cmd)];
    [anInvocation invokeWithTarget:[BayMaxStubObject shareInstance]];
}

@end
