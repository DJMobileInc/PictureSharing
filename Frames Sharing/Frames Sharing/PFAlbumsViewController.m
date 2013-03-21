//
//  PFAlbumsViewController.m
//  Frames Sharing
//
//  Created by Terry Lewis II on 3/4/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFAlbumsViewController.h"
#import "Album.h"
#import "PFAlbumDetailsViewController.h"
@interface PFAlbumsViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *objects;
@property (strong, nonatomic)NSString *albumName;
@property (strong, nonatomic) IBOutlet UIView *addAlbumView;
@property (strong, nonatomic) IBOutlet UITextField *albumTxtField;


@end

@implementation PFAlbumsViewController
Manager * manager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    manager = [Manager sharedInstance];
    manager.delegate = self;
    [manager.ff setAutoLoadBlobs:NO];
    
    if(self.user){
        [manager getAlbumsForUser:[manager.ff metaDataForObj:self.user].guid];
    }
    else{
        [manager displayMessage:@"You need to login to see the albums."];
    }

    //hide elements if not my album
    if(self.user !=manager.user){
        
    }
}


//-(IBAction)hideOrShowAlbumView{
//    float h= self.addAlbumView.frame.size.height;
//
//    [UIView animateWithDuration:1 animations:^{
//        if(self.addAlbumView.frame.origin.y == 0)
//        {
//            CGRect avoffset = CGRectOffset(self.addAlbumView.frame, 0, h);
//            CGRect toffset =  CGRectOffset(self.tableView.frame, 0, h);
//            self.tableView.frame = toffset;
//            self.addAlbumView.frame =avoffset;
//        }
//        else{
//            CGRect avoffset = CGRectOffset(self.addAlbumView.frame, 0, -h);
//            CGRect toffset =  CGRectOffset(self.tableView.frame, 0, -h);
//            self.tableView.frame = toffset;
//            self.addAlbumView.frame =avoffset;
//        }
//        
//    } completion:nil];
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.objects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlbumCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlbumCell"];
    }
    
    Album * album = (Album *)self.objects[indexPath.row];

    cell.textLabel.text =album.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   PFAlbumDetailsViewController * vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"PFAlbumDetailsViewController"];
    Album * album = (Album *)self.objects[indexPath.row];
    vc.albumGuid = [manager getGUID:album];
  
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)makeNewAlbum:(UIBarButtonItem *)sender {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Album Name" message:@"Name this album" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" , nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        self.albumName = [alertView textFieldAtIndex:0].text;
        
        NSLog(@"album name is %@ %d",self.albumName,self.albumName.length );
        
        if(self.albumName.length>0){
            [self createAlbum:self.albumName];
        }
        else{
            NSLog(@"Length is wrong ??? album name is %@ %d",self.albumName,self.albumName.length );

            [manager displayMessage:@"Don't forget about album's title."];
        }
    }
}



-(void)createAlbum:(NSString *)name{
   
    if(manager.user){
        [manager createNewAlbumOfName:name forUser:[manager getGUID:manager.user] privacy:YES];
    }
    else{
        [manager displayMessage:@"You need to be logged in to create new album on the cloud."];
    }
}

//delegate methods
-(void)createdAlbum:(Album *)album{
//    NSLog(@"Album Created: %@", album);
    [self.objects addObject:album];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.objects.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)receivedAlbums:(NSArray *)albums{
    [self.objects removeAllObjects];
    self.objects =[[NSMutableArray alloc]initWithArray:albums];
    
       [self.tableView reloadData];
    
    
    
    
}



@end
