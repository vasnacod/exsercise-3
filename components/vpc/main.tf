resource "aws_vpc" "redshift-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "redshift-subnet-az1" {
  vpc_id            = aws_vpc.redshift-vpc.id
  cidr_block        = var.public_subnet_az1_cidr
  availability_zone = var.azzonea

  tags = {
    Name = "${var.project_name}-subnet-az1"
  }
}

resource "aws_subnet" "redshift-subnet-az2" {
  vpc_id            = aws_vpc.redshift-vpc.id
  cidr_block        = var.public_subnet_az2_cidr
  availability_zone = var.azzoneb

  tags = {
    Name = "${var.project_name}-subnet-az2"
  }
}

resource "aws_redshift_subnet_group" "redshift-subnet-group" {
  depends_on = [
    aws_subnet.redshift-subnet-az1,
    aws_subnet.redshift-subnet-az2,
  ]

  name       = "${var.project_name}-subnet-group"
  subnet_ids = [aws_subnet.redshift-subnet-az1.id, aws_subnet.redshift-subnet-az2.id]

  tags = {
    Name = "${var.project_name}-subnet-group"
  }
}

resource "aws_internet_gateway" "redshift-igw" {
  vpc_id = aws_vpc.redshift-vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "redshift-rt-igw" {
  vpc_id = aws_vpc.redshift-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.redshift-igw.id
  }

  tags = {
    Name = "${var.project_name}-route-igw"
  }
}

resource "aws_route_table_association" "redshift-subnet-igw-az1" {
  subnet_id      = aws_subnet.redshift-subnet-az1.id
  route_table_id = aws_route_table.redshift-rt-igw.id
}

resource "aws_route_table_association" "redshift-subnet-igw-az2" {
  subnet_id      = aws_subnet.redshift-subnet-az2.id
  route_table_id = aws_route_table.redshift-rt-igw.id
}

resource "aws_default_security_group" "redshift_security_group" {
  vpc_id = aws_vpc.redshift-vpc.id
  
  ingress {
    description = "redshift port"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.project_name}-security-group"
    Description = "redshift access"
  }
}

# Create an IAM Role for Redshift
resource "aws_iam_role" "redshift-role" {
  name = "${var.project_name}-redshift-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
                    "scheduler.redshift.amazonaws.com",
                    "redshift.amazonaws.com"
                ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name        = "${var.project_name}-redshift-role"
  }
}

# Create a policy for Redshift to start and stop clusters
resource "aws_iam_policy" "redshift-scheduler-policy" {
  name        = "${var.project_name}-redshift-scheduler-policy"
  description = "Policy to allow Redshift to start and stop clusters"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "redshift:PauseCluster",
          "redshift:ResumeCluster"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the Redshift role
resource "aws_iam_role_policy_attachment" "redshift-role-policy-attachment" {
  role       = aws_iam_role.redshift-role.name
  policy_arn = aws_iam_policy.redshift-scheduler-policy.arn
}

#sm key
resource "aws_iam_policy" "redshift-secrets-manager-policy" {
  name        = "${var.project_name}-redshift-secrets-manager-policy"
  description = "Policy to allow Redshift to read from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "redshift-secrets-manager-policy-attachment" {
  role       = aws_iam_role.redshift-role.name
  policy_arn = aws_iam_policy.redshift-secrets-manager-policy.arn
}