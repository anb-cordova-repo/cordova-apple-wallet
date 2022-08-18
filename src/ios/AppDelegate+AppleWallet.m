/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
*/

#import "MainViewController.h"
#import "AppDelegate+AppleWallet.h"
#import <objc/runtime.h>

@implementation AppDelegate (AppleWallet)


// Borrowed from http://nshipster.com/method-swizzling/
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(application:didFinishLaunchingWithOptions:);
        SEL swizzledSelector = @selector(appleWallet_application:didFinishLaunchingWithOptions:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (BOOL)appleWallet_application:(UIApplication*)application 
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    BOOL handled = [self appleWallet_application:application didFinishLaunchingWithOptions:launchOptions];
    self.isPairedWatchExist = NO;
    self.viewController = [[MainViewController alloc] init];
    [self checkPairedWatches];
    
    return handled;
}

-(void)checkPairedWatches 
{
    if ([WCSession isSupported]) {
        self.session = [WCSession defaultSession];
        self.session.delegate = self;
        [self.session activateSession];
    }
}

/** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed.
- (void)sessionDidBecomeInactive:(WCSession *)session 
{
    
}

*/

/** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
- (void)sessionDidDeactivate:(WCSession *)session 
{
    
}

- (void)session:(nonnull WCSession *)session 
    activationDidCompleteWithState:(WCSessionActivationState)activationState 
    error:(nullable NSError *)error 
{
    if (activationState == WCSessionActivationStateActivated) {
        if (self.session.isPaired) {
            self.isPairedWatchExist = YES;
        }
    }
}

@end
