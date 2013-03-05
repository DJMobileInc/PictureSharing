//
//  FiltersPack.m
//  iPictureFrames Lite
//
//  Created by sadmin on 12/23/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import "FiltersPack.h"

@implementation FiltersPack

-(id)init{
    self = [super init];
    if(self){
        _filters = [NSArray arrayWithObjects: 
                    @"CINone",
                    @"CIBloom",
                    @"CICircleSplashDistortion",
                    @"CICircularScreen",
                    @"CIColorInvert",
                   // @"CIColorMap",
                    @"CIDotScreen",
                    @"CIFalseColor",
                    @"CIColorPosterize",
                    @"CIHatchedScreen",
                    @"CIColorMonochrome",
                    @"CIMaximumComponent",
                    @"CIMinimumComponent",
                    @"CIPixellate",
                    @"CISepiaTone",
                    @"CIPerspectiveTile",

                    nil];
        _filtersNames = [NSArray arrayWithObjects:
                         @"Default",
                         @"Bloom",
                          @"Circle Splash",
                          @"Circular Frenzy",
                          @"Invert",
                        //  @"Color Map",
                          @"Dot Screen",
                          @"False Color",
                          @"Posterize",
                          @"Hatched",
                         @"Monochrome",
                         @"Max",
                          @"Min",
                         @"Pixels",
                         @"Sepia",
                         @"Tiles",
                         nil];

        _filtersImages = [NSArray arrayWithObjects:
                          @"flowers.jpg",
                          @"Bloom",
                          @"CircleSplash",
                          @"circular",
                          @"colorInvert",
                         // @"colormap",
                          @"dotscreen",
                          @"falseColor",
                          @"posterize",
                          @"hatchedScreen",
                          @"monochrome",
                          @"maximum",
                          @"minimum",
                          @"pixelate",
                          @"sepia",
                          @"Tile",
                         nil];
    }

    return self;
    
}


@end
