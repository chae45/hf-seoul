#S3 버킷생성
resource "aws_s3_bucket" "s3" {
  bucket = "hamhifive1234"
  acl    = "private"

  tags = {
    Name        = "hamhifive"
    Environment = "Production"
  }
}


resource "aws_cloudfront_origin_access_identity" "cloudfront" {
  comment = "Origin Access Identity for CloudFront"
}

resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.cloudfront.id}"
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.s3.arn}/*"
      }
    ]
  })
}


#git action관련 정책 생성





