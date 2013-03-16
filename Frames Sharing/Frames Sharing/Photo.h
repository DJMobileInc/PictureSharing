//
//  Photo.h
//  Frames Sharing
//
//  Created by sadmin on 3/10/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoFile.h"

@interface Photo : NSObject
@property (strong, nonatomic) NSString * description;
@property (strong, nonatomic) NSString * title;
@property(strong, nonatomic)  NSString * uniqueId;
@property(strong, nonatomic)  NSString * albumId;
@property(strong, nonatomic)  PhotoFile *photoFile;
@property(strong,nonatomic)   NSArray * ratings;
@property(assign, nonatomic) BOOL isPublic;


@end
