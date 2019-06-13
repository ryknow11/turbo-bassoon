execute block
as
declare variable NAME varchar(1000);
declare variable CODE varchar(1000);
declare variable ID bigint;
declare variable S_VERSION varchar(30);
begin
  for select DXA.ADAPTER_NAME, DXA.PROTOCOL_CODE, DXA.ID, OV.version
      from DX_ADAPTER DXA
      join OSP_VERSIONS OV on OV.OSP_SYSTEM_SITE_ID <> DXA.ID
      where OV.OSP_VERSION_ID in (select max(OSP_VERSION_ID)
                                  from OSP_VERSIONS)
      into :NAME, :CODE, :ID, :S_VERSION
  do
  begin
    --опционально всем адаптерам логин-пароль = PKSP.69XXX - pass
    begin
      update DX_ADAPTER_WEB_SERVICE
      set remote_username = (select('PKSP.' || SS.department_code) from system_site SS), remote_password = 'pass';

    end
    --МВВ, общее_0.5 для всех стендов
    begin
      if (NAME in ('Клиент сервера МВВ-СМЭВ', 'Клиент сервера МВВ-ФНС', 'Клиент сервера МВВ-ФМС', 'Клиент сервера МВВ-ОСС', 'Клиент сервера МВВ-Запросы', 'Клиент сервера МВВ-ПФР', 'Клиент сервера МВВ-Банки', 'Клиент сервера МВВ-МВД', 'Клиент сервера МВВ-Росреестр', 'Клиент сервера МВВ-Почта',
                   'Клиент сервера МВВ-Сайт') and
          CODE = 'общее_0.5') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.157:8080/fssp-mvv/dx/1.1/common/0.5'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
    end
    --МВВ, МВВ_ТРАНЗИТ_2.0 для всех стендов
    begin
      if (NAME in ('Клиент сервера МВВ-Банки', 'Клиент сервера МВВ-Банки-СМЭВ2', 'Клиент сервера МВВ-Банки2', 'Клиент сервера МВВ-ОСС') and
          CODE = 'МВВ_ТРАНЗИТ_2.0') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.157:8080/fssp-mvv/mvv-transit/mvv-dx/2.0'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
    end
    --SMEV_3 для всех стендов
    begin
      if (NAME = 'Клиент сервера МВВ-СМЭВ_3-Обращения' and
          CODE = 'SMEV3_Application') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.157:8082/fssp-mvv/dx/1.1/auth_user3'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
      if (NAME = 'Клиент сервера МВВ-СМЭВ_3-ИД' and
          CODE = 'SMEV3_Execution') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.157:8080/fssp-mvv/mvv-transit/mvv-dx/smev3/smev3-execution'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
      if (NAME = 'Клиент сервера МВВ-СМЭВ_3-ФНС-ЗАГС' and
          CODE = 'SMEV3_FNS_ZAGS') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.157:8080/fssp-mvv/mvv-transit/mvv-dx/smev3/smev3-fns-zags'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
      if (NAME = 'Клиент сервера МВВ-СМЭВ_3-Запросы' and
          CODE = 'SMEV3_Inquiry') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.157:8080/fssp-mvv/mvv-transit/mvv-dx/smev3/smev3-inquiry'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
      if (NAME = 'Клиент сервера МВВ-СМЭВ_3-ПФР-ПЕНСИЯ' and
          CODE = 'SMEV3_PFR_PENSION') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.157:8080/fssp-mvv/mvv-transit/mvv-dx/smev3/smev3-pfr-pension'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
      if (NAME = 'Клиент сервера МВВ-СМЭВ_3-ПФР-СНИЛС' and
          CODE = 'SMEV3_PFR_SNILS') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.157:8080/fssp-mvv/mvv-transit/mvv-dx/smev3/smev3-pfr-snils'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
      if (NAME = 'Клиент сервера МВВ-СМЭВ_3-Постановления' and
          CODE = 'SMEV3_Restriction') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.157:8080/fssp-mvv/mvv-transit/mvv-dx/smev3/smev3-restriction'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
    end
    --для НСИ, голова вида 19.2.3.0
    if (S_VERSION similar to '[0-9]{2}.[0-9].%.0') then
    begin
      if (NAME = 'Клиент публикации справочников НСИ' and
          CODE = 'nsidata-2012') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.186:8081/nsi/dx/1.1/nsidata'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент публикации справочников НСИ (ТО)' and
          CODE = 'nsi-2012') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.186:8081/nsi/dx/1.1/nsi'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент репликации базы ОСП в ТО' and
          CODE = 'rpl-2012') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.121:8080/pksp-server/dx/1.1/pkosp-db'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент электронного документооборота' and
          CODE = 'ПКОСП-ЭД-1.0') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.121:8080/pksp-server/dx/1.1/pkosp-df/1.0'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент управления пользователями' and
          CODE = 'TMA-СК-1.0') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.121:8080/pksp-server/dx/1.1/ua'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
    end

    --для НСИ, патчсет вида 1.24.268.15.75

    if (S_VERSION similar to '1.%.%.%.%') then
    begin
      if (NAME = 'Клиент публикации справочников НСИ' and
          CODE = 'nsidata-2012') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.186:8080/nsi/dx/1.1/nsidata'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент публикации справочников НСИ (ТО)' and
          CODE = 'nsi-2012') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.186:8080/nsi/dx/1.1/nsi'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент репликации базы ОСП в ТО' and
          CODE = 'rpl-2012') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.149:8080/pksp-server/dx/1.1/pkosp-db'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент электронного документооборота' and
          CODE = 'ПКОСП-ЭД-1.0') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.149:8080/pksp-server/dx/1.1/pkosp-df/1.0'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент управления пользователями' and
          CODE = 'TMA-СК-1.0') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.149:8080/pksp-server/dx/1.1/ua'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
    end

    --для НСИ, ветка вида 19.1.64.4

    if (S_VERSION similar to '[0-9]{2}.[0-9].[0-9]{1,3}.[1-9]{1,2}') then
    begin
      if (NAME = 'Клиент публикации справочников НСИ' and
          CODE = 'nsidata-2012') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.186:8082/nsi/dx/1.1/nsidata'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент публикации справочников НСИ (ТО)' and
          CODE = 'nsi-2012') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.186:8082/nsi/dx/1.1/nsi'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент репликации базы ОСП в ТО' and
          CODE = 'rpl-2012') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.146:8080/pksp-server/dx/1.1/pkosp-db'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент электронного документооборота' and
          CODE = 'ПКОСП-ЭД-1.0') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.146:8080/pksp-server/dx/1.1/pkosp-df/1.0'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;

      if (NAME = 'Клиент управления пользователями' and
          CODE = 'TMA-СК-1.0') then
        update DX_ADAPTER_WEB_SERVICE
        set REMOTE_ENDPOINT = 'http://10.81.2.146:8080/pksp-server/dx/1.1/ua'
        where DX_ADAPTER_WEB_SERVICE.ID = :ID;
    end

  end

end