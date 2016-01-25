//
//  TweetTableViewCell.m
//  Super Twitter
//
//  Created by Andres Lara Aguirre on 2016-01-25.
//  Copyright © 2016 Andres Lara. All rights reserved.
//

#import "TweetTableViewCell.h"

@interface TweetTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation TweetTableViewCell
static dispatch_once_t onceToken;
static NSDateFormatter *formatter; //Static so that it can be reused
- (void)awakeFromNib {
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M/d/yy h:mm"];
    });

}

-(void)configureText:(NSString*)text andDate:(NSDate*)date{
    self.contentLabel.text = text;
    self.dateLabel.text = [formatter stringFromDate:date];
}

@end
