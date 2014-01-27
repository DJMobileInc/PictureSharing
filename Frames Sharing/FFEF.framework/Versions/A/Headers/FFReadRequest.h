//
//  FFReadRequest.h
//  FF-IOS-Framework
//
//  Created by Gary on 03/11/2013.
//
//

#import <Foundation/Foundation.h>

@class FFReadResponse;
@class FatFractal;

typedef void (^FFReadRequestCompletion)
(
 FFReadResponse *response
 );

typedef NS_OPTIONS(NSInteger, FFReadOption) {
    FFReadOptionAutoLoadRefs        = (0x1 << 0), // When retrieving objects, automatically retrieve objects which they reference
    FFReadOptionAutoLoadBlobs       = (0x1 << 1), // When retrieving objects, automatically retrieve any BLOBs they contain
    FFReadOptionCacheResponse       = (0x1 << 2), // When retrieving, cache the response
    FFReadOptionUseCachedOnly       = (0x1 << 3), // When retrieving, ONLY try the cache - i.e. do not hit the network
    FFReadOptionUseCachedIfCached   = (0x1 << 4), // When retrieving, try the cache first - only hit the network if cache is empty
    FFReadOptionUseCachedIfOffline  = (0x1 << 5)  // When retrieving, try the network first - if offline, then try the cache
};

@interface FFReadRequest : NSObject

@property (nonatomic, readonly)         FFReadOption options;
@property (strong, nonatomic)           NSString *queryName;
@property (strong, nonatomic)           FatFractal *ff;
@property (strong, nonatomic, readonly) NSError *error;

@property (nonatomic, readonly)           BOOL sent;
@property (strong, nonatomic, readonly)   NSURL *url;

- initWithFf:(FatFractal *)ff;

- (void) executeAsyncWithBlock:(FFReadRequestCompletion)block;
- (void) executeAsyncWithOptions:(FFReadOption)options andBlock:(FFReadRequestCompletion)block;

- (FFReadResponse *) executeSync;
- (FFReadResponse *) executeSyncWithOptions:(FFReadOption)options;

- prepareGetFromURL:(NSURL *)url;
- prepareGetFromUri:(NSString *)uri;
- prepareGetFromCollection:(NSString *)collectionUri;
- prepareGetFromExtension:(NSString *)extensionUri;
- prepareGrabBagGetAllForObj:(id)parentObj grabBagName:(NSString *)gbName;
- prepareGrabBagGetAllForObj:(id)parentObj grabBagName:(NSString *)gbName withQuery:(NSString *)query;

- (BOOL) autoLoadRefs;
- (BOOL) autoLoadBlobs;
- (BOOL) shouldCacheResponse;
- (BOOL) useCachedOnly;
- (BOOL) useCachedIfOffline;
- (BOOL) useCachedIfCached;

@end
