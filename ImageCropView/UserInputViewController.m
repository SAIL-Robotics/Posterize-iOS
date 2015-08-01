//
//  UserInputViewController.m
//  ImageCropView
//
//  Created by Aishwarya Krishnan on 7/29/15.
//
//

#import "UserInputViewController.h"
#import "ViewController.h"
#import "PosterController.h"

@interface UserInputViewController ()

@end

@implementation UserInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_imageView setImage:_image];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    _widthText.keyboardType = UIKeyboardTypeNumberPad;
    _heightText.keyboardType = UIKeyboardTypeNumberPad;
    
    _widthText.delegate = self;
    _heightText.delegate = self;
    
    [self.view addGestureRecognizer:tap];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *imagebgTop = [UIImage imageNamed:@"background.jpg"];
    [navBar setBackgroundImage:imagebgTop forBarMetrics:UIBarMetricsDefault];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard {
    [_widthText resignFirstResponder];
    [_heightText resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    if (range.length > 0 && [string length] == 0) {
        return YES;
    }
   
    if (range.location == 0 && [string isEqualToString:@"."]) {
        return NO;
    }
  
    NSString *newValue = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    newValue = [[newValue componentsSeparatedByCharactersInSet:nonNumberSet] componentsJoinedByString:@""];
    textField.text = newValue;
   
    return NO;
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@" The segue identifer %@",segue.identifier);
    
    if([segue.identifier isEqualToString:@"posterSegue"])
    {
        NSLog(@"inside");
       
        
        PosterController *controller = (PosterController *)segue.destinationViewController;
       // controller.widthString = widthText;
        //controller.heightString = heightText;
        controller.image = _imageView.image;
        
        NSLog(@"CGSIZE %f %f",_imageView.image.size.width,_imageView.image.size.height);
        
        //TODO - i think we need to remove this
        //controller.totalA4Width = *(_totalA4Width);
        //controller.totalA4Height = *(_totalA4Height);
        
        controller.newWidth = [_widthText.text doubleValue];
        controller.newHeight = [_heightText.text doubleValue];
            
        //controller.stringForVC2 = @"some string";
        // here you have passed the value //
        
    }
    
    }

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    NSString *widthText = _widthText.text;
    NSString *heightText = _heightText.text;
    
    if(widthText.length == 0){
        //alert saying its not there
        NSLog(@"Width missing");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                                        message:@"Please fill in width"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
        
    }
    else if(heightText.length == 0) {
        //alert saying its not there
        NSLog(@"Height missing");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                                        message:@"Please fill in height"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    else {
        
        double widthDouble = [widthText doubleValue];
        NSString *message1 =[[NSString alloc] initWithFormat:@"%f",widthDouble];
        
        double heightDouble = [heightText doubleValue];
        NSString *message2 =[[NSString alloc] initWithFormat:@"%f",heightDouble];
        
        NSLog(@"the two are @%f @%f",widthDouble,heightDouble);
        
    }
    
   
    return YES;
    
}






- (IBAction)setWidth:(UIButton *)sender {
    
    NSString *widthText = _widthText.text;
    
    if(widthText.length == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                                        message:@"Please fill in width"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    else {
        
        NSLog(@"Pict size %f %f",_imageView.image.size.width,_imageView.image.size.height);
        double setWidth= [widthText doubleValue];
        double setHeight = [self aspectRatio:_imageView.image.size.width :_imageView.image.size.height :setWidth :TRUE]; //get the height based on the given width
         NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
         [fmt setPositiveFormat:@"0.##"]; //format to two digits
        NSString *newSetHeightText = [fmt stringFromNumber:[NSNumber numberWithFloat:setHeight]];//Convert to text, in 2 digits
        setHeight = [newSetHeightText doubleValue]; //Convert to double
        _heightText.text = @(setHeight).stringValue; //Set to text
    }
    
}

- (IBAction)setHeight:(UIButton *)sender {
    
    NSString *heightText = _heightText.text;
   
   if(heightText.length == 0) {
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                                        message:@"Please fill in height"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
       
    }
   else {
       NSLog(@"Pict size %f %f",_imageView.image.size.width,_imageView.image.size.height);
       double setHeight= [heightText doubleValue];
       double setWidth = [self aspectRatio:_imageView.image.size.width :_imageView.image.size.height :setHeight :FALSE];
       NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
       [fmt setPositiveFormat:@"0.##"];
       NSString *newSetWidthText = [fmt stringFromNumber:[NSNumber numberWithFloat:setWidth]];
       setWidth = [newSetWidthText doubleValue];
       _widthText.text = @(setWidth).stringValue;
       
   }
}

-(double) aspectRatio:(double) oldWidth: (double) oldHeight: (double) newSize: (BOOL) isWidth {
    double factor;
    if (isWidth) {
        factor = newSize / oldWidth;
        return factor * oldHeight;
    }
    factor = newSize / oldHeight;
    return factor * oldWidth;
}



@end
