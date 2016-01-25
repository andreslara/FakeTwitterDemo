//
//  TwitterAPI.m
//  Super Twitter
//
//  Created by Andres Lara Aguirre on 2016-01-24.
//  Copyright © 2016 Andres Lara. All rights reserved.
//

#import "TwitterAPI.h"
#define kLastTweetId @"lastTweetId"
@implementation TwitterAPI

static TwitterAPI* _sharedInstance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[TwitterAPI alloc] _initPrivate];
    });
    return _sharedInstance;
}

- (id)init {
    NSAssert(NO, @"Use sharedInstance.");
    self = nil;
    return self;
}

- (id)_initPrivate {
    if (self = [super init]) {
    }
    return self;
}

-(void)login:(NSString*)userName password:(NSString*)password responseHandler:(LoginResponsenHandler)responseHandler{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(responseHandler){
            if([userName isEqualToString:@"username"] && [password isEqualToString:@"password"]){
                responseHandler(YES, @"");
            }
            else{
                responseHandler(NO, @"Incorrect credentials.");
            }
        }
    });
}

-(void)sendTweet:(NSString*)tweetContent responseHandler:(SendTweetResponsenHandler)responseHandler{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(responseHandler){
            NSInteger randomNumber = 1 + rand() % (5); //Random number between 1 and 5 to simulate error in 1 out of 5 calls.
            if(randomNumber < 5){
                NSInteger lastId = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastTweetId] integerValue];
                [[NSUserDefaults standardUserDefaults] setObject:@(lastId+1) forKey:kLastTweetId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                responseHandler(YES, @"", tweetContent, lastId+1, [NSDate date]);
            }
            else{
                responseHandler(NO, @"Error trying to send. Try again later", nil, -1, nil);
            }
        }
    });
}

-(void)getTweetsAfterIdentifier:(NSInteger)identifier responseHandler:(GetTweetsResponsenHandler)responseHandler{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(responseHandler){
            NSInteger randomNumber = 1 + rand() % (5); //Random number between 1 and 5 to simulate error in 1 out of 5 calls.
            if(randomNumber < 5){
                NSDictionary *tweetDictionary = @{@"identifier":@(identifier+1), @"tweetContent":@"Tweet from server.", @"date":[NSDate date]};
                [[NSUserDefaults standardUserDefaults] setObject:@(identifier+1) forKey:kLastTweetId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                responseHandler(YES, nil, @[tweetDictionary]);
            }
            else{
                responseHandler(NO, @"Error retrieveing tweets", nil);
            }
        }
    });
}

@end
