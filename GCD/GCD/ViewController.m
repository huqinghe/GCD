//
//  ViewController.m
//  GCD
//
//  Created by huqinghe on 2018/1/5.
//  Copyright © 2018年 huqinghe. All rights reserved.
//

#import "ViewController.h"
#import "TestGCDAPIViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)addTaskToQueue:(id)sender
{
    NSLog(@"DISPATCH_QUEUE_CONCURRENT  DISPATCH_QUEUE_SEARAL");
    dispatch_queue_t queue = dispatch_queue_create("com.love.xi", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"11111");
        sleep(3);
        NSLog(@"22222");
        dispatch_sync(queue, ^{
            NSLog(@"===queue是线程安全的==");
        });
    });
    dispatch_async(queue, ^{
        NSLog(@"333");
        sleep(2);
        NSLog(@"4444");
    });
    dispatch_sync( queue, ^{
        NSLog(@"5555555");
        sleep(1);
        NSLog(@"6666666");
    });
    NSLog(@"同步队列时最后执行 异步队列时不确定");
}


- (IBAction)attr_t:(id)sender
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t firstQueue = dispatch_queue_create("com.starming.gcddemo.firstqueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t secondQueue = dispatch_queue_create("com.starming.gcddemo.secondqueue", DISPATCH_QUEUE_CONCURRENT);

    dispatch_set_target_queue(firstQueue, serialQueue);
    dispatch_set_target_queue(secondQueue, serialQueue);

    dispatch_async(firstQueue, ^{
        NSLog(@"1");
        [NSThread sleepForTimeInterval:3.f];
    });
    dispatch_async(secondQueue, ^{
        NSLog(@"2");
        [NSThread sleepForTimeInterval:2.f];
    });
    dispatch_async(secondQueue, ^{
        NSLog(@"3");
        [NSThread sleepForTimeInterval:1.f];
    });
//    dispatch_sync(serialQueue, ^{
//        sleep(7);
//    });
    
}

- (IBAction)barry:(id)sender {
    dispatch_queue_t dataQueue = dispatch_queue_create("com.starming.gcddemo.dataqueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(dataQueue, ^{
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"read data 1");
    });
    dispatch_async(dataQueue, ^{
        NSLog(@"read data 2");
    });
    //等待前面的都完成，在执行barrier后面的
    dispatch_barrier_async(dataQueue, ^{
        NSLog(@"write data 1");
        [NSThread sleepForTimeInterval:1];
    });
    dispatch_async(dataQueue, ^{
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"read data 3");
    });
    dispatch_async(dataQueue, ^{
        NSLog(@"read data 4");
    });
}


- (IBAction)apple:(id)sender
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.starming.gcddemo.concurrentqueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply(10, concurrentQueue, ^(size_t i) {
        NSLog(@"%zu",i);
    });
    NSLog(@"The end");//这里有个需要注意的是，dispatch_apply这个是会阻塞主线程的。这个log打印会在dispatch_apply都结束后才开始执行
}


#pragma mark 下面是group相关

- (IBAction)gruopWait:(id)sender
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.starming.gcddemo.concurrentqueue",DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    //在group中添加队列的block
    dispatch_group_async(group, concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"1");
    });
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"2");
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"go on");
}



- (IBAction)blockNotify:(id)sender
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_block_t firstBlock = dispatch_block_create(0, ^{
        NSLog(@"first block start");
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"first block end");
    });
    dispatch_async(serialQueue, firstBlock);
    dispatch_block_t secondBlock = dispatch_block_create(0, ^{
        NSLog(@"second block run");
    });
    //first block执行完才在serial queue中执行second block
    dispatch_block_notify(firstBlock, serialQueue, secondBlock);
}



- (IBAction)cancelQueue:(id)sender
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t firstBlock = dispatch_block_create(0, ^{
        NSLog(@"first block start");
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"first block end");
    });
    dispatch_block_t secondBlock = dispatch_block_create(0, ^{
        NSLog(@"second block run");
    });
    dispatch_async(serialQueue, firstBlock);
    dispatch_async(serialQueue, secondBlock);
    //取消secondBlock
    dispatch_block_cancel(secondBlock);
}


- (IBAction)testAPIVC:(id)sender
{
    [self presentViewController:[[TestGCDAPIViewController alloc] init] animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
