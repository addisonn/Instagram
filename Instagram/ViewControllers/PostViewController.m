//
//  PostViewController.m
//  Instagram
//
//  Created by addisonz on 7/9/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import "PostViewController.h"
#import "ReplyCell.h"
#import "Reply.h"

@interface PostViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UITextField *replyText;
@property (weak, nonatomic) IBOutlet UITableView *replyTable;
@property (strong, nonatomic) NSArray *replies;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;



@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.tappedPost[@"replies"]);
    
    // Do any additional setup after loading the view.
    self.username.text = self.tappedPost.author.username;
    self.caption.text = self.tappedPost.caption;
    self.likeCount.text = [NSString stringWithFormat:@"%@", self.tappedPost[@"likeCount"]];
    
    // Format createdAt date string
    NSDate *createdAt = self.tappedPost.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    // Convert Date to String
    self.time.text = [formatter stringFromDate:createdAt];
    
    // profile pic setting and styling
    [self.profilePic setImage:[UIImage imageNamed:@"profile-placeholder"]];
    PFFileObject *profilePicFile = self.tappedPost.author[@"profilePic"];
    
    [profilePicFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            [self.profilePic setImage:image];
        }
    }];
    
    self.profilePic.layer.cornerRadius = 20;
    self.profilePic.layer.masksToBounds = YES;
    
    PFFileObject *imageFile = self.tappedPost[@"image"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [self.picView setImage:image];
        }
    }];
    
    // for keyboard to go away
    self.replyText.delegate = self;
    
    // set up for reply table
    self.replyTable.dataSource = self;
    self.replyTable.delegate = self;
    
    [self fetchReplies];
    
    // tableview styling
    [self.replyTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.replyTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (IBAction)didReply:(id)sender {
    
    PFObject *reply = [PFObject objectWithClassName:@"Replies"];

    // Use the name of your outlet to get the text the user typed
    reply[@"text"] = self.replyText.text;
    reply[@"user"] = PFUser.currentUser;
    reply[@"post"] = self.tappedPost;

    [reply saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.replyText.text = @"";
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    
    // alternate way of adding reply - question!
    
//    Reply *reply = [[Reply alloc] initWithText:self.replyText.text andUser:PFUser.currentUser];
//
//    if(self.tappedPost[@"replies"] == nil) {
//        self.tappedPost[@"replies"] = [NSMutableArray new];
//    }
//
//
//    [self.tappedPost[@"replies"] insertObject:@"reply" atIndex:0];
//
//    NSLog(@"%@", self.tappedPost[@"replies"]);
//
//    [self.tappedPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if(succeeded) {
//            NSLog(@"😎😎😎 Successfully added reply");
//            self.replyText.text = @"";
//             NSLog(@"%@", self.tappedPost[@"replies"]);
//        } else {
//            NSLog(@"😫😫😫 Error adding reply: %@", error.localizedDescription);
//        }
//
//    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)fetchReplies {
    
    NSLog(@"%@", self.tappedPost[@"replies"]);
    
    PFQuery *query = [PFQuery queryWithClassName:@"Replies"];
    [query includeKey:@"post"];
    [query includeKey:@"user"];
    [query whereKey:@"post" equalTo:self.tappedPost];
    [query orderByDescending:@"createdAt"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *replies, NSError *error) {
        if (replies != nil) {
            // do something with the array of object returned by the call
            NSLog(@"successful");
            self.replies = replies;
            [self.replyTable reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyCell" forIndexPath:indexPath];
    PFObject *reply = self.replies[indexPath.row];
    
    //    // for profile segue delegate (click to see profile)
    //    cell.delegate = self;
    
    // set up components in the cell
    NSString *username = (reply[@"user"])[@"username"];
    cell.username.text = [@"@" stringByAppendingString:username];;
    cell.reply.text = reply[@"text"];
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.replies.count;
}

- (IBAction)likePost:(id)sender {
    
    if (self.tappedPost[@"likedUsers"] == nil) {
        self.tappedPost[@"likedUsers"] = [NSMutableArray new];
    }
    
    NSMutableArray *likedUsers = self.tappedPost[@"likedUser"];

    if(likedUsers && [likedUsers containsObject:PFUser.currentUser]) {
        [likedUsers removeObject:PFUser.currentUser];
        UIImage *unlikeImage = [UIImage imageNamed:@"favor-icon"];
        [self.likeButton setImage:unlikeImage forState:UIControlStateNormal];
        
    } else {
        [likedUsers addObject:PFUser.currentUser];
        UIImage *likeImage = [UIImage imageNamed:@"favor-icon-red"];
        [self.likeButton setImage:likeImage forState:UIControlStateNormal];
//        NSInteger *likeCount = self.tappedPost[@"likedUser"];
//        self.tappedPost[@"likedUser"] = likeCount + 1;
        
    }
    
    [self.tappedPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded) {
                    NSLog(@"😎😎😎 Successfully added reply");
                } else {
                    NSLog(@"😫😫😫 Error adding reply: %@", error.localizedDescription);
                }
        
    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
