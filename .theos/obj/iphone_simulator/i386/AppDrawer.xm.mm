#line 1 "AppDrawer.xm"
#import <UIKit/UIKit.h>
#import "ADBlurEffect.h"

@interface SpringBoard <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (void)applicationDidFinishLaunching:(id)application;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

static UICollectionView *collectionView;

@interface UIWindow (Private)
- (void)_setSecure:(BOOL)secure;
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;
@end

UIView *tempView = nil;
UIVisualEffectView *visualEffectView = nil;
UIWindow *window = nil;

@interface SBHomeScreenViewController: UIViewController
-(void)tap;
-(void)move;
@end


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class UIWindow; @class SpringBoard; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static NSInteger _logos_method$_ungrouped$SpringBoard$collectionView$numberOfItemsInSection$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UICollectionView *, NSInteger); static UICollectionViewCell * _logos_method$_ungrouped$SpringBoard$collectionView$cellForItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UICollectionView *, NSIndexPath *); static CGSize _logos_method$_ungrouped$SpringBoard$collectionView$layout$sizeForItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UICollectionView *, UICollectionViewLayout*, NSIndexPath *); static void _logos_method$_ungrouped$SpringBoard$tap$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UITapGestureRecognizer *); static void _logos_method$_ungrouped$SpringBoard$move$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIPanGestureRecognizer *); static BOOL (*_logos_orig$_ungrouped$UIWindow$pointInside$withEvent$)(_LOGOS_SELF_TYPE_NORMAL UIWindow* _LOGOS_SELF_CONST, SEL, CGPoint, UIEvent *); static BOOL _logos_method$_ungrouped$UIWindow$pointInside$withEvent$(_LOGOS_SELF_TYPE_NORMAL UIWindow* _LOGOS_SELF_CONST, SEL, CGPoint, UIEvent *); 

#line 27 "AppDrawer.xm"


static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application) {
			_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application);
			window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
			window.windowLevel = UIWindowLevelAlert + 1;
			if ([window respondsToSelector:@selector(_setSecure:)]) [window _setSecure:YES];
			[window makeKeyAndVisible];

			tempView = [[UIView alloc] initWithFrame: CGRectMake (0,0,50,50)];
			tempView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
			tempView.layer.cornerRadius = 50 / 2;
			tempView.layer.shadowRadius  = 7.0f;
			tempView.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
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
			blurEffect = [ADBlurEffect effectWithStyle:UIBlurEffectStyleDark];

			visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

			visualEffectView.frame = tempView.bounds;
			visualEffectView.clipsToBounds = YES;
			visualEffectView.layer.cornerRadius = 50 / 2;
			[tempView addSubview:visualEffectView];
			[window addSubview: tempView];

			UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
			layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
			collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,100,100) collectionViewLayout:layout];
	    collectionView.dataSource = self;
	    collectionView.delegate = self;
			collectionView.alpha = 0.0;
			collectionView.layer.cornerRadius = 50 / 2;
			collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 0);
			[collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
	    [collectionView setBackgroundColor:[UIColor clearColor]];

	    [window addSubview: collectionView];
}



static NSInteger _logos_method$_ungrouped$SpringBoard$collectionView$numberOfItemsInSection$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UICollectionView * collectionView, NSInteger section) {
   return 4;
}



static UICollectionViewCell * _logos_method$_ungrouped$SpringBoard$collectionView$cellForItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UICollectionView * collectionView, NSIndexPath * indexPath) {
   UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

   cell.backgroundColor=[UIColor greenColor];

   return cell;
}



static CGSize _logos_method$_ungrouped$SpringBoard$collectionView$layout$sizeForItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UICollectionView * collectionView, UICollectionViewLayout* collectionViewLayout, NSIndexPath * indexPath) {
   return CGSizeMake(30, 30);
}

bool hasBeenResized = NO;
bool boxIsMoving = NO;


static void _logos_method$_ungrouped$SpringBoard$tap$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UITapGestureRecognizer * recognizer) {
	 if(hasBeenResized) {
		 [UIView animateWithDuration:0.4
	                       delay:.0
	      usingSpringWithDamping:4.0
	       initialSpringVelocity:4.0
	                     options:UIViewAnimationOptionCurveEaseOut
	                  animations:^{
	                      
												CGRect frameRect = tempView.frame;
												frameRect.size.width = frameRect.size.width / 4;
												CGRect frameRect2 = tempView.frame;
												frameRect2.size.width = frameRect2.size.width / 5;
												collectionView.alpha = 0.0;
												collectionView.frame = frameRect;
												tempView.frame = frameRect2;
												visualEffectView.frame = tempView.bounds;
	                  }completion: ^(BOOL done){
												hasBeenResized = NO;
												dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
														
														[NSThread sleepForTimeInterval:2.0f];
														dispatch_async(dispatch_get_main_queue(), ^{
																
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
	                      
												CGRect frameRect = tempView.frame;
												CGRect frameRect2 = tempView.frame;
												frameRect.size.width = frameRect.size.width * 4;
												frameRect2.size.width = frameRect2.size.width * 5;
												collectionView.frame = frameRect;
												collectionView.center = CGPointMake(tempView.center.x + 125, tempView.center.y);
												tempView.frame = frameRect2;
												visualEffectView.frame = tempView.bounds;
												collectionView.alpha = 1.0;
												tempView.alpha = 1.0f;
	                  } completion: ^(BOOL done){
												hasBeenResized = YES;
												dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
														
														[NSThread sleepForTimeInterval:2.0f];
														dispatch_async(dispatch_get_main_queue(), ^{
																
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
}


static void _logos_method$_ungrouped$SpringBoard$move$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIPanGestureRecognizer * pan) {
		UIView *viewToDrag = pan.view;
   CGPoint offset = [pan translationInView:viewToDrag.superview];
   CGPoint center = viewToDrag.center;
		

		viewToDrag.center = CGPointMake(center.x + offset.x, center.y + offset.y);

		
		if(viewToDrag.alpha == 0.5f) {
			viewToDrag.alpha = 1.0f;
		}
		collectionView.center = CGPointMake(viewToDrag.center.x + 25, viewToDrag.center.y);

		if(!CGPointEqualToPoint(center, viewToDrag.center)) {
				boxIsMoving = YES;
		}

		[pan setTranslation:CGPointZero inView:viewToDrag.superview];
		boxIsMoving = NO;

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       [NSThread sleepForTimeInterval:2.0f];
       dispatch_async(dispatch_get_main_queue(), ^{
						[UIView animateWithDuration: 0.5 animations: ^{
							if(CGPointEqualToPoint(center, viewToDrag.center) && !hasBeenResized) {
									viewToDrag.alpha = 0.5f;
									boxIsMoving = NO;
							}
						}];
       });
   });
}





static BOOL _logos_method$_ungrouped$UIWindow$pointInside$withEvent$(_LOGOS_SELF_TYPE_NORMAL UIWindow* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGPoint point, UIEvent * event) {
		
		window.userInteractionEnabled = NO;
		if(CGRectContainsPoint(tempView.frame, point) || CGRectContainsPoint(collectionView.frame, point)) {
			window.userInteractionEnabled = YES;
		}
   return YES;
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSInteger), strlen(@encode(NSInteger))); i += strlen(@encode(NSInteger)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UICollectionView *), strlen(@encode(UICollectionView *))); i += strlen(@encode(UICollectionView *)); memcpy(_typeEncoding + i, @encode(NSInteger), strlen(@encode(NSInteger))); i += strlen(@encode(NSInteger)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(collectionView:numberOfItemsInSection:), (IMP)&_logos_method$_ungrouped$SpringBoard$collectionView$numberOfItemsInSection$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(UICollectionViewCell *), strlen(@encode(UICollectionViewCell *))); i += strlen(@encode(UICollectionViewCell *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UICollectionView *), strlen(@encode(UICollectionView *))); i += strlen(@encode(UICollectionView *)); memcpy(_typeEncoding + i, @encode(NSIndexPath *), strlen(@encode(NSIndexPath *))); i += strlen(@encode(NSIndexPath *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(collectionView:cellForItemAtIndexPath:), (IMP)&_logos_method$_ungrouped$SpringBoard$collectionView$cellForItemAtIndexPath$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(CGSize), strlen(@encode(CGSize))); i += strlen(@encode(CGSize)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UICollectionView *), strlen(@encode(UICollectionView *))); i += strlen(@encode(UICollectionView *)); memcpy(_typeEncoding + i, @encode(UICollectionViewLayout*), strlen(@encode(UICollectionViewLayout*))); i += strlen(@encode(UICollectionViewLayout*)); memcpy(_typeEncoding + i, @encode(NSIndexPath *), strlen(@encode(NSIndexPath *))); i += strlen(@encode(NSIndexPath *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(collectionView:layout:sizeForItemAtIndexPath:), (IMP)&_logos_method$_ungrouped$SpringBoard$collectionView$layout$sizeForItemAtIndexPath$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UITapGestureRecognizer *), strlen(@encode(UITapGestureRecognizer *))); i += strlen(@encode(UITapGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(tap:), (IMP)&_logos_method$_ungrouped$SpringBoard$tap$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIPanGestureRecognizer *), strlen(@encode(UIPanGestureRecognizer *))); i += strlen(@encode(UIPanGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(move:), (IMP)&_logos_method$_ungrouped$SpringBoard$move$, _typeEncoding); }Class _logos_class$_ungrouped$UIWindow = objc_getClass("UIWindow"); MSHookMessageEx(_logos_class$_ungrouped$UIWindow, @selector(pointInside:withEvent:), (IMP)&_logos_method$_ungrouped$UIWindow$pointInside$withEvent$, (IMP*)&_logos_orig$_ungrouped$UIWindow$pointInside$withEvent$);} }
#line 222 "AppDrawer.xm"
