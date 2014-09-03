//
//  GNPreferences.h
//  GlobusNotes
//
//  Created by Artem Goncharov on 03/09/14.
//  Copyright (c) 2014 Artem Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNPreferences : NSObject

+ (NSURL *)dataStoreUrl;
+ (NSURL *)applicationDocumentsDirectory;
+ (NSString *)applicationName;

@end
