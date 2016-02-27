//
//  HTTPService.h
//  myToDoList
//
//  Created by Kersuzan on 18/02/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoItem.h"

typedef void (^onComplete)(NSMutableArray<ToDoItem *>  * _Nullable dataDict, NSString  * _Nullable errorMessage);

@interface HTTPService : NSObject

NS_ASSUME_NONNULL_BEGIN
@property(nonatomic, strong) NSURLSession *sharedSession;

+ (id)instance;

NS_ASSUME_NONNULL_END

- (void)getToDoItems:(nullable onComplete)completionHandler;
- (void)postToDoItem:(nonnull ToDoItem*)itemToPost completionHandler:(nullable onComplete)completionHandler;
- (void)updateToDoItem:(nonnull ToDoItem*)itemToUpdate completionHandler:(nullable onComplete)completionHandler;
- (void)deleteToDoItem:(nonnull ToDoItem*)itemToDelete completionHandler:(nullable onComplete)completionHandler;
@end
