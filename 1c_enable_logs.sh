DIR_BY_XML="/opt/1cv8/conf"
DIR_BY_LOGS="/"
mkdir "$DIR_BY_LOGS/1c_dumps"
mkdir "$DIR_BY_LOGS/1c_logs"

chmod 777 "$DIR_BY_LOGS/1c_dumps"
chmod 777 "$DIR_BY_LOGS/1c_logs"

touch "$DIR_BY_XML/logcfg.xml"
chmod 666 "$DIR_BY_XML/logcfg.xml"
cat > /opt/1cv8/conf/logcfg.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<config xmlns="http://v8.1c.ru/v8/tech-log">
    <dump location="/1c_dumps/" externaldump="1" create="true" type="3"/>
    <log location="/1c_logs/" history="168">
        <event>
            <ne property="Name" value=""/> <!-- Не пустое имя лога -->
        </event>
        <event>
            <eq property="name" value="excp"/> <!-- Логирование ошибок -->
        </event>
        <event>
            <eq property="name" value="excpcntx"/> <!-- Логирование контекста ошибок -->
        </event>
        <property name="all">
        </property>
    </log>
</config>
EOF
