//
//  basic_ai.c
//  gomoku
//
//  Created by Konstantin Gredeskoul on 2/3/12.
//  Copyright (c) 2012. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "basic_ai.h"


//===============================================================================
// implementation

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
                score += calc_score_at(work_board, size, other_player(next_player), i, j);
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
#ifdef PRINT_DEBUG
    printf("evaluating cell at x=%d, y=%d\n", x, y);
#endif
    
    int min_x = max(x - SEARCH_RADIUS, 0);
    int max_x = min(x + SEARCH_RADIUS, size - 1);
    int min_y = max(y - SEARCH_RADIUS, 0);
    int max_y = min(y + SEARCH_RADIUS, size - 1);
    
    int row_size = SEARCH_RADIUS * 2 + 1;
    int row[SEARCH_RADIUS * 2 + 1];
    int i, index;
    int score = 0;

    // walk horizontally
    memset(row, -1, row_size);
    for (i = x + 1, index = SEARCH_RADIUS + 1; i <= max_x; i++, index++)  row[index] = board[i][y];
    for (i = x - 1, index = SEARCH_RADIUS - 1; i >= min_x; i--, index--)  row[index] = board[i][y];

    score += calc_score_in_one_dimension(row, player);
    
    // walk vertically
    memset(row, -1, row_size);
    for (i = y + 1, index = SEARCH_RADIUS + 1; i <= max_y; i++, index++)  row[index] = board[x][i];
    for (i = y - 1, index = SEARCH_RADIUS - 1; i >= min_y; i--, index--)  row[index] = board[x][i];

    score += calc_score_in_one_dimension(row, player);

    int j;    
    // walk diagonally top to bottom (left to right)
    memset(row, -1, row_size);
    for (i = x + 1, j = y + 1, index = SEARCH_RADIUS + 1; 
         i <= max_x && j <= max_y; i++, j++, index++)                     row[index] = board[i][j];
    for (i = x - 1, j = y - 1, index = SEARCH_RADIUS - 1; 
         i >= min_x && j >= min_y; i--, j--, index--)                     row[index] = board[i][j];
    
    score += calc_score_in_one_dimension(row, player);

    
    // walk diagonally bottom to top (left to right)
    memset(row, -1, row_size);
    for (i = x, j = y, index = SEARCH_RADIUS; 
         i <= max_x && j >= min_y; i++, j--, index++)                     row[index] = board[i][j];
    for (i = x, j = y, index = SEARCH_RADIUS; 
         i >= min_x && j <= max_y; i--, j++, index--)                     row[index] = board[i][j];
    
    score += calc_score_in_one_dimension(row, player);
    return score;
}


// calculates a total score for a configuration within a single-dimensional array
// where the cell of interest (being evaluated) is exactly in the middle (and assumed 
// to belong to player, and the array is (SEARCH_RADIUS * 2 + 1) in size.
int calc_score_in_one_dimension(int *row, int player) {
    
    int player_square_count = 1; // total squares found for this player in the strip
    int player_contiguous_square_count = 1; // total contiguous squares found for this player
    int right_hole_count = 0, left_hole_count = 0;   // holes found (we don't go past double-holes)
    int last_square;
    int i;

#ifdef PRINT_DEBUG
    for (i = 0; i < SEARCH_RADIUS * 2 + 1; i++) {
        printf("%s", row[i] == -1 ? "B" : (row[i] == 0 ? "." : (row[i] == 1 ? "X" : "O")));
    }
#endif
    
    // walk from the middle till the end
    for (i = SEARCH_RADIUS + 1, last_square = player; i <= SEARCH_RADIUS*2 && row[i] >= 0; i++) {
        if (count_squares(row[i], player, &last_square, &right_hole_count, 
                          &player_square_count, &player_contiguous_square_count) == RT_BREAK) 
            break;
    }
    // walk from the middle back to the beginning
    for (i = SEARCH_RADIUS - 1, last_square = player; i >= 0 && row[i] >= 0; i--) {
        if (count_squares(row[i], player, &last_square, &left_hole_count, 
                          &player_square_count, &player_contiguous_square_count) == RT_BREAK) 
            break;
    }
    
    int holes = left_hole_count + right_hole_count;
    int total = holes + player_square_count;
    int cost = COST_NOTHING;

    if (player_contiguous_square_count >= NEED_TO_WIN) {
        cost = COST_FIVE;
    } else if (player_contiguous_square_count == 4 && right_hole_count > 0 && left_hole_count > 0) {
        cost = COST_STRAIGHT_FOUR;
    } else if (player_contiguous_square_count == 4 && (right_hole_count > 0 || left_hole_count > 0)) {
        cost = COST_FOUR;
    } else if (player_contiguous_square_count == 3 && (right_hole_count > 0 && left_hole_count > 0)) {
        cost = COST_THREE;
    } else if (player_square_count >= 3 &&  (right_hole_count > 0 || left_hole_count > 0) && total >= 5) {
        cost =  COST_THREE_BROKEN;
    } else if (player_contiguous_square_count >= 2 &&  (right_hole_count > 0 || left_hole_count > 0) && total >= 4) { 
        cost =  COST_TWO;
    } else if (player_square_count >= 2 &&  (right_hole_count > 0 || left_hole_count > 0)) { 
        cost =  COST_TWO - 1;
    }

#ifdef PRINT_DEBUG
    printf("\ngot cost %d\n", cost);
#endif
    return cost;
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



