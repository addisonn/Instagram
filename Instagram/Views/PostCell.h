//
//  PostCell.h
//  Instagram
//
//  Created by addisonz on 7/9/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate;

@interface PostCell : UITableViewCell
@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setPic:(Post *) post;
- (void)setProfile:(Post *) post;

@property (nonatomic, weak) id<PostCellDelegate> delegate;

@end

// protocal for delegate when tapping the profile pic or username
@protocol PostCellDelegate

- (void)postCell:(PostCell *) postCell didTap: (PFUser *)user;

@end


NS_ASSUME_NONNULL_END
