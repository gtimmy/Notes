//
//  GNPreferences.m
//  GlobusNotes
//
//  Created by Artem Goncharov on 03/09/14.
//  Copyright (c) 2014 Artem Goncharov. All rights reserved.
//

#import "GNPreferences.h"

@implementation GNPreferences

+ (NSURL *)dataStoreUrl
{
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@.sqlite",[self applicationName]]];
}

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)applicationName
{
    return @"GlobusNotes";
}

@end
