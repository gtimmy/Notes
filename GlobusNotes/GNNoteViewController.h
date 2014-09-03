//
//  GNNoteViewController.h
//  GlobusNotes
//
//  Created by Artem Goncharov on 02/09/14.
//  Copyright (c) 2014 Artem Goncharov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface GNNoteViewController : UIViewController

@property (strong, nonatomic) Note *note;
@property (nonatomic) BOOL isNewNote;

@end
