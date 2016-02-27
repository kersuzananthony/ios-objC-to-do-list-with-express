//
//  DetailVC.m
//  myToDoList
//
//  Created by Kersuzan on 18/02/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

#import "DetailVC.h"
#import "HTTPService.h"

@interface DetailVC ()

@end

@implementation DetailVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleTextView.text = self.toDoItem.toDoTitle;
    self.descriptionTextView.text = self.toDoItem.toDoDescription;
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:self.toDoItem.toDoDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
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
    if (![self.titleTextView.text isEqual:@""] && ![self.descriptionTextView.text isEqual:@""]) {
        if (![self.titleTextView.text isEqualToString:self.toDoItem.toDoTitle] || ![self.descriptionTextView.text isEqualToString:self.toDoItem.toDoDescription]) {
            // We need to update
            [self.toDoItem setToDoTitle:self.titleTextView.text];
            [self.toDoItem setToDoDescription:self.descriptionTextView.text];
            
            [self initIndicatorView];
            
            [[HTTPService instance]updateToDoItem:self.toDoItem completionHandler:^(NSMutableArray<ToDoItem *> * _Nullable dataDict, NSString * _Nullable errorMessage) {
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopIndicatorView];
                    if (errorMessage) {
                        [self displayAlertMessageWithTitle:@"Error" message:errorMessage];
                    } else {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"dataHasChanged" object:nil];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }

                });
            }];

        } else {
            // Dismiss
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self displayAlertMessageWithTitle:@"Cannot process data" message:@"Please make sure that your title and your description are not empty"];
    }
}

- (IBAction)removePressed:(id)sender {
    [self initIndicatorView];
    [[HTTPService instance]deleteToDoItem:self.toDoItem completionHandler:^(NSMutableArray<ToDoItem *> * _Nullable dataDict, NSString * _Nullable errorMessage) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopIndicatorView];
            if (errorMessage) {
                [self displayAlertMessageWithTitle:@"Error" message:errorMessage];
            } else {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"dataHasChanged" object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    }];
}

- (void) displayAlertMessageWithTitle:(NSString *)aTitle message:(NSString *)aMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: aTitle message: aMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
