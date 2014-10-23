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
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ViewController

-(void) loadURL: (NSString *)theURL
{
    NSURL *url = [NSURL URLWithString:theURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.delegate = self;
    

}

-(void)viewDidAppear:(BOOL)animated
{

    self.backButton.Enabled = NO;
    self.forwardButton.Enabled = NO;
    
    [self loadURL:@"http://mobilemakers.co"];
    [self updatebuttons];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.networkActivityIndicator stopAnimating];
    [self updatebuttons];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSString *urlString = self.urlTextField.text;
    if ([urlString hasPrefix: @"http://"]) {
        [self loadURL:urlString];
        
    } else {
        NSString *httpString = [NSString stringWithFormat:@"http://%@",urlString];
        [self loadURL:httpString];
        
    }
    
    return YES;
}
- (IBAction)onBackButtonPressed:(id)sender {
    
    [self.webView goBack];

}
-(void)updatebuttons
{
    if (self.webView.canGoBack) {
        self.backButton.enabled =YES;
    }
    else
    {
    self.backButton.Enabled = NO;
    }

    if (self.webView.canGoForward) {
        self.forwardButton.Enabled = YES;
    }
    else
    {
        self.forwardButton.enabled = NO;
    }
    
    self.urlTextField.text = self.webView.request.URL.absoluteString;
    self.titleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    
}
- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
    
   
}
- (IBAction)onStopLoadingButtonPressed:(id)sender
{
    [self.webView stopLoading];
}
- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}
- (IBAction)comingSoon:(id)sender
{
    UIAlertController *comingSoon = [UIAlertController alertControllerWithTitle:nil message:@"Coming Soon" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:comingSoon animated:YES completion:nil];
    UIAlertAction *cancelSoon = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [comingSoon addAction:cancelSoon];
}

- (IBAction)deleteButton:(id)sender {
    
    self.urlTextField.text = @"";
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 20) {
        [UIView animateWithDuration:.5 animations:^{
            self.urlTextField.alpha = 1;
            self.urlTextField.frame = CGRectMake(self.urlTextField.frame.origin.x, 61, self.urlTextField.frame.size.width, self.urlTextField.frame.size.height);
    
    
        }];}
    else
    {
            [UIView animateWithDuration:.5 animations:^{
                self.urlTextField.alpha = 1;
                self.urlTextField.frame = CGRectMake(self.urlTextField.frame.origin.x, -40, self.urlTextField.frame.size.width, self.urlTextField.frame.size.height);
                
                
            }];
    }

}


@end
