//
//  HTTPRequest.m
//  BDGourmet
//
//  Created by Guillermo Blanco on 27/05/14.
//  Copyright (c) 2014 Guillermo Blanco. All rights reserved.
//

#import "HTTPRequest.h"
#import "HTTPSyncRequest.h"

@implementation HTTPRequest

@synthesize delegate = _delegate;

- (id)initWithURL:(NSString *)newURL {
    self = [super init];
    if(self){
        url = [NSURL URLWithString:newURL];
        self.request = [NSMutableURLRequest requestWithURL:url];
        [self.request setHTTPMethod:@"POST"];
//        [self.request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [self.request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    }
    return self;
}

- (void)configureMethodPOST {
    [self.request setHTTPMethod:@"POST"];
}

- (void)configureMethodGET {
    [self.request setHTTPMethod:@"GET"];
}

- (void)configureContentTypeJSON {
    [self.request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
}

- (void)sendBodyData:(NSDictionary *)dictionary {
    NSError *error;
    postBody = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    [self.request setHTTPBody:postBody];
}

- (void)sendBodyDataString:(NSString *)data {
    NSData *dataData = [data dataUsingEncoding:NSUTF8StringEncoding];
    [self.request setHTTPBody:dataData];
}

- (void)resume {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *uploadTask = [session dataTaskWithRequest:self.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if(error == nil){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //NSLog(@"Respuesta %d %@", self.operation, json);
            if([_delegate respondsToSelector:@selector(didCompleteRequest:receiveData:)]){
                [_delegate didCompleteRequest:self.operation receiveData:json];
            }
        }else{
            //NSLog(@"Entra al error %@", error.userInfo);
            if([_delegate respondsToSelector:@selector(didCompleteRequest:withError:)]){
                [_delegate didCompleteRequest:self.operation withError:error];
            }
        }
    }];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [uploadTask resume];
}

#pragma mark - NSSessionDataTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[[HTTPSyncRequest alloc] init] didCompleteRequest:self.operation withError:nil];
    NSLog(@"Entra 1");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    //NSLog(@"Entra 2 aqui si");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if([_delegate respondsToSelector:@selector(didCompleteRequest:withError:)]){
        [_delegate didCompleteRequest:self.operation withError:nil];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    //NSLog(@"Entra 3 Bytes Send %lld", bytesSent);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler {
    //NSLog(@"Entra 4");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler {
    //NSLog(@"Entra 5");
}

#pragma mark - NSSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    //NSLog(@"Entra 6");
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    //NSLog(@"Entra 7");
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    //NSLog(@"Entra 8");
}

#pragma mark - NSSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[[HTTPSyncRequest alloc] init] didCompleteReceiveData:nil];
    //NSLog(@"Entra 9");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    //NSLog(@"Entra 10");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    //NSLog(@"Entra 11");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    //NSLog(@"Entra 12");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    //NSLog(@"Entra 13");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //NSLog(@"Entra 14");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    //NSLog(@"Entra 15");
}

@end
