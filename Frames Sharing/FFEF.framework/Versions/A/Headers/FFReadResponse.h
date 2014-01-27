//
//  FFReadResponse.h
//  FF-IOS-Framework
//
//  Created by Gary on 03/11/2013.
//
//

#import <Foundation/Foundation.h>

@class FFReadRequest;

@interface FFReadResponse : NSObject

@property (strong, nonatomic) FFReadRequest *request;

@property (strong, nonatomic) NSHTTPURLResponse *httpResponse;
@property (strong, nonatomic) NSData *rawResponseData;
@property (strong, nonatomic) NSError *error;

@property (nonatomic) BOOL responseCameFromCache;
@property (nonatomic) BOOL nullResponseAllowed;

@property (strong, nonatomic) NSString *statusMessage;
@property (strong, nonatomic) NSArray *objs;
@property (strong, nonatomic) id obj;

- initWithRequest:(FFReadRequest *)request;

@end
