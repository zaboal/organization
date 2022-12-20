// Главный файл исходного кода бота

// Подключение зависимостей
import { Bot } from "grammy";
const bot = new Bot(`${process.env.BOT_TOKEN}`);

import { Database } from "sqlite3";
const database = new Database("bot.sqlite");




// Применение настроек из директории «settings»
import commands from "./settings/commands.json";
bot.api.setMyCommands(commands, {
    scope: { type: "all_private_chats" },
    language_code: "ru"
});

import rights from "./settings/default_administrator_rights.json";
bot.api.setMyDefaultAdministratorRights({rights,
    for_channels: false
});


// Подключение базы данных организации к базе данных бота
database.run("ATTACH DATABASE \"organization.sqlite\" AS organization");



// Обработка сообщений боту, в данном случае только команд
bot.command(["start", "help"],  ctx => {    // Команда инструктирования
    ctx.reply(
        "Команды бота доступны в сплывающем меню от знака «`/`» в поле ввода сообщения",
        { parse_mode: "MarkdownV2" },
    );
});

bot.command("register",         ctx => {    // Команда регистрации в организации
    // В ctx.match берутся аргументы команды /register и используются как данные вводимые в таблицу
    const command_arguments = ctx.match.split(", ")
    const name: string = command_arguments[0];
    const email: string = command_arguments[1];
    // Заносятся соответствующие данные в БД организации, полученный идентификатор запоминает бот
    database.get(`SELECT user_per_rowid FROM users WHERE user_id = "${ctx.msg.chat.id}"`, (error, result) => {
        if (result == undefined) {
            if (ctx.match == "") {
                ctx.reply(
                    "Данная команда требует аргументы, через запятую: полное имя и личную электронную почту"
                    + "\\. Например, разработчик бота зарегистрировался так: «`/register Зажигин Богдан Алексеевич, za\\.boal@vk\\.com`»",
                    { parse_mode: "MarkdownV2" }
                );
            } else {
                database.run(`INSERT INTO people(per_name, per_email) VALUES ("${name}", "${email}")`, (error) => {
                    if (error == null) {
                        ctx.reply(`Регистрация прошла успешно`);
                        database.get(`SELECT rowid FROM people where per_email = "${email}"`, (error, select) => {
                            if (error == null){
                                database.run(`INSERT INTO users VALUES ("${select.rowid}", "${ctx.msg.chat.id}")`);
                            } else {
                                ctx.reply(
                                    `Регистрация не удалась, SQLite сообщает об ошибке: «\`${error}\`»`,
                                    { parse_mode: "MarkdownV2" }
                                );
                            }
                        });
                    } else {
                        ctx.reply(
                            `Регистрация не удалась, SQLite сообщает об ошибке: «\`${error}\`»`,
                            { parse_mode: "MarkdownV2" }
                        );
                    }
                });
            }
        } else {
            ctx.reply(
                "Вы уже зарегистрированы",
                { parse_mode: "MarkdownV2" }
            );
        }
    });
});


// Запуск бота
bot.start({
    limit:                  1,
    timeout:                1,
    allowed_updates:        ["message"],
    drop_pending_updates:   true,
    onStart:                bot => {
        console.log(
            `Бот запущен как «${bot.first_name}»`
            + ` c именем пользователя @${bot.username}`
            + ` под идентификатором ${bot.id}.`,
            (bot.can_join_groups                == true) ? "Он может присоединяться к группам," : "Он не может присоединяться к группам,",
            (bot.can_read_all_group_messages    == true) ? "читает сообщения в которых уже есть;" : "не читает сообщения в них;",
            (bot.supports_inline_queries        == true) ? "поддерживает инлайн-режим." : "не поддерживает инлайн-режим."
            + "\n"
        );
    }
});



// Обработка событий Process
process.on("exit",      code => {
    console.log(`Запущен протокол выхода под кодом ${code}…`);
    bot.stop();
});

process.on("SIGINT",    () => {
    console.log("\n\nПолучен сигнал POSIX — «SIGINT».");
    process.exit(0);
});