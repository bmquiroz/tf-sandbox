resource "aws_wafv2_web_acl" "cloudfront-waf" {
  name        = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-waf")
  description = "Atlas CloudFront rate based WAF"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10000
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = ["US"]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "waf-rate-based-rule"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "waf-rate-based-rule"
    sampled_requests_enabled   = false
  }
}