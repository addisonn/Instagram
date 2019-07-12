//
//  UploadViewController.m
//  Instagram
//
//  Created by addisonz on 7/8/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import "UploadViewController.h"
#import <MapKit/MapKit.h>
#import "Post.h"
#import "MBProgressHUD.h"

@interface UploadViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIImage *postImage;
@property (weak, nonatomic) IBOutlet UIButton *picButton;
@property (weak, nonatomic) IBOutlet UITextView *caption;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.caption.layer.borderWidth = 1.0f;
    self.caption.layer.borderColor = [[UIColor grayColor] CGColor];
}

// addPic opens the imagePickerController
- (IBAction)addPic:(id)sender {
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


// save the image pictured and upload button
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
//    Get the image captured by the UIImagePickerController
    self.postImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    [self.picButton setImage:self.postImage forState:UIControlStateNormal];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

// save pics to database
- (IBAction)uploadPic:(id)sender {
    
    // resizing the image
    
//    Post *p = [Post init:self.postImage withCaption:self.caption.text];
//    [p saveInBackground];
//    [self.delegate didUpload:p];
//    [self dismissViewControllerAnimated:true completion:nil];
    
    // Third party loader added
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = @"Loading";
    
    // uploading the post
    Post *p = [Post postUserImage:self.postImage withCaption:self.caption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"😫😫😫 Error uploading picture: %@", error.localizedDescription);
        } else {
            NSLog(@"😎😎😎 Successfully uploaded picture");
            [self dismissViewControllerAnimated:true completion:nil];
            [self.hud hideAnimated:YES];
        }
     }];
    
    [self.delegate didUpload:p];

}

// resize helper image
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// go back to home controller
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
