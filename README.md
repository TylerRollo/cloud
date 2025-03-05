# 3-Tier Web-Hosting Application (AWS)
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
5. Internet Gateway added in addition to NAT gateways
6. Added Route table for public subnets and private subnets
7. Creation of the EC2 and RDS Security Groups
8. Created a MySQL DB using RDS
### Current Architecture: 
![Current Architecture at Step 8.](/img/partial_architecture.jpeg)
9. Added 2 EC2 instances into Public subnets using Ubuntu ami
10. Deployed React front-end to EC2 Instance and ran it
11. Added 2 EC2 instances into private subnets using Ubuntu ami
12. created a new security group for the private ec2 instances
## Current Arcitecutre: 
![Current Architecture at Step 8.](/img/instancescomplete.jpeg)

### Next Steps:
Add the API calls and communicate between all 3 layers seamlessly

# Goal Architecture:
![AWS 3-Tier Architecture](/img/image.png)