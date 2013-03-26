//
//  QueueProcessor.m
//  QueueProcessor
//
//  Created by Juha Hollanti on 3/25/13.
//  Copyright (c) 2013 jphollanti. 
//

#import "JHQueueProcessor.h"
#import "JHQueueItem.h"

@implementation JHQueueProcessor

static JHQueueProcessor *sharedSingleton;

@synthesize inProgress, listeners;
pthread_mutex_t queueLock;

+ (void)initialize
{
  static BOOL initialized = NO;
  if(!initialized)
  {
    initialized = YES;
    sharedSingleton = [[JHQueueProcessor alloc] init];
  }
}

+ (JHQueueProcessor *) instance {
  return sharedSingleton;
}

- (id) init {
  self = [super init];
  pthread_mutex_init(&queueLock, NULL);
  inProgress = NO;
  listeners = [[NSMutableArray alloc] init];
  return self;
}

// Delegates processing of queue elements to a dedicated thread. 
-(void) processQueue:(NSArray*)queueItems {
  [self performSelectorInBackground:@selector(executeQueue:) withObject:queueItems];
}

// Processes the queue items in sequence.
-(void) executeQueue:(NSArray*)queueItems {
  if ([self isInProgress]) {
    [NSException raise:@"Queue is busy" format:@"Queue is busy"];
  }
  inProgress = YES;
  pthread_mutex_lock(&queueLock);
  
  [self startedProcessingQueue];
  
  for (id<JHQueueItem> item in queueItems) {
    // http://stackoverflow.com/questions/9778646/objective-c-uiimagepngrepresentation-memory-issue-using-arc
    @autoreleasepool {
      @try {
        [self startedToProcessQueueItem:item];
        if (![item process]) {
          [NSException raise:@"Failed to process queue item" format:@"Failed to process queue item %@", item];
        }
      }
      @finally {
        [self finishedProcessingQueueItem:item];
      }
    }
  }
  
  [self finishedProcessingQueue];
  pthread_mutex_unlock(&queueLock);
  inProgress = NO;
}

- (BOOL) isInProgress {
  return inProgress;
}

- (void) addListener:(id <JHQueueListener>)listener {
  [listeners addObject:listener];
}

- (void) startedProcessingQueue {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (id <JHQueueListener> listener in listeners) {
      [listener startedProcessingQueue];
    }
  });
}
- (void) finishedProcessingQueue {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (id <JHQueueListener> listener in listeners) {
      [listener finishedProcessingQueue];
    }
  });
}
- (void) startedToProcessQueueItem:(id <JHQueueItem>)queueItem {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (id <JHQueueListener> listener in listeners) {
      [listener startedToProcessQueueItem:queueItem];
    }
  });
}
- (void) finishedProcessingQueueItem:(id <JHQueueItem>)queueItem {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (id <JHQueueListener> listener in listeners) {
      [listener finishedProcessingQueueItem:queueItem];
    }
  });
}

@end

























