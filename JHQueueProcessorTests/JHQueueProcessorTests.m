//
//  QueueProcessorTests.m
//  QueueProcessorTests
//
//  Created by Juha Hollanti on 3/25/13.
//  Copyright (c) 2013 jphollanti.
//

#import "JHQueueProcessorTests.h"

@implementation JHQueueProcessorTests

@synthesize queue, queueItems, queueItem, listener;

- (void)setUp {
  [super setUp];
  
  queue = [JHQueueProcessor instance];
  
  queueItem = [OCMockObject mockForProtocol:@protocol(JHQueueItem)];
  queueItems = [NSArray arrayWithObject:queueItem];
  
  listener = [OCMockObject mockForProtocol:@protocol(JHQueueListener)];
  [[listener expect] startedProcessingQueue];
  [[listener expect] startedToProcessQueueItem:queueItem];
  [[listener expect] finishedProcessingQueueItem:queueItem];
  [[listener expect] finishedProcessingQueue];
  
  [queue addListener:listener];
}

- (void)tearDown {
  [queue removeAllListeners];
  queue = nil;
  queueItems = nil;
  queueItem = nil;
  listener = nil;
  
  [super tearDown];
}

- (void)testInitiate {
  NSAssert(queue != nil, @"Failed to initiate queue");
}

- (void)testAsynchronousQueueProcessing {
  [[[queueItem stub] andReturnValue:OCMOCK_VALUE((BOOL){YES})] process];
  
  [queue processQueueAsynchronously:queueItems];
  
  usleep(10000);
  
  BOOL wentToThread = NO;
  // http://stackoverflow.com/questions/3615939/wait-for-code-to-finish-execution
  while ([queue isInProgress]) {
    wentToThread = YES;
    // This executes another run loop.
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    // Sleep 1/100th sec
    usleep(10000);
  }
  
  STAssertTrue(wentToThread, @"Expect main thread to be waiting for the logic in the other thread. ");
  
  [queueItem verify];
  [listener verify];
}

/*
 - (void)testAsynchronousQueueLocking {
 queueItems = [NSArray arrayWithObject:queueItem];
 
 [[[[queueItem stub] andDo:^(NSInvocation *invocation) {
 usleep(3000000);
 }] andReturnValue:OCMOCK_VALUE((BOOL){YES})] process];
 
 [queue processQueueAsynchronously:queueItems];
 usleep(10000);
 STAssertThrows([queue processQueueAsynchronously:queueItems], @"second call to process queue should throw an exception");
 
 while ([queue isInProgress]) {
 // This executes another run loop.
 [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
 // Sleep 1/100th sec
 usleep(10000);
 }
 
 [queueItem verify];
 [listener verify];
 }
*/

- (void)testSynchronousQueueProcessing {
  [[[queueItem stub] andReturnValue:OCMOCK_VALUE((BOOL){YES})] process];
  
  [queue processQueue:queueItems];
  [queueItem verify];
  [listener verify];
}

@end
