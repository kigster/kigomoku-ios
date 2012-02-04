//
//  basic_ai.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 2/3/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#ifndef gomoku_basic_ai_h
#define gomoku_basic_ai_h


int pick_next_move(int **board, int size, 
                    int next_player, 
                    int *move_x, int *move_y);

int pick_next_random_move(int **board, int size, 
                   int next_player, 
                   int *move_x, int *move_y);

#endif
