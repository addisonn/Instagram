//
//  ReplyCell.h
//  Instagram
//
//  Created by addisonz on 7/11/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *reply;

@end

NS_ASSUME_NONNULL_END
