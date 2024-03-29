//
//  CreatePostViewController.h
//  OutGoer
//
// ============================================================================
// Created by Jordan Hennell & Braydon Cohn For INB348 - QUT
// ============================================================================

#import <UIKit/UIKit.h>

@interface CreatePostViewController : UIViewController <UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView       *pickerView;

@property (strong, nonatomic) IBOutlet UIView       *errorView;

@property (strong, nonatomic) IBOutlet UITextView   *questionText;

@property (strong, nonatomic) IBOutlet UITextView   *descriptionText;

@property (strong, nonatomic) IBOutlet UIButton     *createButton;

@property (strong, nonatomic) IBOutlet UIButton     *cancelButton;

@property (strong, nonatomic) IBOutlet UIButton     *changeTopicButton;

@property (strong, nonatomic) IBOutlet UIButton     *chooseTopicButton;

@property (strong, nonatomic) IBOutlet UILabel      *topicChosen;

@property (strong, nonatomic) IBOutlet UIPickerView *topicPicker;


@property (strong, nonatomic)          NSArray      *topicArray;

@end
