resource "aws_cloudfront_distribution" "s3_distribution" {

  depends_on = [aws_s3_bucket_object.new_bucket_object, aws_cloudfront_origin_access_identity.new_bucket_access_identity]

  origin {
    domain_name = aws_s3_bucket.new_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket_object.new_bucket_object.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.new_bucket_access_identity.cloudfront_access_identity_path
    }

  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "C.F Distribution for Project: ${var.Project_Name}"

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket_object.new_bucket_object.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      #     locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}