//
//  ViewController.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/7.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "DynamicObject.h"
#import "Father.h"
#import "Son.h"


#import "HardForardInvoation.h"

#import "WeakReference.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self demo0];
    [self demo1];
    [self demo2];
    [self demo3];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)demo0{
    typedef void (*MYIMP)(id target,SEL sel);
#define CALL_METHOD(instance,selector)\
((MYIMP)objc_msgSend)(instance,selector);
    DynamicObject *object = [DynamicObject new];
    CALL_METHOD(object, @selector(createDynamicObject));
    CALL_METHOD(object, @selector(addDynamicMethod));
    CALL_METHOD(object, @selector(callDynamicMethod));
    CALL_METHOD(object, @selector(changeISAToSubclass));
    CALL_METHOD(object, @selector(resetISA));
    CALL_METHOD(object, @selector(testFatherMethod));
}

- (void)demo1{
    BOOL override = false;
    override = class_getMethodImplementation([Son class], @selector(method0)) != class_getMethodImplementation([Father class], @selector(method0));
    if (override) {
        NSLog(@"重写了");
    }else{
        NSLog(@"没有重写");
    }
}

- (void)demo2{
    HardForardInvoation *hardInvocation = [HardForardInvoation new];
    [hardInvocation hardForwardInvocation];
    [hardInvocation testWithNoParams];
    [hardInvocation testWithParam:@"A" param2:@"B"];
    NSString *returnvalue  = [hardInvocation returnValuetestWithNoParams];
    NSLog(@"return value :%@",returnvalue);
}

- (void)demo3{
    Father *father = [[Father alloc]init];
    WeakReference *weakRef = [[WeakReference alloc]initWithTarget:father];
    [weakRef performSelector:NSSelectorFromString(@"method0")];
    father = nil;
    [weakRef performSelector:NSSelectorFromString(@"method0")];
}

@end
