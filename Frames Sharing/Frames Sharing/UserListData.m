//
//  UserListData.m
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 4/24/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "UserListData.h"
#import "User.h"

@implementation UserListData

User * photoOwner;

-(id)init{
    self = [super init];
    if(self){
        manager = [Manager sharedInstance];
    }
    return self;
}

-(void)photoOwnerFound:(NSNotification *)n{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


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
    cell.imageView.image = [UIImage imageNamed:@"albumSmallIcon"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // Album * album = (Album *)self.objects[indexPath.row];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
       // [manager getPhotosForAlbum:[manager getGUID:album]];
    }
    else{
//        PFAlbumDetailsViewController * vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"PFAlbumDetailsViewController"];
//        vc.album =album;
//        vc.albumGuid = [manager getGUID:album];
        
       // [self.navigationController pushViewController:vc animated:YES];
    }
}





@end
