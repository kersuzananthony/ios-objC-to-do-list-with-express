//
//  ViewController.h
//  myToDoList
//
//  Created by Kersuzan on 18/02/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListToDoVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSMutableArray *toDoItems;
@property(nonatomic, strong) UIRefreshControl *refreshControl;
@property(nonatomic, strong) UILabel *messageLabel;
@end

