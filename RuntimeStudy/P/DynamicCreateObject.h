//
//  DynamicCreateObject.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/14.
//  Copyright © 2018年 zhugefang. All rights reserved.
//
/*
 1、动态创建一个类，继承于某个类
 2、动态的给这个类加上一些方法
 3、动态的调用这些添加的方法（objc_msgsend）
 4、改变父类的isa指针，此时外界获取父类的class时，获取的是子类的class,此时父类的方法列表不变
 5、交换方法，将class方法的实现替换掉，又返回了父类
 
 */
#import <Foundation/Foundation.h>

@interface DynamicCreateObject : NSObject

- (id)createDynamicObject;

- (void)addDynamicMethod;

- (void)callDynamicMethod;

- (void)addDynamicIvars;

- (void)changeISAToSubclass;

- (void)resetISA;

- (void)testFatherMethod;

@end
