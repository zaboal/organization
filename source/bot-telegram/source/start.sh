# Скрипт запуска проекта
# Процедура запуска проекта подробно описана в docs/start.md.

# Получение необходимых переменных среды и вывод их в консоль
source environment.sh;

echo -e                                                     \
    "Полученные переменные окружения:\n"                    \
    "токен Telegram Bot API — «$BOT_TOKEN»,\n"              \
    "путь к базе данных бота — «$BOT_DB_PATH»,\n"           \
    "путь к базе данных организации — «$ORG_DB_PATH».\n\n";


# Сборка и запуск контейнера Docker
docker build .                                              \
    --tag bot-telegram_profile;

docker run -it                                              \
    --env BOT_TOKEN=$BOT_TOKEN                              \
    --volume $BOT_DB_PATH:/usr/src/app/bot.sqlite           \
    --volume $ORG_DB_PATH:/usr/src/app/organization.sqlite  \
    bot-telegram_profile;