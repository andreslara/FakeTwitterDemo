//
//  TweetTableViewCell.h
//  Super Twitter
//
//  Created by Andres Lara Aguirre on 2016-01-25.
//  Copyright © 2016 Andres Lara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetTableViewCell : UITableViewCell

-(void)configureText:(NSString*)text andDate:(NSDate*)date;
@end
