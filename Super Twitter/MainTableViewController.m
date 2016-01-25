//
//  MainTableViewController.m
//  Super Twitter
//
//  Created by Andres Lara Aguirre on 2016-01-24.
//  Copyright © 2016 Andres Lara. All rights reserved.
//

#import "MainTableViewController.h"
#import "DataManager.h"
#import "TweetTableViewCell.h"
#import "Tweet.h"
#define kMainToComposeSegue @"mainToComposeSegue"

@interface MainTableViewController ()  <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 85.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error loading tweets %@, %@", error, [error userInfo]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo =[[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TweetTableViewCell";
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    Tweet *tweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureText:tweet.text andDate:tweet.date];
    return cell;
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {

    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[DataManager sharedInstance] fetchRequestForAllTweets];
    NSEntityDescription *entity = [[DataManager sharedInstance] entityDescriptionForTweet];
    [fetchRequest setEntity:entity];

    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[[DataManager sharedInstance] managedObjectContext] sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

#pragma mark - IBActions
- (IBAction)tappedCompose:(id)sender {
    [self performSegueWithIdentifier:kMainToComposeSegue sender:self];
}
- (IBAction)tappedLogout:(id)sender {
    [[DataManager sharedInstance] logout];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)refresh:(id)sender {
    Tweet *tweet = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if(tweet){
    [[DataManager sharedInstance] refreshTweetsAfterLastIdentifier:[tweet.identifier integerValue]];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    }
}

#pragma mark - NSFetchedControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}
@end
