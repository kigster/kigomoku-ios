//
//  basic_ai.h
//  gomoku ANSI C AI basic interface
//
//  Created by Konstantin Gredeskoul on 2/3/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#ifndef gomoku_basic_ai_h
#define gomoku_basic_ai_h

#define RT_SUCCESS 0
#define RT_FAILURE -1

#define EMPTY 0

/**
 * For a board of a given size, assume that it is filled with int 0 (empty), 1 (X) or 2 (0).
 * next_player is set to either 1 or 2.
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

//==============================================================================================
// private
//==============================================================================================

#define SEARCH_RADIUS 5
#define NEED_TO_WIN 5

#define RT_BREAK 1
#define RT_CONTINUE 2

//===============================================================================
// REF: Go-Moku and Threat-Space Search, L.V. Allis, H.J. van den Herik (c) 1994
//
// winning position, straight five
#define COST_FIVE 3000

// the straight four is a a line of six squares, of which the attacker has 
// occupied the four center squares, while the two outer squares are empty; 
#define COST_STRAIGHT_FOUR 1000  

// the three is either a line of seven squares of which the three center 
// squares are occupied by the attacker, and the remaining four squares are 
// empty, or a line of six squares, with three consecutive squares of the four
// center squares occupied by the attacker, and the remaining three squares empty;
#define COST_THREE 200

// the four is defined as a line of five squares, of which the
// attacker has occupied any four, with the fifth square empty;
#define COST_FOUR 100

// the broken three is a line of six squares of which the attacker has occupied 
// three non-consecutive squares of the four center squares, while the other 
// three squares are empty.
#define COST_THREE_BROKEN 50

// just two squares together...
#define COST_TWO 10

// useless piece of shit.
#define COST_NOTHING 0

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
                  int *contiguous_square_count);

int pick_next_random_move(int **board, 
                          int size, 
                          int next_player, 
                          int *move_x, 
                          int *move_y);

int calc_score_in_one_dimension(int *row, 
                                int player);

#endif
