//
//  QueueProcessor.h
//  QueueProcessor
//
//  Created by Juha Hollanti on 3/25/13.
//  Copyright (c) 2013 jphollanti.
//

#import <Foundation/Foundation.h>
#import "QueueItem.h"
#import "QueueListener.h"

@interface QueueProcessor : NSObject<QueueListener>
@property (nonatomic, retain) NSMutableArray *listeners;
@property (nonatomic) bool inProgress;
+ (QueueProcessor *) instance;

- (BOOL) isInProgress;
- (void) processQueue:(NSArray*)queueItems;
- (void) executeQueue:(NSArray*)queueItems;
- (void) addListener:(id <QueueListener>)listener;

@end
