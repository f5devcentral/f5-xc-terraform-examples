#XC Global
api_url = "https://treino.console.ves.volterra.io/api"
xc_tenant = "treino-ufahspac"
xc_namespace = "default"
app_domain = "cek8s.f5-hyd-demo.com"
xc_waf_blocking = "true"

azure = "false"

k8s_pool = "true"
serviceName = "productpage.default"
serviceport = "9080"
site_name = "ce-k8s"
advertise_sites = "true"
http_only = "true"

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

eks_ce_site = "true"
