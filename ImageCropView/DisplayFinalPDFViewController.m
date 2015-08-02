//
//  DisplayFinalPDFViewController.m
//  ImageCropView
//
//  Created by Arjun Santhanam on 8/2/15.
//
//

#import "DisplayFinalPDFViewController.h"

@implementation DisplayFinalPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *imagebgTop = [UIImage imageNamed:@"background.jpg"];
    [navBar setBackgroundImage:imagebgTop forBarMetrics:UIBarMetricsDefault];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backward_arrow.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(10.0, 2.0, 45.0, 40.0);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    
    [self locatePDF];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)locatePDF {
    
    NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:_fileName]; //The file name passed from previous controller
    NSURL *urlPdf = [NSURL fileURLWithPath: file];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlPdf];
    
    [self.webView setUserInteractionEnabled:YES];
    [self.webView setDelegate:self];
    
    self.webView.scalesPageToFit = YES;
    
    [self.webView loadRequest:request];
    
}


@end


