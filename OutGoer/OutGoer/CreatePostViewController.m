//
//  CreatePostViewController.m
//  OutGoer
//
// ============================================================================
// Modified by Jordan Hennell & Braydon Cohn For INB348 - QUT
// ============================================================================

#import "CreatePostViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "OutGoerService.h"
#import "PostsListViewController.h"

@interface CreatePostViewController ()

// Private properties
@property (strong, nonatomic) OutGoerService *outGoerService;

@end

@implementation CreatePostViewController

@synthesize questionText = _questionText;
@synthesize descriptionText = _descriptionText;
@synthesize createButton;
@synthesize cancelButton;
@synthesize changeTopicButton;
@synthesize chooseTopicButton;
@synthesize outGoerService;


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
    [self setUpTopics];
    [self.errorView setHidden:YES]; // no errors when first loaded
    
    // Create the OutGoerService - this creates the Mobile Service client inside the wrapped service
    self.outGoerService = [OutGoerService customService:@"Posts"];
 }

/**
 * initialise topics array and then re-initialise topic picker
 */
- (void) setUpTopics
{
    self.topicArray  = [[NSArray alloc] initWithObjects: @"Attractions", @"Eating", @"Info", @"Nightlife", @"Shopping", nil];
    
    self.topicPicker.delegate = self;
    self.topicPicker.dataSource = self;
    [self.topicPicker reloadAllComponents];
    [self.pickerView setHidden:YES]; // hide until ready
}

/**
 * set strechable images to prevent skewing as background on all buttons
 */
- (void)setUpButtons
{
    // initialise image, 8 pixels in at each side will strech only the middle pixel of the image
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    UIImage *whiteTransparentImage = [[UIImage imageNamed:@"ButtonTransparentWhite.png"]
                         resizableImageWithCapInsets:edgeInsets];
    UIImage *blackTransparentImage = [[UIImage imageNamed:@"ButtonTransparentBlack.png"]
                         resizableImageWithCapInsets:edgeInsets];
    UIImage *whiteSolidImage = [[UIImage imageNamed:@"ButtonSolidWhite.png"]
                                      resizableImageWithCapInsets:edgeInsets];
    UIImage *blackSolidImage = [[UIImage imageNamed:@"ButtonSolidBlack.png"]
                                resizableImageWithCapInsets:edgeInsets];
    
    // update buttons: normal and highlighted state
    [self.createButton setBackgroundImage:whiteTransparentImage
                                 forState:UIControlStateNormal];
    [self.createButton setBackgroundImage:blackTransparentImage
                                  forState:UIControlStateHighlighted];
        
    [self.cancelButton setBackgroundImage:whiteTransparentImage
                                 forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:blackTransparentImage
                                 forState:UIControlStateHighlighted];
        
    [self.changeTopicButton setBackgroundImage:blackTransparentImage
                                      forState:UIControlStateNormal];
    [self.changeTopicButton setBackgroundImage:whiteTransparentImage
                                      forState:UIControlStateHighlighted];
    [self.changeTopicButton setTitleColor: [UIColor blackColor]
                                 forState:UIControlStateHighlighted];
    
    [self.chooseTopicButton setBackgroundImage:whiteSolidImage
                                      forState:UIControlStateNormal];
    [self.chooseTopicButton setBackgroundImage:blackSolidImage
                                      forState:UIControlStateHighlighted];
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
    [self setTopicChosen:nil];
    [self setTopicPicker:nil];
    [self setTopicPicker:nil];
    [self setPickerView:nil];
    [self setChangeTopicButton:nil];
    [self setChooseTopicButton:nil];
    [self setErrorView:nil];
    [super viewDidUnload];
}


#pragma mark * Keyboard methods

/**
 * Closes keyboard if the screen is touched outside the text view
 */
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_questionText resignFirstResponder];
    [_descriptionText resignFirstResponder];
}


#pragma mark * PickerView methods 

// returns the number of 'columns' to display
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    return 1;
}

// returns the # of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component

{
    return [self.topicArray count];
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [self.topicArray objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    self.topicChosen.text = [self.topicArray objectAtIndex:row];
}


#pragma mark * Button methods

- (IBAction)showTopicPicker:(id)sender {
    [self.pickerView setHidden:NO];
}

- (IBAction)closeTopicPicker:(id)sender {
    [self.pickerView setHidden:YES];
}

/**
 * add post to table based upon title, description and topic
 */
- (IBAction)addPostToTable:(id)sender {
    if (self.checkFieldsNotEmpty) {
        
        // create item to add to table
        NSDictionary *item = @{ @"Question"     : self.questionText.text,
                                @"Description"  : self.descriptionText.text,
                                @"Topic"        : self.topicChosen.text,
                                @"Date"         : [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]]};
        
        
        // add item to table on Azure, as well as table view
        [self.outGoerService addItem:item completion:^(NSUInteger index)
         {
             // show another view that says successfully added, after a few seconds redirect to the page for that topic
         }];
        
        // find ViewController, then show
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        PostsListViewController *new = [storyboard instantiateViewControllerWithIdentifier:@"nightlife"];
        new.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:new animated:YES completion:NULL];
        
    }
}

/**
 * checks if the user has filled in each field
 */
- (BOOL) checkFieldsNotEmpty
{
    if (([self.topicChosen.text isEqual: @"No Topic Selected"]) ||
        ([self.questionText.text length] < 1) ||
        ([self.descriptionText.text length] < 1))
          {
              [self.errorView setHidden:NO];
              return false;
          }
    else
          {
              [self.errorView setHidden:YES];
              return true;
          }
}

@end
