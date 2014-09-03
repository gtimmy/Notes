//
//  GNAppDelegate.h
//  GlobusNotes
//
//  Created by Artem Goncharov on 02/09/14.
//  Copyright (c) 2014 Artem Goncharov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@end
