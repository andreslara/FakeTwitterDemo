//
//  TwitterAPI.h
//  Super Twitter
//
//  Created by Andres Lara Aguirre on 2016-01-24.
//  Copyright © 2016 Andres Lara. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ASYNC(...) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ __VA_ARGS__ })
#define ASYNC_MAIN(...) dispatch_async(dispatch_get_main_queue(), ^{ __VA_ARGS__ })

typedef void (^LoginResponsenHandler)(BOOL success, NSString *errorMessage);
typedef void (^SendTweetResponsenHandler)(BOOL success, NSString *errorMessage, NSString *tweetContent, NSInteger tweetId, NSDate *date);
typedef void (^GetTweetsResponsenHandler)(BOOL success, NSString *errorMessage, NSArray *tweetArray);

@interface TwitterAPI : NSObject

+ (instancetype)sharedInstance;
/*!
 Returns success = YES for username = username and password = password
*/
-(void)login:(NSString*)userName password:(NSString*)password responseHandler:(LoginResponsenHandler)responseHandler;

/*!
Fakes error 20% of the time.
 */
-(void)sendTweet:(NSString*)tweetContent responseHandler:(SendTweetResponsenHandler)responseHandler;

/*!
 Fakes error 20% of the time.
 */
-(void)getTweetsAfterIdentifier:(NSInteger)identifier responseHandler:(GetTweetsResponsenHandler)responseHandler;

@end
