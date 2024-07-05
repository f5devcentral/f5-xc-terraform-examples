#Only set to true if infrastructure is vk8s in XC
vk8s = true
xc_project_prefix = "janibd"

#XC Global
api_url = "https://treino.console.ves.volterra.io/api"
xc_tenant = "treino-ufahspac"
xc_namespace = "bot-defense"

#XC LB
app_domain = "janibot.f5-hyd-xcdemo.com"

#XC WAF
xc_waf_blocking = false

#XC Azure CE site creation
az_ce_site = "false"

#XC Service Discovery
xc_service_discovery = "false"

# pool and LB inputs
k8s_pool = "true"
serviceName = "airline-flask.bot-defense"
serviceport = "80"
advertise_sites = "false"
http_only = "true"
xc_delegation = "false"
ip_address_on_site_pool = "false"
site_name = "sv10-sjc"
user_site = "false"

#XC AI/ML Settings for MUD, APIP - NOTE: Only set if using AI/ML settings from the shared namespace
xc_app_type = []
xc_multi_lb = false

#XC API Protection and Discovery
xc_api_disc = false
xc_api_pro = false
xc_api_spec = []
#Enable API schema validation
xc_api_val = false
#Enable API schema validation on all endpoints
xc_api_val_all = false

#Validation properties for request and response validation
xc_api_val_properties = [] #Example ["PROPERTY_QUERY_PARAMETERS", "PROPERTY_PATH_PARAMETERS", "PROPERTY_CONTENT_TYPE", "PROPERTY_COOKIE_PARAMETERS", "PROPERTY_HTTP_HEADERS", "PROPERTY_HTTP_BODY"]
xc_resp_val_properties = [] #Example ["PROPERTY_HTTP_HEADERS", "PROPERTY_CONTENT_TYPE", "PROPERTY_HTTP_BODY", "PROPERTY_RESPONSE_CODE"]

#Validation Mode active for requests and responses (false = skip)
xc_api_val_active = false
xc_resp_val_active = false

#Validation Enforcement Type (only one of these should be set to true)
enforcement_block = false
enforcement_report = false

#Allow access to unprotected endpoints 
fall_through_mode_allow = false

#Enable API Validation custom rules
xc_api_val_custom = false 

#XC Bot Defense
xc_bot_def = true
xc_bot_path = "/user"
need_infra = false

#XC DDoS
xc_ddos_pro = false

#XC Malicious User Detection
xc_mud = false

# CE configs
gcp_ce_site = "false"
aws_ce_site = "false"
