test

/#
#  tasks:
#      - name: Centos
#        block:
#      - name: "Install packages"
#        dnf: "name={{ item }} state=present"
#        with_items:
#          - postgresql
          - postgresql-server

      - name: "Install packages"
        yum : "name={{ item }} state=present"
        with_items:
          - python3-psycopg2
        when: ansible_facts['distribution'] == 'CentOS'
  
      - name: "Find out if PostgreSQL is initialized"
        ansible.builtin.stat:
          path: "/var/lib/pgsql/data/pg_hba.conf"
        register: postgres_data

      - name: "Initialize PostgreSQL"
        shell: "postgresql-setup initdb"
        when: not postgres_data.stat.exists
 
      - name: "Start and enable services"
        service: "name={{ item }} state=started enabled=yes"
        with_items:
          - postgresql

      - name: "Create app database"
        become: yes
        become_user: postgres
        postgresql_db:
          state: present
          name: "{{ db_name }}"

      - name: "Create db user"
        become: yes
        become_user: postgres
        postgresql_user:
          state: present
          name: "{{ db_user }}"
          password: "{{ db_password }}"

      - name: "Grant db user access to app db"
        become: yes
        become_user: postgres
        postgresql_privs:
          type: database
          database: "{{ db_name }}"
          roles: "{{ db_user }}"
          grant_option: no
          privs: all

      - name: "Allow md5 connection for the db user"
        postgresql_pg_hba:
          dest: "~/data/pg_hba.conf"
          contype: host
          databases: all
          method: md5
          users: "{{ db_user }}"
          create: true
        become: yes
        become_user: postgres
        notify: restart postgres

      - name: "Add some dummy data to our database"
        become: true
        become_user: postgres
        shell: psql {{ db_name }} < /tmp/dump.sql

      handlers:
      - name: restart postgres
        service: name=postgresql state=restarted 