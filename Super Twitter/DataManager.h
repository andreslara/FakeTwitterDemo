//
//  DataManager.h
//  Super Twitter
//
//  Created by Andres Lara Aguirre on 2016-01-25.
//  Copyright © 2016 Andres Lara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

+ (instancetype)sharedInstance;
-(BOOL)isLoggedIn;

-(void)loginAsUser:(NSString*)user;
-(void)logout;

-(NSFetchRequest*)fetchRequestForAllTweets;
-(NSEntityDescription*)entityDescriptionForTweet;
- (NSManagedObjectContext *)managedObjectContext;
-(void)refreshTweetsAfterLastIdentifier:(NSInteger)lastIdentifier;
-(NSArray*) getAllTweets;
-(BOOL) addTweet:(NSString*)tweetContent date:(NSDate*)date identifier:(NSInteger)identifier;
- (void)saveContext;
@end
