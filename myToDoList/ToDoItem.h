//
//  ToDoItem.h
//  myToDoList
//
//  Created by Kersuzan on 18/02/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject
@property(nonatomic, strong) NSString *toDoTitle;
@property(nonatomic, strong) NSString *toDoDescription;
@property(nonatomic, strong) NSDate *toDoDate;
@property(nonatomic, strong) NSString *toDoId;

- (id)initWithTitle:(NSString *)aTitle description:(NSString *)aDescription;
- (id)initWithDictionary:(NSDictionary<NSString *, id> *)aDictionary;
- (NSDictionary<NSString *, NSString *> *)convertToDictionary;
@end
