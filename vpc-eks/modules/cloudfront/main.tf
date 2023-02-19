# locals {
#   s3_origin_id = "s3-origin"
# }

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = var.domain_name
    # domain_name = "${aws_s3_bucket.bucket.id}.s3.amazonaws.com"
    origin_id   = var.nlb_endpoint

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
    }
  }

  # aliases         = var.domain_cnames
  enabled         = true
  is_ipv6_enabled = false
  comment         = "Atlas PoC"
  # default_root_object = "index.html"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "logs.s3.amazonaws.com"
  #   prefix          = "prefix"
  # }

  #   origin {
  #   domain_name = var.domain_name
  #   origin_id   = var.nlb_endpoint

  #   custom_origin_config {
  #     http_port              = 80
  #     https_port             = 443
  #     origin_protocol_policy = "http-only"
  #     origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
  #   }
  # }

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = var.nlb_endpoint

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

      viewer_protocol_policy = "allow-all"
      min_ttl                = 0
      default_ttl            = 3600
      max_ttl                = 86400
    }

    # Cache behavior with precedence 0
    ordered_cache_behavior {
      path_pattern     = "/content/immutable/*"
      allowed_methods  = ["GET", "HEAD", "OPTIONS"]
      cached_methods   = ["GET", "HEAD", "OPTIONS"]
      target_origin_id = var.nlb_endpoint

      forwarded_values {
        query_string = false
        headers      = ["Origin"]

        cookies {
          forward = "none"
        }
      }

      min_ttl                = 0
      default_ttl            = 86400
      max_ttl                = 31536000
      compress               = true
      viewer_protocol_policy = "redirect-to-https"
    }

    # Cache behavior with precedence 1
    # ordered_cache_behavior {
    #   path_pattern     = "/content/*"
    #   allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    #   cached_methods   = ["GET", "HEAD"]
    #   target_origin_id = local.s3_origin_id

    #   forwarded_values {
    #     query_string = false

    #     cookies {
    #       forward = "none"
    #     }
    #   }

    #   min_ttl                = 0
    #   default_ttl            = 3600
    #   max_ttl                = 86400
    #   compress               = true
    #   viewer_protocol_policy = "redirect-to-https"
    # }

    price_class = "PriceClass_200"

    restrictions {
      geo_restriction {
        restriction_type = "whitelist"
        locations        = ["US", "CA", "GB", "DE"]
      }
    }

    # tags = {
    #   Environment = "production"
    # }

    viewer_certificate {
      cloudfront_default_certificate = true
      # acm_certificate_arn = var.acm_cert
  }
}
