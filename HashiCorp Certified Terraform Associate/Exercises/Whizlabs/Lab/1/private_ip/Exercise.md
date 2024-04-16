# Exercise 1
Create a Application Load Balancer which contains two AWS EC2 instances running a web server.

Load balancer checks the target group, in our case the VPC (Virtual Private Cloud) for our EC2 machines will be specifed for the Application Load Balancer. EC2 instances will require a security group which allows http traffic.

To setup:
+ EC2 Instances (with HTTP server)
+ Security Groups (allowing http traffic)
+ Load Balancer
    + Target Groups for LB
    + Listners
    