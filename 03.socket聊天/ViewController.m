//
//  ViewController.m
//  03.socket聊天
//
//  Created by 浅爱 on 16/3/2.
//  Copyright © 2016年 my. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tf_ip;
@property (weak, nonatomic) IBOutlet UITextField *tf_port;
@property (weak, nonatomic) IBOutlet UITextField *tf_msg;
@property (weak, nonatomic) IBOutlet UITextView *tf_showMsgView;

// 定义一个socket属性
@property (assign, nonatomic) int clientSocket;

@end

@implementation ViewController


- (IBAction)connectBtnClicked:(UIButton *)sender {
    
    NSString *ip = self.tf_ip.text;
    
    int port = self.tf_port.text.intValue;
    
    if ([self connectToServerWithIP:ip port:port]) {
        
        NSLog(@"connect is OK");
        
    } else {
    
        NSLog(@"connect error");
    
    }
    
}

// 连接服务器
- (BOOL)connectToServerWithIP:(NSString *)ipStr port:(int)port {

    self.clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    struct sockaddr_in addr;
    
    addr.sin_family = AF_INET;
    
    addr.sin_port = htons(port);
    
    addr.sin_addr.s_addr = inet_addr(ipStr.UTF8String);
    
    int connectResult = connect(self.clientSocket, (const struct sockaddr *)&addr, sizeof(addr));
    
    if (connectResult == 0) {
        
        return YES;
        
    } else {
    
        return NO;
    
    }

}



- (IBAction)sendMsgBtnClicked:(UIButton *)sender {

    NSString *sendMsg = self.tf_msg.text;
    
    NSString *recvMsg = [self sendAndReceiveMessage:sendMsg];
    
    self.tf_showMsgView.text = recvMsg;
    
}


// 发送接收数据
- (NSString *)sendAndReceiveMessage:(NSString *)message {

    char *str = message.UTF8String;
    
    ssize_t sendLen = send(self.clientSocket, str, strlen(str), 0);
    
    NSLog(@"%ld", sendLen);
    
    char *buffer[1024];
    
    ssize_t recvLen = recv(self.clientSocket, buffer, sizeof(buffer), 0);
    
    
    // char --> data
    NSData *data = [NSData dataWithBytes:buffer length:recvLen];
    
    NSString *recvStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    return recvStr;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


@end






