resource "aws_s3_bucket" "new_bucket" {
  bucket = var.Bucket_Name
  acl    = "private"

  tags = {
    Name = "${var.Project_Name}-Bucket"
  }
}


resource "aws_s3_bucket_object" "new_bucket_object" {
  depends_on = [aws_s3_bucket.new_bucket, ]
  bucket     = aws_s3_bucket.new_bucket.id
  key        = "my_image.jpg"
  source     = "/path/to/file.jpg"
  # acl        = "public-read"
  tags = {
    Place = "Me at Kubernetes Meet Delhi"
  }

}


resource "aws_s3_bucket_public_access_block" "new_bucket_block" {
  bucket = aws_s3_bucket.new_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}