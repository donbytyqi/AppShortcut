#include "adsRootListController.h"
#include <spawn.h>
#include <signal.h>

@implementation adsRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)email {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:spontaneousarray@gmail.com"]];
}

- (void)follow {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/donbytyqi"]];
}

-(void)respringDevice {
		pid_t pid;
		int status;
		const char *argv[] = {"killall", "SpringBoard", NULL};
		posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv, NULL);
		waitpid(pid, &status, WEXITED);
}

@end
