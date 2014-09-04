//
//  GNNoteTableViewCell.h
//  GlobusNotes
//
//  Created by Artem Goncharov on 02/09/14.
//  Copyright (c) 2014 Artem Goncharov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface GNNoteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (nonatomic, strong) Note *note;

- (void)refresh;

@end
