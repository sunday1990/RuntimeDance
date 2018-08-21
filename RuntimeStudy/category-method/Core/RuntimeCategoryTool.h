//
//  CategoryTool.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//  可以调用被分类方法覆盖掉的原始方法

#import <Foundation/Foundation.h>

@interface RuntimeCategoryTool : NSObject

+ (instancetype)sharedInstance;
//调用分类方法的时候，会越过分类，直接调用原有的方法
- (void)callOriginalSelector:(SEL)sel insteadofCategoryInClass:(Class)cls;
//调用分类方法的时候，会先调用原有的方法，类似于在category中实现super
- (void)callOriginalSelector:(SEL)sel beforeCategoryInClass:(Class)cls;
//调用分类方法之后，会再调用原有的方法
- (void)callOriginalSelector:(SEL)sel afterCategoryInClass:(Class)cls;

@end
