//
//  TestGCDAPIViewController.m
//  GCD
//
//  Created by huqinghe on 2018/1/6.
//  Copyright © 2018年 huqinghe. All rights reserved.
//

#import "TestGCDAPIViewController.h"

@interface TestGCDAPIViewController ()

@end

@implementation TestGCDAPIViewController
- (IBAction)Current_queue_label:(id)sender
{
    dispatch_queue_t queue = dispatch_queue_create("com.tiger", DISPATCH_QUEUE_CONCURRENT);
    const char * queueName =  dispatch_queue_get_label(queue);
    NSLog(@"queueName=:%s",queueName);
    

}

- (IBAction)dispatch_async_f:(id)sender
{
//    int context = 100;
//    dispatch_async_f(dispatch_get_global_queue(0, 0), &context, test);
    
    NSString* context = @"12345678";
    
    dispatch_async_f(dispatch_get_global_queue(0, 0), (__bridge void * _Nullable)(context), testTwo);
}
void test(void *context)
{
    printf("%d", *((int *) context));
}
void testTwo(void *context)
{
    NSString*name = (__bridge NSString*)context;
    NSLog(@"name=:%@",name);
    
}
/*
 *延时执行一段代码
 */
- (IBAction)dispatch_after:(id)sender
{
   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  (int64_t)3*NSEC_PER_SEC), queue, ^{
        NSLog(@"延时执行");
    });
}

/*
 * 延时执行一个函数
 */
- (IBAction)dispatch_after_f:(id)sender {
    NSString* context = @"name123456789";
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after_f(dispatch_time(DISPATCH_TIME_NOW,  (int64_t)3*NSEC_PER_SEC), queue, (__bridge  void * _Nullable) context, testTwo);
}

- (IBAction)dispatch_apply_f:(id)sender
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSString* context = @"传去的参数";
    dispatch_apply_f(10, queue, (__bridge void * _Nullable)context, calc_func);
}
void calc_func(void *data, size_t i)
{
    NSLog(@"==:%zu",i);
    NSString* name = (__bridge NSString*)data;
    NSLog(@"name=:%@",name);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"执行一次");
    });

}


- (IBAction)dispatch_get_specific:(id)sender
{
    dispatch_queue_t queueA = dispatch_queue_create("com.yiyaaixuexi.queueA", NULL);
    dispatch_queue_t queueB = dispatch_queue_create("com.yiyaaixuexi.queueB", NULL);
    dispatch_set_target_queue(queueB, queueA);
    
    static int specificKey;
    CFStringRef specificValue = CFSTR("queueA");
    dispatch_queue_set_specific(queueA,
                                &specificKey,
                                (void*)specificValue,
                                (dispatch_function_t)CFRelease);
    
    dispatch_sync(queueB, ^{
        dispatch_block_t block = ^{
            //do something
        };
        CFStringRef retrievedValue = dispatch_get_specific(&specificKey);
        if (retrievedValue) {
            block();
        } else {
            dispatch_sync(queueA, block);
        }
    });
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    static void *queueKey1 = "queueKey1";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
