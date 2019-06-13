{
  "kind": "ServiceSpec",
  "apiVersion": "hyscale.io/v1/",
  "metadata": {
    "name": "db",
    "internalendpoint":"mydb",
    "version": 1,
    "replicas": "{{db_REPLICAS | default('1') }}",
    "resourceLimits": {
       "memory" : {{db_MEMORY_LIMIT_IN_MB | default('1024') }}
    }
  },
  "spec": {
    "stack": {
      "name": "mysql-empsvc",
      "version": "5.6",
      "packages": [
        "mysql:5.6"
      ],
      "configProps": [
        {
          "key": "MYSQL_ROOT_PASSWORD",
          "value": "{{ db_MYSQL_ROOT_PASSWORD | default('cHJhbWF0aQ==') }}"
        }
      ],
      "os": "Ubuntu:14.04",
     "distribution":"DEBIAN"
    },
   "artifacts": [
      {
        "name": "database-dump",
        "destination": "/tmp/",
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
        "sizeInGB": "{{ db_MYSQL_DATA_DIR_IN_GB | default('2') }}",
        "storageClass": "{{ db_STORAGE_CLASS | default('2') }}"
      }
    ],
    "config": {
      "commands":  [
                "if [ -d \/var\/lib\/mysql\/lost+found ]; then",
                "    echo \"Found lost+found. Removing it ...\"",
                "    rm -rf \/var\/lib\/mysql\/lost+found",
                "fi",
                "if [ ! -d \/var\/lib\/mysql\/mysql ]; then",
                "     cp \/etc\/mysql\/my.cnf \/usr\/share\/mysql\/my-default.cnf",
                "      mysql_install_db || echo \"Failed to initialize mysql!!\"",
                "fi",
                "\/usr\/bin\/mysqld_safe &",
                "attempts=0",
                "RET=1",
                "while [[ RET -ne 0 ]] && [[ attempts -lt 30 ]]; do",
                "echo \"=> Waiting for confirmation of MySQL service startup\"",
                "       sleep 3",
                "       mysql -uroot -p$MYSQL_ROOT_PASSWORD -e \"status\" > \/dev\/null 2>&1 && RET=$? || RET=1",
                "attempts=$[attempts+1]",
                "done",
                "if [[ $attempts -gt 29 ]];",
                "then",
                "echo \"Mysql Not Started!!...Exiting Now!!\"",
                "exit 1",
                "fi",
                "mysql -uroot -p$MYSQL_ROOT_PASSWORD < \/tmp\/crudservlet.sql",
                "mysqladmin -uroot shutdown -p$MYSQL_ROOT_PASSWORD"
                ],
      "props": [
	{
            "key": "MYSQL_ROOT_PASSWORD",
            "type": "PASSWORD",
            "value": "{{ db_MYSQL_ROOT_PASSWORD | default('cHJhbWF0aQ==') }}",
            "order": 0
        }
      ]
    }
  }
}
