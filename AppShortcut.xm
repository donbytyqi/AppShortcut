#import <UIKit/UIKit.h>
#import "AppShortcutBlur.h"
#include "AppList/AppList.h"

/*
 This is a tweak I wrote when I first started tweak development, please don't judge the code :P
 */



@interface SpringBoard <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (void)applicationDidFinishLaunching:(id)application;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

static UICollectionView *collectionView;
static NSMutableArray *appIds;

@interface UIWindow (Private)
- (void)_setSecure:(BOOL)secure;
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;
@end

@interface UIApplication ()
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

UIView *tempView = nil;
UIVisualEffectView *visualEffectView = nil;
UIWindow *window = nil;

@interface SBHomeScreenViewController: UIViewController
-(void)tap;
-(void)move;
@end

static NSMutableArray *testArray;
static UIImageView *closeButton;
static CGPoint lastPosition = CGPointMake(25.0, 25.0);
static BOOL userIsMovingTheCircle = NO;
static BOOL moveFreely = NO;

bool hasBeenResized = NO;
bool boxIsMoving = NO;

// coming soon?
// %hook SBWorkspace
// 		-(void)handleReachabilityModeActivated {
//
// 			%orig;
// 			SBWindow *backgroundView = MSHookIvar<SBWindow*>(self,"_reachabilityEffectWindow");
// 			SBWindow *backgroundView2 = MSHookIvar<SBWindow*>(self,"_reachabilityWindow");
//
// 			UIView *redView = [[UIView alloc] initWithFrame: CGRectMake(0,0 ,100, 100)];
// 			redView.backgroundColor = [UIColor redColor];
//
// 			[backgroundView addSubview: redView];
// 			redView.backgroundColor = [UIColor blueColor];
// 			[backgroundView2 addSubview: redView];
//
// 		}
// %end

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)application {
    %orig();
    
    NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.donbytyqi.appshortcut"];
    id isEnabled = [bundleDefaults valueForKey:@"isEnabled"];
    id isDarkModeEnabled = [bundleDefaults valueForKey:@"isDarkModeEnabled"];
    id snapToSidesBool = [bundleDefaults valueForKey:@"isSnapToSidesOn"];
    if([snapToSidesBool isEqual: @0]) {
        moveFreely = NO;
    } else if ([snapToSidesBool isEqual: @1]) {
        moveFreely = YES;
    } else {
        moveFreely = NO;
    }
    NSString *plistpath = @"/var/mobile/Library/Preferences/com.donbytyqi.appshortcut.plist";
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistpath];
    
    NSMutableArray *allKeys = [[plistDict allKeys] mutableCopy];
    appIds = [[NSMutableArray alloc] init];
    
    for (NSString *key in allKeys) {
        id object = [plistDict objectForKey: key];
        if([object isEqual:@1] && [key containsString: @"X-"]) {
            [appIds addObject: [key stringByReplacingOccurrencesOfString: @"X-" withString: @""]];
        }
    }
    
    if ([isEnabled isEqual:@0]) {
        %log("Cool!");
    } else {
        window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        window.windowLevel = UIWindowLevelAlert + 1;
        if ([window respondsToSelector:@selector(_setSecure:)]) [window _setSecure:YES];
        [window makeKeyAndVisible];
        
        NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/MobileSubstrate/DynamicLibraries/com.donbytyqi.appshortcut.bundle"];
        if([isDarkModeEnabled isEqual:@1]){
            closeButton = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"closeForBlack" ofType:@"png"]]];
        } else {
            closeButton = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"closeForWhite" ofType:@"png"]]];
        }
        closeButton.frame = CGRectMake(18, 16, 17, 17);
        closeButton.contentMode = UIViewContentModeScaleAspectFit;
        closeButton.alpha = 0.0f;
        
        double lastPositionKnownX = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastPositionOfCircleX"] floatValue];
        double lastPositionKnownY = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastPositionOfCircleY"] floatValue];
        
        tempView = [[UIView alloc] initWithFrame: CGRectMake (0,0,50,50)];
        lastPosition = CGPointMake(lastPositionKnownX, lastPositionKnownY);
        tempView.center = CGPointMake(lastPositionKnownX, lastPositionKnownY);
        tempView.backgroundColor = [UIColor clearColor];
        tempView.layer.cornerRadius = 50 / 2;
        tempView.layer.shadowRadius  = 7.0f;
        if([isDarkModeEnabled isEqual:@1]) {
            tempView.layer.shadowColor   = [UIColor blackColor].CGColor;
        } else {
            tempView.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
        }
        tempView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
        tempView.layer.shadowOpacity = 0.6f;
        tempView.layer.masksToBounds = NO;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tap:)];
        [tempView addGestureRecognizer: tapG];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [tempView addGestureRecognizer:panRecognizer];
        
        UIVisualEffect *blurEffect;
        if([isDarkModeEnabled isEqual:@1]) {
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        } else {
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
        
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        // 1
        // let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        // // 2
        // let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        // vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        // // 3
        // vibrancyView.contentView.addSubview(optionsView)
        // // 4
        // blurView.contentView.addSubview(vibrancyView)
        
        visualEffectView.frame = tempView.bounds;
        // visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        visualEffectView.clipsToBounds = YES;
        visualEffectView.layer.cornerRadius = 50 / 2;
        
        if([isDarkModeEnabled isEqual:@1]) {
            visualEffectView.backgroundColor = [UIColor blackColor];
        } else {
            visualEffectView.backgroundColor = [UIColor whiteColor];;
        }
        
        visualEffectView.alpha = 0.7f;
        [tempView addSubview: visualEffectView];
        [tempView insertSubview: closeButton aboveSubview: visualEffectView];
        [window addSubview: tempView];
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,100,100) collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.alpha = 0.0;
        collectionView.layer.cornerRadius = 50 / 2;
        collectionView.contentInset = UIEdgeInsetsMake(0, 3, 0, 4);
        [collectionView setShowsHorizontalScrollIndicator:NO];
        [collectionView setShowsVerticalScrollIndicator:NO];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        
        collectionView.center = CGPointMake(lastPositionKnownX, lastPositionKnownY);
        
        [window addSubview: collectionView];
    }
    
    
}

%new
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return appIds.count;
}

%new
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    NSString *string = [NSString stringWithFormat: @"%@", appIds[indexPath.item]];
    UIImage *image = [[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier: string];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0,0,30,30)];
    imageView.image = image;
    [cell.contentView addSubview: imageView];
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

%new
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(30, 30);
}
%new
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:appIds[indexPath.item] suspended:NO];
    [UIView animateWithDuration:0.4
                          delay:.0
         usingSpringWithDamping:4.0
          initialSpringVelocity:4.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Coming from a value of CGAffineTransformMakeScale(0.001, 1.0)
                         CGRect frameRect = tempView.frame;
                         frameRect.size.width = frameRect.size.width / 4;
                         CGRect frameRect2 = tempView.frame;
                         frameRect2.size.width = frameRect2.size.width / 5;
                         collectionView.alpha = 0.0;
                         collectionView.frame = frameRect;
                         closeButton.alpha = 0.0f;
                         tempView.frame = frameRect2;
                         visualEffectView.frame = tempView.bounds;
                         tempView.center = lastPosition;
                         collectionView.frame = tempView.frame;
                     }completion: ^(BOOL done){
                         hasBeenResized = NO;
                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                             //Here your non-main thread.
                             [NSThread sleepForTimeInterval:2.0f];
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 //Here you returns to main thread.
                                 [UIView animateWithDuration: 0.5 animations: ^{
                                     if(!boxIsMoving && !hasBeenResized) {
                                         tempView.alpha = 0.5f;
                                     }
                                 }];
                             });
                         });
                     }
     ];
}

%new
- (void)tap:(UITapGestureRecognizer *)recognizer {
    if(hasBeenResized) {
        [UIView animateWithDuration:0.4
                              delay:.0
             usingSpringWithDamping:4.0
              initialSpringVelocity:4.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             // Coming from a value of CGAffineTransformMakeScale(0.001, 1.0)
                             CGRect frameRect = tempView.frame;
                             frameRect.size.width = frameRect.size.width / 4;
                             CGRect frameRect2 = tempView.frame;
                             frameRect2.size.width = frameRect2.size.width / 5;
                             collectionView.alpha = 0.0;
                             collectionView.frame = frameRect;
                             tempView.frame = frameRect2;
                             closeButton.alpha = 0.0f;
                             visualEffectView.frame = tempView.bounds;
                             tempView.center = lastPosition;
                             collectionView.frame = tempView.frame;
                         }completion: ^(BOOL done){
                             hasBeenResized = NO;
                             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                 //Here your non-main thread.
                                 [NSThread sleepForTimeInterval:2.0f];
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     //Here you returns to main thread.
                                     [UIView animateWithDuration: 0.5 animations: ^{
                                         if(!boxIsMoving && !hasBeenResized) {
                                             tempView.alpha = 0.5f;
                                         }
                                     }];
                                 });
                             });
                         }
         ];
    } else {
        [UIView animateWithDuration:0.4
                              delay:.0
             usingSpringWithDamping:4.0
              initialSpringVelocity:4.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             // Coming from a value of CGAffineTransformMakeScale(0.001, 1.0)
                             CGRect frameRect = tempView.frame;
                             CGRect frameRect2 = tempView.frame;
                             frameRect.size.width = frameRect.size.width * 4;
                             frameRect2.size.width = frameRect2.size.width * 5;
                             collectionView.frame = frameRect;
                             collectionView.center = CGPointMake(tempView.center.x + 120, tempView.center.y);
                             tempView.frame = frameRect2;
                             visualEffectView.frame = tempView.bounds;
                             collectionView.alpha = 1.0;
                             tempView.alpha = 1.0f;
                             closeButton.alpha = 1.0f;
                             hasBeenResized = YES;
                             CGRect rectToCheckBounds = CGRectMake(tempView.frame.origin.x, tempView.frame.origin.x, tempView.frame.size.width, tempView.frame.size.height);
                             // - rectToCheckBounds.origin.x could work but it will go out of bounds on the other side lol
                             if (!CGRectContainsRect(tempView.superview.frame, rectToCheckBounds) && tempView.center.x >= [[UIScreen mainScreen] bounds].size.width){
                                 tempView.center = CGPointMake(tempView.center.x - 200, tempView.center.y);
                                 collectionView.center = CGPointMake(tempView.center.x + 20, tempView.center.y);
                             }
                         } completion: ^(BOOL done){
                             hasBeenResized = YES;
                             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                 //Here your non-main thread.
                                 [NSThread sleepForTimeInterval:2.0f];
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     //Here you returns to main thread.
                                     [UIView animateWithDuration: 0.5 animations: ^{
                                         if(!boxIsMoving && !hasBeenResized) {
                                             tempView.alpha = 0.5f;
                                         } else {
                                             tempView.alpha = 1.0f;
                                         }
                                     }];
                                 });
                             });
                         }
         ];
    }
}

%new
-(void)move:(UIPanGestureRecognizer *)pan {
    
    if(!hasBeenResized) {
        userIsMovingTheCircle = YES;
        UIView *viewToDrag = pan.view;
        
        CGPoint translation = [pan translationInView:viewToDrag.superview];
        CGPoint center = viewToDrag.center;
        // this is so the touch location moves from the finger not the center of the viewToDrag
        tempView.alpha = 1.0f;
        center.x += translation.x;
        center.y += translation.y;
        
        CGFloat checkOriginX = viewToDrag.frame.origin.x + translation.x; // imageView's origin's x position after translation, if translation is applied
        CGFloat checkOriginY = viewToDrag.frame.origin.y + translation.y; // imageView's origin's y position after translation, if translation is applied
        
        CGRect rectToCheckBounds = CGRectMake(checkOriginX, checkOriginY, viewToDrag.frame.size.width, viewToDrag.frame.size.height); // frame of imageView if translation is applied
        
        if (CGRectContainsRect(viewToDrag.superview.frame, rectToCheckBounds)){
            viewToDrag.center = center;
            lastPosition = center;
            collectionView.center = CGPointMake(viewToDrag.center.x + 20, viewToDrag.center.y);
            [pan setTranslation:CGPointZero inView:viewToDrag.superview];
            boxIsMoving = NO;
            
        }
        
        if(pan.state == UIGestureRecognizerStateEnded)
        {
            //All fingers are lifted.
            userIsMovingTheCircle = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration: 0.2 animations: ^{
                    if(moveFreely == NO) {
                        if(viewToDrag.center.x < (viewToDrag.superview.frame.size.width / 2)) {
                            viewToDrag.center = CGPointMake(25.0, viewToDrag.center.y);
                            lastPosition = viewToDrag.center;
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:lastPosition.x] forKey:@"lastPositionOfCircleX"];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:lastPosition.y] forKey:@"lastPositionOfCircleY"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        } else {
                            viewToDrag.center = CGPointMake([[UIScreen mainScreen] bounds].size.width - 25, viewToDrag.center.y);
                            lastPosition = viewToDrag.center;
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:lastPosition.x] forKey:@"lastPositionOfCircleX"];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:lastPosition.y] forKey:@"lastPositionOfCircleY"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        
                        collectionView.center = CGPointMake(viewToDrag.center.x + 20, viewToDrag.center.y);
                        [pan setTranslation:CGPointZero inView:viewToDrag.superview];
                        boxIsMoving = NO;
                    }
                }];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [NSThread sleepForTimeInterval:2.0f];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration: 0.5 animations: ^{
                            if(!boxIsMoving && !hasBeenResized) {
                                viewToDrag.alpha = 0.5f;
                            } else {
                                viewToDrag.alpha = 1.0f;
                            }
                        }];
                    });
                });
            });
            
        }
        
        if(!CGPointEqualToPoint(center, viewToDrag.center)) {
            boxIsMoving = YES;
        }
    }
}

%end

%hook UIWindow

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // umm, idk if this is a good idea, this basically changes back and forth, if user taps on the app drawer, it becomes interactible else the whatever view the user is being displayed
    window.userInteractionEnabled = NO;
    if(CGRectContainsPoint(tempView.frame, point) || CGRectContainsPoint(collectionView.frame, point)) {
        window.userInteractionEnabled = YES;
    }
    return YES;
}

%end
