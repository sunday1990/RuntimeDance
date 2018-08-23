//
//  TestProtocol.h
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/22.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestProtocol <NSObject>

@property (nonatomic ,copy) NSString *name;

@property (nonatomic ,copy) NSString *age;

- (void)methodProtocol;

@end
