//
//  AppDelegate.h
//  SudokuSolver
//
//  Created by Programmieren on 07.03.14.
//  Copyright (c) 2014 AP-Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Sudoku.h"
#import "SudokuSolver.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property IBOutlet NSTableView *tableView;
@property IBOutlet NSProgressIndicator *progressIndicator;

- (IBAction)pushedClear:(id)sender;
- (IBAction)pushedSolve:(id)sender;

@end
