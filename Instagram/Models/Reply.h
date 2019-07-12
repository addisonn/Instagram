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

@interface Reply : NSObject

// MARK: Properties
@property (nonatomic, strong) NSString *replyText; // For favoriting, retweeting & replying
@property (strong, nonatomic) PFUser *user; // Text content of tweet


- (instancetype)initWithText:(NSString *)replyText andUser: (PFUser *)user;

@end

NS_ASSUME_NONNULL_END
