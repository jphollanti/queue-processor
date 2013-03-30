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
-(void) processQueueAsynchronously:(NSArray*)queueItems {
  [self performSelectorInBackground:@selector(processQueue:) withObject:queueItems];
}

// Processes the queue items in sequence.
-(void) processQueue:(NSArray*)queueItems {
  if ([self isInProgress]) {
    [NSException raise:@"Queue is busy" format:@"Queue is busy"];
  }
  
  @try {
    pthread_mutex_lock(&queueLock);
    inProgress = YES;
    
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
    
  } @finally {
    [NSThread sleepForTimeInterval:2];
    [self finishedProcessingQueue];
    inProgress = NO;
    pthread_mutex_unlock(&queueLock);
  }
}

- (BOOL) isInProgress {
  return inProgress;
}

- (void) addListener:(id <JHQueueListener>)listener {
  [listeners addObject:listener];
}

- (void) removeAllListeners {
  [listeners removeAllObjects];
}

- (void) startedProcessingQueue {
    if ([NSThread isMainThread]) {
      for (id <JHQueueListener> listener in listeners) {
        [listener startedProcessingQueue];
      }
    } else {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (id <JHQueueListener> listener in listeners) {
      [listener startedProcessingQueue];
    }
  });
    }
}

- (void) finishedProcessingQueue {
  if ([NSThread isMainThread]) {
    for (id <JHQueueListener> listener in listeners) {
      [listener finishedProcessingQueue];
    }
    
  } else {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (id <JHQueueListener> listener in listeners) {
      [listener finishedProcessingQueue];
    }
  });
  }
}

- (void) startedToProcessQueueItem:(id <JHQueueItem>)queueItem {
    if ([NSThread isMainThread]) {
      for (id <JHQueueListener> listener in listeners) {
        [listener startedToProcessQueueItem:queueItem];
      }
    } else {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (id <JHQueueListener> listener in listeners) {
      [listener startedToProcessQueueItem:queueItem];
    }
  });
    }
}

- (void) finishedProcessingQueueItem:(id <JHQueueItem>)queueItem {
      if ([NSThread isMainThread]) {
        for (id <JHQueueListener> listener in listeners) {
          [listener finishedProcessingQueueItem:queueItem];
        }
      } else {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (id <JHQueueListener> listener in listeners) {
      [listener finishedProcessingQueueItem:queueItem];
    }
  });
      }
}

@end

























