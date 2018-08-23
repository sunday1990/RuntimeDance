//
//  MyRuntime.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/7.
//  Copyright © 2018年 zhugefang. All rights reserved.
//  https://developer.apple.com/documentation/objectivec/objective_c_runtime?language=objc

#ifndef MyRuntime_h
#define MyRuntime_h

#include <stdio.h>

#pragma mark 定义结构体
//method结构体
struct objc_method;
//method list结构体
struct objc_method_list;

//category结构体
struct objc_category;

//ivar结构体
struct objc_ivar;
//成员变量列表结构体
struct objc_ivar_list;

struct objc_property;

//cache
struct objc_cache;

//协议链表
struct objc_protocol_list;
struct objc_protocol;

#pragma mark 定义结构体指针
typedef struct objc_method *Method;
typedef struct objc_category *Category;
typedef struct objc_ivar *Ivar;
typedef struct objc_cache *cache;
typedef struct objc_protocol *Protocol;

#endif /* MyRuntime_h */
