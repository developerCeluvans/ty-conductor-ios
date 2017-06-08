//
//  HTTPService.m
//  BDGourmet
//
//  Created by Guillermo Blanco on 27/05/14.
//  Copyright (c) 2014 Guillermo Blanco. All rights reserved.
//

#import "HTTPService.h"
#import "HTTPSyncRequest.h"


@interface HTTPService ()
@property (nonatomic) int operation;
@property (nonatomic) BOOL send;
@property (nonatomic) NSMutableArray *data;
@property (nonatomic, retain) HTTPSyncRequest *request;
@end

@implementation HTTPService

static NSOperationQueue *operationQueue;
static NSMutableArray *_dataPending;

//- (NSArray *)addObject:(NSSet *)objects delete:(BOOL)delete {
//    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[objects count]];
//    for (SyncManagedObject *object in [objects allObjects]) {
//        if([self validateObjectClass:object]){
//            NSURL *urlID = nil;
//            if(!delete){
//                urlID = [[object objectID] URIRepresentation];
//            }
//            [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSString stringWithFormat:@"%@", [object class]], @"name",
//                             [object remote_id], @"id",
//                             urlID, @"url",
//                             nil]];
//        }
//    }
//    return data;
//}

//- (id)initWithOperation:(int)operation inserted:(NSSet *)insertedObjects updated:(NSSet *)updatedObjects deleted:(NSSet *)deletedObjects send:(BOOL)send delegate:(HTTPSyncRequest *)delegate {
//    if([super init]){
//        self.data = [[NSMutableArray alloc] init];
//        self.operation = operation;
//        self.send = send;
//        self.request = delegate;
//        if([insertedObjects count]){
//            [self.data addObjectsFromArray:[self addObject:insertedObjects delete:NO]];
//        }
//        if([updatedObjects count]){
//            [self.data addObjectsFromArray:[self addObject:updatedObjects delete:NO]];
//        }
//        if([deletedObjects count]){
//            [self.data addObjectsFromArray:[self addObject:deletedObjects delete:YES]];
//        }
//    }
//    return self;
//}

- (id)initWithOperation:(int)operation delegate:(HTTPSyncRequest *)delegate {
    if([super init]){
        self.operation = operation;
        self.request = delegate;
    }
    return self;
}

//- (BOOL)validateObjectClass:(id)object {
//    return (![object isKindOfClass:[SyncState class]] && ![object isKindOfClass:[SyncPendingPutRequest class]]);
//}

- (void)main {
    switch (self.operation) {
        case 1:
            [self.request synchronizeWithData:self.data synchronize:self.send];
            break;
        case 2:
            [self.request synchronizeWithData:[NSArray new] synchronize:YES];
            break;
        default:
            break;
    }
}

//+ (void)synchronize:(NSSet *)insertedObjects updated:(NSSet *)updatedObjects deleted:(NSSet *)deletedObjects send:(BOOL)send delegate:(HTTPSyncRequest *)delegate {
//    if(operationQueue == nil){
//        operationQueue = [[NSOperationQueue alloc] init];
//    }
//    [operationQueue addOperation:[[HTTPService alloc] initWithOperation:1 inserted:insertedObjects updated:updatedObjects deleted:deletedObjects send:send delegate:delegate]];
//}

+ (void)synchronize:(HTTPSyncRequest *)delegate {
    if(operationQueue == nil){
        operationQueue = [[NSOperationQueue alloc] init];
    }
    [operationQueue addOperation:[[HTTPService alloc] initWithOperation:2 delegate:delegate]];
}

@end
