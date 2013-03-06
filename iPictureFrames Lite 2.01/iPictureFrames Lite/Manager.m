//
//  Manager.m
//  iPictureFrames Lite
//
//  Created by sadmin on 12/29/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import "Manager.h"

@implementation Manager

+ (id)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}


@end
