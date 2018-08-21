//
//  WeakReference.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakReference : NSObject

@property (nullable, nonatomic, weak) id target;

- (instancetype)initWithTarget:(id)target;

@end
