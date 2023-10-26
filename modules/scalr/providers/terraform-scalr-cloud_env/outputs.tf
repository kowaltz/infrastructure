output "ids" {
  value = {
    aws   = length(scalr_provider_configuration.aws) > 0 ? scalr_provider_configuration.aws[0].id : "",
    azure = length(scalr_provider_configuration.azure) > 0 ? scalr_provider_configuration.azure[0].id : "",
  }
}

output "names" {
  value = {
    aws   = length(scalr_provider_configuration.aws) > 0 ? scalr_provider_configuration.aws[0].name : "",
    azure = length(scalr_provider_configuration.azure) > 0 ? scalr_provider_configuration.azure[0].name : "",
  }
}