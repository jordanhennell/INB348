//
//  CreatePostViewController.h
//  OutGoer
//
//  Created by Jordan on 30/10/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePostViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *questionText;

@property (strong, nonatomic) IBOutlet UITextView *descriptionText;

@property (strong, nonatomic) IBOutlet UIButton *createButton;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end
