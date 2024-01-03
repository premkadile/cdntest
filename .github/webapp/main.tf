locals {
  ns = "${var.name}-${var.environment}"
  
}

resource "aws_s3_bucket" "static_website" {
  bucket = local.ns


  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_cloudfront_distribution" "static_website_cdn" {
  origin {
    domain_name = aws_s3_bucket.static_website.bucket_domain_name
    origin_id   = aws_s3_bucket.static_website.id
     s3_origin_config {
      origin_access_identity = ""
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

 

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.static_website.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Add more settings as needed

  tags = {
    Name = local.ns
  }
}


resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.bucket

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PolicyForCloudFront",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${local.ns}/*",
      "Condition": {
        "StringNotEqualsIfExists": {
          "aws:UserAgent": "Amazon CloudFront"
        }
      }
    }
  ]
}
POLICY
}

output "website_url" {
  description = "URL of the static website"
  value       = aws_s3_bucket.static_website.website_endpoint
}

output "cloudfront_url" {
  description = "URL of the CloudFront distribution"
  value       = aws_cloudfront_distribution.static_website_cdn.domain_name
}
