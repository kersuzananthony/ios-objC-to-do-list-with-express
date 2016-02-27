//
//  ViewController.m
//  myToDoList
//
//  Created by Kersuzan on 18/02/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

#import "ListToDoVC.h"
#import "ToDoItem.h"
#import "ToDoCell.h"
#import "HTTPService.h"
#import "DetailVC.h"

@interface ListToDoVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListToDoVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Do any additional setup after loading the view, typically from a nib.
    self.toDoItems = [[NSMutableArray alloc]init];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    NSString *title = [NSString stringWithFormat:@"Update data..."];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    [self.refreshControl addTarget:self
                            action:@selector(loadDataFromServer)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataFromServer) name:@"dataHasChanged" object:nil];
    
    [self loadDataFromServer];
}

- (void)loadDataFromServer {
    if (self.refreshControl == nil) {
        NSLog(@"NIL");
    }
    
    [self.refreshControl beginRefreshing];
    
    [[HTTPService instance]getToDoItems:^(NSMutableArray<ToDoItem *> * _Nullable dataDict, NSString * _Nullable errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            if (errorMessage) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Something went wrong" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:cancelAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            if (dataDict) {
                self.toDoItems = dataDict;
                [self.tableView reloadData];
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TableViewDataSource / Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoCell *toDoCell = (ToDoCell *) [tableView dequeueReusableCellWithIdentifier:@"ToDoCell" forIndexPath:indexPath];
    
    if (!toDoCell) {
        toDoCell = [[ToDoCell alloc]init];
    }
    
    [toDoCell configureCellWithToDoItem:self.toDoItems[indexPath.row]];

    return toDoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ToDoItem *selectedItem = self.toDoItems[indexPath.row];
        
        [self performSegueWithIdentifier:@"GoToDetailVC" sender:selectedItem];

    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepare for segue");
    if ([segue.identifier isEqualToString:@"GoToDetailVC"]) {
        ToDoItem *selectedItem = (ToDoItem *)sender;
        DetailVC *detailViewController = (DetailVC *)segue.destinationViewController;
        
        if (selectedItem && detailViewController) {
            NSLog(@"We have it");
            detailViewController.toDoItem = selectedItem;
        } else {
            NSLog(@"No data");
        }
    } else {
        NSLog(@"Segue incorrect");
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[HTTPService instance]deleteToDoItem:self.toDoItems[indexPath.row] completionHandler:^(NSMutableArray<ToDoItem *> * _Nullable dataDict, NSString * _Nullable errorMessage) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (errorMessage) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"Error" message: errorMessage preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                    
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                } else {
                    [self loadDataFromServer];
                }
            });
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.toDoItems.count > 0) {
        NSLog(@"Remove message");
        self.tableView.backgroundView = nil;
        return self.toDoItems.count;
    } else {
        NSLog(@"Display message");
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        [self.messageLabel removeFromSuperview];
        self.messageLabel.text = @"No data is currently available. Please add a new item.";
        self.messageLabel.textColor = [UIColor blackColor];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [self.messageLabel sizeToFit];
        
        self.tableView.backgroundView = self.messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return 0;
    }

}

@end
