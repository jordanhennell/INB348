//
//  CurrentPostViewController.h
//  OutGoer
//
//  Created by Jordan on 31/10/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentPostViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *postDate;
@property (strong, nonatomic) IBOutlet UILabel *postQuestion;
@property (strong, nonatomic) IBOutlet UITextView *postDescription;

@end
