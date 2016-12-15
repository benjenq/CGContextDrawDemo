//
//  EmptyProjectAppDelegate.h
//  EmptyProject
//
//  Created by Administrator on 16/2/25.
//  Copyright 2016 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGContextDrawDemoAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

