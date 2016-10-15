//
//  SudokuSolver.m
//  SudokuSolver
//
//  Created by Programmieren on 22.03.14.
//  Copyright (c) 2014 AP-Software. All rights reserved.
//

#import "SudokuSolver.h"

@implementation SudokuSolver

+ (SudokuSolverResult)solveSudoku:(Sudoku *)sudoku{
    if ([SudokuSolver isSudokuRuleConforming:sudoku] == false) {
        return ResultSudokuImpossible;
    }
    Sudoku *sudokuCopy = sudoku.copy;
    
    if ([SudokuSolver solveObviousCells:sudokuCopy] == false) {
        return ResultSudokuImpossible;
    }
    
    if (sudokuCopy.isSolved) {
        [sudoku copyValuesFromSudoku:sudokuCopy];
        return ResultSudokuWithSingleSolution;
    }
    
    int x = 0;
    int y = 0;
    while ([sudokuCopy valueAtRow:x column:y] != 0) {
        if (x < 8) {
            x++;
        }else{
            x = 0;
            y++;
        }
    }
    
    int solutionsCount = 0;
    Sudoku *solution;
    for (NSUInteger v = 1; v <= 9; v++) {
        if (![sudokuCopy isValuePossible:v atRow:x column:y]) continue;
        Sudoku *s = sudokuCopy.copy;
        [s setValue:v atRow:x column:y];
        
        SudokuSolverResult result = [SudokuSolver solveSudoku:s];
        if (result == ResultSudokuImpossible) {
            continue;
        }else if (result == ResultSudokuWithMultipleSolutions) {
            solution = s;
            solutionsCount = 10;
            break;
        }else if (result == ResultSudokuWithSingleSolution) {
            solutionsCount++;
            if (solutionsCount > 1) break;
            solution = s;
        }
    }
    
    [sudokuCopy copyValuesFromSudoku:solution];
    
    if (solutionsCount == 1) {
        [sudoku copyValuesFromSudoku:sudokuCopy];
        return ResultSudokuWithSingleSolution;
    }else if (solutionsCount == 0) {
        return ResultSudokuImpossible;
    }else{
        [sudoku copyValuesFromSudoku:sudokuCopy];
        return ResultSudokuWithMultipleSolutions;
    }
}

+ (BOOL)isSudokuRuleConforming: (Sudoku*)sudoku{
    for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
            NSUInteger v = [sudoku valueAtRow:r column:c];
            
            if (v == 0) continue;
            if (![sudoku isValuePossible:v atRow:r column:c]) return false;
        }
    }
    
    return true;
}

+ (BOOL)solveObviousCells: (Sudoku*)sudoku{
    while (true) {
        bool changed = false;
        for (int x = 0; x < 9; x++) {
            for (int y = 0; y < 9; y++) {
                if ([sudoku valueAtRow:x column:y] != 0) continue;
                
                bool possible [9] = {false};
                int possibleCount = 0;
                NSUInteger possibleValue = 0;
                
                for (NSUInteger v = 1; v <= 9; v++) {
                    possible[v - 1] = [sudoku isValuePossible:v atRow:x column:y];
                    if (possible[v - 1]) {
                        possibleCount++;
                        possibleValue = v;
                    }
                }
                
                if (possibleCount == 0) return false;
                if (possibleCount > 1) continue;
                [sudoku setValue:possibleValue atRow:x column:y];
                changed = true;
            }
        }
        
        for (int r = 0; r < 9; r++) {
            bool existingValues[9] = {false};
            bool emptyFields[9] = {false};
            for (int c = 0; c < 9; c++) {
                NSUInteger v = [sudoku valueAtRow:r column:c];
                
                emptyFields[c] = (v == 0);
                if (v == 0) continue;
                existingValues[v - 1] = true;
            }
            
            for (NSUInteger v = 1; v <= 9; v++) {
                if (existingValues[v - 1]) continue;
                
                int possibleFieldsCount = 0;
                int possibleField;
                for (int i = 0; i < 9; i++) {
                    if (emptyFields[i] == false) continue;
                    
                    if ([sudoku isValuePossible:v atRow:r column:i]) {
                        possibleFieldsCount++;
                        possibleField = i;
                    }
                }
                
                if (possibleFieldsCount == 0) return false;
                if (possibleFieldsCount > 1) continue;
                [sudoku setValue:v atRow:r column:possibleField];
                changed = true;
            }
        }
        
        for (int c = 0; c < 9; c++) {
            bool existingValues[9] = {false};
            bool emptyFields[9] = {false};
            for (int r = 0; r < 9; r++) {
                NSUInteger v = [sudoku valueAtRow:r column:c];
                
                emptyFields[r] = (v == 0);
                if (v == 0) continue;
                existingValues[v - 1] = true;
            }
            
            for (NSUInteger v = 1; v <= 9; v++) {
                if (existingValues[v - 1]) continue;
                
                int possibleFieldsCount = 0;
                int possibleField;
                for (int i = 0; i < 9; i++) {
                    if (emptyFields[i] == false) continue;
                    
                    if ([sudoku isValuePossible:v atRow:i column:c]) {
                        possibleFieldsCount++;
                        possibleField = i;
                    }
                }
                
                if (possibleFieldsCount == 0) return false;
                if (possibleFieldsCount > 1) continue;
                [sudoku setValue:v atRow:possibleField column:c];
                changed = true;
            }
        }
        
        if (!changed) return true;
    }
    
}

@end
