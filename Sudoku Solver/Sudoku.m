//
//  Sudoku.m
//  SudokuSolver
//
//  Created by Programmieren on 07.03.14.
//  Copyright (c) 2014 AP-Software. All rights reserved.
//

#import "Sudoku.h"

@implementation Sudoku{
    NSUInteger values[81];
}

- (id)init{
    self = [super init];
    if (self) {
        for (NSUInteger i = 0; i < 81; i++) {
            values[i] = 0;
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    Sudoku *copy = [[[self class] alloc] init];
    for (int x = 0; x < 9; x++) {
        for (int y = 0; y < 9; y++) {
            [copy setValue:[self valueAtRow:x column:y] atRow:x column:y];
        }
    }
    return copy;
}

- (NSUInteger)valueAtRow: (NSUInteger)row column: (NSUInteger)column{
    if (row > 8 || column > 8) {
        @throw NSInvalidArgumentException;
        return NSNotFound;
    }
    return values[row + (column * 9)];
}

- (void)setValue: (NSUInteger)value atRow: (NSUInteger)row column: (NSUInteger) column{
    if (row > 8 || column > 8 || value > 9) {
        @throw NSInvalidArgumentException;
        return;
    }
    values[row + (column * 9)] = value;
}

- (NSUInteger)numberOfGivenCells{
    NSUInteger counter = 0;
    for (int i = 0; i < 81; i++) {
        if (values[i] != 0) counter++;
    }
    return counter;
}

- (BOOL)isSolved{
    for (int i = 0; i < 81; i++) {
        if (values[i] == 0) return false;
    }
    return true;
}

- (BOOL)isValuePossible: (NSUInteger)value atRow: (NSUInteger)row column: (NSUInteger)column{
    if (value == 0 || value > 9 || row > 8 || column > 8) return false;
    
    for (int i = 0; i < 9; i++) {
        if (i == column) continue;
        if ([self valueAtRow:row column:i] == value) return false;
    }
    
    for (int i = 0; i < 9; i++) {
        if (i == row) continue;
        if ([self valueAtRow:i column:column] == value) return false;
    }
    
    for (int i = 0; i < 9; i++) {
        int r = (((int)(row / 3)) * 3) + ((int)(i / 3));
        int c = (((int)(column / 3)) * 3) + (i % 3);
        
        if (r == row && c == column) continue;
        
        NSUInteger v = [self valueAtRow: r column:c];
        
        if (v == value) return false;
    }
    
    return true;
}

- (void)copyValuesFromSudoku:(Sudoku *)sudoku{
    for (int x = 0; x < 9; x++) {
        for (int y = 0; y < 9; y++) {
            NSUInteger v = [sudoku valueAtRow:x column:y];
            [self setValue:v atRow:x column:y];
        }
    }
}

@end
