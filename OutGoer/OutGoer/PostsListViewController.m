// ----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// ----------------------------------------------------------------------------
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// ============================================================================
// Modified by Jordan Hennell & Braydon Cohn For INB348 - QUT
// ============================================================================

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "PostsListViewController.h"
#import "OutGoerService.h"
#import "CurrentPostViewController.h"
#import "CurrentPost.h"


#pragma mark * Private Interface


@interface PostsListViewController ()

// Private properties
@property (strong, nonatomic)   OutGoerService   *outGoerService;

@property (nonatomic)           BOOL            useRefreshControl;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end


#pragma mark * Implementation


@implementation PostsListViewController

@synthesize outGoerService;
@synthesize activityIndicator;
@synthesize currentTopic;


#pragma mark * UIView methods


- (void)viewDidLoad
{
    [super viewDidLoad];
     
    [self setUpService:@"Posts"];
}

/**
 * sets up service for data connection, based on name of table
 */
- (void) setUpService: (NSString*)tableName
{
    // Create the OutGoerService - this creates the Mobile Service client inside the wrapped service
    self.outGoerService = [OutGoerService customService:tableName];
    
    // Set the busy method
    UIActivityIndicatorView *indicator = self.activityIndicator;
    self.outGoerService.busyUpdate = ^(BOOL busy)
    {
        if (busy)
        {
            [indicator startAnimating];
        } else
        {
            [indicator stopAnimating];
        }
    };
    
    // add the refresh control to the table (iOS6+ only)
    [self addRefreshControl];
    
    // load the data
    [self refresh];
}


- (void) refresh
{
    // only activate the refresh control if the feature is available
    if (self.useRefreshControl == YES) {
        [self.refreshControl beginRefreshing];
    }
    
    
    // get all items in table, no predicate
    [self.outGoerService refreshDataOnSuccess:^
    {
        if (self.useRefreshControl == YES)
        {
            [self.refreshControl endRefreshing];
        }
        [self.tableView reloadData];
    }
                                withPredicate:[NSPredicate predicateWithFormat:@"Topic == %@", self.currentTopic.text]];
}


#pragma mark * UITableView methods


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Find item that was commited for editing (selected)
    NSDictionary *item = [self.outGoerService.items objectAtIndex:indexPath.row];
    CurrentPost *currentPost = [CurrentPost storePost];
    currentPost.currentPost = [item objectForKey:@"id"];
    
    // find currentPostViewController, then show, then update
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    CurrentPostViewController *currentPostViewController = [storyboard instantiateViewControllerWithIdentifier:@"currentViewPostController"];
    currentPostViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:currentPostViewController animated:YES completion:NULL];
    
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Customize the Delete button to say "complete"
    return @"view";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set the label and subtitle of the cell based upon the question and description of the table entry
    UILabel *question = (UILabel *)[cell viewWithTag:1];
    UILabel *description = (UILabel *)[cell viewWithTag:2];
    question.textColor = [UIColor whiteColor];
    description.textColor = [UIColor grayColor];
    NSDictionary *item = [self.outGoerService.items objectAtIndex:indexPath.row];
    question.text = [item objectForKey:@"Question"];
    description.text = [item objectForKey:@"Description"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Always a single section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of items in the todoService items array
    return [self.outGoerService.items count];
}


#pragma mark * UITextFieldDelegate methods


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark * iOS Specific Code

// This method will add the UIRefreshControl to the table view if
// it is available, ie, we are running on iOS 6+

- (void)addRefreshControl
{
    Class refreshControlClass = NSClassFromString(@"UIRefreshControl");
    if (refreshControlClass != nil)
    {
        // the refresh control is available, let's add it
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self
                                action:@selector(onRefresh:)
                      forControlEvents:UIControlEventValueChanged];
        self.useRefreshControl = YES;
    }
}

- (void)onRefresh:(id) sender
{
    [self refresh];
}


- (void)viewDidUnload {
    [self setTextView:nil];
    [self setCurrentTopic:nil];
    [super viewDidUnload];
}
@end
