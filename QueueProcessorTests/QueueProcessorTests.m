//
//  QueueProcessorTests.m
//  QueueProcessorTests
//
//  Created by Juha Hollanti on 3/25/13.
//  Copyright (c) 2013 jphollanti.
//

#import "QueueProcessorTests.h"
#import "QueueProcessor.h"

@implementation QueueProcessorTests

- (void)setUp {
  [super setUp];
  // Set-up code here.
}

- (void)tearDown {
  // Tear-down code here.
  [super tearDown];
}

- (void)initiate {
  QueueProcessor* queue = [QueueProcessor instance];
  NSAssert(queue != nil, @"Failed to initiate queue");
}

@end
