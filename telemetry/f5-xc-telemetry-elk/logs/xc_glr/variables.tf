
variable bucket_name {
    type = string
    description = "GCS Bucket Name"
}

variable xc_url {
    type = string
    description = "XC URL"
}

variable api_p12{
    type = string
    description = "XC API P12 file path"
}

variable glr{
    type = string
    description = "GLR name"
}

variable namespace_list{
    type = list(string)
    description = "Export logs from list of namespaces"
}

variable current_namespace{
    type = bool
    description = "Export logs from current namespace"
}

variable all_namespaces{
    type = bool
    description = "Export logs from all namespaces"
}
