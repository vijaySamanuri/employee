{
  "kind": "ServiceSpec",
  "apiVersion": "hyscale.io/v1/",
  "metadata": {
    "name": "db",
    "internalendpoint":"mydb",
    "version": 1,
    "replicas": "{{hfsdb_REPLICAS | default('1') }}",
    "resourceLimits": {
       "memory" : {{hfsdb_MEMORY_LIMIT_IN_MB | default('1024') }}
    },

    "dependencies": [
    ],
    "healthChecks": [
    ]
  },
  "spec": {
    "stack": {
      "name": "mysql-ts",
      "version": "5.6",
      "packages": [
        "mysql:5.6"
      ],
      "os": "Ubuntu:14.04",
     "distribution":"DEBIAN"
    },
   "artifacts": [
      {
        "name": "database-dump",
        "destination": "/docker-entrypoint-initdb.d/",
        "source": {
          "store": "jenkins",
          "basedir": "/home/ubuntu/",
          "path": "crudservlet.sql"
        }
      }
    ],
    "dataDirectories": [
      {
        "name": "mysql-data",
        "path": "/var/lib/mysql",
        "readOnly": false,
        "sizeInGB": "{{ hfsdb_MYSQL_DATA_DIR_IN_GB | default('2') }}",
        "storageClass": "{{ hfsdb_STORAGE_CLASS | default('2') }}"
      }
    ],
    "config": {
	"commands" : ["if [! -d /var/lib/mysql/lost+found ]; then" ,"rm -rf /var/lib/mysql/lost+found","fi"],
      "props": [
	{
            "key": "MYSQL_ROOT_PASSWORD",
            "type": "PASSWORD",
            "value": "{{ hfsdb_MYSQL_ROOT_PASSWORD | default('pramati') }}",
            "order": 0,
	    
            "key": "MYSQL_HOST",
            "type": "STRING",
            "value": "{{ hfsdb_MYSQL_HOST | default('mydb') }}",
            "order": 0
        }
      ]
    }
  }
}
