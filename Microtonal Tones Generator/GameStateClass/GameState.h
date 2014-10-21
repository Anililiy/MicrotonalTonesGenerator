#define kGameStatePlayCount @"GameStatePlayCount"
#define kGameStateMusic 	@"GameStateMusic"
#define kGameStateScores 	@"GameStateScores"
#define kGameStateLevels 	@"GameStateLevels"

@interface GameState : NSObject {
	int playCount;
	BOOL music;
	NSArray *scores;
	NSMutableDictionary *levels;
}

- (void) loadSavedState;
- (void) saveState;
+ (GameState *) sharedGameState;
+ (void) purgeSharedGameState;

@property (nonatomic, assign) int playCount;
@property (nonatomic, assign) BOOL music;
@property (nonatomic, retain) NSArray *scores;
@property (nonatomic, retain) NSMutableDictionary *levels;

@end