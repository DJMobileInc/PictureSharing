//
//  User.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/12/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Album;

@interface User : FFUser
@property (nonatomic, retain) NSString * aboutDescription;
@property (nonatomic, retain) NSData * profilePicture;
@property (nonatomic, retain) NSMutableArray * albums;


@end
