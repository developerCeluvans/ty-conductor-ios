//
//  HTTPRequest.h
//  BDGourmet
//
//  Created by Guillermo Blanco on 27/05/14.
//  Copyright (c) 2014 Guillermo Blanco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HTTPRequestMethodPOST,
    HTTPRequestMethodGET
} HTTPRequestMethodType;

@class HTTPDataRequest;

@protocol HTTPRequestDelegate <NSObject>

@required
- (void)didCompleteRequest:(int)request withError:(NSError *)error;
- (void)didCompleteRequest:(int)request receiveData:(NSDictionary *)data;

@end

@interface HTTPRequest : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate> {
    NSURL *url;
    NSData *postBody;
    NSURLSession *session;
}

@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, assign) id <HTTPRequestDelegate> delegate;
@property (nonatomic) int operation;

- (id)initWithURL:(NSString *)newURL;
- (void)configureMethodPOST;
- (void)configureMethodGET;
- (void)configureContentTypeJSON;
- (void)sendBodyData:(NSDictionary *)dictionary;
- (void)sendBodyDataString:(NSString *)data;
- (void)resume;

@end
