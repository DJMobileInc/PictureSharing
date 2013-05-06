//
//  FilterEffects.m
//  iPictureFrames Lite
//
//  Created by sadmin on 12/23/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import "FilterEffects.h"
#import "Manager.h"

@implementation FilterEffects
Manager * manager;
UIImage * processedImage;
NSArray * filters;

-(id)init{
    self = [super init];
    if(self){
        manager = [Manager sharedInstance];
    }
    return self;
}

- (void)applyModifiedImage: (UIImage *) image{
    
    self.image = image;
    if(!self.image){
        self.image = manager.defaultImage;
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ImageNotification"
     object:self.image];

     manager.modifiedImage = self.image;
   
    
}

-(void)filterSelected:(CIFilter *)filter{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self applyFilterInBackground:filter];
    });
}


-(void)applyFilterInBackground:(CIFilter *)
filter{
    if(filter){
    CGImageRef cgi=manager.defaultImage.CGImage;
    CIContext *context=[CIContext contextWithOptions:nil];
    CIImage * img=[CIImage imageWithCGImage:cgi];
    
    NSDictionary * attributes = filter.attributes;
    [filter setDefaults];
    if([attributes objectForKey:@"inputImage"])
    {
        [filter setValue:img forKey:@"inputImage"];
    }
     
    float w=  CGImageGetWidth(cgi);
    float h=  CGImageGetHeight(cgi);
    if([filter.name isEqualToString:@"CICircleSplashDistortion"]){
        CIVector * v = [[CIVector alloc]initWithCGPoint:CGPointMake(w/2.0, h/2.0)];
        [filter setValue:v forKey:@"inputCenter"];
        float radius  = 0.65 * sqrtf(w/2.0*w/2.0 + h/2.0*h/2.0);
      
        [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius" ];
    }
        if([filter.name isEqualToString:@"CICircularScreen"]){
            CIVector * v = [[CIVector alloc]initWithCGPoint:CGPointMake(w/2.0, h/2.0)];
            [filter setValue:v forKey:@"inputCenter"];
        }

   
    CIImage *result=[filter valueForKey:@"outputImage"];
    
    CGRect originFrame=CGRectMake(0, 0,w, h);
    
    CGImageRef resultImageRef2=[context createCGImage:result fromRect:originFrame];
    
    UIImage *scaledImage=[UIImage imageWithCGImage:resultImageRef2 scale:1 orientation:manager.defaultImage.imageOrientation];
    CGImageRelease(resultImageRef2);
    
    [self performSelectorOnMainThread:@selector(applyModifiedImage:) withObject:scaledImage waitUntilDone:NO];
    }
    else{
       
        [self performSelectorOnMainThread:@selector(applyModifiedImage:) withObject:manager.defaultImage waitUntilDone:NO];
    }
}

@end
