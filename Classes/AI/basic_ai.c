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


int calc_score_at(int **work_board, int size, int next_player, int x, int y);
int calc_score_one_way(int *row, int player);

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

    if (max_score >= 0) {
        *move_x = max_x;
        *move_y = max_y;
        return RT_SUCCESS;
    }
    printf("bad score %.2f\n", max_score);
    return RT_FAILURE;
}
                              

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
    
    int row_size = SEARCH_RADIUS * 2 + 1;
    int row[row_size];
    int i;
    int score = 0;

    // walk horizontally
    for (i = 0; i < row_size; i++)      row[i] = -1;
    for (i = x; i <= max_x; i++)        row[SEARCH_RADIUS + i - x] = board[i][y];
    for (i = x - 1; i >= min_x; i--)    row[i - min_x] = board[i][y];

    score += calc_score_one_way(row, player);
    
    // walk vertically
    for (i = 0; i < row_size; i++)      row[i] = -1;
    for (i = y; i <= max_y; i++)        row[SEARCH_RADIUS + i - y] = board[x][i];
    for (i = y - 1; i >= min_y; i--)    row[i - min_y] = board[x][i];

    score += calc_score_one_way(row, player);

//    // walk diagonally left to right
//    for (i = 0; i < row_size; i++)      row[i] = -1;
//    for (i = y; i <= max_y; i++)        row[SEARCH_RADIUS + i - y] = board[x][i];
//    for (i = y - 1; i >= min_y; i--)    row[i - min_y] = board[x][i];
//    
//    score += calc_score_one_way(row, player);


    return score;
}

int calc_score_one_way(int *row, int player) {
    
    int square_count = 1; // start by assuming we place there
    int contiguous_square_count = 1; 
    int right_hole_count = 0, left_hole_count = 0;   // holes found
    int last_square;
    int i;
    
    for (i = SEARCH_RADIUS + 1, last_square = player; i <= SEARCH_RADIUS*2 && row[i] >= 0; i++) {
        if (count_squares(row[i], player, &last_square, &right_hole_count, 
                          &square_count, &contiguous_square_count) == RT_BREAK) 
            break;
    }
    for (i = SEARCH_RADIUS - 1, last_square = player; i >= 0 && row[i] >= 0; i--) {
        if (count_squares(row[i], player, &last_square, &left_hole_count, 
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
    } else if (contiguous_square_count >= 2 &&  (right_hole_count > 0 || left_hole_count > 0)) { 
        return COST_TWO;
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
        if (*hole_count == 0) { (*contiguous_square_count)++; }
        
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



