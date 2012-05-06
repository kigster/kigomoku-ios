//
//  basic_ai.h
//  gomoku ANSI C AI basic interface
//
//  Created by Konstantin Gredeskoul on 2/3/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#ifndef gomoku_basic_ai_h
#define gomoku_basic_ai_h

#define RT_SUCCESS  0
#define RT_FAILURE -1

#define AI_CELL_EMPTY  0
#define AI_CELL_BLACK  1
#define AI_CELL_WHITE -1

/**
 * For a board of a given size, assume that it is filled with int 0 (empty), 1 (X) or -1 (O).
 * next_player is set to either 1 or -1.
 *
 * AI calculates the next move, and saves it into &move_x, &move_y, and returns RT_SUCCESS;
 * or returns RT_FAILURE if no appropriate next move is found.
 *
 * NOTE: future revisions should allow passing flags to control the gameplay, such as Renji
 * variations.
 *
 */
int pick_next_move(int **board, 
                   int size, 
                   int next_player, 
                   int *move_x, 
                   int *move_y);

int pick_next_move_with_score(int **board, 
                              int size, 
                              int next_player, 
                              int *move_x, 
                              int *move_y,
                              double *move_score);

int pick_next_move_with_score_and_opponent(int **board, 
                              int size, 
                              int next_player, 
                              int *move_x, 
                              int *move_y,
                              double *move_score,
                              int include_opponent);

//==============================================================================================
// private
//==============================================================================================

#define SEARCH_RADIUS 5
#define NEED_TO_WIN 5

#define RT_BREAK 1
#define RT_CONTINUE 2

#define THREAT_NOTHING 0

//===============================================================================
// REF: Go-Moku and Threat-Space Search, L.V. Allis, H.J. van den Herik (c) 1994
//
// winning position, straight five
#define THREAT_FIVE 1

// the straight four is a a line of six squares, of which the attacker has 
// occupied the four center squares, while the two outer squares are empty; 
#define THREAT_STRAIGHT_FOUR 2

// the three is either a line of seven squares of which the three center 
// squares are occupied by the attacker, and the remaining four squares are 
// empty, or a line of six squares, with three consecutive squares of the four
// center squares occupied by the attacker, and the remaining three squares empty;
#define THREAT_THREE 3

// the four is defined as a line of five squares, of which the
// attacker has occupied any four, with the fifth square empty;
#define THREAT_FOUR 4

// the broken three is a line of six squares of which the attacker has occupied 
// three non-consecutive squares of the four center squares, while the other 
// three squares are empty.
#define THREAT_FOUR_BROKEN 5

#define THREAT_THREE_BROKEN 6

// just two squares together...
#define THREAT_TWO 7

#define THREAT_THREE_AND_FOUR  8
#define THREAT_THREE_AND_THREE  9
#define THREAT_THREE_AND_THREE_BROKEN 10

#define THREAT_NEAR_ENEMY 11

//===============================================================================

#define max(a,b) \
({ __typeof__ (a) _a = (a); \
__typeof__ (b) _b = (b); \
_a > _b ? _a : _b; })

#define min(a,b) \
({ __typeof__ (a) _a = (a); \
__typeof__ (b) _b = (b); \
_a < _b ? _a : _b; })

//===============================================================================
// private functions
int calc_score_at(int **work_board, 
                  int size, 
                  int next_player, 
                  int x, 
                  int y);

int other_player(int player);

int count_squares(int value, int player, int *last_square, 
                  int *hole_count, int *square_count, 
                  int *contiguous_square_count,
                  int *enemy_count);

int pick_next_random_move(int **board, 
                          int size, 
                          int next_player, 
                          int *move_x, 
                          int *move_y);

int calc_threat_in_one_dimension(int *row, 
                                int player);

int calc_combination_threat(int one, int two);

void populate_threat_matrix();


#endif
