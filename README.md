# 3-Tier Web-Hosting Application
(not guided)

### Timeline:
1. Providers
2. VPC and Subnets (Public and Private)
3. Added 2 Public and 4 Private Subnets \
3a. 2 private for EC2 \
3b. 2 private for RDS
### Current Architecture:
![Current Architecture at Step 3.](/img/firstpartial.jpeg)
4. Added Availability Zones
5. (1). Internet Gateway added in addition to NAT gateways (2). and Elastic IP address
6. Added Route table for public subnets and private subnets
7. Creation of the EC2 and RDS Security Groups
8. Created a MySQL DB
### Current Architecture: 
![Current Architecture at Step 8.](/img/partial_architecture.jpeg)
9. Added 2 EC2 instances into Public subnets using Ubuntu
10. Deployed React front-end to EC2 Instance
11. Added 2 EC2 instances into private subnets using Ubuntu
12. created a new security group for the private ec2 instances
## Current Arcitecutre: 

### Goal Architecture:
![AWS 3-Tier Architecture](/img/image.png)