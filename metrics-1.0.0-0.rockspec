package = "metrics"
version = "1.0.0-0"
source = {
   url = "https://github.com/mateuslima90/kong-custom-metrics/archive/refs/tags/v1.0.0.zip",
}
description = {
   summary = "Biblioteca de métricas customizadas para Kong",
   detailed = "Facilita o registro e uso de métricas customizadas no Kong usando o plugin oficial Prometheus.",
   license = "MIT",
   homepage = "https://github.com/mateuslima90/kong-custom-metrics.git"
}
dependencies = {
   "lua >= 5.1, < 5.2"
}
build = {
   type = "builtin",
   modules = {
      ["metrics"] = "metrics.lua",
   }
}