#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
static CGRect rect(double x,double y,double w,double h){return CGRectMake(x,y,w,h);}
static UIColor *color(double r,double g,double b){return [UIColor colorWithRed:r green:g blue:b alpha:1];}
@interface StreamController:UIViewController <WKUIDelegate, WKNavigationDelegate>
@property(nonatomic,strong) WKWebView* web; @property(nonatomic,strong) UIView* bar; @property(nonatomic,strong) UIButton* address; @property(nonatomic,strong) UIButton* back; @property(nonatomic,strong) UIButton* reloadButton; @property(nonatomic,strong) UIButton* full; @property(nonatomic,strong) UIButton* restore; @property(nonatomic) BOOL immersive;
@end
@implementation StreamController
- (UIButton*)button:(NSString*)title action:(SEL)sel parent:(UIView*)parent {
 UIButton *b=[UIButton buttonWithType:1]; [b setTitle:title forState:0]; [b setTitleColor:[UIColor whiteColor] forState:0]; b.titleLabel.font=[UIFont systemFontOfSize:15 weight:0.5]; b.backgroundColor=color(.12,.18,.25); [b addTarget:self action:sel forControlEvents:64]; [parent addSubview:b]; return b;
}
- (void)viewDidLoad { [super viewDidLoad]; self.view.backgroundColor=[UIColor blackColor];
 WKWebViewConfiguration *cfg=[[WKWebViewConfiguration alloc]init]; cfg.allowsInlineMediaPlayback=YES; cfg.mediaTypesRequiringUserActionForPlayback=0; cfg.allowsAirPlayForMediaPlayback=YES;
 self.web=[[WKWebView alloc]initWithFrame:self.view.bounds configuration:cfg]; self.web.UIDelegate=self; self.web.navigationDelegate=self; self.web.allowsBackForwardNavigationGestures=NO; [self.view addSubview:self.web];
 self.bar=[[UIView alloc]initWithFrame:rect(0,0,0,0)]; self.bar.backgroundColor=color(.05,.09,.14); [self.view addSubview:self.bar];
 self.address=[self button:@"Connect" action:@selector(prompt) parent:self.bar]; self.back=[self button:@"Back" action:@selector(backPage) parent:self.bar]; self.reloadButton=[self button:@"Reload" action:@selector(reloadPage) parent:self.bar]; self.full=[self button:@"Fullscreen" action:@selector(toggleFullscreen) parent:self.bar];
 self.restore=[self button:@"⋯" action:@selector(toggleFullscreen) parent:self.view]; self.restore.accessibilityLabel=@"Show app controls"; self.restore.alpha=.65; self.restore.hidden=YES;
 NSString *saved=[[NSUserDefaults standardUserDefaults]stringForKey:@"hostURL"]; if(saved.length) [self connect:saved]; else [self home];
}
- (void)home { [self.web loadHTMLString:@"<!doctype html><html><meta name='viewport' content='width=device-width,initial-scale=1'><style>body{background:#101923;color:#e8f2ff;font:17px -apple-system;padding:24px;line-height:1.6}h1{font-size:34px;line-height:1.2;color:#fff}small{color:#a8bdcf}code{color:#a8ddff;overflow-wrap:anywhere}a{color:#86caff}</style><h1>MoonlightWeb<br>for iPhone</h1><p>Stream your PC directly to this app.</p><p>1. Install and start MoonlightWeb on your PC.<br>2. Tap <b>Connect</b> above and enter your PC's streaming address or its <code>https://stream.moonlightweb.top/…</code> link.<br>3. Pair with the PIN shown on the PC, then start a stream.</p><p><a href='https://moonlightweb.top/guides/'>Host setup instructions</a></p><small>Unofficial WebKit client. The PC must remain online.</small></html>" baseURL:nil]; }
- (void)connect:(NSString*)raw { NSString *s=[raw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; if(!s.length)return; NSString* lower=[s lowercaseString]; if(![lower hasPrefix:@"https://"] && ![lower hasPrefix:@"http://"]) s=[@"http://" stringByAppendingString:s]; NSURL* u=[NSURL URLWithString:s]; if(!u.host.length){ [self error:@"Enter a valid HTTP or HTTPS streaming address."]; return; } [[NSUserDefaults standardUserDefaults]setObject:u.absoluteString forKey:@"hostURL"]; [self.web loadRequest:[NSURLRequest requestWithURL:u]]; }
- (void)error:(NSString*)message { UIAlertController* a=[UIAlertController alertControllerWithTitle:@"Connection" message:message preferredStyle:1]; [a addAction:[UIAlertAction actionWithTitle:@"OK" style:0 handler:nil]]; [self presentViewController:a animated:YES completion:nil]; }
- (void)prompt { UIAlertController *a=[UIAlertController alertControllerWithTitle:@"Connect to PC" message:@"Enter your MoonlightWeb host address, including its port if needed, or its full remote streaming URL." preferredStyle:1]; NSString* saved=[[NSUserDefaults standardUserDefaults]stringForKey:@"hostURL"]; [a addTextFieldWithConfigurationHandler:^(UITextField* f){f.placeholder=@"http://192.168.1.10:PORT"; f.text=saved; f.keyboardType=3; f.autocapitalizationType=0; f.autocorrectionType=1; f.clearButtonMode=1;}]; [a addAction:[UIAlertAction actionWithTitle:@"Cancel" style:1 handler:nil]]; __weak UIAlertController* wa=a; [a addAction:[UIAlertAction actionWithTitle:@"Connect" style:0 handler:^(UIAlertAction* act){UITextField* f=(UITextField*)[wa.textFields firstObject]; [self connect:f.text];}]]; [self presentViewController:a animated:YES completion:nil]; }
- (void)backPage { if(self.web.canGoBack)[self.web goBack]; else [self home]; }
- (void)reloadPage { [self.web reload]; }
- (BOOL)prefersStatusBarHidden { return self.immersive; }
- (BOOL)prefersHomeIndicatorAutoHidden { return self.immersive; }
- (UIStatusBarStyle)preferredStatusBarStyle {return UIStatusBarStyleLightContent;}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations { return UIInterfaceOrientationMaskAll; }
- (void)toggleFullscreen { self.immersive=!self.immersive; self.bar.hidden=self.immersive; self.restore.hidden=!self.immersive; [self setNeedsStatusBarAppearanceUpdate]; [self setNeedsUpdateOfHomeIndicatorAutoHidden]; [self layout]; }
- (void)viewDidLayoutSubviews { [super viewDidLayoutSubviews]; [self layout]; }
- (void)viewSafeAreaInsetsDidChange { [super viewSafeAreaInsetsDidChange]; [self layout]; }
- (void)layout { CGRect b=self.view.bounds; UIEdgeInsets s=self.view.safeAreaInsets; double w=b.size.width,h=b.size.height; double usable=w-s.left-s.right; double y=s.top; self.bar.frame=rect(0,y,w,48); double gap=4; double bw=(usable-5*gap)/4; self.address.frame=rect(s.left+gap,4,bw,40); self.back.frame=rect(s.left+2*gap+bw,4,bw,40); self.reloadButton.frame=rect(s.left+3*gap+2*bw,4,bw,40); self.full.frame=rect(s.left+4*gap+3*bw,4,bw,40); self.web.frame=self.immersive?rect(s.left,s.top,usable,h-s.top-s.bottom):rect(s.left,y+48,usable,h-y-48-s.bottom); self.restore.frame=rect(w-s.right-42,y+4,38,32); [self.view bringSubviewToFront:self.restore]; }
- (WKWebView*)webView:(WKWebView*)web createWebViewWithConfiguration:(WKWebViewConfiguration*)cfg forNavigationAction:(WKNavigationAction*)action windowFeatures:(WKWindowFeatures*)features { if(!action.targetFrame)[web loadRequest:action.request]; return nil; }
@end
@interface AppDelegate:UIResponder <UIApplicationDelegate>
@property(nonatomic,strong) UIWindow* window;
@end
@implementation AppDelegate
- (BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options { self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds]; self.window.rootViewController=[[StreamController alloc]init]; [self.window makeKeyAndVisible]; return YES; }
@end
int main(int argc,char**argv){ @autoreleasepool {return UIApplicationMain(argc,argv,nil,NSStringFromClass([AppDelegate class]));} }
