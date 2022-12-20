CREATE TABLE vacancies (
    vac_div_rowid   INT         NOT NULL    -- Подразделение открывшее вакансию
                    REFERENCES  divisions   (rowid),
    vac_okpdtr      VARCHAR(18) NOT NULL,   -- Код информационного блока ОКПДТР вакансии
    vac_per_rowid   INT                     -- Человек, проходящий собеседование по ваканасии
                    REFERENCES  people      (rowid)
);