//
//  MyObjc.c
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/7.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#include "MyObjc.h"
#include "MyRuntime.h"

struct objc_class{
    Class isa;//等价于struct objc_class *isa;
    Class super_class;//等价于struct objc_class *super_class;
    const char *name;//类名如 "UIView"
    long instance_size;//实例变量的大小
    struct objc_ivar_list *ivars;//该类的成员变量链表
    struct objc_method_list **methodLists;//该方法定义链表
    struct objc_cache *cache;//方法缓存
    struct objc_protocol_list *protocols;//协议链表
};

struct objc_object{
    Class isa;
};

struct objc_selector{
    char *name;//名称
    char *types;//类型
};
