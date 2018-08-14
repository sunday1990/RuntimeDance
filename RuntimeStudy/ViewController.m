//
//  ViewController.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/7.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "ViewController.h"
#import "DynamicCreateObject.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self create];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)create{
#define CALL_METHOD(instance,selector)\
    ((void(*)(id,SEL))objc_msgSend)(instance,selector);
    DynamicCreateObject *fatherObject = [DynamicCreateObject new];
    CALL_METHOD(fatherObject, @selector(createDynamicObject));
    CALL_METHOD(fatherObject, @selector(addDynamicMethod));
    CALL_METHOD(fatherObject, @selector(callDynamicMethod));
    CALL_METHOD(fatherObject, @selector(changeISAToSubclass));
    CALL_METHOD(fatherObject, @selector(resetISA));
    CALL_METHOD(fatherObject, @selector(testFatherMethod));
}
@end
