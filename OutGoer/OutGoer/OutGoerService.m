// ----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// ----------------------------------------------------------------------------
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// ============================================================================
// Modified by Jordan Hennell & Braydon Cohn For INB348 - QUT
// ============================================================================

#import "OutGoerService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>


#pragma mark * Private interace


@interface OutGoerService() <MSFilter>

@property (nonatomic, strong)   MSTable *table;
@property (nonatomic)           NSInteger busyCount;

@end


#pragma mark * Implementation


@implementation OutGoerService

@synthesize items;


/**
 * Creates a singleton instance of OutGoerService linked to the posts table
 */
+ (OutGoerService *)defaultService
{
    
    static OutGoerService* service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[OutGoerService alloc] init];
    });
    
    return service;
}

/**
 * Creates a singleton instance of OutGoerService linked to a custom table specific by tableName
 */
+ (OutGoerService *)customService: (NSString*)tableName
{
    
    static OutGoerService* service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[OutGoerService alloc] initWithTable:tableName];
    });
    
    return service;
}

/**
 * Default constructor, connects to table named posts
 */
-(OutGoerService *)init
{    
    return [self initWithTable:@"Posts"];
}

/**
 * Custom constructor to allow a specific table to be selected
 */
-(OutGoerService *)initWithTable:(NSString*)tableName
{
    self = [super init];
    
    if (self)
    {
        // Initialize the Mobile Service client with your URL and key
        MSClient *client = [MSClient clientWithApplicationURLString:@"https://outgoer.azure-mobile.net/"
                                                     applicationKey:@"BPROLfBPRfbbmpYgCGUKxlnIREkmfe83"];
        
        // Add a Mobile Service filter to enable the busy indicator
        self.client = [client clientWithFilter:self];
        
        // Create an MSTable instance to allow us to work with the TodoItem table
        self.table = [_client tableWithName:tableName];
        
        self.items = [[NSMutableArray alloc] init];
        self.busyCount = 0;
    }
    
    return self;
}

/**
 * get all data from table
 */
- (void)refreshDataOnSuccess:(CompletionBlock)completion
{
    // Query the table and update the items property with the results from the service
    [self.table readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error)
    {
        [self logErrorIfNotNil:error];
        
        items = [results mutableCopy];
        
        // Let the caller know that we finished
        completion();
    }];
    
}

/** 
 * get data from table based on predicate: filters results
 */
- (void)refreshDataOnSuccess:(CompletionBlock)completion withPredicate:(NSPredicate *)predicate
{
    // Query the table and update the items property with the results from the service
    [self.table readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         
         items = [results mutableCopy];
         
         // Let the caller know that we finished
         completion();
     }];
    
}


-(void)addItem:(NSDictionary *)item completion:(CompletionWithIndexBlock)completion
{
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.table insert:item completion:^(NSDictionary *result, NSError *error)
    {
        [self logErrorIfNotNil:error];
        
        NSUInteger index = [items count];
        [(NSMutableArray *)items insertObject:result atIndex:index];
        
        // Let the caller know that we finished
        completion(index);
    }];
}


-(void)completeItem:(NSDictionary *)item completion:(CompletionWithIndexBlock)completion
{
    // Cast the public items property to the mutable type (it was created as mutable)
    NSMutableArray *mutableItems = (NSMutableArray *) items;
    
    // Set the item to be complete (we need a mutable copy)
    NSMutableDictionary *mutable = [item mutableCopy];
    [mutable setObject:@YES forKey:@"complete"];
    
    // Replace the original in the items array
    NSUInteger index = [items indexOfObjectIdenticalTo:item];
    [mutableItems replaceObjectAtIndex:index withObject:mutable];
    
    // Update the item in the TodoItem table and remove from the items array on completion
    [self.table update:mutable completion:^(NSDictionary *item, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSUInteger index = [items indexOfObjectIdenticalTo:mutable];
        if (index != NSNotFound)
        {
            [mutableItems removeObjectAtIndex:index];
        }
        
        // Let the caller know that we have finished
        completion(index);
    }];
}

- (void)busy:(BOOL)busy
{
    // assumes always executes on UI thread
    if (busy)
    {
        if (self.busyCount == 0 && self.busyUpdate != nil)
        {
            self.busyUpdate(YES);
        }
        self.busyCount ++;
    }
    else
    {
        if (self.busyCount == 1 && self.busyUpdate != nil)
        {
            self.busyUpdate(FALSE);
        }
        self.busyCount--;
    }
}

- (void)logErrorIfNotNil:(NSError *) error
{
    if (error)
    {
        NSLog(@"ERROR %@", error);
    }
}


#pragma mark * MSFilter methods


- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response
{
    // A wrapped response block that decrements the busy counter
    MSFilterResponseBlock wrappedResponse = ^(NSHTTPURLResponse *innerResponse, NSData *data, NSError *error)
    {
        [self busy:NO];
        response(innerResponse, data, error);
    };
    
    // Increment the busy counter before sending the request
    [self busy:YES];
    next(request, wrappedResponse);
}

@end
