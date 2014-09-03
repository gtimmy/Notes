//
//  GNNoteViewController.m
//  GlobusNotes
//
//  Created by Artem Goncharov on 02/09/14.
//  Copyright (c) 2014 Artem Goncharov. All rights reserved.
//

#import "GNNoteViewController.h"
#import "GNNotesProvider.h"

@interface GNNoteViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *noteDateLabel;

- (void)configureView;

@end

@implementation GNNoteViewController

#pragma mark - Managing the detail view

- (void)configureView
{
    if (self.note) {
        self.textView.text = [[self.note valueForKey:@"noteText"] description];
    }
    self.title = @"";
    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.textView.delegate = self;
    [self toggleDoneButton:YES];
    [self updateNoteDate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self updateNoteDate];
    [self updateNoteText];
    
    if ([[self.note.noteText stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        [[GNNotesProvider sharedInstance] removeNote:self.note];
    }
    [[GNNotesProvider sharedInstance] save];
    [self removeAllObservers];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isNewNote) {
        [self.textView becomeFirstResponder];
    }
}

- (BOOL)automaticallyAdjustsScrollViewInsets
{
    return NO;
}

- (void)removeAllObservers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark - Actions

- (IBAction)doneButtonClicked:(id)sender
{
    [self.textView endEditing:YES];
    [self updateNoteDate];
    [self updateNoteText];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    [self showTextViewCaretPosition:textView];
}

- (void)showTextViewCaretPosition:(UITextView *)textView
{
    CGRect caretRect = [textView caretRectForPosition:self.textView.selectedTextRange.end];
    [textView scrollRectToVisible:caretRect animated:NO];
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    CGFloat keyboardHeight = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;
    
    UIEdgeInsets contentInset = self.textView.contentInset;
    contentInset.bottom = keyboardHeight;
    
    
    UIEdgeInsets scrollIndicatorInsets = self.textView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = keyboardHeight;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.textView.contentInset = contentInset;
        self.textView.scrollIndicatorInsets = scrollIndicatorInsets;
    }];
    [self toggleDoneButton:NO];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    [self showTextViewCaretPosition:self.textView];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIEdgeInsets contentInset = self.textView.contentInset;
    contentInset.bottom = 0;
    
    UIEdgeInsets scrollIndicatorInsets = self.textView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = 0;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.textView.contentInset = contentInset;
        self.textView.scrollIndicatorInsets = scrollIndicatorInsets;
    }];
    [self toggleDoneButton:YES];
}

#pragma mark - Helpful methods

- (void)toggleDoneButton:(BOOL)hide
{
    if (hide) {
        [self.doneButton setEnabled:NO];
        [self.doneButton setTintColor: [UIColor clearColor]];
    }
    else {
        [self.doneButton setEnabled:YES];
        [self.doneButton setTintColor:nil];
    }
}

- (void)updateNoteText {
    self.note.noteText = self.textView.text;
}

- (void)updateNoteDate {
    if (![self.note.noteText isEqualToString:self.textView.text]) {
        self.note.lastChangedDate = [NSDate date];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [self.noteDateLabel setText:[dateFormatter stringFromDate:self.note.lastChangedDate]];
}

@end
