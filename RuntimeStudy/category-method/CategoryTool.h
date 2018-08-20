//
//  CategoryTool.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//  可以调用被分类方法覆盖掉的原始方法

#import <Foundation/Foundation.h>

@interface CategoryTool : NSObject

- (void)callOriginalSelWithClass:(Class)cls selector:(SEL)sel;

@end
