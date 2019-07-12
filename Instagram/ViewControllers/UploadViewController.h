//
//  UploadViewController.h
//  Instagram
//
//  Created by addisonz on 7/8/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UploadViewControllerDelegate

- (void)didUpload:(Post *)post;;

@end

@interface UploadViewController : UIViewController

@property (nonatomic, weak) id<UploadViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
