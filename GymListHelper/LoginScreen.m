//
//  ViewController.m
//  Login
//
//  Created by Rodrigo Dias Takase on 26/03/15.
//  Copyright (c) 2015 Rodrigo Dias Takase. All rights reserved.
//

#import "LoginScreen.h"


@interface LoginScreen () <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation LoginScreen

- (void)applicationDidBecomeActive
{
    NSLog(@"app did become active");
}

- (void)viewDidLoad {
//    self.panel.hidden = true;
    
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    
    //self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(viewDidBecomeActive)
//                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
//    self.lbWarning.hidden = true;
    

}

- (void)viewDidBecomeActive{
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)LoginBtn:(id)sender {
//    [self Login];
//    
//    if ([FBSDKAccessToken currentAccessToken]) {
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//             if (!error) {
//                 NSLog(@"fetched user:%@", result);
//             }
//         }];
//    }
//}
//
//
//- (void)Login {
//    NSString *sendData = @"email=";
//    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", self.email.text]];
//    
//    sendData = [sendData stringByAppendingString:@"&password="];
//    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", self.password.text]];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.gamescamp.com.br/gymhelper/webservices/checkLogin.php"]];
//    
//    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
//    
//    //Here you send your data
//    [request setHTTPBody:[sendData dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPMethod:@"POST"];
//    NSError *error = nil;
//    NSURLResponse *response = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    
//    if (error)
//    {
//        NSLog(@"Error");
//    }
//    else
//    {
//        //The response is in data
//        NSLog(@"%@", results);
//        
//        if([results isEqualToString:@"ERRO"]){
//            self.lbWarning.hidden = false;
//            self.lbWarning.textColor = [UIColor redColor];
//            self.lbWarning.text = @"Incorrect e-mail and/or password";
//        }else{
//            self.lbWarning.hidden = false;
//            self.lbWarning.textColor = [UIColor orangeColor];
//            self.lbWarning.text = @"Login OK!";
//        }
//    }
//}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"LOGOUT");
//    
//    self.profilePhoto.image = nil;
//    self.panel.hidden = true;
}

- (void)
loginButton:	(FBSDKLoginButton *)loginButton
didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
error:	(NSError *)error
{
    NSLog(@"LOGIN");
//    self.panel.hidden = false;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 NSLog(@"fetched user:%@", result);
                 
                 [[NSUserDefaults standardUserDefaults] setValue: result[@"id"] forKey:@"loggedUserFacebookId"];
                 
                 [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@ %@", result[@"first_name"],result[@"last_name"]] forKey:@"loggedUserName"];
                 
                 NSString *sendData = @"facebookid=";
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", result[@"id"]]];
                 
                 sendData = [sendData stringByAppendingString:@"&name="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
                 
                 sendData = [sendData stringByAppendingString:@"&email="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
                 
                 sendData = [sendData stringByAppendingString:@"&password="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
                 
                 sendData = [sendData stringByAppendingString:@"&pic="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];

                 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.gamescamp.com.br/gymhelper/webservices/insertUser.php"]];
                 
                 [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                 
                 //Here you send your data
                 [request setHTTPBody:[sendData dataUsingEncoding:NSUTF8StringEncoding]];
                 
                 [request setHTTPMethod:@"POST"];
                 NSURLResponse *response = nil;
                 NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                 
                 NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 
                 
                 if (error)
                 {
                     NSLog(@"Error");
                 }
                 else
                 {
                     //The response is in data
                     NSLog(@"%@", results);
                     
                     if([results isEqualToString:@"ERROR2"]){
                         NSLog(@"InsertUser Error2");
                     }else{
                         NSLog(@"InsertUser ok = %@",results);
                         
                         [[NSUserDefaults standardUserDefaults] setInteger:[results intValue] forKey:@"loggedUserId"];
                         
                         [self performSegueWithIdentifier:@"BackToChartsMenu" sender:self];
                     }
                 }
                 
             }
         }];
    }else{
        NSLog(@"Not Logged");
    }
}

@end
