//
//  DataManagerTests.m
//  Super Twitter
//
//  Created by Andres Lara Aguirre on 2016-01-25.
//  Copyright © 2016 Andres Lara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DataManager.h"
#import "Tweet.h"
@interface DataManagerTests : XCTestCase

@end

@implementation DataManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSString *text = @"first tweet";
    NSDate *date = [NSDate date];
    NSInteger identifier = [[DataManager sharedInstance] getAllTweets].count+1; //This is assuming that the identifier increases by 1 for each new tweet.
    [[DataManager sharedInstance] addTweet:text date:date identifier:identifier];

    Tweet *tweet = [[DataManager sharedInstance] getAllTweets].firstObject;
    XCTAssert([tweet.text isEqualToString:text],@"New tweet text is not correct");
    XCTAssert([tweet.date isEqualToDate:date],@"New tweet date is not correct");
    XCTAssert([tweet.identifier integerValue] == identifier,@"New tweet identifier is not correct");

    //Nil Date
    text = @"second tweet";
    date = nil;
    identifier = [[DataManager sharedInstance] getAllTweets].count+1; //This is assuming that the identifier increases by 1 for each new tweet.
    XCTAssert(![[DataManager sharedInstance] addTweet:text date:date identifier:identifier],@"Should not add tweet with nil date");

    //Empty string
    text = @"";
    date = [NSDate date];
    identifier = [[DataManager sharedInstance] getAllTweets].count+1; //This is assuming that the identifier increases by 1 for each new tweet.
    XCTAssert(![[DataManager sharedInstance] addTweet:text date:date identifier:identifier],@"Should not add tweet when text length is 0");

    //Invalid identifier
    text = @"third tweet";
    date = [NSDate date];
    identifier = -1;
    XCTAssert(![[DataManager sharedInstance] addTweet:text date:date identifier:identifier],@"Should not add tweet when text identifiers is less than 0");

    //140 characters
    text = @"third tweet third tweet third tweet third tweetthird tweetthird tweetthird tweetthird tweetthird tweetthird tweetthird tweetthird tweet23456";
    NSLog(@"length = %lu",text.length);
    date = [NSDate date];
    identifier = [[DataManager sharedInstance] getAllTweets].count+1; //This is assuming that the identifier increases by 1 for each new tweet.;
    XCTAssert([[DataManager sharedInstance] addTweet:text date:date identifier:identifier],@"Should add tweet when text is less than characters 140 long.");

    //141 characters
    text = @"third tweet third tweet third tweet third tweetthird tweetthird tweetthird tweetthird tweetthird tweetthird tweetthird tweetthird tweet234561";
    NSLog(@"length = %lu",text.length);
    date = [NSDate date];
    identifier = [[DataManager sharedInstance] getAllTweets].count+1; //This is assuming that the identifier increases by 1 for each new tweet.;
    XCTAssert(![[DataManager sharedInstance] addTweet:text date:date identifier:identifier],@"Should not add tweet when text is too long.");

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
