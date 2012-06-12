//
//  MyCryptAppDelegate.h
//  MyCrypt
//
//  Created by Nagoor.KaniS on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyCryptViewController;

@interface MyCryptAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MyCryptViewController *viewController;

@end
