# Create S3 Bucket for Static Website Hosting


## Adding random definition for unique bucket name

resource "random_id" "bucket_suffix" {
  byte_length = 16
}

## Create S3 Bucket for Static Website Hosting 

resource "aws_s3_bucket" "random_website_bucket" {
  bucket = "my-static-site-${random_id.bucket_suffix.hex}"
}


