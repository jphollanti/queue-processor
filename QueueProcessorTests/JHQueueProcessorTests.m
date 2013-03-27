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
  [[[[queueItem stub] andDo:^(NSInvocation *invocation) {
    
    // Sleep for a while to ensure verification of thread execution
    [NSThread sleepForTimeInterval:2];
    
  }] andReturnValue:OCMOCK_VALUE((BOOL){YES})] process];
  
  [queue processQueueAsynchronously:queueItems];
  
  BOOL wentToThread = NO;
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

- (void)testSynchronousQueueProcessing {  
  [[[queueItem stub] andReturnValue:OCMOCK_VALUE((BOOL){YES})] process];
  
  [queue processQueue:queueItems];
  [queueItem verify];
  //[listener verify];
}

@end
