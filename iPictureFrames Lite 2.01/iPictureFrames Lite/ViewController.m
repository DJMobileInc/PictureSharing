//
//  ViewController.m
//  iPictureFrames Lite
//
//  Created by Janusz Chudzynski on 12/21/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//


#define blackBarY 223
#define blackBarTallY 270

#define kFrameCellId @"frameCellId"
#define kEffectCellId @"effectCellId"

#import "ViewController.h"
#import "FrameCell.h"
#import "EffectCell.h"

#import "Content.h"
#import "ContentPack.h"

#import "FilterEffects.h"
#import "FiltersPack.h"
#import "MKStoreManager.h"

#import "Manager.h"
#import "SocialHelper.h"
@interface UIImage (Extras)
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize ;
@end;
@implementation UIImage (Extras)
- (UIImage *)crop:(CGRect)rect {
    
    rect = CGRectMake(rect.origin.x*self.scale,
                      rect.origin.y*self.scale,
                      rect.size.width*self.scale,
                      rect.size.height*self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}



+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

@end;

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *framesView;
@property (strong, nonatomic) IBOutlet UIView *effectsView;

@property (strong, nonatomic) IBOutlet UIButton *framesTitleButton;
@property (strong, nonatomic) IBOutlet UIImageView *applicationFrame;
@property (strong, nonatomic) IBOutlet UIImageView *photoContainerImgView;
@property (strong, nonatomic) IBOutlet UIImageView *frameContainerImageView;
@property (strong, nonatomic) UITapGestureRecognizer * tapGesture;
@property (strong, nonatomic) IBOutlet UICollectionView *framesCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *effectsCollectionView;

@property (strong, nonatomic) ContentPack * currentContentPack;
@property (strong, nonatomic) FilterEffects * filterEffects;
@property (strong, nonatomic) FiltersPack * filterPack;

@property (strong, nonatomic) Manager * manager;
@property (strong, nonatomic) IBOutlet UIButton *framesButon;
@property (strong, nonatomic) IBOutlet ADBannerView *bannerView;

@property (strong,nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong,nonatomic) UIPinchGestureRecognizer * pinchGestureRecognizer;

- (IBAction)hideFramesFor:(id)sender;
- (IBAction)framesButtonAction:(id)sender;
- (IBAction)photoAction:(id)sender;
- (IBAction)hideEffects:(id)sender;


@end

@implementation ViewController

UIPopoverController * cameraPopoverController;
UIActionSheet *  photoAction;
UIActionSheet * shareAction;

CGRect imageFrame;

- (BOOL)deviceIsAnIPad {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)])
        //We can test if it's an iPad. Running iOS3.2+
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            return YES; //is an iPad
        else
            return NO; //is an iPhone
        else
            return NO; //does not respond to selector, therefore must be < iOS3.2, therefore is an iPhone
}


- (IBAction)showFramesFor:(id)sender {
     [self hideAll];
    int tag = [sender tag];
    switch (tag) {
        case kChristmas:
        {
            self.currentContentPack = [self searchForContentPack:kChristmasPackName];

          break;
        }
          
        case kAnimals:
        {
            self.currentContentPack = [self searchForContentPack:kAnimalPackName];

            break;
        }

        case kAssorted:
        {
            self.currentContentPack = [self searchForContentPack:kAssortedPackName];
            
        }
            break;

        case kLove:
        {
            self.currentContentPack = [self searchForContentPack:kLovePackName];
            
        }
            break;
         
        case kWood:
        {
            self.currentContentPack = [self searchForContentPack:kWoodPackName];
            
        }
            break;
        
        case kStone:
        {
            self.currentContentPack = [self searchForContentPack:kStonePackName];
            
        }
            break;
        default:
            break;
    }
    if(self.currentContentPack){
        [self.framesTitleButton setTitle:self.currentContentPack.commonName forState:UIControlStateNormal];
        [self.framesCollectionView reloadData];
        
    }
    else{
      //  NSLog(@"Pack doesnt exis..");
    }
    
    
  

    [UIView animateWithDuration:1 animations:^{
   if([self deviceIsAnIPad]){     
        float y = self.frameContainerImageView.frame.origin.y +self.frameContainerImageView.frame.size.height-self.framesView.frame.size.height ;
        
    self.framesView.frame = CGRectMake(self.framesView.frame.origin.x, y, self.framesView.frame.size.width, self.framesView.frame.size.height);
        
#warning TO DO
//#warning ADD In-App purchase images FRAMES TO ITUNES CONNECT
//#warning if you want to add frames edit me here...
//#warning to do: add dismissing frames
#warning add info about gestures with NSUserDefaults after adding images
   }
   else{
        float y = self.view.bounds.size.height - self.framesView.frame.size.height -30.0 ;

       self.framesView.frame = CGRectMake(self.framesView.frame.origin.x, y, self.framesView.frame.size.width, self.framesView.frame.size.height);
   
   }
       
    } completion:^(BOOL finished){
            }];
}



     
- (IBAction)hideFramesFor:(id)sender {
    
  
    [UIView animateWithDuration:0.5 animations:^{
        float fh = self.framesView.frame.size.height;
        float sh =self.view.bounds.size.height;
        self.framesView.frame = CGRectMake(self.framesView.frame.origin.x,fh+sh , self.framesView.frame.size.width, self.framesView.frame.size.height);

    } completion:^(BOOL finished){}];
}

- (IBAction)showEffects:(id)sender {
    [self hideAll];
    [UIView animateWithDuration:1 animations:^{
        if([self deviceIsAnIPad]){
        float y = self.frameContainerImageView.frame.origin.y +self.frameContainerImageView.frame.size.height-self.effectsView.frame.size.height ;
        
        self.effectsView.frame = CGRectMake(self.effectsView.frame.origin.x, y, self.effectsView.frame.size.width, self.effectsView.frame.size.height);
        }
        else{
            float y = self.view.bounds.size.height - self.effectsView.frame.size.height -30.0 ;
         self.effectsView.frame = CGRectMake(self.effectsView.frame.origin.x, y, self.effectsView.frame.size.width, self.effectsView.frame.size.height);   
        
        }
    }
                     completion:^(BOOL finished){
                         
    }];
    
   

}

- (IBAction)hideEffects:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        float fh = self.framesView.frame.size.height;
        float sh =self.view.bounds.size.height;
        self.effectsView.frame = CGRectMake(self.effectsView.frame.origin.x,fh+sh , self.effectsView.frame.size.width, self.effectsView.frame.size.height);
        
    } completion:^(BOOL finished){}];
}


-(void)hideAll{
    [self hideFramesFor:nil];
    [self hideEffects:nil];
}

#pragma mark gestures

-(void)viewTappedOn:(UITapGestureRecognizer *)tapGesture{
    if(tapGesture.view == self.view){
        [self hideAll];
        
    }
}

-(void)viewPanOn:(UIPanGestureRecognizer *)recognizer{
   
    UIView * t= _photoContainerImgView;// recognizer.view;
    CGPoint center = [recognizer translationInView:[t superview]];
    //[t setCenter:CGPointMake(t.center.x + center.x, t.center.y + center.y)];
  //  t.transform =    CGAffineTransformTranslate(self.photoContainerImgView.transform, center.x, center.y);
  
    imageFrame =   CGRectApplyAffineTransform(imageFrame, CGAffineTransformTranslate(self.photoContainerImgView.transform, center.x, center.y));
    self.photoContainerImgView.frame = imageFrame;
    
    [recognizer setTranslation:CGPointZero inView:[t superview]];

    
}

-(void)viewPinchOn:(UIPinchGestureRecognizer *)recognizer{
        //_photoContainerImgView.transform = CGAffineTransformScale(self.photoContainerImgView.transform, recognizer.scale, recognizer.scale);
    CGAffineTransform  transform = CGAffineTransformScale(self.photoContainerImgView.transform, recognizer.scale, recognizer.scale);
//    CGRect transformedRect = CGRectApplyAffineTransform[self.frameContainerImageView.frame,
    
        
    CGRect tf =CGRectApplyAffineTransform(_photoContainerImgView.bounds, transform);
    CGRect fRect = self.frameContainerImageView.frame;
    
    
    if(tf.size.width <=fRect.size.width * 2 && tf.size.width>250)
    {
        //_photoContainerImgView.transform = transform;//CGAffineTransformScale(self.photoContainerImgView.transform, recognizer.scale, recognizer.scale);
       // NSLog(@"Affine Transform %f,", _photoContainerImgView.transform.tx);
        _photoContainerImgView.frame= tf;
        imageFrame =tf;
        
    }
       recognizer.scale = 1;
}



-(void)viewWillAppear:(BOOL)animated{
    [self hideAll];
    [self manageOrientation];
}


-(ContentPack *)searchForContentPack:(NSString *)contentPackName{
    SharedStore * sharedStore = [SharedStore sharedStore];
    NSMutableArray * array = [sharedStore updateItems];
    
   // NSLog(@"All Items %@ ",array);
    for(ContentPack * cp in array)
    {
//        NSLog(@"Common Name %@ ",cp.commonName);
//        NSLog(@"Content %@ ",cp.freeContent.images);
        if ([cp.commonName isEqualToString:contentPackName]) {
            
//            NSLog(@"Matched!");
            return cp;
        }
        
    }
    return nil;
}



-(void)manageOrientation{
    
    self.photoContainerImgView.center =  self.view.center;
    
    /*
     CGRect pFrame =  CGRectMake(86, 146, 595, 706);
     CGRect lFrame =  CGRectMake(155, 107, 706, 587);
  
    UIView * t= _photoContainerImgView;// recognizer.view;
    CGPoint center = [recognizer translationInView:[t superview]];
    //[t setCenter:CGPointMake(t.center.x + center.x, t.center.y + center.y)];
    //  t.transform =    CGAffineTransformTranslate(self.photoContainerImgView.transform, center.x, center.y);
    
    imageFrame =   CGRectApplyAffineTransform(imageFrame, CGAffineTransformTranslate(self.photoContainerImgView.transform, center.x, center.y));
    self.photoContainerImgView.frame = imageFrame;

    
    if([self deviceIsAnIPad]){
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
       
        [UIView animateWithDuration:0.2 animations:^{
             self.applicationFrame.image = [UIImage imageNamed:@"ApplicationFrame"];
             self.photoContainerImgView.frame = lFrame;
             self.frameContainerImageView.frame =lFrame;
            
            
        } completion:^(BOOL finished){
            self.photoContainerImgView.frame = lFrame;
            self.frameContainerImageView.frame =lFrame;
        }];
    
        }
        else{
        [UIView animateWithDuration:0.2 animations:^{
            self.applicationFrame.image = [UIImage imageNamed:@"ApplicationFramePortrait"];
            self.photoContainerImgView.frame = pFrame;
            self.frameContainerImageView.frame =pFrame;

        } completion:^(BOOL finished){
            self.photoContainerImgView.frame = pFrame;
            self.frameContainerImageView.frame =pFrame;
        }];
        }
    }
    else{
        self.applicationFrame.image = nil;
        float bannerh = 30.0;
        float buttonsh = 30.0;

       // NSLog(@"Bounds %fFrame %f ",self.view.bounds.size.width, self.view.frame.size.width);
        CGRect piFrame = CGRectMake(0, bannerh*3, self.view.bounds.size.width, self.view.bounds.size.height - 6 *  bannerh);
        CGRect liFrame = CGRectMake(3 *buttonsh, bannerh, self.view.bounds.size.width-6 * buttonsh, self.view.bounds.size.height - buttonsh - bannerh);
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            self.photoContainerImgView.frame = liFrame;
            self.frameContainerImageView.frame = liFrame;
            
        }
        else{
            self.photoContainerImgView.frame = piFrame;
            self.frameContainerImageView.frame =piFrame;
        }
    }
     */
}


-(void)viewDidAppear:(BOOL)animated{
    	imageFrame = self.photoContainerImgView.frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.panGestureRecognizer =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPanOn:)];
    self.pinchGestureRecognizer =[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(viewPinchOn:)];
    
    [self.frameContainerImageView addGestureRecognizer:self.panGestureRecognizer];
    [self.frameContainerImageView addGestureRecognizer:self.pinchGestureRecognizer];
    
    self.frameContainerImageView.userInteractionEnabled = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
     self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTappedOn:)];
    [self.tapGesture setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:self.tapGesture];
    
    if(!_filterEffects){
        _filterEffects = [[FilterEffects alloc]init];
    }
    if(!_filterPack){
        _filterPack = [[FiltersPack alloc]init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveImageNotification:)
                                                 name:@"ImageNotification"
                                               object:nil];
    SharedStore * st =[SharedStore sharedStore];
    st.delegate =self;
    _manager = [Manager sharedManager];
    _manager.defaultImage = self.photoContainerImgView.image;
    [self manageOrientation];
}

-(void)purchaseCompleted{
    [self.framesCollectionView reloadData];
}

-(void) receiveImageNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"ImageNotification"])
    {
       
        [UIView animateWithDuration:0.5 animations:^{
            self.photoContainerImgView.image= notification.object;
            
        } completion:^(BOOL finished){
        }];
 
//        if ([self amIAnIPad]) {
//            if([filtersPopover isPopoverVisible]){
//                [filtersPopover dismissPopoverAnimated:YES];
//            }
//        }
//        else{
//            [filters dismissViewControllerAnimated:YES completion:nil];
//        }
   }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self manageOrientation];
    [self hideAll];
}

     
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
      
}

#pragma mark Collection View
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //need a quick check if we already bought it.
    if([self.framesCollectionView isEqual:collectionView]){
        if([MKStoreManager isFeaturePurchased:self.currentContentPack.key])
        {
            return 1;
        }
            else{
    
            return 2;//
            }
    }
    else{
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if([self.framesCollectionView isEqual:collectionView]){

        if(section ==0)
        {
            return self.currentContentPack.freeContent.thumbnails.count;
        }
    else{
        return self.currentContentPack.premiumContent.thumbnails.count;
        }
        return 0;

    }
    else{
        NSLog(@"FIlters pack %d",self.filterPack.filtersImages.count);
        
       return  self.filterPack.filtersImages.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if([collectionView isEqual:_framesCollectionView]){
        FrameCell * cell =   [collectionView dequeueReusableCellWithReuseIdentifier:kFrameCellId forIndexPath:indexPath];
  
    if(indexPath.section==0){
        cell.photoFrame.image = [self.currentContentPack.freeContent.thumbnails objectAtIndex:indexPath.row];
        cell.locked= false;
     return cell;
    }
    else{
        
        cell.photoFrame.image = [self.currentContentPack.premiumContent.thumbnails objectAtIndex:indexPath.row];
        cell.locked= true;
    }
        return cell;
    }
    
    else{
        EffectCell * cell =   [collectionView dequeueReusableCellWithReuseIdentifier:kEffectCellId forIndexPath:indexPath];
        cell.photo.image = [UIImage imageNamed:[self.filterPack.filtersImages objectAtIndex:indexPath.row]];
        cell.effectLabel.text = [self.filterPack.filtersNames objectAtIndex:indexPath.row];

        return cell;
    }
       
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([collectionView isEqual:self.framesCollectionView]){
        if(indexPath.section==0){
            [UIView animateWithDuration:0.5 animations:^{
                self.frameContainerImageView.image = [self.currentContentPack.freeContent.images objectAtIndex:indexPath.row];

            } completion:^(BOOL finished){
                _manager.defaultFrame = [self.currentContentPack.freeContent.images objectAtIndex:indexPath.row];
            }];

        self.framesButon.selected = YES;
            
        }
        else{
            [self performSegueWithIdentifier:@"openStoreId" sender:nil];
        
        }
    }
    else{
       
        self.filterEffects.image = _manager.defaultImage;
        [self.filterEffects filterSelected:[CIFilter filterWithName:[self.filterPack.filters objectAtIndex:indexPath.row]]];
    
    }
}


- (IBAction)framesButtonAction:(id)sender {
    UIButton * button = (UIButton *)sender;
     button.selected = !button.selected;
    if(!button.selected){
        [UIView animateWithDuration:1 animations:^{
            self.frameContainerImageView.image = nil;
        } completion:^(BOOL finished){
        }];
    }
    else{
        [UIView animateWithDuration:1 animations:^{
            self.frameContainerImageView.image = _manager.defaultFrame;
        } completion:^(BOOL finished){
        }];
    }
}

#pragma mark Camera
#pragma mark camera methods
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO))
    {   UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"We were not able to find a camera on this device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    if([self deviceIsAnIPad]){
    if(!cameraPopoverController.isPopoverVisible){
        cameraPopoverController=[[UIPopoverController alloc]initWithContentViewController:cameraUI];
        [cameraPopoverController presentPopoverFromRect:self.framesButon.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    }
    else{
        [self presentViewController:cameraUI animated:YES completion:nil];
    
    }
    return YES;
}

- (BOOL) startCameraControllerPickerViewController: (UIViewController*) controller
                                     usingDelegate: (id <UIImagePickerControllerDelegate,
                                                     UINavigationControllerDelegate>) delegate {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO )
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"We were not able to use photo album on this device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:
                          UIImagePickerControllerSourceTypePhotoLibrary];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    if([self deviceIsAnIPad]){
    if(!cameraPopoverController.isPopoverVisible){
        
        cameraPopoverController=[[UIPopoverController alloc]initWithContentViewController:cameraUI];
        
        [cameraPopoverController presentPopoverFromRect:self.framesButon.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    }
    else{
        [self presentViewController:cameraUI animated:YES completion:nil];
        
    }

    return YES;
}



// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    //  NSLog(@"Did Finish Picking");
    UIImage *originalImage, *editedImage;
    UIImage * imageToUse;
    // Handle a still image capture
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToUse = editedImage;
            
            
        } else {
            imageToUse = originalImage;
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [cameraPopoverController dismissPopoverAnimated:YES];

   // [self addGesturesToView:photo];
    self.photoContainerImgView.image = imageToUse;
    _manager.defaultImage = imageToUse;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
    
    if([actionSheet isEqual:photoAction]){
        if(buttonIndex==0) // make photo
        {
            [self startCameraControllerFromViewController:self usingDelegate:self];
            
        }
        else//pick photo
        {
            [self startCameraControllerPickerViewController:self usingDelegate:self];
            
        }
    }
    if([actionSheet isEqual:shareAction]){
        UIImage * resultImage = [self createScreenshot];
        SocialHelper * helper = [[SocialHelper alloc]init];
        //Create image from Current Canvas
        NSString * urlString = @"https://itunes.apple.com/us/app/ipicture-frames-lt/id508059391?ls=1&mt=8";
        
        NSURL *  url = [NSURL URLWithString:urlString];
        
        if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Email"])
        {
            MFMailComposeViewController  * mf=[[MFMailComposeViewController alloc]init];
            mf.mailComposeDelegate=self;
            
            //Setting Subject
            NSMutableString * body=[[NSMutableString alloc]initWithCapacity:0];
            NSString * tempString= [NSString stringWithFormat:@"<a href=\"%@\">Download App!</a>\n",urlString];
            [body appendString:tempString];
            
            [mf setSubject:@"Hey, look at this!"];
            [mf setMessageBody:body isHTML:YES];
            
            //Adding Image
            NSData *imageData = UIImagePNGRepresentation(resultImage);
            [mf addAttachmentData:imageData mimeType:@"image/png" fileName:@"Image"];
            [self presentViewController:mf animated:YES completion:nil];
        }
        
        if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Twitter"])
        {
            [helper postMessage:@"Message" image:resultImage  andURL:url forService:SLServiceTypeTwitter andTarget:self];
        }
        if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Save to Album"])
        {
//            resultImage
           

            UIImageWriteToSavedPhotosAlbum(resultImage, self, @selector(image:didFinishWithError:contextInfo:), nil);
        }
        if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Facebook"])
        {
            [helper postMessage:@"Message" image:resultImage  andURL:url forService:SLServiceTypeFacebook andTarget:self];
            
        }
        if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Sina Weibo"])
        {
            [helper postMessage:@"Message" image:resultImage  andURL:url forService:SLServiceTypeSinaWeibo andTarget:self];
            
        }
    }
}

- (void) image: (UIImage *) image
didFinishWithError: (NSError *) error
   contextInfo: (void *) contextInfo{
    if(error!=nil)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Image couldn't be saved at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    }
    else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Image was successfully saved." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark email
- (void)mailComposeController:(MFMailComposeViewController *)controller

          didFinishWithResult:(MFMailComposeResult)result

                        error:(NSError *)error

{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    
}


- (IBAction)photoAction:(id)sender {
    
    photoAction=[[UIActionSheet alloc]initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Photo", @"Photo Library", nil];
    [photoAction showInView:self.view];
}

- (IBAction)shareAction:(id)sender {
    shareAction=[[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    
    if([MFMailComposeViewController canSendMail])
    {
        [shareAction addButtonWithTitle:@"Email"];
    }
    [shareAction addButtonWithTitle:@"Twitter"];
    
    [shareAction addButtonWithTitle:@"Save to Album"];
    [shareAction addButtonWithTitle:@"Facebook"];
    [shareAction addButtonWithTitle:@"Sina Weibo"];
    
    [shareAction showInView:self.view];
    
}



#pragma mark banner
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLayoutSubviews
{
    [self layoutAnimated:[UIView areAnimationsEnabled]];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutAnimated:YES];
}

- (void)layoutAnimated:(BOOL)animated
{
    // As of iOS 6.0, the banner will automatically resize itself based on its width.
    // To support iOS 5.0 however, we continue to set the currentContentSizeIdentifier appropriately.
    //CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        //       contentFrame.size.height = _bannerView.frame.size.height;
        bannerFrame.origin.y =0;// contentFrame.size.height;
    } else {
        bannerFrame.origin.y =  -_bannerView.frame.size.height;// contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        _bannerView.frame = bannerFrame;
    }];
}

-(UIImage *)createScreenshot{
    UIImage * resultImage;
    float xo = self.frameContainerImageView.frame.origin.x;
    float yo = self.frameContainerImageView.frame.origin.y;
    float wo = self.frameContainerImageView.frame.size.width;
    float ho = self.frameContainerImageView.frame.size.height;
    
    float xi = imageFrame.origin.x;
    float yi = imageFrame.origin.y;
    float wi = imageFrame.size.width;
    float hi = imageFrame.size.height;
    
    float aspect;
    float hnew;
    float wnew;
    
    NSLog(@"%f %f %f %f %f %f  ",xi, yi,wo,ho, wi,hi);
    //Calculate new size

    aspect = ho/wo;
    if(ho>wo){ // portrait
        hnew =800.0;
        wnew= 800.0 * wo/ho;
    }
    else{
        wnew =800.0;
        hnew= 800.0 * ho/wo;
    }
    
    float wScaleAspect = wnew/wo;
    float hScaleAspect = hnew/ho;
    //Will be used for drawing final images in and resizing the images.
    CGSize newSize = CGSizeMake(wnew, hnew);
    float wt = wi * wScaleAspect;
    float ht = hi * hScaleAspect;
    
    NSLog(@"W %f H %f %f",wt, ht,wScaleAspect);
    NSLog(@"W %f H %f %f ",wnew, hnew, hScaleAspect);
    //Resize to the frame...
    UIImage * photoImage =   [self.photoContainerImgView.image imageByScalingProportionallyToSize:CGSizeMake(wt, ht)];
    
    //Scaling coordinates
    xo *=wScaleAspect;
    yo *=wScaleAspect;
    wo *=wScaleAspect;
    ho *=wScaleAspect;
    
    xi *=wScaleAspect;
    yi *=wScaleAspect;
    wi *=wScaleAspect;
    hi *=wScaleAspect;
    
    //Checking the cases:
    // 1
    CGRect cropFrame;
    CGRect drawFrame;
    if(xi<=xo&&yi<=yo)
    {
        float dx =(xo-xi);//*wScaleAspect;
        float dy =(yo-yi);//*hScaleAspect;
        float dw =(wi - dx);//*wScaleAspect;
        float dh =(hi - dy);//*hScaleAspect;
        
        cropFrame = CGRectMake(dx, dy, dw, dh);
        drawFrame = CGRectMake(0, 0, dw, dh);
    }
// 2
    if(xi>=xo&&yi<=yo)
    {
        float dx =(xi-xo);
        float dy =(yo-yi);
        float dw =(wo - dx);
        float dh =(hi - dy);
        
        cropFrame = CGRectMake(0, dy, dw, dh);
        drawFrame = CGRectMake(dx, 0, dw, dh);
    }
    // 3
    if(xi<=xo&&yi>yo)
    {
        float dx =(xo-xi);
        float dy =(yi-yo);
        float dw =(wi - dx);
        float dh =(ho - dy);
        
        cropFrame = CGRectMake(dx, 0, dw, dh);
        drawFrame = CGRectMake(0, dy, dw, dh);
    }
// 4
    if(xi>=xo&&yi>yo)
    {
        float dx =(xi-xo);
        float dy =(yi-yo);
        float dw =(wo - dx);
        float dh =(ho - dy);
        
        //Rect is inside the frame and doesn't interact
        if(wi<wo&&hi<ho)
        {
          //  NSLog(@"Case Inside Inside %f %f %f %f",dx,dy,dw,dh);
            
            cropFrame =CGRectMake(0, 0, wi, hi);
            drawFrame = CGRectMake(dx, dy, wi, hi);
        }
        else{
            cropFrame = CGRectMake(0, 0, dw, dh);
            drawFrame = CGRectMake(dx, dy, dw, dh);
        }
    }
    
    
    CGRect newFrame = CGRectZero;
    newFrame.size = newSize;
    
    photoImage = [photoImage crop:cropFrame];
    
    UIImage *  frameImage = [UIImage imageWithImage:self.frameContainerImageView.image scaledToSize:newFrame.size];
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    if(photoImage){
        [photoImage drawInRect:drawFrame];
    }
    
    if(frameImage){
        [frameImage drawInRect:newFrame];
    }
    
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData * pngData = UIImagePNGRepresentation(resultImage);
    resultImage = [UIImage imageWithData:pngData];

     return resultImage;
}





@end
