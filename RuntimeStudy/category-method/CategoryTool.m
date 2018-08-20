//
//  CategoryTool.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "CategoryTool.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSInvocation+Category.h"

@implementation CategoryTool

static inline void hardforwardSelectorToInvocation(Class cls,SEL originalSelector){
    NSLog(@"%@被forward",NSStringFromSelector(originalSelector));
    //获取原有的msg_forward
    IMP toolForwardImp = class_getMethodImplementation([CategoryTool class], @selector(forwardInvocation:));
    IMP forwardIMP = (IMP)_objc_msgForward;
    const char *types = method_getTypeEncoding(class_getInstanceMethod([NSObject class], @selector(forwardInvocation:)));
    //将originalSelector指向msg_forward，强行启动消息转发
    if (!class_respondsToSelector(cls, @selector(forwardInvocation:))) {
        class_addMethod(cls, @selector(forwardInvocation:), forwardIMP, types);
        class_replaceMethod(cls, @selector(forwardInvocation:), toolForwardImp, types);
    }else{
        class_replaceMethod(cls, @selector(forwardInvocation:), toolForwardImp, types);
    }
    //获取原有的Method结构体
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    //获取原有方法的实现
    IMP originalIMP = method_getImplementation(originalMethod);
    //添加一个新的selector，指向originalIMP
    NSString *selectorNewAdd = [NSString stringWithFormat:@"category_%@",NSStringFromSelector(originalSelector)];
    class_addMethod(cls, NSSelectorFromString(selectorNewAdd), originalIMP, method_getTypeEncoding(originalMethod));
    class_replaceMethod(cls, originalSelector, forwardIMP, types);
}

- (void)callOriginalSelWithClass:(Class)cls selector:(SEL)sel{
    hardforwardSelectorToInvocation(cls, sel);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    NSArray *args = [anInvocation getAllArguments];
    //获取方法名，和方法参数
    unsigned int count;
    //需要获取到一个类名
    Method *methodList = class_copyMethodList([NSClassFromString(@"TestCategory") class], &count);
    for (int i = count-1; i>0; i--) {
        Method method = methodList[i];
        if ([NSStringFromSelector(method_getName(method)) isEqualToString:NSStringFromSelector(anInvocation.selector)]) {
            if (args.count == 0) {
                ((void(*)(id,SEL))method_getImplementation(method))(self,method_getName(method));
            }else if (args.count == 1){
                ((void(*)(id,SEL,id))method_getImplementation(method))(self,method_getName(method),args[0]);
            }else if (args.count == 2){
                ((void(*)(id,SEL,id,id))method_getImplementation(method))(self,method_getName(method),args[0],args[1]);
            }else if (args.count == 3){
                ((void(*)(id,SEL,id,id,id))method_getImplementation(method))(self,method_getName(method),args[0],args[1],args[2]);
            }else if (args.count == 4){
                ((void(*)(id,SEL,id,id,id,id))method_getImplementation(method))(self,method_getName(method),args[0],args[1],args[2],args[3]);
            }else if (args.count == 5){
                ((void(*)(id,SEL,id,id,id,id,id))method_getImplementation(method))(self,method_getName(method),args[0],args[1],args[2],args[3],args[4]);
            }
            break;
        }
    }

}

@end
