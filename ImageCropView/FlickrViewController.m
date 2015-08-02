//
//  FlickrViewController.m
//  ImageCropView
//
//  Created by Arjun Santhanam on 8/2/15.
//
//

#import "FlickrViewController.h"
#import "AppDelegate.h"
NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";
@interface FlickrViewController ()
- (void)updateUserInterface:(NSNotification *)notification;
@end
@implementation FlickrViewController

-(void)viewDidLoad {
    NSLog(@"Here!");
    [super viewDidLoad];
   
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backward_arrow.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(10.0, 2.0, 45.0, 40.0);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    self.title = @"Flick Images";
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *imagebgTop = [UIImage imageNamed:@"background.jpg"];
    [navBar setBackgroundImage:imagebgTop forBarMetrics:UIBarMetricsDefault];
    

    
}


- (IBAction)searchButton:(id)sender {
    NSString *kFlickrAPIKey = @"8edbd2463db3dfed6d72a6e019f73838";
    NSString *searchTerm = _searchText.text;
    NSURL *flickrGetURL =  [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=10&format=json&nojsoncallback=1",kFlickrAPIKey,searchTerm]];
    
    NSData* data = [NSData dataWithContentsOfURL:flickrGetURL];
    NSError* error;
    //this works
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Response data being called : %@", stringData);
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSDictionary* photoJSON = [[NSDictionary alloc] initWithDictionary:[json valueForKey:@"photos"]];
    NSDictionary* photosJSON;
   // NSMutableArray *photoArray=[[NSMutableArray alloc] init];
    //NSArray *photoArray = [[NSArray alloc] initWithArray:[json valueForKey:@"photos.photo" ]];
    if(json == nil)
    {
        NSLog(@"NULL");
    }else
        
        NSLog(@"worked");
    
    
    for(NSString *key in [photoJSON allKeys]) {
        if([key  isEqual: @"photo"]){
            NSLog(@"Inside");
            for(int i = 0 ; i< 10 ; i++){
                photosJSON = [[NSDictionary alloc] initWithDictionary:[[photoJSON objectForKey:key] objectAtIndex: i]];
                NSString *farm = [photosJSON objectForKey:@"farm"];
                NSString *server = [photosJSON objectForKey:@"server"];
                NSString *secret = [photosJSON objectForKey:@"secret"];
                NSString *idString = [photosJSON objectForKey:@"id"];
                NSURL *photoURL =  [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@_s.jpg",farm,server,idString,secret]];
                NSData* data = [NSData dataWithContentsOfURL:photoURL];
                UIImage *image = [UIImage imageWithData:data];
                NSError* error;
                //this works
                NSLog(@"URL %@",photoURL);
                NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Response data being called : %@", stringData);
                
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            }
        }
        
    }
    
}
@end
