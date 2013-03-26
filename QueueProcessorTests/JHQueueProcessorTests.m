//
//  QueueProcessorTests.m
//  QueueProcessorTests
//
//  Created by Juha Hollanti on 3/25/13.
//  Copyright (c) 2013 jphollanti.
//

#import "JHQueueProcessorTests.h"
#import "JHQueueProcessor.h"
#import "JHQueueListener.h"

@implementation JHQueueProcessorTests

- (void)setUp {
  [super setUp];
  // Set-up code here.
}

- (void)tearDown {
  // Tear-down code here.
  [super tearDown];
}

- (void)testInitiate {
  JHQueueProcessor* queue = [JHQueueProcessor instance];
  NSAssert(queue != nil, @"Failed to initiate queue");
}

- (void)testQueueProcessing {
  JHQueueProcessor* queue = [JHQueueProcessor instance];
  id listener = [OCMockObject mockForProtocol:@protocol(JHQueueListener)];
  id queueItem = [OCMockObject mockForProtocol:@protocol(JHQueueItem)];
  NSArray *queueItems = [NSArray arrayWithObject:queueItem];
  [queue addListener:listener];
  
  [[[queueItem stub] andReturnValue:OCMOCK_VALUE((BOOL){YES})] process];
//  [[queueItem expect] process];
  [[listener expect] startedProcessingQueue];
  [[listener expect] startedToProcessQueueItem:queueItem];
  [[listener expect] finishedProcessingQueueItem:queueItem];
  [[listener expect] finishedProcessingQueue];
  
  [queue processQueue:queueItems];
  
  while ([queue isInProgress]) {
    NSLog(@"waiting...");
    // This executes another run loop.
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    // Sleep 1/100th sec
    usleep(10000);
  }
  NSLog(@"done...");
}

@end
