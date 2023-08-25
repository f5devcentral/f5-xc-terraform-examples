resource "kubernetes_manifest" "namespace_ves_system" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Namespace"
    "metadata" = {
      "name" = "ves-system"
    }
  }
}

resource "kubernetes_manifest" "serviceaccount_ves_system_volterra_sa" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "name" = "volterra-sa"
      "namespace" = "ves-system"
    }
  }
}

resource "kubernetes_manifest" "role_ves_system_volterra_admin_role" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "Role"
    "metadata" = {
      "name" = "volterra-admin-role"
      "namespace" = "ves-system"
    }
    "rules" = [
      {
        "apiGroups" = [
          "*",
        ]
        "resources" = [
          "*",
        ]
        "verbs" = [
          "*",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "rolebinding_ves_system_volterra_admin_role_binding" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "RoleBinding"
    "metadata" = {
      "name" = "volterra-admin-role-binding"
      "namespace" = "ves-system"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "Role"
      "name" = "volterra-admin-role"
    }
    "subjects" = [
      {
        "apiGroup" = ""
        "kind" = "ServiceAccount"
        "name" = "volterra-sa"
        "namespace" = "ves-system"
      },
    ]
  }
}

resource "kubernetes_manifest" "daemonset_ves_system_volterra_ce_init" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "DaemonSet"
    "metadata" = {
      "name" = "volterra-ce-init"
      "namespace" = "ves-system"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "name" = "volterra-ce-init"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "name" = "volterra-ce-init"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "gcr.io/volterraio/volterra-ce-init"
              "name" = "volterra-ce-init"
              "securityContext" = {
                "privileged" = true
              }
              "volumeMounts" = [
                {
                  "mountPath" = "/host"
                  "name" = "hostroot"
                },
              ]
            },
          ]
          "hostNetwork" = true
          "hostPID" = true
          "serviceAccountName" = "volterra-sa"
          "volumes" = [
            {
              "hostPath" = {
                "path" = "/"
              }
              "name" = "hostroot"
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "serviceaccount_ves_system_vpm_sa" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "name" = "vpm-sa"
      "namespace" = "ves-system"
    }
  }
}

resource "kubernetes_manifest" "role_ves_system_vpm_role" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "Role"
    "metadata" = {
      "name" = "vpm-role"
      "namespace" = "ves-system"
    }
    "rules" = [
      {
        "apiGroups" = [
          "*",
        ]
        "resources" = [
          "*",
        ]
        "verbs" = [
          "*",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_ves_system_vpm_cluster_role" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "vpm-cluster-role"
      "namespace" = "ves-system"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "nodes",
        ]
        "verbs" = [
          "get",
          "list",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "rolebinding_ves_system_vpm_role_binding" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "RoleBinding"
    "metadata" = {
      "name" = "vpm-role-binding"
      "namespace" = "ves-system"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "Role"
      "name" = "vpm-role"
    }
    "subjects" = [
      {
        "apiGroup" = ""
        "kind" = "ServiceAccount"
        "name" = "vpm-sa"
        "namespace" = "ves-system"
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_vpm_sa" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "name" = "vpm-sa"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "vpm-cluster-role"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "vpm-sa"
        "namespace" = "ves-system"
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_ver" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "name" = "ver"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "cluster-admin"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "ver"
        "namespace" = "ves-system"
      },
    ]
  }
}

resource "kubernetes_manifest" "configmap_ves_system_vpm_cfg" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "config.yaml" = <<-EOT
      Vpm:
        # CHANGE ME
        ClusterName: ce-k8s
        ClusterType: ce
        Config: /etc/vpm/config.yaml
        DisableModules: ["recruiter"]
        # CHANGE ME
        Latitude: 11.3850
        # CHANGE ME
        Longitude: 71.4867
        MauriceEndpoint: https://register.ves.volterra.io
        MauricePrivateEndpoint: https://register-tls.ves.volterra.io
        PrivateNIC: eth0
        SkipStages: ["osSetup", "etcd", "kubelet", "master", "voucher", "workload", "controlWorkload"]
        # CHANGE ME
        Token: c91bc500-009a-484b-9ef0-11aa4574e500
        CertifiedHardware: k8s-minikube-voltmesh
      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "name" = "vpm-cfg"
      "namespace" = "ves-system"
    }
  }
}

resource "kubernetes_manifest" "statefulset_ves_system_vp_manager" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "StatefulSet"
    "metadata" = {
      "name" = "vp-manager"
      "namespace" = "ves-system"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "name" = "vpm"
        }
      }
      "serviceName" = "vp-manager"
      "template" = {
        "metadata" = {
          "labels" = {
            "name" = "vpm"
            "statefulset" = "vp-manager"
          }
        }
        "spec" = {
          "affinity" = {
            "podAntiAffinity" = {
              "requiredDuringSchedulingIgnoredDuringExecution" = [
                {
                  "labelSelector" = {
                    "matchExpressions" = [
                      {
                        "key" = "name"
                        "operator" = "In"
                        "values" = [
                          "vpm",
                        ]
                      },
                    ]
                  }
                  "topologyKey" = "kubernetes.io/hostname"
                },
              ]
            }
          }
          "containers" = [
            {
              "image" = "gcr.io/volterraio/vpm"
              "imagePullPolicy" = "Always"
              "name" = "vp-manager"
              "securityContext" = {
                "privileged" = true
              }
              "volumeMounts" = [
                {
                  "mountPath" = "/etc/vpm"
                  "name" = "etcvpm"
                },
                {
                  "mountPath" = "/var/lib/vpm"
                  "name" = "varvpm"
                },
                {
                  "mountPath" = "/etc/podinfo"
                  "name" = "podinfo"
                },
                {
                  "mountPath" = "/data"
                  "name" = "data"
                },
              ]
            },
          ]
          "initContainers" = [
            {
              "command" = [
                "/bin/sh",
                "-c",
                "cp /tmp/config.yaml /etc/vpm",
              ]
              "image" = "busybox"
              "name" = "vpm-init-config"
              "volumeMounts" = [
                {
                  "mountPath" = "/etc/vpm"
                  "name" = "etcvpm"
                },
                {
                  "mountPath" = "/tmp/config.yaml"
                  "name" = "vpmconfigmap"
                  "subPath" = "config.yaml"
                },
              ]
            },
          ]
          "serviceAccountName" = "vpm-sa"
          "terminationGracePeriodSeconds" = 1
          "volumes" = [
            {
              "downwardAPI" = {
                "items" = [
                  {
                    "fieldRef" = {
                      "fieldPath" = "metadata.labels"
                    }
                    "path" = "labels"
                  },
                ]
              }
              "name" = "podinfo"
            },
            {
              "configMap" = {
                "name" = "vpm-cfg"
              }
              "name" = "vpmconfigmap"
            },
          ]
        }
      }
      "volumeClaimTemplates" = [
        {
          "metadata" = {
            "name" = "etcvpm"
          }
          "spec" = {
            "accessModes" = [
              "ReadWriteOnce",
            ]
            "resources" = {
              "requests" = {
                "storage" = "1Gi"
              }
            }
          }
        },
        {
          "metadata" = {
            "name" = "varvpm"
          }
          "spec" = {
            "accessModes" = [
              "ReadWriteOnce",
            ]
            "resources" = {
              "requests" = {
                "storage" = "1Gi"
              }
            }
          }
        },
        {
          "metadata" = {
            "name" = "data"
          }
          "spec" = {
            "accessModes" = [
              "ReadWriteOnce",
            ]
            "resources" = {
              "requests" = {
                "storage" = "1Gi"
              }
            }
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "service_ves_system_vpm" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "vpm"
      "namespace" = "ves-system"
    }
    "spec" = {
      "ports" = [
        {
          "port" = 65003
          "protocol" = "TCP"
          "targetPort" = 65003
        },
      ]
      "selector" = {
        "name" = "vpm"
      }
      "type" = "NodePort"
    }
  }
}
