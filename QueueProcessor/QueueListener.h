//
//  QueueListener.h
//  QueueProcessor
//
//  Created by Juha Hollanti on 3/25/13.
//  Copyright (c) 2013 jphollanti.
//

#import <Foundation/Foundation.h>

@protocol QueueListener <NSObject>
- (void) startedProcessingQueue;
- (void) finishedProcessingQueue;
- (void) startedToProcessQueueItem:(id <QueueItem>)queueItem;
- (void) finishedProcessingQueueItem:(id <QueueItem>)queueItem;
@end
