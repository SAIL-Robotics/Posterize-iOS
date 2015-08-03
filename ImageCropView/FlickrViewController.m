//
//  FlickrViewController.m
//  ImageCropView
//
//  Created by Arjun Santhanam on 8/2/15.
//
//

#import "FlickrViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "MySupplementaryView.h"
NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";
@interface FlickrViewController ()

@end
@implementation FlickrViewController
NSString* searchTerm;
MySupplementaryView *headerView;
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
    self.title = @"Flickr Images";
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *imagebgTop = [UIImage imageNamed:@"background.jpg"];
    [navBar setBackgroundImage:imagebgTop forBarMetrics:UIBarMetricsDefault];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    //[self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"Cell"];
   // recipeImages = [NSMutableArray arrayWithObjects:@"posterize.png", @"posterize.png", @"posterize.png", @"posterize.png", @"posterize.png", nil];
    

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return searchImages.count;
    NSLog(@"Collec view");
}
- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [searchImages objectAtIndex:indexPath.row];
   
    
    
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"You clicked - %@",[imageArray objectAtIndex:indexPath.row]);
    NSURL *photo = [NSURL URLWithString:[[imageArray objectAtIndex:indexPath.row] absoluteString]];
    NSData* data = [NSData dataWithContentsOfURL:photo];
    _selectedImage = [UIImage imageWithData:data];
    [self performSegueWithIdentifier: @"flickrImageSegue" sender: self];
    

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
                NSLog(@"URL %@",photoURL);
                NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Response data being called : %@", stringData);
                
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            }
        }
        
    }
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@" From view controller The segue identifer %@",segue.identifier);
    
    if([segue.identifier isEqualToString:@"flickrImageSegue"])
    {
        NSLog(@"Back to view");
        
        ViewController *controller = (ViewController *)segue.destinationViewController;
        controller.passImage = _selectedImage;
        
        
        
    }
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MyHeader" forIndexPath:indexPath];
       
        [headerView.search addTarget:self
                              action:@selector(searchAction)
           forControlEvents:UIControlEventTouchUpInside];
        //NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%li", indexPath.section + 1];
        //headerView.title.text = title;
        //UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        //headerView.backgroundImage.image = headerImage;
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MyHeader" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (void)searchAction{
    
     searchTerm = headerView.searchText.text;
    NSLog(@"SearchAction %@", searchTerm);
    searchImages = [[NSMutableArray alloc]init];
    imageArray = [[NSMutableArray alloc]init];
    NSString *kFlickrAPIKey = @"8edbd2463db3dfed6d72a6e019f73838";
    
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
                NSURL *photoURL =  [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@_m.jpg",farm,server,idString,secret]];
                NSData* data = [NSData dataWithContentsOfURL:photoURL];
                UIImage *image = [UIImage imageWithData:data];
                [searchImages  addObject:image];
                [imageArray addObject:photoURL];
                NSError* error;
                NSLog(@"URL %@",photoURL);
                NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Response data being called : %@", stringData);
                
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            }
        }
        
        NSLog(@"Size %lu", (unsigned long)[searchImages count]);
    }
    [self.collectionView reloadData];

}

@end
