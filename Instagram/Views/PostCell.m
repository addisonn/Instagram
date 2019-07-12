//
//  PostCell.m
//  Instagram
//
//  Created by addisonz on 7/9/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // set profile pic and username to be clickable and activate the function didTap
    // question : why do u need a unique tap gesture recognizer for both?
    UITapGestureRecognizer *profileTapGestureRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePic addGestureRecognizer:profileTapGestureRecognizer1];
    [self.profilePic setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *profileTapGestureRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.username addGestureRecognizer:profileTapGestureRecognizer2];
    [self.username setUserInteractionEnabled:YES];
}

// helper function for set picture in the post cell
- (void)setPic:(Post *) post {
    PFFileObject *imageFile = post.image;
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [self.picView setImage:image];
        }
    }];
}

// helper function for set profile pic in the cell
- (void)setProfile:(Post *) post {
    [self.profilePic setImage:[UIImage imageNamed:@"profile-placeholder"]];
    PFFileObject *profilePicFile = post.author[@"profilePic"];
    
    [profilePicFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            [self.profilePic setImage:image];
        }
    }];
}

// system function
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    // Call method on delegate when tapped
    [self.delegate postCell:self didTap:self.post.author];
    
}

@end
