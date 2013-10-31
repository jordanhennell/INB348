//
//  CurrentPost.h
//  OutGoer
//
// ============================================================================
// Created by Jordan Hennell & Braydon Cohn For INB348 - QUT
// ============================================================================

#import <Foundation/Foundation.h>

@interface CurrentPost : NSObject {
    NSString *currentPost;
}

@property (nonatomic, retain) NSString *currentPost;

+ (id)storePost;

@end
