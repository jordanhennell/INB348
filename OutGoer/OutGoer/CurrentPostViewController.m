//
//  CurrentPostViewController.m
//  OutGoer
//
// ============================================================================
// Created by Jordan Hennell & Braydon Cohn For INB348 - QUT
// ============================================================================

#import "CurrentPostViewController.h"
#import "PostsListViewController.h"
#import "CurrentPost.h"

@interface CurrentPostViewController ()

@end

@implementation CurrentPostViewController

@synthesize postTitle;

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
    CurrentPost *post = [CurrentPost storePost];
    NSLog(@"%@", post.currentPost);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPostTitle:nil];
    [super viewDidUnload];
}
@end
