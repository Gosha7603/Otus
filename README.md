# Ansible
1. После разворачивания vagrantfile подключаемся к машине

2. Создаем ключ (оставляем значения по умолчанию) командой:
ssh-keygen

3. Копируем ключ на серверную машину командой:
ssh-copy-id 192.168.11.150 (оставив значения по умолчанию)

4. Запускаем playbook командой:
ansible-playbook -i ~/otus/inventory ~/otus/playbook.nginx.yml

PLAY [NGINX | Install and configure NGINX] *********************************************************************************

TASK [Gathering Facts] *****************************************************************************************************
ok: [nginx]

TASK [update] **************************************************************************************************************
changed: [nginx]

TASK [NGINX | Install NGINX] ***********************************************************************************************
changed: [nginx]

TASK [NGINX | Create NGINX config file from template] **********************************************************************
changed: [nginx]

RUNNING HANDLER [restart nginx] ********************************************************************************************
changed: [nginx]

RUNNING HANDLER [reload nginx] *********************************************************************************************
changed: [nginx]

PLAY RECAP *****************************************************************************************************************
nginx                      : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

5. Проверим страницу командой:
curl http://192.168.11.150:8080