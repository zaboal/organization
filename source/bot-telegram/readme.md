# Бот в Telegram для регистрации в организации

Бот описан в [`bot-telegram_profile/bot-telegram_profile.ts`](../bot-telegram_profile/bot-telegram_profile.ts) на TypeScript с помощью фреймворка Grammy над Telegram Bot API. Предназначен для запуска в контейнере Docker через NodeJS, файл сборки образа можно видеть под названием [`dockerfile`](../dockerfile). Главный метод запуска проекта — через файл Bash скрипта [`start.sh`](../start.sh).

Официально запускается под доменом [@zaboal_profile_bot](https://t.me/zaboal_profile_bot).


## Переменные бота

Настройки бота расположены в директории [`bot-telegram_profile/settings`](../bot-telegram_profile/settings) для Telegram Bot API и в файле переменных среды [`environment.sh`](../environment.sh) для команды `source`. Файл переменных окружения имеет жизненно необходимые значения, их обязательно требуется указать.


### [`environment.sh`](../environment.sh) — переменные среды

Для запуска бота требуется три константы в формате Bash:

* `BOT_TOKEN` — токен бота, получаемый от [BotFather](https://t.me/BotFather);
* `BOT_DB_PATH` — путь к базе данных SQLite бота на хосте, с данными об идентификаторах пользователя Телеграм людей зарегистрированных в организации;
* `ORG_BD_PATH` — путь к базе данных SQLite орагнизации, с данными об подразделениях, рабочих и т.д.

Данные будут переданы в контейнер Docker в процессе Bash скрипта запуска проекта [`start.sh`](../start.sh). По путям к базам данных на хосте в контейнер будут примонтированы соответствующие файлы SQLite под программными названиями.


### [`settings/*.json`](../bot-telegram_profile/settings) — переменные для Telegram Bot API

При запуске бот передаст Telegram Bot API файлы конфигурации в формате json из директории [`settings`](../bot-telegram_profile/settings/):

* [`commands.json`](../bot-telegram_profile/settings/commands.json) — список команд и их описаний бота;
* [`default_administrator_rights.json`](../bot-telegram_profile/settings/default_administrator_rights.json) — предлагаемый набор прав администратора бота при добавлении в группу.

Эти настройки формируются согласно изменениям кода самого бота. Изменять их рекомендуются только разработчикам, внёсшим изменения.


## Запуск бота

Перед запуском требуется заполнить [переменные среды](#environmentsh--переменные-среды). С помощью команды `source` в [`start.sh`](../start.sh) на основе этих переменных в создаваемый контейнер от образа [`dockerfile`](../dockerfile) будет примонтированы файлы баз данных и передан токен.

Если все переменные указаны верно, можно запускать файл [`start.sh`](../start.sh) от имени администратора:

```bash
sudo bash start.sh
```