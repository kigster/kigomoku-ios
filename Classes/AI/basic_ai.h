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
 * For board of a given size, assume the board is filled with 0 (empty), 1 (X) or 2 (0).
 * next_player is set to either 1 or 2.
 *
 * AI calculates the next move, and saves it into &move_x, &move_y, and returns RC_SUCCESS;
 * or returns RT_FAILURE if no appropriate next move is found.
 *
 * NOTE: future revisions should allow passing flags to control the gameplay, such as Renji
 * variations.
 *
 */
int pick_next_move(int **board, int size, 
                    int next_player, 
                    int *move_x, int *move_y);


#endif
