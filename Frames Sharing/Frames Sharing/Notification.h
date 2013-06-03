//
//  Notification.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 5/3/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject
@property(nonatomic,strong) NSString * message;
@property(nonatomic,strong) NSString * from;
@property(nonatomic,strong) NSString * to;
@property(nonatomic,strong) NSString * photoGuid;
@property(nonatomic,strong) NSDate * date;
@property(nonatomic, assign) BOOL  read;

@end
