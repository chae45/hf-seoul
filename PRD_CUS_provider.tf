terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0" # 또는 최신 버전으로 업데이트
    }
  }
}

provider "aws" {
  region = "ap-northeast-2" #Asia Pacific (seoul) region
}
