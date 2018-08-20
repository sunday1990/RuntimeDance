//
//  HardForardInvoation.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "HardForardInvoation.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSInvocation+Category.h"

static id (*new_msgSend0)(id, SEL, ...) = (id (*)(id, SEL,...)) objc_msgSend;
static id (*new_msgSend1)(id, SEL, id,...) = (id (*)(id, SEL, id,...)) objc_msgSend;
static id (*new_msgSend2)(id, SEL, id, id,...) = (id (*)(id, SEL, id, id,...)) objc_msgSend;

@implementation HardForardInvoation

void hardforwardSelectorToInvocation(Class cls,SEL originalSelector){
    NSLog(@"%@被forward",NSStringFromSelector(originalSelector));
    //获取原有的msg_forward
    IMP forwardImp = (IMP)_objc_msgForward;
    //获取原有的Method结构体
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    //获取原有方法的实现
    IMP originalIMP = method_getImplementation(originalMethod);
    //添加一个新的selector，指向originalIMP
    NSString *selectorNewAdd = [NSString stringWithFormat:@"original_%@",NSStringFromSelector(originalSelector)];
    class_addMethod(cls, NSSelectorFromString(selectorNewAdd), originalIMP, method_getTypeEncoding(originalMethod));
    //将originalSelector指向msg_forward
    class_replaceMethod(cls, originalSelector, forwardImp, method_getTypeEncoding(originalMethod));
}

- (void)hardForwardInvocation{
    unsigned int outcount;
    Method *methodlist= class_copyMethodList([self class], &outcount);
    for (int i = 0; i<outcount; i++) {
        Method method = methodlist[i];
        if ([NSStringFromSelector(method_getName(method)) isEqualToString:@"hardForwardInvocation"]||[NSStringFromSelector(method_getName(method)) isEqualToString:@"forwardInvocation:"]) {
            continue;
        }
        hardforwardSelectorToInvocation([self class], method_getName(method));
    }
    free(methodlist);
}

- (void)testWithNoParams{
    NSLog(@"test with no params");
}

- (NSString *)returnValuetestWithNoParams{
    NSLog(@"test with return value ");
    return  @"哈哈哈";
}

- (void)testWithParam:(NSString *)p1 param2:(NSString *)p2{
    NSLog(@"test with params:%@+%@",p1,p2);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //方法一，通过invocation调用
    NSArray *args = [anInvocation getAllArguments];
    NSString *originalSelector = [NSString stringWithFormat:@"original_%@",NSStringFromSelector(anInvocation.selector)];
    //在此处调用js方法，将参数和方法传递出去,同时在此处可以统计方法的调用次数
    //将selector转为原有的selector
    anInvocation.selector = NSSelectorFromString(originalSelector);
    if (class_respondsToSelector([self class], NSSelectorFromString(originalSelector))) {
        [anInvocation invokeWithTarget:self];
    }
    return;
    //方法二，直接通过objc_msgsend函数指针调用
    if (class_respondsToSelector([self class], NSSelectorFromString(originalSelector))) {
        //调用原有的方法,可以采用msg的方式
        if (args.count == 0) {
            new_msgSend0(self,NSSelectorFromString(originalSelector));
        }else if (args.count == 1){
            new_msgSend1(self,NSSelectorFromString(originalSelector),args[0]);
        }else if (args.count == 2){
            new_msgSend2(self,NSSelectorFromString(originalSelector),args[0],args[1]);
        }
    }
}

@end
