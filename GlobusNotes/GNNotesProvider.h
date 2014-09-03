//
//  GNNotesProvider.h
//  GlobusNotes
//
//  Created by Artem Goncharov on 02/09/14.
//  Copyright (c) 2014 Artem Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface GNNotesProvider : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedInstance;

- (Note *)addNote;
- (void)save;
- (void)removeNote:(Note*)note;
- (NSArray *)notesList;

@end
