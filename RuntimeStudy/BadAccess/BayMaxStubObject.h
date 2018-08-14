//
//  BayMaxStubObject.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/14.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BayMaxStubObject : NSObject
- (instancetype)init __unavailable;

+ (BayMaxStubObject *)shareInstance;

- (BOOL)addFunc:(SEL)sel;

+ (BOOL)addClassFunc:(SEL)sel;

@end
