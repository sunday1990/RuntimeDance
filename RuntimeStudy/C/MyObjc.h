//
//  MyObjc.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/7.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#ifndef MyObjc_h
#define MyObjc_h

#include <stdio.h>
//类是结构体
struct objc_class;
//对象也是结构体
struct objc_object;
//方法也是结构体
struct objc_selector;


//Class：指向objc_class的指针
typedef struct objc_class *Class;
//指向objc_object的指针
typedef struct objc_object *id;
//指向objc_selector的指针
typedef struct objc_selector *SEL;
//定义IMP指针,可以指向任意的函数体
typedef id _Nullable (*IMP)(id _Nonnull, SEL _Nonnull, ...);
#endif /* MyObjc_h */
