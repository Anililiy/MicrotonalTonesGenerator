/*
NSString *currentLevelKey = @"1";
NSMutableDictionary *levelInfo = [NSMutableDictionary dictionaryWithDictionary:[gameState.levels objectForKey:currentLevelKey]];

int highscore = [[levelInfo objectForKey:@"highscore"] intValue];
NSString *levelName = [levelInfo objectForKey:@"levelName"];
// Use highscore and update it...

// Update dictionary with what you have changed
[levelInfo setObject:[NSNumber numberWithInt:highscore] forKey:@"highscore"];

// Update GameState dictionary with this level
[gameState.levels setValue:levelInfo forKey:currentLevelKey];

// Save GameState
[[GameState sharedGameState] saveState];
*/