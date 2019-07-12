//
//  Reply.h
//  Instagram
//
//  Created by addisonz on 7/11/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

// !!! not used model, couldn't be added to Parse because it's not a subclass of PFFIleObject
// Data organization question: how to best store replies?

@interface Reply : NSObject

// MARK: Properties
@property (nonatomic, strong) NSString *replyText;
@property (strong, nonatomic) PFUser *user;


- (instancetype)initWithText:(NSString *)replyText andUser: (PFUser *)user;

@end

NS_ASSUME_NONNULL_END
