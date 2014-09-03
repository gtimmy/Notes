//
//  Note.h
//  GlobusNotes
//
//  Created by Artem Goncharov on 03/09/14.
//  Copyright (c) 2014 Artem Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, strong) NSString * noteText;
@property (nonatomic, strong) NSDate * lastChangedDate;

@end
