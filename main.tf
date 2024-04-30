## the bucketname is prefixed with the GCP project name which is unique
/*
resource "google_storage_bucket" "auto-expire" {
  name          = "tf-gcp-demo-377217-bucket"
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 8
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}
*/