//
//  QueueListener.h
//  QueueProcessor
//
//  Created by Juha Hollanti on 3/25/13.
//  Copyright (c) 2013 jphollanti.
//

#import <Foundation/Foundation.h>
#import "JHQueueItem.h"

@protocol JHQueueListener <NSObject>
- (void) startedProcessingQueue;
- (void) finishedProcessingQueue;
- (void) startedToProcessQueueItem:(id <JHQueueItem>)queueItem;
- (void) finishedProcessingQueueItem:(id <JHQueueItem>)queueItem;
@end
