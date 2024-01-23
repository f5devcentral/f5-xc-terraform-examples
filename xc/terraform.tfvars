#XC Global
api_url = "https://treino.console.ves.volterra.io/api"
xc_tenant = "treino-ufahspac"
xc_namespace = "ddos-testing"
app_domain = "autowaf.f5-hyd-demo.com"
xc_waf_blocking = "true"

# k8s configs
k8s_pool = "false"
serviceName = "10.218.11.245"
serviceport = "9080"
site_name = "chthonda-site"
advertise_sites = "true"
http_only = "true"

# CE configs
gcp_ce_site = "false"
aws_ce_site = "true"

#XC AI/ML Settings for MUD, APIP - NOTE: Only set if using AI/ML settings from the shared namespace
xc_app_type = []
xc_multi_lb = false

#XC API Protection and Discovery
xc_api_disc = false
xc_api_pro = false
xc_api_spec = []

#XC Bot Defense
xc_bot_def = false

#XC DDoS
xc_ddos_pro = false

#XC Malicious User Detection
xc_mud = false

#Origin pool
ip_address_on_site_pool = true
aws_eks_cluster = true