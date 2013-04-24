//
//  Photo.m
//  Frames Sharing
//
//  Created by sadmin on 3/10/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "Photo.h"
@interface Photo()
    
@end

@implementation Photo

-(id)init{
    self = [super init];
    if(self)
    {
        self.ratings = [[NSMutableArray alloc]initWithCapacity:0];
        self.flag =NO;
//        self.isPublic = NO;
    }
    return self;
}



@end
