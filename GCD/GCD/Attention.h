//
//  Attention.h
//  GCD
//
//  Created by huqinghe on 2018/1/5.
//  Copyright © 2018年 huqinghe. All rights reserved.
//

1  队列的创建
    dispatch_queue_t queue;
    queue = dispatch_queue_create("com.example.MyQueue", NULL); // OS X 10.7 和 iOS 4.3 之前
    queue = dispatch_queue_create("com.example.MyQueue",  DISPATCH_QUEUE_SERIAL 串行 DISPATCH_QUEUE_CONCURRENT 并行); // 之后
2 系统队列
    /*
     DISPATCH_QUEUE_PRIORITY_HIGH，
     DISPATCH_QUEUE_PRIORITY_DEFAULT，
     DISPATCH_QUEUE_PRIORITY_LOW，
     DISPATCH_QUEUE_PRIORITY_BACKGROUND
     */
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

