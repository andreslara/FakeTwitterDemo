//
//  DataManager.m
//  Super Twitter
//
//  Created by Andres Lara Aguirre on 2016-01-25.
//  Copyright © 2016 Andres Lara. All rights reserved.
//

#import "DataManager.h"
#import "TwitterAPI.h"
#import "Tweet.h"

#define kUserKey @"user"
@interface DataManager()
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DataManager
static DataManager* _sharedInstance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DataManager alloc] _initPrivate];
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

-(BOOL)isLoggedIn{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserKey];
}
-(void)loginAsUser:(NSString*)user{
    if(user){
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:kUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)logout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)refreshTweetsAfterLastIdentifier:(NSInteger)lastIdentifier{
    [[TwitterAPI sharedInstance] getTweetsAfterIdentifier:lastIdentifier responseHandler:^(BOOL success, NSString *errorMessage, NSArray *tweetArray) {
        if(success){
            for(NSDictionary *dict in tweetArray){
                NSInteger identifier = [dict[@"identifier"] integerValue];
                if(![self tweetWithIdentifierExists:identifier]){
                    NSString *tweetContent = dict[@"tweetContent"];
                    NSDate *date = dict[@"date"];
                    [self addTweet:tweetContent date:date identifier:identifier];
                }
                else{
                    NSLog(@"Received a tweet with an id already known by client");
                }
            }
        }
        else{
            NSLog(@"Error in %s identifier = %lu", __PRETTY_FUNCTION__, lastIdentifier);
        }
    }];
}

-(NSEntityDescription*)entityDescriptionForTweet{
    return [NSEntityDescription
            entityForName:@"Tweet" inManagedObjectContext:[self managedObjectContext]];
}
-(NSFetchRequest*)fetchRequestForAllTweets{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [self entityDescriptionForTweet];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:@[sort]];
    return fetchRequest;
}
-(NSArray*) getAllTweets{
    NSFetchRequest *fetchRequest = [self fetchRequestForAllTweets];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];

    return fetchedObjects;
}
-(BOOL) addTweet:(NSString*)tweetContent date:(NSDate*)date identifier:(NSInteger)identifier{
    if([self tweetWithIdentifierExists:identifier]){
        NSLog(@"A tweet with that identiier already exists. %lu",identifier);
        return NO;
    }
    if(tweetContent.length == 0 || date == nil || identifier < 0){
        NSLog(@"Invalid parameters.");
        return NO;
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    Tweet *tweet = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Tweet"
                                      inManagedObjectContext:context];
    tweet.text = tweetContent;
    tweet.date = date;
    tweet.identifier = @(identifier);
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Could not add tweet: %@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

-(BOOL)tweetWithIdentifierExists:(NSInteger)identifier{
    NSArray *fetchedObjects;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [self entityDescriptionForTweet];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"identifier == %d",identifier]];
    NSError * error = nil;
    fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetch error:&error];
    return [fetchedObjects count] > 0;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "andreslara.Super_Twitter" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Super_Twitter" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    // Create the coordinator and store

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Super_Twitter.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
