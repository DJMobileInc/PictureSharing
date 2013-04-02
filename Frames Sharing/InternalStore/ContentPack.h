//
//  ContentPack.h
//  iPictureFrames Lite
//
//  Created by sadmin on 12/22/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Content;
@interface ContentPack : NSObject
@property(nonatomic,strong) NSString * commonName;
@property(nonatomic,strong) NSString * key;
@property(nonatomic, strong)Content * premiumContent;
@property(nonatomic, strong)Content * freeContent;

@end
