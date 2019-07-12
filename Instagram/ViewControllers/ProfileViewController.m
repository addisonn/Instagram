//
//  ProfileViewController.m
//  Instagram
//
//  Created by addisonz on 7/10/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import "ProfileViewController.h"
#import "PostCollectionCell.h"
#import "Post.h"
#import "Parse/Parse.h"
#import "PostViewController.h"


@interface ProfileViewController ()  <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (nonatomic, strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIImage *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // for profile page
    if(!self.user) {
        self.user = PFUser.currentUser;
    }
    
    // set up username info
    self.usernameLabel.text = self.user.username;
    self.navigationItem.title = [@"@" stringByAppendingString:self.user.username];

    // setting up profile pic
    PFFileObject *imageFile = self.user[@"profilePic"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [self.profileButton setImage:image forState:UIControlStateNormal];
        }
    }];
    
    // set up UI for the collection view (user posts) and fetch data
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    CGFloat posterPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (posterPerLine - 1)) / posterPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self fetchProfile];
    
}

// query for all the posts uploaded by this user
- (void)fetchProfile {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:self.user];
    [query orderByDescending:@"createdAt"];
    
    // fetch all posts by current user asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"😎😎😎 Successfully fetched posts from user");
            self.posts = [NSMutableArray arrayWithArray:posts];
            self.postLabel.text = [NSString stringWithFormat:@"%lu", self.posts.count];;
            [self.collectionView reloadData];
            
        } else {
            NSLog(@"😫😫😫 couldn't fetch post for some reason: %@", error.localizedDescription);
        }
    }];
}

// set up for collection view
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.item];
    
    PFFileObject *imageFile = post[@"image"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [cell.postImageCell setImage:image];
        }
    }];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

// initialize/update profile pics
- (IBAction)changeProfile:(id)sender {
    // set up image picker and segue into imagepicker
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //    Get the image captured by the UIImagePickerController
    self.profilePic = info[UIImagePickerControllerEditedImage];
    
    // set new/update existing field of profile pic in database
    self.user[@"profilePic"] = [self getPFFileFromImage:self.profilePic];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"😎😎😎 Successfully updated profile picture");
            // update profile pic button image
            [self.profileButton setImage:self.profilePic forState:UIControlStateNormal];

            // Dismiss UIImagePickerController to go back to profile page
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"😫😫😫 Error updating profile picture: %@", error.localizedDescription);
        }

    }];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // pass the tapped post to the detail PostViewController
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *tappedPost = self.posts[indexPath.row];
        PostViewController *postViewController = [segue destinationViewController];
        postViewController.tappedPost = tappedPost;
}

@end
