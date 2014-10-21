#import "GameState.h"

static GameState *sharedGameState_ = nil;

@implementation GameState
@synthesize playCount, music, scores, levels;

+ (GameState *) sharedGameState
{
	if (!sharedGameState_) {
		sharedGameState_ = [[GameState alloc] init];
	}
	
	return sharedGameState_;
}

+ (id) alloc
{
	NSAssert(sharedGameState_ == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+ (void) purgeSharedGameState
{
	sharedGameState_ = nil;
}

- (id) init {
	if ( (self = [super init]) ) {		
		[self loadSavedState];
	}
	
	return self;
}

- (void) loadSavedState {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	playCount = [prefs integerForKey:kGameStatePlayCount];
	music = [prefs boolForKey:kGameStateMusic];
	scores = [[NSArray alloc] initWithArray:[prefs dictionaryForKey:kGameStateScores]];
	levels = [[NSMutableDictionary alloc] initWithDictionary:[prefs dictionaryForKey:kGameStateLevels]];
}

- (void) saveState
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	[prefs setInteger:playCount forKey:kGameStatePlayCount];
	[prefs setBool:music forKey:kGameStateMusic];
	[prefs setObject:scores forKey:kGameStateScores];
	[prefs setObject:levels forKey:kGameStateLevels];
	
	[prefs synchronize];
}

@end