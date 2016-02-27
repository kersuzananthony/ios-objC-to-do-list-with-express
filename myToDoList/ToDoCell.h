//
//  ToDoCell.h
//  myToDoList
//
//  Created by Kersuzan on 18/02/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"

@interface ToDoCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UIView *cellView;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property(nonatomic, weak) IBOutlet UILabel *dateLabel;

- (void)configureCellWithToDoItem:(ToDoItem *)aToDoItem;
@end
