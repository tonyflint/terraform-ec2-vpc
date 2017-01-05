variable "vpc_cidr_block" { }
#variable "vpc_domain_name" { }
#variable "vpc_domain_name_servers" { type = "list" }
variable "vpc_name" { }
variable "private_subnets" { type = "list" }
variable "public_subnets" { type = "list" }
variable "avail_zones" { type = "list"  }

resource "aws_vpc" "ec2_vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name = "${var.vpc_name}"
  }
}

/*resource "aws_internet_gateway" "ec2_igw" {
  vpc_id = "${aws_vpc.ec2_vpc.id}"

  tags {
    Name = "${var.vpc_name}-IGW"
  }
}*/

resource "aws_subnet" "ec2_private_subnet" {
  vpc_id                  = "${aws_vpc.ec2_vpc.id}"
  cidr_block              = "${var.private_subnets[count.index]}"
  availability_zone       = "${var.avail_zones[count.index]}"
  map_public_ip_on_launch = false
  count                   = "${length(var.private_subnets)}"

  tags {
    Name = "${var.vpc_name}-subnet-private-${element(var.avail_zones, count.index)}"
  }
}

resource "aws_subnet" "ec2_public_subnet" {
  vpc_id                  = "${aws_vpc.ec2_vpc.id}"
  cidr_block              = "${var.public_subnets[count.index]}"
  availability_zone       = "${var.avail_zones[count.index]}"
  map_public_ip_on_launch = true
  count                   = "${length(var.public_subnets)}"

  tags {
    Name = "${var.vpc_name}-subnet-public-${element(var.avail_zones, count.index)}"
  }
}

/*
resource "aws_route_table" "ec2_route_table" {
  vpc_id = "${aws_vpc.ec2_vpc.id}"
}


/*resource "aws_vpc_dhcp_options" "ec2_vpc_dhcp_options" {


}*/

/*resource "aws_vpc_dhcp_options_association" "ec2_vpc_dhcp_options_association" {
  vpc_id          = "${aws_vpc.ec2_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.ec2_vpc_dhcp_options.id}"
}

resource "aws_internet_gateway" "ec2_vpc_internet_gateway" {
  vpc_id = "${aws_vpc.ec2_vpc.id}"
}*/
