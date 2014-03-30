//
//  ServerViewController.m
//  mobileDrive
//
//  Created by Sebastian Sanchez on 3/12/14.
//  Copyright (c) 2014 Eric Klinginsmith. All rights reserved.
//

#import "ServerViewController.h"

// Used to get IP
#import <ifaddrs.h>
#import <arpa/inet.h>


#define kTrialMaxUploads 50

@interface ServerViewController ()

@end

@implementation ServerViewController{
    GCDWebServer* webServer;
   // NSMutableString *current_ip_address;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) init{
    NSLog(@"viewDidLoad ServerViewController.m");
    _current_ip_address = [NSMutableString stringWithString: @"test"];
    
    @autoreleasepool {
        
        // Create server
        webServer = [[GCDWebServer alloc] init];

        // Get the path to the website directory
        NSString* websitePath = [[NSBundle mainBundle] pathForResource:@"Website" ofType:nil];
        
        NSString* footer = [NSString stringWithFormat:NSLocalizedString(@"SERVER_FOOTER_FORMAT", nil),
                            [[UIDevice currentDevice] name],
                            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        NSDictionary* baseVariables = [NSDictionary dictionaryWithObjectsAndKeys:footer, @"footer", nil];
        
        //[webServer addGETHandlerForBasePath:@"/" directoryPath:NSHomeDirectory() indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
        [webServer addGETHandlerForBasePath:@"/" directoryPath:websitePath indexFilename:nil cacheAge:3600 allowRangeRequests:YES];

        // Redirect root website to index.html
        [webServer addHandlerForMethod:@"GET" path:@"/" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            
            // Called from GCD thread
            return [GCDWebServerResponse responseWithRedirect:[NSURL URLWithString:@"index.html" relativeToURL:request.URL] permanent:NO];
            
        }];
        /*
        [webServer addHandlerForMethod:@"GET" path:@"/index.html" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            
            // Called from GCD thread
            NSMutableDictionary* variables = [NSMutableDictionary dictionaryWithDictionary:baseVariables];
            [variables setObject:[NSString stringWithFormat:@"%i", kTrialMaxUploads] forKey:@"max"];
            return [GCDWebServerDataResponse responseWithHTMLTemplate:[websitePath stringByAppendingPathComponent:request.path] variables:variables];
            
        }];*/

        /*
        // Add a handler to respond to requests on any URL
        [webServer addDefaultHandlerForMethod:@"GET"
                                 requestClass:[GCDWebServerRequest class]
                                 processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                     
                                     return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>Hello World</p></body></html>"];
                                     
                                 }]; */
        
        
        NSLog(@"Before Running server");
        // Use convenience method that runs server on port 8080 until SIGINT received
        [webServer start];
        
        NSLog(@"#####");
        NSLog( [self getIPAddress] );
        NSLog(@"#####");
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad ServerViewController.m");
    //	webServer = [[GCDWebServer alloc] init];
	// Do any additional setup after loading the view.

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) turnOnServer{
    [webServer start];
}

-(void) turnOffServer{
    [webServer stop];
}

// Get IP Address
// Source: http://stackoverflow.com/questions/7072989/iphone-ipad-osx-how-to-get-my-ip-address-programmatically
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
@end
