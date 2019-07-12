//
//  ProfileViewController.h
//  Instagram
//
//  Created by addisonz on 7/10/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"


NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
