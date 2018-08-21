//
//  RuntimeMsgSendTool.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/21.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "RuntimeMsgSendTool.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

static NSString *extractStructName(NSString *typeEncodeString)
{
    NSArray *array = [typeEncodeString componentsSeparatedByString:@"="];
    NSString *typeString = array[0];
    int firstValidIndex = 0;
    for (int i = 0; i< typeString.length; i++) {
        char c = [typeString characterAtIndex:i];
        if (c == '{' || c=='_') {
            firstValidIndex++;
        }else {
            break;
        }
    }
    return [typeString substringFromIndex:firstValidIndex];
}

@implementation NSObject (RuntimeMsgSend)
//类方法
+ (id)callSelector:(SEL)selector error:(NSError *__autoreleasing *)error,... NS_REQUIRES_NIL_TERMINATION{
    NSMethodSignature *sig =  [self methodSignatureForSelector:selector];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:selector];
    va_list args;
    va_start(args,error);
    [NSObject setInv:inv withSig:sig andArgs:args];
    va_end(args);
    [inv invoke];
    id returnValue = [self returnValueOfInv:inv sig:sig selector:selector];
    return returnValue;
}

//实例方法
- (id)callSelector:(SEL)selector error:(NSError *__autoreleasing *)error,... NS_REQUIRES_NIL_TERMINATION{
    NSMethodSignature *sig =  [self methodSignatureForSelector:selector];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:selector];
    va_list args;
    va_start(args,error);
    [NSObject setInv:inv withSig:sig andArgs:args];
    va_end(args);
    [inv invoke];
    id returnValue = [[self class] returnValueOfInv:inv sig:sig selector:selector];
    return returnValue;
}

+ (id)returnValueOfInv:(NSInvocation *)invocation sig:(NSMethodSignature *)sig selector:(SEL)selector{
    NSString *selectorName = NSStringFromSelector(selector);
    char returnType[255];
    strcpy(returnType, [sig methodReturnType]);
    id returnValue = nil;
    if (strncmp(returnType, "v", 1) != 0) {
        if (strncmp(returnType, "@", 1) == 0) {
            void *result;
            [invocation getReturnValue:&result];
            if ([selectorName isEqualToString:@"alloc"] || [selectorName isEqualToString:@"new"] ||
                [selectorName isEqualToString:@"copy"] || [selectorName isEqualToString:@"mutableCopy"]) {
                returnValue = (__bridge_transfer id)result;
            } else {
                returnValue = (__bridge id)result;
            }
            return returnValue;
        } else {
            switch (returnType[0] == 'r' ? returnType[1] : returnType[0]) {
        #define CALL_RET_CASE(_typeString, _type) \
        case _typeString: {                              \
            _type tempResultSet; \
            [invocation getReturnValue:&tempResultSet];\
            returnValue = @(tempResultSet); \
            break; \
        }
                    CALL_RET_CASE('c', char)
                    CALL_RET_CASE('C', unsigned char)
                    CALL_RET_CASE('s', short)
                    CALL_RET_CASE('S', unsigned short)
                    CALL_RET_CASE('i', int)
                    CALL_RET_CASE('I', unsigned int)
                    CALL_RET_CASE('l', long)
                    CALL_RET_CASE('L', unsigned long)
                    CALL_RET_CASE('q', long long)
                    CALL_RET_CASE('Q', unsigned long long)
                    CALL_RET_CASE('f', float)
                    CALL_RET_CASE('d', double)
                    CALL_RET_CASE('B', BOOL)
                case '{': {
                    NSString *typeString = extractStructName([NSString stringWithUTF8String:returnType]);
        #define CALL_RET_STRUCT(_type) \
        if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
            _type result;   \
            [invocation getReturnValue:&result];    \
            NSValue * returnValue = [NSValue valueWithBytes:&(result) objCType:@encode(_type)];\
            return returnValue;\
        }
                    CALL_RET_STRUCT(CGRect)
                    CALL_RET_STRUCT(CGPoint)
                    CALL_RET_STRUCT(CGSize)
                    CALL_RET_STRUCT(NSRange)
                    CALL_RET_STRUCT(CGAffineTransform)
                    CALL_RET_STRUCT(UIEdgeInsets)
                    CALL_RET_STRUCT(UIOffset)
                    CALL_RET_STRUCT(CGVector)
                    break;
                }
                case '*':
                case '^': {//函数指针
                    break;
                }
                case '#': {
                    break;
                }
            }
            return returnValue;
        }
    }
    return returnValue;
}

/**
 来源于YYKit，用于根据方法签名和可变参数列表初始化invocation
 */
+ (void)setInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig andArgs:(va_list)args {
    NSUInteger count = [sig numberOfArguments];
    for (int index = 2; index < count; index++) {
        char *type = (char *)[sig getArgumentTypeAtIndex:index];
        while (*type == 'r' || // const
               *type == 'n' || // in
               *type == 'N' || // inout
               *type == 'o' || // out
               *type == 'O' || // bycopy
               *type == 'R' || // byref
               *type == 'V') { // oneway
            type++; // cutoff useless prefix
        }
        BOOL unsupportedType = NO;
        switch (*type) {
            case 'v': // 1: void
            case 'B': // 1: bool
            case 'c': // 1: char / BOOL
            case 'C': // 1: unsigned char
            case 's': // 2: short
            case 'S': // 2: unsigned short
            case 'i': // 4: int / NSInteger(32bit)
            case 'I': // 4: unsigned int / NSUInteger(32bit)
            case 'l': // 4: long(32bit)
            case 'L': // 4: unsigned long(32bit)
            { // 'char' and 'short' will be promoted to 'int'.
                int arg = va_arg(args, int);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
            case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
            {
                long long arg = va_arg(args, long long);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'f': // 4: float / CGFloat(32bit)
            { // 'float' will be promoted to 'double'.
                double arg = va_arg(args, double);
                float argf = arg;
                [inv setArgument:&argf atIndex:index];
            } break;
                
            case 'd': // 8: double / CGFloat(64bit)
            {
                double arg = va_arg(args, double);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'D': // 16: long double
            {
                long double arg = va_arg(args, long double);
                [inv setArgument:&arg atIndex:index];
                
            } break;
                
            case '*': // char *
            case '^': // pointer
            {
                void *arg = va_arg(args, void *);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case ':': // SEL
            {
                SEL arg = va_arg(args, SEL);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '#': // Class
            {
                Class arg = va_arg(args, Class);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '@': // id
            {
                id arg = va_arg(args, id);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '{': // struct
            {
                if (strcmp(type, @encode(CGPoint)) == 0) {
                    CGPoint arg = va_arg(args, CGPoint);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGSize)) == 0) {
                    CGSize arg = va_arg(args, CGSize);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGRect)) == 0) {
                    CGRect arg = va_arg(args, CGRect);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGVector)) == 0) {
                    CGVector arg = va_arg(args, CGVector);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
                    CGAffineTransform arg = va_arg(args, CGAffineTransform);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CATransform3D)) == 0) {
                    CATransform3D arg = va_arg(args, CATransform3D);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(NSRange)) == 0) {
                    NSRange arg = va_arg(args, NSRange);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIOffset)) == 0) {
                    UIOffset arg = va_arg(args, UIOffset);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
                    UIEdgeInsets arg = va_arg(args, UIEdgeInsets);
                    [inv setArgument:&arg atIndex:index];
                } else {
                    unsupportedType = YES;
                }
            } break;
                
            case '(': // union
            {
                unsupportedType = YES;
            } break;
                
            case '[': // array
            {
                unsupportedType = YES;
            } break;
                
            default: // what?!
            {
                unsupportedType = YES;
            } break;
        }
        
        if (unsupportedType) {
            // Try with some dummy type...
            
            NSUInteger size = 0;
            NSGetSizeAndAlignment(type, &size, NULL);
            
#define case_size(_size_) \
else if (size <= 4 * _size_ ) { \
struct dummy { char tmp[4 * _size_]; }; \
struct dummy arg = va_arg(args, struct dummy); \
[inv setArgument:&arg atIndex:index]; \
}
            if (size == 0) { }
            case_size( 1) case_size( 2) case_size( 3) case_size( 4)
            case_size( 5) case_size( 6) case_size( 7) case_size( 8)
            case_size( 9) case_size(10) case_size(11) case_size(12)
            case_size(13) case_size(14) case_size(15) case_size(16)
            case_size(17) case_size(18) case_size(19) case_size(20)
            case_size(21) case_size(22) case_size(23) case_size(24)
            case_size(25) case_size(26) case_size(27) case_size(28)
            case_size(29) case_size(30) case_size(31) case_size(32)
            case_size(33) case_size(34) case_size(35) case_size(36)
            case_size(37) case_size(38) case_size(39) case_size(40)
            case_size(41) case_size(42) case_size(43) case_size(44)
            case_size(45) case_size(46) case_size(47) case_size(48)
            case_size(49) case_size(50) case_size(51) case_size(52)
            case_size(53) case_size(54) case_size(55) case_size(56)
            case_size(57) case_size(58) case_size(59) case_size(60)
            case_size(61) case_size(62) case_size(63) case_size(64)
            else {
                /*
                 Larger than 256 byte?! I don't want to deal with this stuff up...
                 Ignore this argument.
                 */
                struct dummy {char tmp;};
                for (int i = 0; i < size; i++) va_arg(args, struct dummy);
                NSLog(@"YYKit performSelectorWithArgs unsupported type:%s (%lu bytes)",
                      [sig getArgumentTypeAtIndex:index],(unsigned long)size);
            }
#undef case_size
            
        }
    }
}
@end

@implementation RuntimeMsgSendTool

@end
