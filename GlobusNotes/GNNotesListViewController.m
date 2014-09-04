//
//  GNNotesListViewController.m
//  GlobusNotes
//
//  Created by Artem Goncharov on 02/09/14.
//  Copyright (c) 2014 Artem Goncharov. All rights reserved.
//

#import "GNNotesListViewController.h"
#import "GNNoteTableViewCell.h"
#import "GNNoteViewController.h"
#import "GNNotesProvider.h"

#define kRowHeight 100.0
#define kCellIdentifier @"Cell"

@interface GNNotesListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *noNotesLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GNNotesListViewController
{
    NSArray *notes;
    NSArray *searchResults;
    NSMutableArray *attributedSearchResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    notes = [[GNNotesProvider sharedInstance] notesList];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    [self updateTable];
    [self.tableView scrollRectToVisible:CGRectMake(0, self.searchDisplayController.searchBar.frame.size.height, 1, 1) animated:NO];
}

#pragma mark - Helpful methods

- (void)updateTable
{
    notes = [[GNNotesProvider sharedInstance] notesList];
    [self checkNoNotesLabel];
    [self.tableView reloadData];
}

- (void)checkNoNotesLabel
{
    if ([notes count] == 0) {
        self.noNotesLabel.hidden = NO;
    }
    else {
        self.noNotesLabel.hidden = YES;
    }
    [self.tableView setHidden:!self.noNotesLabel.hidden];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return [notes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GNNoteTableViewCell *cell = (GNNoteTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell = [self configureCell:cell forTableView:tableView atIndexPath:indexPath];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        GNNoteTableViewCell *noteCell = (GNNoteTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        noteCell.alpha = 0.0;
        [[GNNotesProvider sharedInstance] removeNote:noteCell.note];
        notes = [[GNNotesProvider sharedInstance] notesList];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self checkNoNotesLabel];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GNNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    cell = [self configureCell:cell forTableView:tableView atIndexPath:indexPath];
    [cell layoutSubviews];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (GNNoteTableViewCell *)configureCell:(GNNoteTableViewCell *)cell forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    }
    if (cell == nil) {
        cell = [[GNNoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    NSAttributedString *attributedString;
    Note *note = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        note = [searchResults objectAtIndex:indexPath.row];
        attributedString = [attributedSearchResults objectAtIndex:indexPath.row];
    } else {
        note = [notes objectAtIndex:indexPath.row];
    }
    [cell setNote:note];
    [cell refresh];
    
    
    if (attributedString) {
        cell.title.attributedText = attributedString;
    }
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = nil;
        Note *note = nil;
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            note = [searchResults objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            note = [notes objectAtIndex:indexPath.row];
        }
        
        GNNoteViewController *destViewController = segue.destinationViewController;
        destViewController.note = note;
    }
    if ([segue.identifier isEqualToString:@"CreateNewNote"]) {        
        
        GNNoteViewController *destViewController = segue.destinationViewController;
        destViewController.note = [[GNNotesProvider sharedInstance] addNote];
        destViewController.isNewNote = YES;
    }
}

#pragma mark - Search Display Controller

- (void)searchResultsForText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"noteText contains[c] %@", searchText];
    searchResults = [notes filteredArrayUsingPredicate:resultPredicate];
    attributedSearchResults = [[NSMutableArray alloc] initWithCapacity:[searchResults count]];
    for (Note *note in searchResults) {
        NSString *resultsText = note.noteText;
        
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:resultsText];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, resultsText.length)];
        
        NSString * regexPattern = [NSString stringWithFormat:@"(%@)", searchText];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSRange range = NSMakeRange(0,resultsText.length);
        
        [regex enumerateMatchesInString:resultsText
                                options:kNilOptions
                                  range:range
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 
                                 NSRange subStringRange = [result rangeAtIndex:1];
                                 
                                 [mutableAttributedString addAttribute:NSForegroundColorAttributeName
                                              value:[UIColor blackColor]
                                              range:subStringRange];
                             }];
        [attributedSearchResults addObject:mutableAttributedString];
    }
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchResultsForText:searchString];
    
    return YES;
}

@end
