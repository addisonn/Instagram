//
//  Reply.m
//  Instagram
//
//  Created by addisonz on 7/11/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

// not used!

#import "Reply.h"

@implementation Reply

- (instancetype)initWithText:(NSString *)replyText andUser: (PFUser *)user {
    self = [super init];
    if (self) {
        self.replyText = replyText;
        self.user = PFUser.currentUser;
        
    }
    return self;
}



@end
