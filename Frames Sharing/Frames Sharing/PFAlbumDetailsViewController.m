//
//  PFAlbumDetailsViewController.m
//  Frames Sharing
//
//  Created by sadmin on 3/14/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFAlbumDetailsViewController.h"
#import "PFExploreCell.h"
#import "Manager.h"
#import "Photo.h"
#import "AlbumDetailsData.h"


@interface PFAlbumDetailsViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *privacySegmentedControl;
@property (strong, nonatomic) IBOutlet UIButton *trashButton;

@end

@implementation PFAlbumDetailsViewController
AlbumDetailsData * albumDetails;
Manager * manager;
NSMutableArray * photoArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    albumDetails = [[AlbumDetailsData alloc]init];
    albumDetails.storyboard= self.storyboard;
    albumDetails.navigationController = self.navigationController;
    self.collectionView.dataSource = albumDetails;
    self.collectionView.delegate = albumDetails;

    
    manager = [Manager sharedInstance];
    [manager.ff setAutoLoadBlobs:NO];
    albumDetails.manager =manager;

    if(!photoArray){
        photoArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    else{
        [photoArray removeAllObjects];
    }
    [manager getPhotosForAlbum:self.albumGuid];
    
      NSLog(@"album userid %@ and manager.user %@",self.album.userId, [manager getGUID:manager.user]);
    
    if([self.album.userId isEqualToString: [manager getGUID:manager.user]])
    {
        self.privacySegmentedControl.selectedSegmentIndex= 1;

        if(self.album.isPublic)
        {
            self.privacySegmentedControl.selectedSegmentIndex= 0;
            
        }
      
        
    }
    else{
        self.trashButton.hidden = YES;
        self.privacySegmentedControl.hidden = YES;
        
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photosRetrieved:) name:photosRetrievedNotification object:nil];
}


- (IBAction)removeAlbum:(id)sender {
    [manager delete:self.album];
}


- (IBAction)privacyChanged:(id)sender {
    if(self.privacySegmentedControl.selectedSegmentIndex==0){
        self.album.isPublic = YES;
    }
    else{
        self.album.isPublic = NO;
        for (Photo * p in photoArray){
            p.isPublic = NO;
            [manager updateObject:p];
        }
    }
    
    [manager updateObject:self.album];
}



-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}


-(void)photosRetrieved:(NSNotification *)notification{
    NSLog(@"Received Photos %@",notification.object);
    if(notification.object){
        photoArray =[NSMutableArray arrayWithArray:notification.object];
        albumDetails.photoArray= photoArray;
    }
    [self.collectionView reloadData];
    
}
/*
-(void)downloadedPhotoFile:(Photo *)file forIndex:(NSIndexPath *)indexPath{
    
    PFExploreCell * cell =(PFExploreCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
   
    UIImage * thumbnail = [UIImage imageWithData:file.thumbnailImageData];

    cell.imageView.image = thumbnail;
    Photo * pf = [photoArray objectAtIndex:indexPath.row];
    if(photoArray){
        [photoArray replaceObjectAtIndex:indexPath.row withObject:pf];
            
    }
}
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate




@end
