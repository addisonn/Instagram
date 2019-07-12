//
//  HomeViewController.m
//  Instagram
//
//  Created by addisonz on 7/8/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "PostCell.h"
#import "Post.h"
#import "UploadViewController.h"
#import "PostViewController.h"
#import "ProfileViewController.h"
#import "MBProgressHUD.h"
#import "DateTools.h"


@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UploadViewControllerDelegate, UIScrollViewDelegate, PostCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

// third party loader
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setting up the navigation title
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instagram"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    imageView.frame = titleView.bounds;
    [titleView addSubview:imageView];
    
    self.navigationItem.titleView = titleView;
    
    // Third party loader added
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = @"Loading";
    
    // setting up table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.isMoreDataLoading = NO;
    
    [self fetchTimeline];
    
    
    // refresh controls
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // attempt to fix glitch with reload table
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 50;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;

}

- (void)fetchTimeline {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 5;
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            NSLog(@"successful");
            self.posts = [NSMutableArray arrayWithArray:posts];
            [self.tableView reloadData];
            [self.hud hideAnimated:YES];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
}

- (IBAction)logout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        NSLog(@"User logged out successfully");
    }];
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // pass the tapped post to the detail PostViewController
    if ([segue.identifier isEqualToString:@"showDeets"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *tappedPost = self.posts[indexPath.row];
        PostViewController *postViewController = [segue destinationViewController];
        postViewController.tappedPost = tappedPost;
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    // set up delegate relationship with UploadViewController
    else if([segue.identifier isEqualToString:@"newPic"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        UploadViewController *uploadViewController = (UploadViewController*)navigationController.topViewController;
        uploadViewController.delegate = self;
    }
    // pass the tapped user to the detail PostViewController
    else if ([segue.identifier isEqualToString:@"profileSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = sender;
        
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    
    // set local copy
    cell.post = post;
    
    // for profile segue delegate (click to see profile)
    cell.delegate = self;
    
    // set up components in the cell
    [cell setPic:post];
    [cell setProfile:post];
    cell.username.text = post.author[@"username"];
    cell.content.text = post.caption;
    
    // change createdAt date to time till now string, set time label
    NSDate *createdAt = post.createdAt;
    cell.timeLabel.text = createdAt.shortTimeAgoSinceNow;

    // styling profile pic
    cell.profilePic.layer.cornerRadius = 25;
    cell.profilePic.layer.masksToBounds = YES;

    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

// delegate method for uploadViewController, refresh with new post
- (void)didUpload:(Post *)post {
    [self.posts insertObject:post atIndex:0];
    [self.tableView reloadData];
}

// UI design for lines between different table cells
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

// inplementing infinite scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            
            // fetch new data
            PFQuery *query = [PFQuery queryWithClassName:@"Post"];
            Post *mostrecent = [self.posts lastObject];
            [query whereKey:@"createdAt" lessThan:mostrecent.createdAt];
            query.limit = 5;
            [query includeKey:@"author"];
            [query orderByDescending:@"createdAt"];
            
            
            // fetch data asynchronously
            [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
                if (posts != nil && posts.count > 0) {
                    // do something with the array of object returned by the call
                    NSLog(@"successfully loaded more data");
                    [self.posts addObjectsFromArray:posts];
                    [UIView animateWithDuration:0 animations:^{
                        // attempt to fix glitch
//                        [self.tableView setContentOffset:self.tableView.contentOffset animated: false]
                        
                        [self.tableView reloadData];
                    } completion:^(BOOL finished) {
                        self.isMoreDataLoading = false;
                    }];

                } else {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
    }
    
}

// perform segue when profile pic/username is tapped 
- (void)postCell:(nonnull PostCell *)postCell didTap:(nonnull PFUser *)user {
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}


@end
