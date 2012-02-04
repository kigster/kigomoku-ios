//
//  basic_ai.c
//  gomoku
//
//  Created by Konstantin Gredeskoul on 2/3/12.
//  Copyright (c) 2012. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include "basic_ai.h"

#define EMPTY 0

#define RT_SUCCESS 0
#define RT_FAILURE -1

#define CELLS_TO_SEARCH 1

#define max(a,b) \
    ({ __typeof__ (a) _a = (a); \
    __typeof__ (b) _b = (b); \
    _a > _b ? _a : _b; })

#define min(a,b) \
    ({ __typeof__ (a) _a = (a); \
    __typeof__ (b) _b = (b); \
    _a < _b ? _a : _b; })

int **copy_board(int** board, int size);
void free_board(int **board, int size);
int calc_score_at(int **work_board, int size, int next_player, int x, int y);
int other_player(int player);

// 
// Return 0 for success, -1 for error
//
int pick_next_move(int **board, int size, 
                    int next_player, 
                    int *move_x, int *move_y) {
    
    // return pick_next_random_move(board, size, next_player, move_x, move_y);
    int i, j, max_x = -1, max_y = -1;
    int **work_board = copy_board(board, size);
    float score, max_score = -1;

    for (i = 0; i < size; i++) {
        for (j = 0; j < size; j++) {
            if (work_board[i][j] == EMPTY) {
                score = 1.1 * calc_score_at(work_board, size, next_player, i, j);
                if (score > max_score && score > 0) {
                    printf("new PLAYER max at %d,%d, score = %.2f\n", i, j, score);
                    max_score = score; max_x = i; max_y = j;
                }
                score = calc_score_at(work_board, size, other_player(next_player), i, j);
                if (score > max_score && score > 0) {
                    printf("new ENEMY  max at %d,%d, score = %.2f\n", i, j, score);
                    max_score = score; max_x = i; max_y = j;
                }
            }
        }
    }

    free_board(work_board, size);
        
    if (max_score > 0) {
        *move_x = max_x;
        *move_y = max_y;
        return RT_SUCCESS;
    }

    return RT_FAILURE;
}
                              
void free_board(int **board, int size) {
    for(int i = 0; i < size; i++) free(board[i]); 
    free(board);
}

int **copy_board(int** board, int size) {
    int **new_board = malloc(size * sizeof(int *));
	for(int i = 0; i < size; i++) {
		new_board[i] = malloc(size * sizeof(int));
        for (int j = 0; j < size; j++) {
            new_board[i][j] = board[i][j];
        }
    }
    
    return new_board;
}

// todo: fix this
int other_player(int player) {
    return (player == 1) ? 2 : 1;
}

int calc_score_at(int **work_board, int size, int player, int x, int y) {
    int min_x = max(x - CELLS_TO_SEARCH, 0);
    int max_x = min(x + CELLS_TO_SEARCH, size - 1);
    int min_y = max(y - CELLS_TO_SEARCH, 0);
    int max_y = min(y + CELLS_TO_SEARCH, size - 1);
    
    //int num_empty = 0, num_other = 0, num_ours = 0;
    int score = 0;
    for (int i = min_x; i < max_x; i++) {
        for (int j = min_y; j < max_y; j++) {
            if ((abs(x - i) == 1 || abs(y - j) == 1) && 
                work_board[i][j] == player) {
                score++;
            }
        }
    }
    return score;
}

// Choose random move
int pick_next_random_move(int **board, int size, 
                   int next_player, 
                   int *move_x, int *move_y) {
    
    int x, y, tries = 0;
    
    do {
        x = (int)(rand() % size);
        y = (int)(rand() % size);
        tries++;
        
    } while (board[x][y] != EMPTY && tries < 10000);
    
    if (board[x][y] == EMPTY) {
        *move_x = x;
        *move_y = y;
        return RT_SUCCESS;
    }
    return RT_FAILURE;
    
}



