resource "aws_s3_bucket" "scripts" {
  bucket = "shells-scripts-pfizer-2027"
}

resource "aws_s3_object" "script" {
  bucket = aws_s3_bucket.scripts.id

  key    = "hello.sh"
  source = "hello.sh"

  etag = filemd5("hello.sh")
}