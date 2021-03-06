//
//  UIWebViewTestViewController.m
//  UIWebViewTest
//
//  Created by Tomasz Janeczko on 11-07-28.
//  Copyright 2011. Released under MIT License
//

#import "UIWebViewTestViewController.h"
#import "JavaScriptChartHelper.h"

@implementation UIWebViewTestViewController
@synthesize webView=_webView;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) handleChartClick {
    NSLog(@"Chart click handled!");
}

#pragma mark - UIWebView delegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSArray *data = [NSArray arrayWithObjects:[NSNumber numberWithInteger:3], [NSNumber numberWithInteger:4], [NSNumber numberWithInteger:5], nil];
    NSArray *legend = [NSArray arrayWithObjects:@"First", @"Second", @"Third", nil];
    
    [JavaScriptChartHelper createPieChartInWebview:self.webView withData:data andLegend:legend];
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;

    NSString* path = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//TODO: Refactoring of this method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    //NSLog(requestString);
    
    if ([requestString hasPrefix:@"ios-log:"]) {
        NSString* logString = [[requestString componentsSeparatedByString:@":#iOS#"] objectAtIndex:1];
        NSLog(@"UIWebView console: %@", logString);
        return NO;
    } else if ([requestString hasPrefix:@"ios-chart-action:"]) {
        [self handleChartClick];
        return NO;
    }
    
    return YES;
}

@end
