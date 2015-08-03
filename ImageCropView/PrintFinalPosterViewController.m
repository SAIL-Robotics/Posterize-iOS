//
//  PrintFinalPosterViewController.m
//  ImageCropView
//
//  Created by Aishwarya Krishnan on 7/31/15.
//
//

#import "PrintFinalPosterViewController.h"
#import "DisplayFinalPDFViewController.h"

@interface PrintFinalPosterViewController ()

@end

@implementation PrintFinalPosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Loading printfinalposter");
    [_printposterView setImage:_image];
    [_printposterView setHidden:YES];
    
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

    NSLog(@"total papes %d",_totalPapers);
 
    _pagesLabel.text = [NSString stringWithFormat:@"%d", _totalPapers];
    _orientationLabel.text = _orientation;
    //[_orientationLabel setText:_orientation];
    
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    NSLog(@"The original poster size : width : %ff and height : %f",_totalA4Width,_totalA4Height);
    
    [self cropImage:_printposterView.image];
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


- (void) cropImage:(UIImage *)croppedImage {
    
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%ld",unixTime];
    
    _fileName = @"Poster_";
    
    _fileName = [_fileName stringByAppendingString:timestamp];
     _fileName = [_fileName stringByAppendingString:@".pdf"];
    NSLog(@"FILE NAME %@", _fileName);
    
    [_fileLabel setText:_fileName];
    NSLog(@"cutting image");
    
    CGSize size = [croppedImage size];
    
    CGFloat pageOffset = 0;
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *pdfFileName = [documentDirectory stringByAppendingPathComponent:_fileName];
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    int a4Height = 11;
    double a4Width = 8.27;
    
    double oldWidth = size.width,oldHeight = size.height;
    //double newWidth=25,newHeight=33; //The size of the poster
    
    
    /*if(size.height > size.width) {
        newWidth = size.height;
        newHeight = size.width;
    }
    
    int totalA4Width = newWidth/a4Width;
    int totalA4Height = newHeight/a4Height;*/
    
    
    
    //imageDivision
    
    double loopWidth = oldWidth / _totalA4Width;
    double loopHeight = oldHeight / _totalA4Height;
    
    
    double edgeWidth = loopWidth * (_totalA4Width - (int) _totalA4Width);
    double edgeHeight = loopHeight * (_totalA4Height - (int) _totalA4Height);
    
    int xStart = 0, yStart = 0, xEnd = (int)(loopWidth), yEnd = (int)(loopHeight);
    bool isPartWidth = false;
    bool isPartHeight = false;
    
    for(int j = 0; j <= (int) _totalA4Height; j++)
    {
        for(int i=0; i <= (int) _totalA4Width; i++)
        {
            isPartWidth = false;
            isPartHeight = false;
            
            xEnd = (int)(loopWidth);
            yEnd = (int)(loopHeight);
            
            if(i == (int) _totalA4Width)
            {
                isPartWidth = true;
                xEnd = (int)edgeWidth;
                //alignment = Image.LEFT;
            }
            if(j == (int) _totalA4Height)
            {
                isPartHeight = true;
                yEnd = (int)edgeHeight;
                //alignment = Image.TOP;
            }
            xStart = (int)(i * (int)(loopWidth));
            yStart = (int)(j * (int)(loopHeight));
            
            [self makeRectangle :xStart :yStart :xEnd :yEnd :croppedImage];
            //Todo - write to PDF
            
        }
    }
    
    
    //imageDivision
    
    UIGraphicsEndPDFContext();
    
}


- (void) makeRectangle:(NSInteger) startX: (NSInteger) startY : (NSInteger) width : (NSInteger) height: (UIImage *) cutImage {
    
    UIImageView *cutImageView = [[UIImageView alloc] initWithImage:cutImage];
    CGSize size = [cutImage size];
    
    // Frame location in view to show original image
    [cutImageView setFrame:CGRectMake(0, 0, size.width, size.height)];
    
    // Create rectangle that represents a cropped image
    // from the middle of the existing image
    CGRect rect = CGRectMake(startX,startY ,
                             width, height);
    
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([cutImage CGImage], rect);
    
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    // Create and show the new image from bitmap data
    cutImageView = [[UIImageView alloc] initWithImage:img];
    [cutImageView setFrame:CGRectMake(startX,startY,width,height)];
    
    if(cutImageView.image!=nil) {
        NSLog(@"It should be saved");
        //792, 1122ß
        // UIImageWriteToSavedPhotosAlbum(cutImageView.image, self ,  @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
        [cutImageView.image drawInRect:CGRectMake(0, 0, 612,792)];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@" The segue identifer %@",segue.identifier);
    if([segue.identifier isEqualToString:@"displayPDFSegue"])
    {
        DisplayFinalPDFViewController *controller = (DisplayFinalPDFViewController *)segue.destinationViewController;
        controller.fileName = _fileName;
    }
    
}




-(void) uploadPDFFile {
    NSString *fileName = _fileName;
    // post body
    NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:_fileName];
    //The file name passed from previous controller
    
    NSData *itemdata = [NSData dataWithContentsOfFile:file];
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://71.112.204.61/AndroidFileUpload/fileUpload.php"]];
    [request setHTTPMethod:@"POST"];
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableData *postData = [NSMutableData data];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Append the Usertoken
    [postData appendData:[@"Content-Disposition: form-data; name=\"token\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Type: application/json\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"%s", "SOMETOKEN"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Append the file
    
    //NSData *data = [[NSFileManager defaultManager] contentsAtPath:file];
    
    // Append the file
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", fileName]dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[NSData dataWithData:itemdata]];
    
    
    
    // Close
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Append
    [request setHTTPBody:postData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"==> sendSyncReq returnString: %@", returnString);
    
    NSString* messageString = [NSString stringWithFormat: @"Your poster %@ was successfully uploaded to drive",_fileName];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                    message:messageString
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    //Toast.makeText
    
}


- (IBAction)uploadServerAction:(UIButton *)sender {
    [self uploadPDFFile];
}
@end
