//
//  CurrentPostViewController.m
//  OutGoer
//
//  Created by Jordan on 31/10/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "CurrentPostViewController.h"
#import "CurrentPost.h"
#import "OutGoerService.h"

@interface CurrentPostViewController ()

// Private properties
@property (strong, nonatomic)   OutGoerService   *outGoerService;

@end

@implementation CurrentPostViewController

@synthesize postDate;
@synthesize postDescription;
@synthesize postQuestion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpService];
}

-(void)setUpService
{
    // Create the OutGoerService - this creates the Mobile Service client inside the wrapped service
    self.outGoerService = [OutGoerService customService:@"Posts"];
    
    CurrentPost *post = [CurrentPost storePost];
    
    [self.outGoerService refreshDataOnSuccess:^{
        [self setUpPage];
    } withPredicate:[NSPredicate predicateWithFormat:@"id == %@", post.currentPost]];
    
}

- (void) setUpPage
{
    NSDictionary *item = [self.outGoerService.items objectAtIndex:0]; // should be only one item returned
    
    self.postDescription.text = [item objectForKey:@"Description"];
    self.postQuestion.text = [item objectForKey:@"Question"];
    self.postDate.text = [item objectForKey:@"Date"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (void)viewDidUnload {
    [self setPostDate:nil];
    [self setPostQuestion:nil];
    [self setPostDescription:nil];
    [super viewDidUnload];
}
@end
