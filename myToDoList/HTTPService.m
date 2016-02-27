//
//  HTTPService.m
//  myToDoList
//
//  Created by Kersuzan on 18/02/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

#import "HTTPService.h"

#define URL_BASE "http://localhost:6069/api"
#define URL_TODOS "/todos"

@implementation HTTPService

+ (id)instance {
    static HTTPService *sharedInstance = nil;
    
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc]init];
            sharedInstance.sharedSession = [NSURLSession sharedSession];
        }
    }
    
    return sharedInstance;
}

- (void)getToDoItems:(nullable onComplete)completionHandler {
    NSMutableArray<ToDoItem *> *toDoItems = [[NSMutableArray alloc]init];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%s", URL_BASE, URL_TODOS]];
    
    [[self.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            NSError *err;
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            
            if (err != nil) {
                completionHandler(nil, @"Data is corrupted, please try again.");
            } else {
                // Loop through all data
                for (NSDictionary<NSString *, id> *itemDictionary in json) {
                    ToDoItem *toDoItem = [[ToDoItem alloc]initWithDictionary:itemDictionary];
                    [toDoItems addObject:toDoItem];
                }
                
                completionHandler(toDoItems, nil);
            }
        } else {
            completionHandler(nil, @"Problem connecting to the server");
        }
        
    }] resume];
}

- (void)postToDoItem:(ToDoItem *)itemToPost completionHandler:(nullable onComplete)completionHandler {
    NSError *error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%s", URL_BASE, URL_TODOS ]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:[itemToPost convertToDictionary] options:0 error:&error];
    [request setHTTPBody:postData];
    
    if (error) {
        completionHandler(nil, @"Cannot contact the server, please retry later");
    }
    
    NSURLSessionDataTask *dataTask = [self.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (error) {
                completionHandler(nil, @"Data is corrupted please retry later");
            } else {
                ToDoItem *postedToDoItem = [[ToDoItem alloc]initWithDictionary:json];
                NSMutableArray<ToDoItem *> *arrayToReturn = [[NSMutableArray alloc]init];
                [arrayToReturn addObject:postedToDoItem];
                
                completionHandler(arrayToReturn, nil);
            }
        } else {
            completionHandler(nil, @"Problem contacting the server");
        }
        
    }];
    
    [dataTask resume];
}

- (void)updateToDoItem:(ToDoItem *)itemToUpdate completionHandler:(onComplete)completionHandler {
    NSError *error;
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%s%s/%@", URL_BASE, URL_TODOS, itemToUpdate.toDoId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"PUT"];

    NSData *postData = [NSJSONSerialization dataWithJSONObject:[itemToUpdate convertToDictionary] options:0 error:&error];
    [request setHTTPBody:postData];

    if (error) {
        completionHandler(nil, @"Cannot contact the server, please retry later");
    }
    
    NSURLSessionDataTask *dataTask = [self.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (error) {
                completionHandler(nil, @"Data is corrupted please retry later");
            } else {
                ToDoItem *updatedToDoItem = [[ToDoItem alloc]initWithDictionary:json];
                NSMutableArray<ToDoItem *> *arrayToReturn = [[NSMutableArray alloc]init];
                [arrayToReturn addObject:updatedToDoItem];
                
                completionHandler(arrayToReturn, nil);
            }
        } else {
            completionHandler(nil, @"Problem contacting the server");
        }
        
    }];
    
    [dataTask resume];

}

- (void)deleteToDoItem:(ToDoItem *)itemToDelete completionHandler:(onComplete)completionHandler {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%s%s/%@", URL_BASE, URL_TODOS, itemToDelete.toDoId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    
    NSURLSessionDataTask *dataTask = [self.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (data) {
            completionHandler(nil, nil);
        } else {
            completionHandler(nil, @"Problem contacting the server");
        }
    }];
    
    [dataTask resume];
}

@end
