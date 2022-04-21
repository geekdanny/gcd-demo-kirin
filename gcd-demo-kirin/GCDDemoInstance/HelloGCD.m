//
//  GCDDemoInstance.m
//  gcd-demo-kirin
//
//  Created by Admin on 2022-04-15.
//

#import "HelloGCD.h"

@implementation HelloGCD

// dispatch：调度，GCD里面的函数都是以dispatch开头的。

/**
 串行队列：顺序，一个一个执行。
 同步执行：在当前线程执行，不会开辟新线程。
 结果：不开辟新线程，所有任务都在这个主线程里面执行。
 */
-(void)syncOnSerialQueue
{
    NSString * caseLog = @"串行队列+同步 Case Started";
    NSLog(@"--- %@ ---", caseLog);
    
    // 1. 创建一个串行队列
    // 参数：1.队列标签(纯c语言)   2.队列的属性
    dispatch_queue_t  queue = dispatch_queue_create("gcd.serialqueue", DISPATCH_QUEUE_SERIAL);
    
    // 2. 同步执行任务
    // 一般只要使用“同步” 执行，串行队列对添加的任务，会立马执行。
    for (int i=0 ; i<10 ; i++) {
        dispatch_sync(queue, ^{
            [NSThread sleepForTimeInterval:1];
            NSLog(@"%@ executes task %s", [NSThread currentThread],  __PRETTY_FUNCTION__);
        });
    }
    NSLog(@"--- %@ finished ---", caseLog);
}

/**
 串行队列：任务必须要一个一个先后执行。
 异步执行：肯定会开新线程，在新线程执行。
 结果：只会开辟一个线程，而且所有任务都在这个新的线程里面执行。
 */
-(void)asyncOnSerialQueue
{
    NSString * caseLog = @"串行队列+异步 Case Started";
    NSLog(@"--- %@ ---", caseLog);
    
    // 1. 串行队列
    dispatch_queue_t queue = dispatch_queue_create("gcd.serialqueue", DISPATCH_QUEUE_SERIAL);
    // 按住command进入， #define DISPATCH_QUEUE_SERIAL NULL
    // DISPATCH_QUEUE_SERIAL 等于直接写NULL， 且开发的时候都使用NULL
    // 2. 异步执行
    for (int i=0 ; i<10 ; i++) {
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:1];
            NSLog(@"%@ executes task %s", [NSThread currentThread],  __PRETTY_FUNCTION__);
        });
    }
    NSLog(@"--- %@ finished ---", caseLog);
}

/**
 并发队列：可以同时执行多个任务
 同步执行：不会开辟新线程，是在当前线程执行。
 结果：不开新线程，顺序执行。
 */
-(void)syncOnConcurrentQueue
{
    NSString * caseLog = @"并发队列+同步 Case Started";
    NSLog(@"--- %@ ---", caseLog);
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("gcd.concurrentqueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0 ; i< 10; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%@  %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"--- %@ finished ---", caseLog);
}

/**
 并发队列：可以同时执行多个任务，
 异步执行：肯定会开新线程，在新线程执行。
 结果：会开很多个线程，同时执行。
 */
-(void)asyncOnConcurrentQueue
{
    NSString * caseLog = @"并发队列+异步 Case Started";
    NSLog(@"--- %@ ---", caseLog);
    
    // 1. 并发队列
    dispatch_queue_t queue = dispatch_queue_create("gcd.concurrentqueue", DISPATCH_QUEUE_CONCURRENT);
    // 异步执行任务
    for (int i=0 ; i<5000 ; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%@  %d", [NSThread currentThread], i);
        });
        if(i==4999){
            NSLog(@"Breaking ... %@  %d", [NSThread currentThread], i);
        }
    }
    NSLog(@"--- %@ finished ---", caseLog);
}


/**
 主队列：专门负责在主线程上调度任务，不会在子线程调度任务，在主队列不允许开新线程。
 同步执行：阻塞当前线程，要马上执行
 结果：死锁。
 死锁原因：同步任务需要马上执行，但是CPU上的主线程正在执行syncOnMainQueue，所以需要等syncOnMainQueue执行完毕，
 再去处理Main Queue上的任务；但是syncOnMainQueue 也在等主线程去处理完主队列内任务。所以相互等待造成主线程内部的阻塞。产生死锁。
 */
-(void)syncOnMainQueue
{
    NSString * caseLog = @"并发队列+异步 Case Started";
    NSLog(@"--- %@ ---", caseLog);
    // 1. 获得主队列—> 程序启动以后至少有一个主线程—> 一开始就会创建主队列。
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 2. 同步执行任务
    for(int i=0; i<10; i++){
        NSLog(@"调度前");
        // 同步：把任务放到主队列里，但是需要马上执行。
        dispatch_sync(queue, ^{
            NSLog(@"%@  %d", [NSThread currentThread], i);
        });
        NSLog(@"睡1秒");
        [NSThread sleepForTimeInterval:1.0];
    }
    NSLog(@"--- %@ finished ---", caseLog);
}


/**
 主队列：专门负责在主线程上调度任务，不会在子线程调度任务，在主队列不允许开新线程。
 主队列特点：不允许开新线程。
 异步执行：会开新线程，在新线程执行。
 异步特点：异步任务不需要马上执行，只是把任务放到主队列，等线程有空再去执行，也就是等asyncOnMainQueue执行完毕，主线程就有空了。
 结果：不开线程，只能在主线程上，顺序执行。
 */
-(void) asyncOnMainQueue
{
    NSString * caseLog = @"并发队列+异步 Case Started";
    NSLog(@"--- %@ ---", caseLog);
    // 1. 获得主队列—> 程序启动以后至少有一个主线程—> 一开始就会创建主队列。
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 2. 异步执行任务
    for(int i=0; i<10; i++){
        NSLog(@"调度前");
        // 异步：把任务放到主队列里，但是不需要马上执行。
        dispatch_async(queue, ^{  // 也就是说，把{}内的任务先放到队列里面，等主线程别的任务完成之后才执行。
            NSLog(@"%@  %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"--- %@ finished ---", caseLog);
    /**
     之所以将放到主队列内的任务最后执行，是因为当前队列所在的asyncOnMainQueue方法正由主线程进行执行，只有将先调度的asyncOnMainQueue执行完毕，才会执行加在队列内的任务。
     注意在执行方法过程中只是先把任务加到队列中。
     */
}



@end
