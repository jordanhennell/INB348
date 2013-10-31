//
//  CurrentPost.m
//  OutGoer
//
//  Singleton class to store currently selected post
//
// ============================================================================
// Created by Jordan Hennell & Braydon Cohn For INB348 - QUT
// ============================================================================

#import "CurrentPost.h"

@implementation CurrentPost

@synthesize currentPost;

#pragma mark Singleton Methods

+ (id)storePost
{
    static CurrentPost *sharedCurrentPost = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCurrentPost = [[self alloc] init];
    });
    return sharedCurrentPost;
}

- (id)init
{
    if (self = [super init])
    {
        currentPost = @"";
    }
    return self;
}


@end
