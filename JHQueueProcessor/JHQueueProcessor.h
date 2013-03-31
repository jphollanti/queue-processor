//
//  QueueProcessor.h
//  QueueProcessor
//
//  Created by Juha Hollanti on 3/25/13.
//  Copyright (c) 2013 jphollanti.
//

#import <Foundation/Foundation.h>
#import "JHQueueItem.h"
#import "JHQueueListener.h"

@interface JHQueueProcessor : NSObject<JHQueueListener>
@property (nonatomic, retain) NSMutableArray *listeners;
@property (nonatomic) bool inProgress;
+ (JHQueueProcessor *) instance;

- (BOOL) isInProgress;
- (void) processQueueAsynchronously:(NSArray*)queueItems;
- (void) processQueue:(NSArray*)queueItems;
- (void) addListener:(id <JHQueueListener>)listener;
- (void) removeAllListeners;

@end
