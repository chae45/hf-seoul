# # 인증서 생성
# resource "aws_acm_certificate" "cert" {
#     domain_name       = "*.eunchae.shop"
#     validation_method = "DNS"

#     subject_alternative_names = ["eunchae.shop"]  # 추가할 도메인

#     tags = {
#         Name = "cert"
#     }

#     lifecycle {
#         create_before_destroy = true
#     }
# }

# data "aws_route53_zone" "route53_zone" {
#   name = "eunchae.shop."  # 이미 존재하는 호스팅 영역의 도메인 이름을 입력
# }

# # 인증서 검증
# resource "aws_route53_record" "route53_ssl" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.route53_zone.zone_id
# }