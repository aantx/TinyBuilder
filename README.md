# TinyBuilder
Управляющий скрипт для оформления changelog'a и сборки exe посредством ps2exe.
<<<<<<< HEAD
# Для корректной работы следует придерживаться следующих правил для коммитов
Используется латиница {en}
  * для установки мажорной версии в коммит следует включить флаг -A,
  * Минорная версия - флаг -B,
  * Версия сборки - флаг -C,
  * Апдейт ревизии происходит при отсутствии флага в коммите.
# Процесс работы
  * Проверка существования исполняемого файла.
# Процесс работы
 * Проверка существования исполняемого файла.
     * если отсутствует - ввод базовой версии файла вручную, сборка и завершение работы
  * Парсинг атрибутов файла
  * Запрос даты последниего коммита exe файла
  * Запрос коммитов исходоного кода с даты изменения .exe
  * Парсинг коммитов построчно
  * Счёт версии с учетом последних коммитов
  * Редактирование синопсиса в исходном коде
  * Запрос diff'a и формирование changelog'a
# Требует доработки:
  * многострочные коммиты
  * заякорить изменяемые поля в искодном коде
  * сделать человеческий changelog
  * вывод текста коммитов в utf-8, diff в oem кодировке
