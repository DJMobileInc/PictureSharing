//
//  Album.h
//  Frames Sharing
//
//  Created by sadmin on 3/10/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * description;
@property (nonatomic,strong) NSString * userId;
@property (nonatomic,assign) BOOL privacy;

@end
