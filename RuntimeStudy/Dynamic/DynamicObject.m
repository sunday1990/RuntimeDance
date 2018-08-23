//
//  DynamicCreateObject.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/14.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "DynamicObject.h"
#import <objc/runtime.h>
#import <objc/message.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation DynamicObject

void dynamicMethod(id target,SEL selector){
    NSLog(@"动态添加的方法被调用了");
}

Class dynamicOriginalClass(id target,SEL selector){
    return [DynamicObject class];
}

static void addMethodToProtocol(Protocol* protocol, NSString *selectorName, NSString *typeencoding, BOOL isInstance){
    SEL sel = NSSelectorFromString(selectorName);
    const char* type = [typeencoding UTF8String];
    protocol_addMethodDescription(protocol, sel, type, YES, isInstance);
}

- (id)createDynamicObject{
    //动态创建DynamicCreateObject的子类，并调用一个方法
    Class Myclass = objc_allocateClassPair([DynamicObject class], "DynamicTestObject", 0);
    class_addMethod(Myclass, @selector(testmyClassMethod), (IMP)dynamicMethod, "v@:");
    objc_registerClassPair(Myclass);
    //动态创建一个子类的对象,并进行绑定
    id instance = class_createInstance(Myclass, 0);
    objc_setAssociatedObject(self, "DynamicSubclass", instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSLog(@"动态创建了一个子类和子类对象");
    return instance;
}

- (void)addDynamicMethod{
    Class Myclass = objc_getClass("DynamicTestObject");
    class_addMethod(Myclass, @selector(testmyClassMethod), (IMP)dynamicMethod, "v@:");
    NSLog(@"动态的给类添加了一个方法");
}

- (void)callDynamicMethod{
    id instance = objc_getAssociatedObject(self, "DynamicSubclass");
    ( (void(*)(id,SEL))objc_msgSend )(instance,@selector(testmyClassMethod));    
}

- (void)addDynamicIvars{
    //    运行时规定,只能在objc_allocateClassPair与objc_registerClassPair两个函数之间为类添加变量
    Class People = objc_allocateClassPair([NSObject class], "DynamicPeople", 0);
    BOOL flag1 = class_addIvar(People, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    if (flag1) {
        NSLog(@"给动态创建的类添加了一个NSString类型的成员变量");
    }
    
    BOOL flag2 = class_addIvar(People, "_age", sizeof(int), sizeof(int), @encode(int));
    if (flag2) {
        NSLog(@"给动态创建的类添加了一个int类型的成员变量");
    }
    objc_registerClassPair(People);
}

- (void)changeISAToSubclass{
    Class Myclass = objc_getClass("DynamicTestObject");
    object_setClass(self, Myclass);
    NSLog(@"改变了父类的isa，使其指向了子类");
    NSLog(@"此时的父类class为：%@",NSStringFromClass([self class]));
}

- (void)resetISA{
    Class Myclass = objc_getClass("DynamicTestObject");
    IMP originalIMP = class_replaceMethod(Myclass, @selector(class), (IMP)dynamicOriginalClass, "@@:");
    if (originalIMP) {
        //添加上原来的方法
        class_addMethod(Myclass, NSSelectorFromString(@"originalClass"), originalIMP, "@@:");
    }
    NSLog(@"交换了子类的class方法");
    NSLog(@"此时的父类class为：%@",NSStringFromClass([self class]));
}

- (void)testFatherMethod{
    NSLog(@"父类方法被调用");
}

//创建协议
- (void)testCreateProtocol{
    //动态创建协议
    NSString *testcreateProtocol = @"TestCreateProtocol";
    const char *protocolName = [testcreateProtocol UTF8String];
    Protocol *newprotocol = objc_allocateProtocol(protocolName);
    if (newprotocol) {
        addMethodToProtocol(newprotocol, @"helloprotocol:", @"v@:@", YES);
        addMethodToProtocol(newprotocol, @"hahaprotocol", @"v@:", YES);
        objc_registerProtocol(newprotocol);
    }
    //动态添加协议
    BOOL success = class_addProtocol([self class], newprotocol);
    if (success) {
        NSLog(@"protocol 添加成功");
        unsigned int outcount;
        Protocol * __unsafe_unretained * protocols = class_copyProtocolList([self class], &outcount);
        for (int i = 0; i < outcount; i++) {
            Protocol *protocol = protocols[i];
            NSLog(@"protocol name: %s", protocol_getName(protocol));
        }
    }else{
        NSLog(@"protocol 添加失败");
    }
}

- (NSArray *)findAllOf:(Class)defaultClass {
    int count = objc_getClassList(NULL, 0);
    if (count <= 0) {
        @throw@"Couldn't retrieve Obj-C class-list";
        return @[defaultClass];
    }
    NSMutableArray *output = @[].mutableCopy;
    Class *classes = (Class *) malloc(sizeof(Class) * count);
    objc_getClassList(classes, count);
    for (int i = 0; i < count; ++i) {
        if (defaultClass == class_getSuperclass(classes[i])){//子类
            [output addObject:classes[i]];
        }
    }
    free(classes);
    return output.copy;
}

@end

#pragma clang diagnostic pop
