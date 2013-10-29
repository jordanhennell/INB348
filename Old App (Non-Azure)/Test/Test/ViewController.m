//
//  ViewController.m
//  Test
//
//  Created by Jordan on 29/10/13.
//  Copyright (c) 2013 Jordan. All rights reserved.
//

#import "ViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize testText;


/**
 * test method to add some mock data to azure table
 */
- (IBAction)testAdd:(id)sender {
    MSClient *client = [MSClient clientWithApplicationURLString:@"https://outgoer.azure-mobile.net/"
                                                 applicationKey:@"BPROLfBPRfbbmpYgCGUKxlnIREkmfe83"];
    
    // get instance of table to be inserted into: "Item"
    MSTable *itemTable = [client tableWithName:@"Item"];
    
    // create item to add from text box
    NSDictionary *item = @{ @"text" : self.testText.text};
    
    // insert item into table, included log entries
    [itemTable insert:item completion:^(NSDictionary *insertedItem, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Item inserted, id: %@", [insertedItem objectForKey:@"id"]);
        }
    }];
    
    // reset text in textText field
    self.testText.text = @"";

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
