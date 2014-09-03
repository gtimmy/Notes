//
//  GNNoteTableViewCell.m
//  GlobusNotes
//
//  Created by Artem Goncharov on 02/09/14.
//  Copyright (c) 2014 Artem Goncharov. All rights reserved.
//

#import "GNNoteTableViewCell.h"

@implementation GNNoteTableViewCell

- (void)refresh
{
    [self.title setText:self.note.noteText];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    [self.detail setText:[dateFormatter stringFromDate:self.note.lastChangedDate]];
}

@end
