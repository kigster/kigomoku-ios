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
#include <time.h>

#include "basic_ai.h"

#define NUM_DIRECTIONS 4
#define OUT_OF_BOUNDS 32
//#define PRINT_DEBUG

static int threat_cost[20]; 
static int threat_initialized = 0;
static int threats[NUM_DIRECTIONS];

static int possible_moves[1024];

void populate_threat_matrix();
void reset_row(int *row, int size);

//===============================================================================
// implementation

int pick_next_move_with_score(int **board, 
                   int size, 
                   int next_player, 
                   int *move_x, 
                   int *move_y,
                   double *move_score) {
    
    return pick_next_move_with_score_and_opponent(board, size, next_player, move_x, move_y, move_score, 1);
}

int pick_next_move_with_score_and_opponent(int **board, 
                                           int size, 
                                           int next_player, 
                                           int *move_x, 
                                           int *move_y,
                                           double *move_score,
                                           int include_opponent) {

    // return pick_next_random_move(board, size, next_player, move_x, move_y);
    int i, j;
    int **work_board = board; // copy_board(board, size);
    double our_score, enemy_score, score, max_score = 0;

    int possible_move_index = 0;
    memset(possible_moves, 0, sizeof(possible_moves));
    
    populate_threat_matrix();

    for (i = 0; i < size; i++) {
        for (j = 0; j < size; j++) {
            if (work_board[i][j] == AI_CELL_EMPTY) {
                our_score   = 1.5 * calc_score_at(work_board, size, next_player, i, j);
                enemy_score = (include_opponent == 1) ? 
                    1.0 * calc_score_at(work_board, size, other_player(next_player), i, j) :  0;

                score = our_score + enemy_score;

                if (score > THREAT_NOTHING) {
                    if (score == max_score) {
                        possible_moves[possible_move_index++] = i;
                        possible_moves[possible_move_index++] = j;
#ifdef PRINT_DEBUG
                        if (score > 0) {
                            printf("existing max at x:%d y:%d, ours => %.2f, enemy => %.2f, total => %.2f\n", i, j, our_score, enemy_score, score);
                        }
#endif                        
                    } else if (score > max_score) {
                        //printf("new max at x:%d y:%d, ours => %.2f, enemy => %.2f, total => %.2f\n", i, j, our_score, enemy_score, score);
                        memset(possible_moves, 0, sizeof(possible_moves));
                        possible_move_index = 0;
                        possible_moves[possible_move_index++] = i;
                        possible_moves[possible_move_index++] = j;
                        max_score = score; 
                    }
                }
            }
        }
    }
    

    if (max_score >= 0 && possible_move_index > 0) {
        int a_move_index = rand() % (possible_move_index / 2);
        *move_x = possible_moves[a_move_index * 2];
        *move_y = possible_moves[a_move_index * 2 + 1];
        *move_score = (double) max_score;
#ifdef PRINT_DEBUG
        printf("choosing random move from %d options, chose %d, x = %d, y = %d, score = %.2f\n", (possible_move_index / 2), a_move_index,
               *move_x, *move_y, *move_score);
#endif
        if (include_opponent == 0) {
            *move_score *= next_player; // change sign of the score depending on who it is
        }
        return RT_SUCCESS;
    }
    printf("ERROR: AI is unable to find a good move");
    return RT_FAILURE;
}
                              
// 
// Return 0 for success, -1 for error
//
int pick_next_move(int **board, 
                   int size, 
                   int next_player, 
                   int *move_x, 
                   int *move_y) {

    double score = 0;
    return pick_next_move_with_score(board, size, next_player, move_x, move_y, &score);
}

int other_player(int player) {
    return -player;
}

void reset_row(int *row, int size) {
    for (int i = 0; i < size; i++) {
        row[i] = OUT_OF_BOUNDS;
    }
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
    
    memset(threats, 0, NUM_DIRECTIONS * sizeof(int));

    // walk horizontally
    reset_row(row, row_size);
    for (i = x + 1, index = SEARCH_RADIUS + 1; i <= max_x; i++, index++)  row[index] = board[i][y];
    for (i = x - 1, index = SEARCH_RADIUS - 1; i >= min_x; i--, index--)  row[index] = board[i][y];

    threats[0] = calc_threat_in_one_dimension(row, player);
    
    // walk vertically
    reset_row(row, row_size);
    for (i = y + 1, index = SEARCH_RADIUS + 1; i <= max_y; i++, index++)  row[index] = board[x][i];
    for (i = y - 1, index = SEARCH_RADIUS - 1; i >= min_y; i--, index--)  row[index] = board[x][i];

    threats[1] = calc_threat_in_one_dimension(row, player);

    int j;    
    // walk diagonally top to bottom (left to right)
    reset_row(row, row_size);
    for (i = x + 1, j = y + 1, index = SEARCH_RADIUS + 1; 
         i <= max_x && j <= max_y; i++, j++, index++)                     row[index] = board[i][j];
    for (i = x - 1, j = y - 1, index = SEARCH_RADIUS - 1; 
         i >= min_x && j >= min_y; i--, j--, index--)                     row[index] = board[i][j];
    
    threats[2] = calc_threat_in_one_dimension(row, player);

    // walk diagonally bottom to top (left to right)
    reset_row(row, row_size);
    for (i = x, j = y, index = SEARCH_RADIUS; 
         i <= max_x && j >= min_y; i++, j--, index++)                     row[index] = board[i][j];
    for (i = x, j = y, index = SEARCH_RADIUS; 
         i >= min_x && j <= max_y; i--, j++, index--)                     row[index] = board[i][j];
    
    threats[3] = calc_threat_in_one_dimension(row, player);

  
    for (i = 0; i < NUM_DIRECTIONS; i++) {
        score += threat_cost[threats[i]];
        for (j = i + 1; j < NUM_DIRECTIONS; j++) {
            score += calc_combination_threat(threats[i], threats[j]);
        }
    }
    return score;
}


// calculates a total score for a configuration within a single-dimensional array
// where the cell of interest (being evaluated) is exactly in the middle (and assumed 
// to belong to player, and the array is (SEARCH_RADIUS * 2 + 1) in size.
int calc_threat_in_one_dimension(int *row, int player) {
    int player_square_count = 1; // total squares found for this player in the strip
    int player_contiguous_square_count = 1; // total contiguous squares found for this player
    int enemy_count = 0;
    int right_hole_count = 0, left_hole_count = 0;   // holes found (we don't go past double-holes)
    int last_square;
    int i;


#ifdef PRINT_DEBUG
    char c;
    for (i = 0; i < SEARCH_RADIUS * 2 + 1; i++) {
        if (row[i] == OUT_OF_BOUNDS) 
            c = 'B';
        else if (row[i] == AI_CELL_EMPTY) 
            c = '.';
        else if (row[i] == AI_CELL_BLACK) 
            c = 'x';
        else if (row[i] == AI_CELL_WHITE) 
            c = 'o';
        else 
            c = i;
        printf("%c", c);
    }
    printf("\n");
#endif
    
    // walk from the middle forward till the end
    for (i = SEARCH_RADIUS + 1, last_square = player; i <= SEARCH_RADIUS*2 && row[i] != OUT_OF_BOUNDS; i++) {
        if (count_squares(row[i], player, &last_square, &right_hole_count, 
                          &player_square_count, &player_contiguous_square_count, &enemy_count) == RT_BREAK) 
            break;
    }
    // walk from the middle back to the beginning
    for (i = SEARCH_RADIUS - 1, last_square = player; i >= 0 && row[i] != OUT_OF_BOUNDS; i--) {
        if (count_squares(row[i], player, &last_square, &left_hole_count, 
                          &player_square_count, &player_contiguous_square_count, &enemy_count) == RT_BREAK) 
            break;
    }
    
    int holes = left_hole_count + right_hole_count;
    int total = holes + player_square_count;
    int threat = THREAT_NOTHING;

    if (player_contiguous_square_count >= NEED_TO_WIN) {
        threat = THREAT_FIVE;
    } else if (player_contiguous_square_count == 4 && right_hole_count > 0 && left_hole_count > 0) {
        threat = THREAT_STRAIGHT_FOUR;
    } else if (player_contiguous_square_count == 4 && (right_hole_count > 0 || left_hole_count > 0)) {
        threat = THREAT_FOUR;
    } else if (player_contiguous_square_count == 3 && (right_hole_count > 0 && left_hole_count > 0)) {
        threat = THREAT_THREE;
    } else if (player_square_count >= 4 &&  (right_hole_count > 0 || left_hole_count > 0) && total >= 5) {
        threat = THREAT_FOUR_BROKEN;
    } else if (player_square_count >= 3 &&  (right_hole_count > 0 || left_hole_count > 0) && total >= 5) {
        threat = THREAT_THREE_BROKEN;
    } else if (player_contiguous_square_count >= 2 &&  (right_hole_count > 0 || left_hole_count > 0) && total >= 4) { 
        threat = THREAT_TWO;
    } else if (player_contiguous_square_count >= 1 && (right_hole_count == 0 || left_hole_count == 0) && enemy_count > 0) { 
        threat = THREAT_NEAR_ENEMY;
    }
#ifdef PRINT_DEBUG
    printf("got threat %d\n", threat);
#endif
    return threat;
}


int count_squares(int value, 
                  int player, 
                  int *last_square, 
                  int *hole_count, 
                  int *square_count, 
                  int *contiguous_square_count,
                  int *enemy_count) {
 
    if (value == player) {
        (*square_count)++;
        if (*hole_count == 0) { (*contiguous_square_count)++; }
        
    } else if (value == AI_CELL_EMPTY) {
        if (*last_square == AI_CELL_EMPTY) 
            return RT_BREAK;
        (*hole_count)++;
        
    } else if (value == -player) {
        // enemy 
        (*enemy_count) ++;
        return RT_BREAK;
    }
    // remember this value
    *last_square = value;
    return RT_CONTINUE;
}

int calc_combination_threat(int one, int two) {    
    
    if (
        ((one == THREAT_THREE) && (two == THREAT_FOUR || two == THREAT_FOUR_BROKEN)) || 
        ((two == THREAT_THREE) && (one == THREAT_FOUR || one == THREAT_FOUR_BROKEN))
        ) {
        return threat_cost[THREAT_THREE_AND_FOUR];
    } else if (one == THREAT_THREE && two == THREAT_THREE){
        return threat_cost[THREAT_THREE_AND_THREE];
    }
    return 0;
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
        
    } while (board[x][y] != AI_CELL_EMPTY && tries < 10000);
    
    if (board[x][y] == AI_CELL_EMPTY) {
        *move_x = x;
        *move_y = y;
        return RT_SUCCESS;
    }
    return RT_FAILURE;
    
}

void populate_threat_matrix() {
    if (threat_initialized > 0) {
        return;
    }

    threat_initialized = 1;
    srand(time(NULL));
    
    threat_cost[THREAT_NOTHING]                 = 0;
    threat_cost[THREAT_FIVE]                    = 100000;
    threat_cost[THREAT_STRAIGHT_FOUR]           = 50000;
    threat_cost[THREAT_THREE]                   = 1000;
    threat_cost[THREAT_FOUR]                    = 300;
    threat_cost[THREAT_FOUR_BROKEN]             = 150;
    threat_cost[THREAT_THREE_BROKEN]            = 30;
    threat_cost[THREAT_TWO]                     = 20;
    threat_cost[THREAT_NEAR_ENEMY]              = 5;
    
    // combinations
    threat_cost[THREAT_THREE_AND_FOUR]          = 5000;
    threat_cost[THREAT_THREE_AND_THREE]         = 5000;
    threat_cost[THREAT_THREE_AND_THREE_BROKEN]  = 300;    
}



