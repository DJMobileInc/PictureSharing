//
//  ViewController.h
//  iPictureFrames Lite
//
//  Created by Janusz Chudzynski on 12/21/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedStore.h"
@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, ADBannerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, PurchaseCompleted>

@end
