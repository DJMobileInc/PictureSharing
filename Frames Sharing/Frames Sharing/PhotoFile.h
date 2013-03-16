//
//  PhotoFile.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/12/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoFile : NSObject
@property(strong, nonatomic) NSString * uniqueId;
@property (strong,nonatomic) NSData * imageData;
@property (strong,nonatomic) NSData * thumbnailImageData;
@property (strong,nonatomic) NSDate * date;

@end
