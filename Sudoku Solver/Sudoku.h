//
//  Sudoku.h
//  SudokuSolver
//
//  Created by Programmieren on 07.03.14.
//  Copyright (c) 2014 AP-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sudoku : NSObject <NSCopying>

- (NSUInteger)valueAtRow: (NSUInteger)row column: (NSUInteger)column;
- (void)setValue: (NSUInteger)value atRow: (NSUInteger)row column: (NSUInteger) column;

- (NSUInteger)numberOfGivenCells;
- (BOOL)isSolved;
- (BOOL)isValuePossible: (NSUInteger)value atRow: (NSUInteger)row column: (NSUInteger)column;

- (void)copyValuesFromSudoku: (Sudoku*)sudoku;

@end
