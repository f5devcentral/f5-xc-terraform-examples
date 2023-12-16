#XC Global
api_url = "https://treino.console.ves.volterra.io/api"
xc_tenant = "treino-ufahspac"
xc_namespace = "default"
app_domain = "gcplb.f5-hyd-demo.com"
xc_waf_blocking = "true"

# k8s configs
k8s_pool = "false"
serviceName = ""
serviceport = ""
site_name = "janibasha-gcp-site"
advertise_sites = "true"
http_only = "false"

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

# CE configs
gcp_ce_site = "true"


azure_subscription_id = ""
azure_subscription_tenant_id = ""
azure_service_principal_appid = ""
azure_service_principal_password = ""
