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
#import "CameraPicker.h"
#import "PFSharingCenterViewController.h"


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
UIPopoverController * sharingCenterPopoverController;
UIActionSheet *  photoAction;

CameraPicker * camera;
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
  
    imageFrame =   CGRectApplyAffineTransform(imageFrame, CGAffineTransformTranslate(self.photoContainerImgView.transform, center.x, center.y));
    self.photoContainerImgView.frame = imageFrame;
    
    [recognizer setTranslation:CGPointZero inView:[t superview]];
}

-(void)viewPinchOn:(UIPinchGestureRecognizer *)recognizer{
       CGAffineTransform  transform = CGAffineTransformScale(self.photoContainerImgView.transform, recognizer.scale, recognizer.scale);
        
    CGRect tf =CGRectApplyAffineTransform(_photoContainerImgView.bounds, transform);
    CGRect fRect = self.frameContainerImageView.frame;
    
    
    if(tf.size.width <=fRect.size.width * 2 && tf.size.width>250)
    {
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
    
    for(ContentPack * cp in array)
    {
        if ([cp.commonName isEqualToString:contentPackName]) {
            return cp;
        }
        
    }
    return nil;
}



-(void)manageOrientation{
    self.photoContainerImgView.center =  self.view.center;
}


-(void)viewDidAppear:(BOOL)animated{
    	imageFrame = self.photoContainerImgView.frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    camera = [[CameraPicker alloc]init];
    
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
    _manager = [Manager sharedInstance];
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
        }];   }
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




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
    
    if([actionSheet isEqual:photoAction]){
        if(buttonIndex==0) // make photo
        {
            [camera startCameraControllerFromViewController:self usingDelegate:self from:self.framesButon picker:NO andPopover:cameraPopoverController];
        }
        else//pick photo
        {
            [camera startCameraControllerFromViewController:self usingDelegate:self from:self.framesButon picker:YES andPopover:cameraPopoverController];
            
        }
    }
}



- (IBAction)photoAction:(id)sender {
    
    photoAction=[[UIActionSheet alloc]initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Photo", @"Photo Library", nil];
    [photoAction showInView:self.view];
}

- (IBAction)shareAction:(id)sender {
    UIImage * resultImage = [self createScreenshot];
    PFSharingCenterViewController *vc;
    if([self deviceIsAnIPad])
    {
        //pick right storyboard
        UIStoryboard *iPhoneStoryboard = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
        vc = [iPhoneStoryboard instantiateViewControllerWithIdentifier:@"sharingCenterViewController"];
        vc.imageToShare = resultImage;
        //present it in popover
        if(!sharingCenterPopoverController)
        {
            sharingCenterPopoverController = [[UIPopoverController alloc]initWithContentViewController:vc];
        }
        if([sharingCenterPopoverController isPopoverVisible]){
            [sharingCenterPopoverController dismissPopoverAnimated:YES];
        }
        else{
            [sharingCenterPopoverController presentPopoverFromRect:self.framesButon.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
        
    }
    else{
        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
         vc =(PFSharingCenterViewController *) [iPadStoryboard instantiateViewControllerWithIdentifier:@"sharingCenterViewController"];
         vc.imageToShare = resultImage;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    
   // NSLog(@"W %f H %f %f",wt, ht,wScaleAspect);
   // NSLog(@"W %f H %f %f ",wnew, hnew, hScaleAspect);
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


// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
   
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
    
    self.photoContainerImgView.image = imageToUse;
    _manager.defaultImage = imageToUse;
}


@end
