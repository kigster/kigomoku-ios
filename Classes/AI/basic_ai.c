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

//int **copy_board(int** board, int size);
//void free_board(int **board, int size);
int calc_score_at(int **work_board, int size, int next_player, int x, int y);
int other_player(int player);
int pick_next_random_move(int **board, int size, 
                          int next_player, 
                          int *move_x, int *move_y);

int count_squares(int value, int player, int *last_square, 
                  int *hole_count, int *square_count, 
                  int *contiguous_square_count);

// 
// Return 0 for success, -1 for error
//
int pick_next_move(int **board, 
                   int size, 
                   int next_player, 
                   int *move_x, 
                   int *move_y) {
    
    // return pick_next_random_move(board, size, next_player, move_x, move_y);
    int i, j, max_x = -1, max_y = -1;
    int **work_board = board; // copy_board(board, size);
    float score, max_score = 0;

    for (i = 0; i < size; i++) {
        for (j = 0; j < size; j++) {
            if (work_board[i][j] == EMPTY) {
                score = 1.1 * calc_score_at(work_board, size, next_player, i, j);
                if (score > max_score && score > COST_NOTHING) {
                    printf("new PLAYER max at %d,%d, score = %.2f\n", i, j, score);
                    max_score = score; max_x = i; max_y = j;
                }
                score = calc_score_at(work_board, size, other_player(next_player), i, j);
                if (score > max_score && score > COST_NOTHING) {
                    printf("new ENEMY  max at %d,%d, score = %.2f\n", i, j, score);
                    max_score = score; max_x = i; max_y = j;
                }
            }
        }
    }

    // free_board(work_board, size);
    if (max_score >= 0) {
        *move_x = max_x;
        *move_y = max_y;
        return RT_SUCCESS;
    }
    printf("bad score %.2f\n", max_score);
    return RT_FAILURE;
}
                              
//void free_board(int **board, int size) {
//    for(int i = 0; i < size; i++) free(board[i]); 
//    free(board);
//}
//
//int **copy_board(int** board, int size) {
//    int **new_board = malloc(size * sizeof(int *));
//	for(int i = 0; i < size; i++) {
//		new_board[i] = malloc(size * sizeof(int));
//        for (int j = 0; j < size; j++) {
//            new_board[i][j] = board[i][j];
//        }
//    }
//    
//    return new_board;
//}

// todo: fix this
int other_player(int player) {
    return (player == 1) ? 2 : 1;
}

int calc_score_at(int **board, 
                  int size, 
                  int player, 
                  int x, 
                  int y) {
    
    int min_x = max(x - SEARCH_RADIUS, 0);
    int max_x = min(x + SEARCH_RADIUS, size - 1);
    int min_y = max(y - SEARCH_RADIUS, 0);
    int max_y = min(y + SEARCH_RADIUS, size - 1);
    
    //int num_empty = 0, num_other = 0, num_ours = 0;

    int square_count = 1; // start by assuming we place there
    int contiguous_square_count = 1; 
    int right_hole_count = 0, left_hole_count = 0;   // holes found
    int open_right = 0, open_left = 0;
    int last_square;
    // horizontal
    for (int i = x + 1, last_square = player; i <= max_x; i++) {
        if (count_squares(board[i][y], player, &last_square, &right_hole_count, 
                          &square_count, &contiguous_square_count) == RT_BREAK) 
            break;
    }
    for (int i = x - 1, last_square = player; i >= min_x; i--) {
        if (count_squares(board[i][y], player, &last_square, &left_hole_count, 
                          &square_count, &contiguous_square_count) == RT_BREAK) 
            break;
    }
    // vertical
    for (int i = y + 1, last_square = player; i <= max_y; i++) {
        if (count_squares(board[x][i], player, &last_square, &right_hole_count, 
                          &square_count, &contiguous_square_count) == RT_BREAK) 
            break;
    }
    for (int i = y - 1, last_square = player; i >= min_y; i--) {
        if (count_squares(board[x][i], player, &last_square, &left_hole_count, 
                          &square_count, &contiguous_square_count) == RT_BREAK) 
            break;
    }
    
    int holes = left_hole_count + right_hole_count;
    int total = holes + square_count;
    if (holes + square_count < NEED_TO_WIN) {
        return COST_NOTHING;
    } else if (contiguous_square_count >= NEED_TO_WIN) {
        return COST_FIVE;
    } else if (contiguous_square_count == 4 && right_hole_count > 0 && left_hole_count > 0) {
        return COST_STRAIGHT_FOUR;
    } else if (contiguous_square_count == 4 && (right_hole_count > 0 || left_hole_count > 0)) {
        return COST_FOUR;
    } else if (contiguous_square_count == 3 && (right_hole_count > 0 && left_hole_count > 0)) {
        return COST_THREE;
    } else if (square_count >= 3 &&  (right_hole_count > 0 || left_hole_count > 0) && total >= 6) {
        return COST_THREE_BROKEN;
    }
    return COST_NOTHING;
}


int count_squares(int value, 
                  int player, 
                  int *last_square, 
                  int *hole_count, 
                  int *square_count, 
                  int *contiguous_square_count) {

    if (value == player) {
        (*square_count)++;
        if (hole_count == 0) { (*contiguous_square_count)++; }
        
    } else if (value == EMPTY) {
        if (*last_square == EMPTY) 
            return RT_BREAK;
        (*hole_count)++;
        
    } else {
        return RT_BREAK;
    }
    // remember this value
    *last_square = value;
    return RT_CONTINUE;
}

// Choose random move
int pick_next_random_move(int **board, 
                          int size, 
                          int next_player, 
                          int *move_x, 
                          int *move_y) {
    
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



