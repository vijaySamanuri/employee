{
  "kind": "ServiceSpec",
  "apiVersion": "hyscale.io/v1/",
  "metadata": {
    "name": "web",
    "version": 1,
    "replicas": "{{ hfs_REPLICAS | default('1') }}",
    "resourceLimits": {
       "memory" : "{{ hfs_MEMORY_LIMIT_IN_MB | default('1024') }}"
    },
    "labels": {
      "tier": "frontend",
      "externalPorts": [8080]
    },
    "dependencies": [
      "mydbtest"
    ]
  },
  "spec": {
    "external": [
      "tomcat-port"
    ],
    "stack": {
      "name": "tomcat-test",
      "version": "8.5",
      "packages": [
        "java:1.8",
        "apache-tomcat:8.5.15"
      ],
      "os": "Ubuntu:14.04",
    "distribution":"DEBIAN"
   },
   "artifacts": [
      {
        "name": "war",
        "destination": "/usr/local/content/tomcat/current/webapps",
        "source": {
          "store": "jenkins",
          "basedir": "/tmp/@@BUILD_NUMBER@@",
          "path": "curdoperations-1.war"
        }
      },
      {
        "name": "server",
        "destination": "/tmp",
        "source": {
          "store": "jenkins",
          "basedir": "/home/ubuntu/",
          "path": "server.xml"
        }
      },
      {
        "name": "context",
        "destination": "/tmp",
        "source": {
          "store": "jenkins",
          "basedir": "/home/ubuntu/",
          "path": "context.xml"
        }
      }
    ],
    "config": {
      "commands": [
		    "#!/bin/bash",
		    "mysqlhost=${mysqlhost}",
		    "mysqlusername=${mysqlusername}",
		    "mysqlpassword=${mysqlpassword}",
		    "sed -i \"s/@mysqlhost@/$mysqlhost/g\"  /tmp/server.xml",
		    "sed -i \"s/@mysqlusername@/$mysqlusername/g\" /tmp/server.xml",
		    "sed -i \"s/@mysqlpassword@/$mysqlpassword/g\"  /tmp/server.xml",
		    "cp  /tmp/context.xml /usr/local/content/tomcat/current/conf/",
		    "cp  /tmp/server.xml  /usr/local/content/tomcat/current/conf/"
		],
      "props": [
          {
            "key": "mysqlhost",
            "type": "STRING",
            "value": "{{ hfs_mysqlhost | default('mydb') }}"
          },
          {
            "key": "mysqlusername",
            "type": "STRING",
            "value": "{{ hfs_mysqlusername | default('root') }}"
          },
          {
            "key": "mysqlpassword",
            "type": "PASSWORD",
            "value": "{{ hfs_PASSWORD | default('cHJhbWF0aQ==') }}"
          }
        ] 
    }
  }
}
