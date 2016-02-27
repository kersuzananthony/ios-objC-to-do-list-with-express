//
//  AddToDoItemVC.m
//  myToDoList
//
//  Created by Kersuzan on 18/02/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

#import "AddToDoItemVC.h"
#import "ToDoItem.h"
#import "HTTPService.h"

@interface AddToDoItemVC ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation AddToDoItemVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleTextField.delegate = self;
    self.descriptionTextView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.descriptionTextView.layer.borderColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:0.6].CGColor;
    self.descriptionTextView.layer.borderWidth = 0.5;
    self.descriptionTextView.layer.cornerRadius = 2.0;
}

- (void)initIndicatorView {
    self.activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.activityView.center = self.view.center;
    self.activityView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityView];
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.activityView startAnimating];
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
}

- (void)stopIndicatorView {
    [self.activityView stopAnimating];
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
}

- (IBAction)savePressed:(id)sender {
    
    if (![self.titleTextField.text  isEqual: @""] && ![self.descriptionTextView.text isEqual: @""]) {
        ToDoItem *newToDoItem = [[ToDoItem alloc]initWithTitle:self.titleTextField.text description:self.descriptionTextView.text];
        [self initIndicatorView];
        [[HTTPService instance]postToDoItem:newToDoItem completionHandler:^(NSMutableArray<ToDoItem *> * _Nullable dataDict, NSString * _Nullable errorMessage) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopIndicatorView];
                if (errorMessage) {
                    [self displayAlertMessageWithTitle:@"Error!" message:errorMessage];
                } else {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"dataHasChanged" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }];
    } else {
        [self displayAlertMessageWithTitle:@"Cannot save the new item" message:@"Please make sure you have written a title and a description for your new item."];
    }
    
}

- (void) displayAlertMessageWithTitle:(NSString *)aTitle message:(NSString *)aMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: aTitle message: aMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
