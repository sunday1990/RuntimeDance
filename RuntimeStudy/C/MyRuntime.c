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
    struct objc_method_list *obsolete;//指向下一个objc_method_list结构体的指针
    int method_count;
    int space;
    //可变长度的结构体
    struct objc_method method_list[1];
};

struct objc_category{
    
};

struct objc_ivar{
    
};

struct objc_ivar_list{
    
};

struct objc_cache{
    
};









