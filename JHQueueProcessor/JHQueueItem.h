//
//  QueueItem.h
//  QueueProcessor
//
//  Created by Juha Hollanti on 3/25/13.
//  Copyright (c) 2013 jphollanti.
//

#import <Foundation/Foundation.h>

@protocol JHQueueItem <NSObject>
-(BOOL)process;
@end
