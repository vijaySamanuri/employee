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
          "basedir": "/tmp",
          "path": "curdoperations-1.war"
        }
      }
    ],
   "artifacts": [
      {
        "name": "server",
        "destination": "/tmp",
        "source": {
          "store": "jenkins",
          "basedir": "/home/ubuntu/",
          "path": "server.xml"
        }
      }
    ],
    "artifacts": [
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
		    "sed -i \"s/@mysqlhost@/$mysqlhost/g\"  /usr/local/tomcat/maven-application/config/server.xml",
		    "sed -i \"s/@mysqlusername@/$mysqlusername/g\"  /usr/local/tomcat/maven-application/config/server.xml",
		    "sed -i \"s/@mysqlpassword@/$mysqlpassword/g\"  /usr/local/tomcat/maven-application/config/server.xml",
		    "cp  /usr/local/tomcat/maven-application/config/context.xml /usr/local/tomcat/conf/",
		    "cp  /usr/local/tomcat/maven-application/config/server.xml  /usr/local/tomcat/conf/server.xml"
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
