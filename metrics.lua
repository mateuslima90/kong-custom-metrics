local exporter = require("kong.plugins.prometheus.exporter")
local prometheus

local M = {}
local metrics = {}
local my_labels = { 0, 0 }
local DEFAULT_BUCKETS = { 5, 10, 100, 200, 1000, 5000, 30000, 60000 }

function M.init()
    if prometheus then
        return
    end

    -- Register your custom metrics with the Prometheus plugin
    prometheus = exporter.get_prometheus()

    if not prometheus then
        kong.log.err("Prometheus plugin não está ativo. Métricas não serão registradas.")
        return
    end
    
    metrics.rbac_attempts = prometheus:counter(
        "rbac_attempts", -- kong_prefix is already set global
        "rbac attempts retry",
        { "service" }
    )

    metrics.cache = prometheus:counter(
        "cache_hit_counter", -- kong_ prefix is already set global
        "cache hit counter",
        { "name", "hit" }
    )

    metrics.external = prometheus:counter(
        "external_apis_status", -- kong_ prefix is already set global
        "Status of external apis",
        { "service", "status" }
    )

    metrics.external_latency = prometheus:histogram("external_latency",
                                         "Latency added by Kong, total " ..
                                         "request time to external sevices",
                                         {"service"},
                                         DEFAULT_BUCKETS) --TODO make this configurable
end

function M.inc(metric_name, labels, value)
    if metrics[metric_name] and metrics[metric_name].inc then
        metrics[metric_name]:inc(value or 1, labels)
    end
end

function M.observe(metric_name, labels, value)
    if metrics[metric_name] and metrics[metric_name].observe then
      metrics[metric_name]:observe(value, labels)
    end
  end
  
function M.get(metric_name)
  return metrics[metric_name]
end
  
return M