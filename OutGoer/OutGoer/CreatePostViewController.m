//
//  CreatePostViewController.m
//  OutGoer
//
//  Created by Jordan on 30/10/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "CreatePostViewController.h"

@interface CreatePostViewController ()

@end

@implementation CreatePostViewController

@synthesize questionText = _questionText;
@synthesize descriptionText = _descriptionText;
@synthesize createButton;
@synthesize cancelButton;

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

    [self setUpButtons];
}

/**
 * set strechable image as background on all button
 */
- (void)setUpButtons
{
    // initialise image
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    UIImage *backgroundButtonImage = [[UIImage imageNamed:@"ButtonTransparentWhite.png"]
                                      resizableImageWithCapInsets:edgeInsets];
    
    // update buttons
    [self.createButton setBackgroundImage:backgroundButtonImage
                                 forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:backgroundButtonImage
                                 forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setQuestionText:nil];
    [self setDescriptionText:nil];
    [self setCreateButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
}

/**
 * Closes keyboard if the screen is touched outside the text view
 */
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_questionText resignFirstResponder];
    [_descriptionText resignFirstResponder];
}

@end
