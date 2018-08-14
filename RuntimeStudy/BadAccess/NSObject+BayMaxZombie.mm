//
//  NSObject+BayMaxZombie.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/14.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "NSObject+BayMaxZombie.h"
#import <objc/runtime.h>
#import <list>
#import "BayMaxZombieObject.h"

static NSInteger const threshold = 100;
static std::list<id> undellocedList;

@implementation NSObject (BayMaxZombie)
- (void)bayMaxZombieDealloc{
    Class selfClazz = [self class];
    bool needProtected;
    //判断class是否需要被保护
    needProtected = YES;
    if (needProtected) {
        //释放该类的引用
        objc_destructInstance(self);
        //将该实例的isa指向BayMaxZombieObject
        object_setClass(self, [BayMaxZombieObject class]);
        undellocedList.size();
        if (undellocedList.size() >= threshold) {
            id object = undellocedList.front();
            undellocedList.pop_front();
            free(object);
        }
        undellocedList.push_back(self);
    }else{//不需要保护，调用原来的方法即可
        [self bayMaxZombieDealloc];
    }
}

@end
