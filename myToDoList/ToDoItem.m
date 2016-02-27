//
//  ToDoItem.m
//  myToDoList
//
//  Created by Kersuzan on 18/02/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

#import "ToDoItem.h"

@implementation ToDoItem

- (id)initWithDictionary:(NSDictionary<NSString *,id> *)aDictionary {
    
    if (self = [super init]) {
        _toDoTitle = [aDictionary objectForKey:@"title"];
        _toDoDescription = [aDictionary objectForKey:@"description"];
        _toDoId = [aDictionary objectForKey:@"_id"];
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        _toDoDate = [formatter dateFromString:[NSString stringWithFormat:@"%@", [aDictionary objectForKey:@"date"]]];
    }
    
    return self;
    
}

- (id)initWithTitle:(NSString *)aTitle description:(NSString *)aDescription {
    
    if (self = [super init]) {
        _toDoDate = [NSDate date];
        _toDoTitle = aTitle;
        _toDoDescription = aDescription;
    }
    
    return self;
}

- (NSDictionary<NSString *,NSString *> *)convertToDictionary {
    return @{@"title": [NSString stringWithFormat:@"%@", self.toDoTitle], @"description": [NSString stringWithFormat:@"%@", self.toDoDescription ]};
}

@end
