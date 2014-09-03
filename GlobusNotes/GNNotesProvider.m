//
//  GNNotesProvider.m
//  GlobusNotes
//
//  Created by Artem Goncharov on 02/09/14.
//  Copyright (c) 2014 Artem Goncharov. All rights reserved.
//

#import "GNNotesProvider.h"

@implementation GNNotesProvider

#pragma mark - Singleton implementation

+ (instancetype)sharedInstance
{
    static GNNotesProvider* sMySingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        sMySingleton = [[super allocWithZone:NULL] init];
    } );
    return sMySingleton;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

#pragma mark - GNNotesProvider

- (Note *)addNote
{
    NSEntityDescription *noteEntity = [[[[self.managedObjectContext persistentStoreCoordinator] managedObjectModel] entitiesByName] objectForKey:kNoteEntityName];
    
    Note *note = [[Note alloc] initWithEntity:noteEntity insertIntoManagedObjectContext:self.managedObjectContext];
    note.noteText = [[NSString alloc] initWithFormat:@"%@",@""];
    note.lastChangedDate = [NSDate date];
    
    id globalStore = [[self.managedObjectContext persistentStoreCoordinator]
                      persistentStoreForURL:[GNPreferences dataStoreUrl]];
    [self.managedObjectContext assignObject:note toPersistentStore:globalStore];
    [self.managedObjectContext save:nil];
    
    return note;
}

- (NSArray *)notesList
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kNoteEntityName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"noteText"
                                                                     ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (void)removeNote:(Note *)note
{
    [self.managedObjectContext deleteObject:note];
    [self.managedObjectContext save:nil];    
}

- (void)save
{
    [self.managedObjectContext save:nil];
}

@end
