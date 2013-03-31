//
//  QueueProcessorTests.h
//  QueueProcessorTests
//
//  Created by Juha Hollanti on 3/25/13.
//  Copyright (c) 2013 jphollanti.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "JHQueueProcessor.h"
#import "JHQueueListener.h"

@interface JHQueueProcessorTests : SenTestCase
@property (nonatomic, retain) JHQueueProcessor* queue;
@property (nonatomic, retain) NSArray* queueItems;
@property (nonatomic, retain) id queueItem;
@property (nonatomic, retain) id listener;
@end
