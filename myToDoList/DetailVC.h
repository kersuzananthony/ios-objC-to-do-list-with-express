//
//  DetailVC.h
//  myToDoList
//
//  Created by Kersuzan on 18/02/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"

@interface DetailVC : UIViewController

@property(nonatomic, strong) ToDoItem *toDoItem;
@property(nonatomic, weak) IBOutlet UITextView *titleTextView;
@property(nonatomic, weak) IBOutlet UITextView *descriptionTextView;
@property(nonatomic, weak) IBOutlet UILabel *dateLabel;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
@end
