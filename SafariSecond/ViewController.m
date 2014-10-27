//
//  ViewController.m
//  SafariSecond
//
//  Created by Vala Kohnechi on 10/22/14.
//  Copyright (c) 2014 Vala Kohnechi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate,UIWebViewDelegate,UIScrollViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;

@end

@implementation ViewController

- (void)updateButton
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    //display current URL
    self.urlTextField.text = [self.webView stringByEvaluatingJavaScriptFromString : @"window.location.href"];
    //display current page title
    self.titleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString : @"document.title"];
}

//hide spinner and manage button status when page finish loading
- (void)webViewDidFinishLoad : (UIWebView *)webView
{
    [self.networkActivityIndicator stopAnimating];
    [self updateButton];
}

- (void) loadURL : (NSString *)theURL
{
    NSURL *url = [NSURL URLWithString : theURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL : url];
    [self.webView loadRequest : urlRequest];
}

//prefix URL format
- (BOOL)textFieldShouldReturn : (UITextField *)textField
{
    NSString *urlString = self.urlTextField.text;
    if ([urlString hasPrefix : @"http://"])
    {
        [self loadURL : urlString];
    }
    else
    {
        NSString *httpString = [NSString stringWithFormat : @"http://%@" , urlString];
        [self loadURL : httpString];
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadURL : @"http://www.google.com"];
    self.webView.scrollView.delegate = self;
}

//apply google search to deal with error
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertController *invalid = [UIAlertController alertControllerWithTitle : @"Warning"
                                                                     message : @"Website is invalid!"
                                                              preferredStyle : UIAlertControllerStyleAlert];
    UIAlertAction *search = [UIAlertAction actionWithTitle : @"Google Search"
                                                     style : UIAlertActionStyleDefault
                                                   handler : ^(UIAlertAction *action)
    {
        NSString *googleText = self.urlTextField.text;
        NSString *googleString = [NSString stringWithFormat : @"http://www.google.com/search?q=%@" , googleText];
        [self loadURL : googleString];
    }
    ];
    [invalid addAction : search];
    [self presentViewController : invalid
                       animated : YES completion : ^
     {
         [self.networkActivityIndicator stopAnimating];
     }
     ];
}

//navigate back to previous page
- (IBAction)onBackButtonPressed : (id)sender
{
    [self.webView goBack];
}

//navigate forward to previous page
- (IBAction)onForwardButtonPressed : (id)sender
{
    [self.webView goForward];
}

//stop page from loading
- (IBAction)onStopLoadingButtonPressed : (id)sender
{
    [self.webView stopLoading];
}

//reload page
- (IBAction)onReloadButtonPressed : (id)sender
{
    [self.webView reload];
}

//button with alert action
- (IBAction)comingSoon : (id)sender
{
    UIAlertController *comingSoon = [UIAlertController alertControllerWithTitle : @""
                                                                        message : @"Coming Soon!"
                                                                 preferredStyle : UIAlertControllerStyleAlert];
    UIAlertAction *cancelSoon = [UIAlertAction actionWithTitle : @"Return"
                                                         style : UIAlertActionStyleDefault
                                                       handler : nil];
    [comingSoon addAction : cancelSoon];
    [self presentViewController : comingSoon animated : YES completion : nil];
}

//move textField location while scrolling
- (void)scrollViewDidScroll : (UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0)
    {
        self.urlTextField.alpha = 0.4;
        self.buttonView.alpha = 0.4;
        [UIView animateWithDuration : 0.8 animations : ^
         {
             self.urlTextField.alpha = 1;
             self.buttonView.alpha = 1;
             self.urlTextField.frame = CGRectMake(self.webView.frame.origin.x+16 ,
                                                  self.webView.frame.origin.y+5 ,
                                                  self.webView.frame.size.width-32 ,
                                                  self.urlTextField.frame.size.height);
             self.buttonView.frame =CGRectMake(self.webView.frame.origin.x ,
                                               self.webView.frame.size.height+15 ,
                                               self.webView.frame.size.width ,
                                               self.buttonView.frame.size.height);
         }
        ];
    }
    else
    {
        self.urlTextField.alpha = 1;
        self.buttonView.alpha = 1;
        [UIView animateWithDuration : 1.2 animations : ^
         {
             self.urlTextField.alpha = 0.4;
             self.buttonView.alpha = 0.4;
             self.urlTextField.frame = CGRectMake(self.webView.frame.origin.x+16 ,
                                                  self.webView.frame.origin.y-90 ,
                                                  self.webView.frame.size.width-32 ,
                                                  self.urlTextField.frame.size.height);
             self.buttonView.frame =CGRectMake(self.webView.frame.origin.x ,
                                               self.webView.frame.size.height+55 ,
                                               self.webView.frame.size.width ,
                                               self.buttonView.frame.size.height);
         }
        ];
    }
}

@end
