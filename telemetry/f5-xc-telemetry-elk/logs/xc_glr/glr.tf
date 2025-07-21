resource "volterra_global_log_receiver" "example" {
  name      = var.glr
  namespace = "shared"
  ns_current = var.current_namespace
  ns_all = var.all_namespaces
  ns_list { namespaces = var.namespace_list }
  audit_logs = true

  http_receiver {
    uri = "http://${local.ip}:8080"
    auth_basic {
      user_name = "export"
      password {
        blindfold_secret_info {
          location = "string:///AAAAD3RyZWluby11ZmFoc3BhYwAAAAEAAAAAAAAAbgIAAAAFA3k0Jj8AAAEAxw3XaKAS1NMmehODViS3qWFndMEhYv9Z4zQTcExyYbhl1w6QSj7cPCJuAvw4c7RdNYpWHtJahUXF8NUPc/+0eCmhpXbUrmcUUWf4UHeKWf7tux/WTk9vA3l5TI4a4eruhDBCsG3qrP35Uen5BbfD0MvdEyiMhBo3lnOw00UA6WMKzZRIz8ozApkqZEtV2BWEnHW2szlODSlyk3o2x/wakQr/qaZmXRyhvZu83IFuQY1rTXjAwiBUab4G3b/FPMrOslerd+4BVmyQrI932z2S0zfX91USA01LGfX4iiU2N+D/wDQ3Jpm0f/UoTbA3pn3CqgcL6NpfKuHudnOb4PqCuwAAAQCND0moAwX1NafxVNSDezoKB9ymbTSY7+DOv+DZVWuKTrd3I2LVe2nAVekzAvMTa7X9NippKuzP/kRtOEZ86sQmrK9i7Boa6/5GybjmrXPX1tq3TlCmbmMnKVdhY4Sl0oLxJszH0vZyfLZIV5BIjOoZZYhvVgNdF4KnPelu8Vg+Tw8FAO1A2s4F1JLXcwp+oAmXQfUIoAVgMq7ihUuAnafIm67jwIvWl9vE5BlQ+LsJSnDSMZgg2O8UBbFf5r6qlsLB31Hdh1LPXUmRRXJ6loBLYdHKJzNQuvB2SpWnbvp2y00NAxCQxOaqYH+AD++ijuKO//f4XoZLxeptVMnMw5WmzHvPDtwJXAzgMgkQWUUrS7fgl4Bsc4f8"
        }
          secret_encoding_type = "EncodingNone"
        }
      }
    compression {
        compression_gzip = true
    }
    batch {
        timeout_seconds_default = true
        max_events_disabled = true
        max_bytes_disabled = true
      }
     no_tls = true
  }
}