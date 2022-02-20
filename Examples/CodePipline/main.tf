module "code_build" {
  source = "../../"

  project_name = "my project name"

  environment_variables = []

  tags = {
    "Name" = "my code build project name"
  }
}