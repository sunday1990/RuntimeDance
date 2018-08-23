//
//  MyRuntime.c
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/7.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#include "MyRuntime.h"
#include "MyObjc.h"

struct objc_method{
    SEL _Nonnull method_name;
    char *_Nullable method_types;
    IMP _Nonnull method_imp;
};

struct objc_method_list{
    struct objc_method_list *obsolete;
    int method_count;
    int space;
    //可变长度的结构体数组
    struct objc_method method_list[1];
};


struct objc_category{
    char *category_name                           ; // 类别名称
    char *class_name                              ; // 类名
    struct objc_method_list *instance_methods     ; // 实例方法列表
    struct objc_method_list *class_methods        ; // 类方法列表
    struct objc_protocol_list *protocols;
};


struct objc_ivar{
    char *ivar_name;   // 变量名
    char *ivar_type;   // 变量类型
    int ivar_offset;   // 基地址偏移字节
};

struct objc_ivar_list{
    int ivar_count;
    /* 可变长结构体 */
    struct objc_ivar ivar_list[1];
};

struct objc_cache{
    unsigned int mask        ;
    unsigned int occupied    ;
    Method buckets[1]        ;
};

struct objc_protocol_list {
    struct objc_protocol_list *next;
    long count;
    Protocol * _Nullable list[1];
};

//
struct objc_protocol{
    Protocol *super;
    char *protocol_name                          ; //协议名称
    struct objc_method_list *instance_methods     ; // 实例方法列表
    struct objc_method_list *class_methods        ; // 类方法列表
    
};









