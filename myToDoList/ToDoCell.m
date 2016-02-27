//
//  ToDoCell.m
//  myToDoList
//
//  Created by Kersuzan on 18/02/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

#import "ToDoCell.h"

@implementation ToDoCell

- (void)awakeFromNib {
    // Initialization code
    
    self.cellView.layer.cornerRadius = 5.0;
    self.cellView.layer.shadowColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:0.8].CGColor;
    self.cellView.layer.shadowOpacity = 0.8;
    self.cellView.layer.shadowRadius = 5.0;
    self.cellView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithToDoItem:(ToDoItem *)aToDoItem {
    self.titleLabel.text = aToDoItem.toDoTitle;
    self.descriptionLabel.text = aToDoItem.toDoDescription;
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:aToDoItem.toDoDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

@end
