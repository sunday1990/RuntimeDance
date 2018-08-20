//
//  MyObjc.c
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/7.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#include "MyObjc.h"

struct objc_class{
  
};

struct objc_object{
    Class isa;
};

struct objc_selector{
    void *sel_id;
    const char *sel_types;
};
