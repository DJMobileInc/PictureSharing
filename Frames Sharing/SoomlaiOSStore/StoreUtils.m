/*
 * Copyright (C) 2012 Soomla Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "StoreUtils.h"
#import "StoreConfig.h"
#import "OpenUDID.h"
#import <AdSupport/AdSupport.h>
#import "ObscuredNSUserDefaults.h"

@implementation StoreUtils

static NSString* TAG = @"SOOMLA StoreUtils";

+ (void)LogDebug:(NSString*)tag withMessage:(NSString*)msg {
    if (STORE_DEBUG_LOG) {
        NSLog(@"[Debug] %@: %@", tag, msg);
    }
}

+ (void)LogError:(NSString*)tag withMessage:(NSString*)msg {
    NSLog(@"[*** ERROR ***] %@: %@", tag, msg);
}

+ (NSString*)deviceIdNew {
    ASIdentifierManager *adIdentManager = [ASIdentifierManager sharedManager];
    if (adIdentManager && adIdentManager.advertisingTrackingEnabled && [adIdentManager respondsToSelector:@selector(advertisingIdentifier)]) {
        return [[adIdentManager advertisingIdentifier] UUIDString];
    } else {
        return [self deviceIdOld];
    }
}

+ (NSString*)deviceIdOld {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        return [SOOM_OpenUDID value];
    }
}

// This function is only used to decide what mechanism to use in order to fetch the device's UDID.
// This is introduced along with the IDFA fetching of UDID in order to backward support previous devices that use the SDK.
+ (void)udidBackwardInit {
    NSString* uuidSaved = [[NSUserDefaults standardUserDefaults] stringForKey:@"UDID_SOOMLA"];
    if (uuidSaved && [uuidSaved length] > 0) {
        return;
    }
    
    int saVerSaved = [ObscuredNSUserDefaults intForKey:@"SA_VER_NEW" withDefaultValue:-1 andDeviceId:[self deviceIdOld]];
    if (saVerSaved>-1) {
        [[NSUserDefaults standardUserDefaults] setObject:[self deviceIdOld] forKey:@"UDID_SOOMLA"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[self deviceIdNew] forKey:@"UDID_SOOMLA"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString*)deviceId {
    NSString* udid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UDID_SOOMLA"];
    if (!udid) {
        [self udidBackwardInit];
        udid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UDID_SOOMLA"];
        LogDebug(TAG, @"Can't find 'UDID_SOOMLA'. Fetching UDID according to udidBackwardInit policy.");
    }
    return udid;
}

+ (NSMutableDictionary*)jsonStringToDict:(NSString*)str {
    NSError* error = NULL;
    NSMutableDictionary *dict =
    [NSJSONSerialization JSONObjectWithData: [str dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    if (error) {
        LogError(TAG, ([NSString stringWithFormat:@"There was a problem parsing the given JSON string: %@ error: %@", str, [error localizedDescription]]));
        
        return NULL;
    }
    
    return dict;
}

+ (NSMutableArray*)jsonStringToArray:(NSString*)str {
    NSError* error = NULL;
    NSMutableArray *arr =
    [NSJSONSerialization JSONObjectWithData: [str dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    if (error) {
        LogError(TAG, ([NSString stringWithFormat:@"There was a problem parsing the given JSON string: %@ error: %@", str, [error localizedDescription]]));
        
        return NULL;
    }
    
    return arr;
}

+ (NSString*)dictToJsonString:(NSDictionary*)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        LogError(TAG, ([NSString stringWithFormat:@"There was a problem parsing the given NSDictionary. error: %@", [error localizedDescription]]));
        
        return NULL;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString*)arrayToJsonString:(NSArray*)arr {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        LogError(TAG, ([NSString stringWithFormat:@"There was a problem parsing the given NSArray. error: %@", [error localizedDescription]]));
        
        return NULL;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
