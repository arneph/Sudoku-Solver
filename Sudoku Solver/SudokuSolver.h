//
//  SudokuSolver.h
//  SudokuSolver
//
//  Created by Programmieren on 22.03.14.
//  Copyright (c) 2014 AP-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sudoku.h"

typedef enum{
    ResultSudokuImpossible,
    ResultSudokuWithMultipleSolutions,
    ResultSudokuWithSingleSolution
}SudokuSolverResult;

@interface SudokuSolver : NSObject

+ (SudokuSolverResult)solveSudoku: (Sudoku*)sudoku;

@end
