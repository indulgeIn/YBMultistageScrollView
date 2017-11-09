//
//  YbWebView.m
//  ToolsDemoByYangBo
//
//  Created by cqdingwei@163.com on 17/3/8.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import "YbWebView.h"

@interface YbWebView () <UIWebViewDelegate, NSURLConnectionDataDelegate>
{
    BOOL _authenticated;
}
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLConnection *urlConnection;


@property (nonatomic, assign) BOOL showHudToKeyWindow;

@end

@implementation YbWebView
- (void)dealloc {
    
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    if (self.webView.delegate) {
        self.webView.delegate = nil;
    }
}
- (instancetype)initWithFrame:(CGRect)frame showHudToKeyWindow:(BOOL)showHudToKeyWindow
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.webView];
        WEAK_SELF
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        _showHudToKeyWindow = showHudToKeyWindow;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.webView];
        WEAK_SELF
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


#pragma mark *** private ***
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(ybWebView:finishLoadWithHeight:)]) {
            [_delegate ybWebView:self finishLoadWithHeight:self.webView.scrollView.contentSize.height];
            NSLog(@"_heightOfCell : %lf", self.webView.scrollView.contentSize.height);
        }
    }
}

#pragma mark *** public ***
- (void)loadWithUrlStr:(NSString *)urlStr {
    
    _request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [self.webView loadRequest:_request];
}
- (void)loadWithHTMLStr:(NSString *)HTMLStr {
    
    [self.webView loadHTMLString:HTMLStr baseURL:nil];
}

#pragma mark *** UIWebViewDelegate ***
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

#pragma mark - NURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    NSLog(@"WebController Got auth challange via NSURLConnection");
    
    if ([challenge previousFailureCount] == 0)
    {
        _authenticated = YES;
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"WebController received response via NSURLConnection");
    
    // remake a webview call now that authentication has passed ok.
    _authenticated = YES;
    [self.webView loadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


#pragma mark *** Getter ***
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.bounds];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}


@end
