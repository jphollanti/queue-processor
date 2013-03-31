queue-processor - Queue processor for iOS. 
========================================

Supports synchronous and asynchronous queue processing. Only one queue is allowed at 
a time and only one list of items is allowed to be processed at a time. 

Example: 
--------
    JHQueueProcessor* queue = [JHQueueProcessor instance];
    id queueItem = *object conforming to JHQueueItem protocol*;
    NSArray* queueItems = [NSArray arrayWithObject:queueItem];

    // It's possible to add listeners to the queue
    [queue addListener:*object conforming to JHQueueListener protocol*];

    [queue processQueueAsynchronously:queueItems];

JHQueueItem protocol defines only one method: 

    - (BOOL) process;

Listeners receive the following events: 

    - (void) startedProcessingQueue;
    - (void) finishedProcessingQueue;
    - (void) startedToProcessQueueItem:(id <JHQueueItem>)queueItem;
    - (void) finishedProcessingQueueItem:(id <JHQueueItem>)queueItem;