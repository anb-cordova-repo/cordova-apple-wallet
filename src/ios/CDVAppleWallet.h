/**
 * 8/8/2018
 * @author Hatem 
 * @header file
 */
#import "Foundation/Foundation.h"
#import "Cordova/CDV.h"
#import <Cordova/CDVPlugin.h>
#import <PassKit/PassKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface AppleWallet : CDVPlugin

- (void)isAvailable:(CDVInvokedUrlCommand*)command;
- (void) checkCardEligibility:(CDVInvokedUrlCommand*)command;
- (void) checkCardEligibilityBySuffix:(CDVInvokedUrlCommand*)command;

- (void) checkPairedDevices:(CDVInvokedUrlCommand*)command;
- (void) checkPairedDevicesBySuffix:(CDVInvokedUrlCommand*)command;
- (void)startAddPaymentPass:(CDVInvokedUrlCommand*)command;
- (void)completeAddPaymentPass:(CDVInvokedUrlCommand*)command;
/* Fix for MABS 8.1 */
- (void)sessionDidBecomeInactive:(nonnull WCSession *)session;

@end
