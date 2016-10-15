//
//  AppDelegate.m
//  SudokuSolver
//
//  Created by Programmieren on 07.03.14.
//  Copyright (c) 2014 AP-Software. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate{
    Sudoku *sudoku;
}

- (id)init{
    self = [super init];
    if (self) {
        sudoku = [[Sudoku alloc] init];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    
}

- (void)windowWillClose:(NSNotification *)notification{
    [NSApp terminate:self];
}

#pragma mark -
#pragma mark NSTableView Datasource / Delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 9;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSUInteger value = [sudoku valueAtRow:row
                                   column:[tableView.tableColumns indexOfObject:tableColumn]];
    if (value == 0) return @"";
    else return @(value);
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([object isKindOfClass:[NSNumber class]]) {
        [sudoku setValue:((NSNumber*)object).unsignedIntegerValue
                   atRow:row
                  column:[_tableView.tableColumns indexOfObject:tableColumn]];
    }else{
        [sudoku setValue:0
                   atRow:row
                  column:[_tableView.tableColumns indexOfObject:tableColumn]];
    }
}

- (void)tableView:(NSTableView *)tableView
  willDisplayCell:(NSTextFieldCell*)cell
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row{
    [cell setFocusRingType:NSFocusRingTypeNone];
    
    NSInteger column = [_tableView.tableColumns indexOfObject:tableColumn];
    if ((((int)(row / 3)) + ((int)(column / 3))) % 2 == 1) {
        [cell setBackgroundColor:[NSColor colorWithDeviceWhite:.85 alpha:1]];
    }else{
        [cell setBackgroundColor:[NSColor colorWithDeviceWhite:.95 alpha:1]];
    }
}

#pragma mark -
#pragma mark Actions

- (void)pushedClear:(id)sender{
    sudoku = [[Sudoku alloc] init];
    [_tableView reloadData];
}

- (void)pushedSolve:(id)sender{
    __block SudokuSolverResult result;
    __block Sudoku *sudokuCopy = sudoku.copy;
    
    [_progressIndicator startAnimation:sender];
    
    dispatch_async(dispatch_queue_create("de.AP-Software.SudokuSolver.solverqueue", NULL), ^{
        result = [SudokuSolver solveSudoku:sudokuCopy];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [sudoku copyValuesFromSudoku:sudokuCopy];
            [_tableView reloadData];
            [_progressIndicator stopAnimation:sender];
            
            if (result == ResultSudokuImpossible) {
                NSAlert *alert;
                alert = [NSAlert alertWithMessageText:@"The sudoku is impossible."
                                        defaultButton:@"Okay"
                                      alternateButton:nil
                                          otherButton:nil
                            informativeTextWithFormat:@""];
                [alert beginSheetModalForWindow:_window completionHandler:nil];
            }else if (result == ResultSudokuWithMultipleSolutions) {
                NSAlert *alert;
                alert = [NSAlert alertWithMessageText:@"The sudoku has multiple possible solutions."
                                        defaultButton:@"Okay"
                                      alternateButton:nil
                                          otherButton:nil
                            informativeTextWithFormat:@""];
                [alert beginSheetModalForWindow:_window completionHandler:nil];
            }
        });
    });
}

@end
