//
//  WeakReferenceViewController.m
//  RuntimeStudy
//
//  Created by zhugefang on 2018/8/20.
//  Copyright © 2018年 zhugefang. All rights reserved.
//

#import "WeakReferenceViewController.h"
#import "WeakReference.h"
#import "Father.h"

@interface WeakReferenceViewController ()

@property (nonatomic, strong) WeakReference *weakRef;
@property (nonatomic, copy) dispatch_block_t block;
@end

@implementation WeakReferenceViewController
{
    Father *father;
}
#pragma mark ===== Life Cycle =====

- (void)viewDidLoad {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:3];
        self.block();
    });
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    //father的生命周期在此函数中，之后会被释放
    father = [[Father alloc]init];
    _weakRef = [[WeakReference alloc]initWithTarget:father];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:_weakRef selector:NSSelectorFromString(@"method0") userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc{
    NSLog(@"dealloc WeakReferenceViewController");
}

#pragma mark ===== NetWork =====




#pragma mark ===== System Delegate =====





#pragma mark ===== Custom Delagate =====





#pragma mark ===== KVO && Notifications =====




#pragma mark ===== Event Response =====
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark ===== Update =====




#pragma mark ===== PrivateMethods =====
- (void)initViewModels{
    
}

- (void)initViews{
    
}

- (void)initLayout{
    
}

#pragma mark ===== Getters && Setters =====



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
