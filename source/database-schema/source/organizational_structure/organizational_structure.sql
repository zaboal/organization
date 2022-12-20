-- SQL Схема организационной структуры
/*  Создал Зажигин Богдан Алексеевич под СУБД
    SQLite версии 3.32.3. В основном, идентификатор
    таблиц — rowid.                                 */



CREATE TABLE channels (     -- Каналы общения организации
    ch_participation_uri    VARCHAR UNIQUE  NOT NULL    -- Универсальный идентификатор ресурса (канала общения)
                                                        /*  С помощью функции subsrt() можно будет определить,
                                                            является ли канал общения групповым чатом по протоколу
                                                            Telegram, или комнатой в некотором доме Санкт-Петебурга. */
);

CREATE TABLE projects (     -- Проекты организации
    proj_name       VARCHAR UNIQUE  NOT NULL,   -- Название проекта
    proj_ch_rowid   INT     UNIQUE              -- Идентификатор канала общения участников проекта.
                    REFERENCES  channels    (rowid),
    proj_website    VARCHAR UNIQUE              -- Копроративный сайт проекта
);

CREATE TABLE divisions (    -- Структурные подразделения организации
    div_name        VARCHAR NOT NULL    UNIQUE, -- Название подразделения
    div_ch_rowid    INT     NOT NULL    UNIQUE  -- Идентификатор канала общения для участников подразделения.
                    REFERENCES  channels    (rowid),
    div_proj_rowid  INT     DEFAULT NULL        -- Идентификатор проекта, над которым работает подразделение.
                    REFERENCES  projects    (rowid),
    div_status      BOOLEAN DEFAULT NULL,       -- Статус подразделения
                                                /*  0 — ликвидировано
                                                    1 — активно       */
    div_admin       VARCHAR DEFAULT NULL        -- Контроллирующие подразделение
                    REFERENCES  divisions   (rowid)
);


CREATE TABLE people (       -- Зарегистрированные в организации люди, стали клиентами или рабочими
    per_name    VARCHAR     NOT NULL,           -- Полное имя человека
    per_tel     VARCHAR(11)             UNIQUE, -- Личный телефонный номер человека
    per_email   VARCHAR                 UNIQUE, -- Личная электропочта человека
    per_tin     INT(12)                 UNIQUE, -- Идентификационный номер налогоплательщика (человека)
    per_snils   INT(9)                  UNIQUE, -- Страховой номер индивидуального лицевого счёта человека
    per_dob     DATE,                           -- Дата рождения человека
    per_gender  BOOLEAN                         -- Половые признаки человека
                                                /* 0 — мужские
                                                   1 — женские */
);

CREATE TABLE employments (   -- Трудоустройство персонала организации
    emp_per_rowid   INT         NOT NULL            -- Идентификатор рабочего трудоустройста
                    REFERENCES  people      (rowid),
    emp_div_rowid   INT         NOT NULL            -- Подразделение работы рабочего
                    REFERENCES  divisions   (rowid),
    emp_okpdtr      VARCHAR(18) NOT NULL,           -- Код информационного блока ОКПДТР рабочего
    emp_beginning   DATE        NOT NULL,           -- Дата начала трудоустройста
    emp_ch_rowid    VARCHAR                         -- Копроративная электропочта рабочего данного трудоустройста
                    REFERENCES  channels    (rowid),
    emp_ending      DATE        DEFAULT NULL        -- Дата конца трудоустройста
);