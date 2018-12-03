// MIT License
// Copyright (c) 2018 Vladimir Vasiliev
// https://github.com/vasvl123/OneScriptDB
//


Перем Хост, Порт;
Перем ПерезапуститьСервер, ОстановитьСервер;
Перем Ресурсы;
Перем Загрузка;
Перем ВсеДанные;
Перем Профили;
Перем Соль;


Функция СтрокуВСтруктуру(Знач Стр)
	Стр = СтрРазделить(Стр, Символы.Таб);
	Ключ = Неопределено;
	Рез = Неопределено;
	Для Каждого знСтр Из Стр Цикл
		Если Ключ = Неопределено Тогда
			Ключ = знСтр;
		Иначе
			Если Рез = Неопределено Тогда
				Рез = Новый Структура;
			КонецЕсли;
			Рез.Вставить(Ключ, РаскодироватьСтроку(знСтр, СпособКодированияСтроки.КодировкаURL));
			Ключ = Неопределено;
		КонецЕсли;
	КонецЦикла;
	Возврат Рез;
КонецФункции


Функция СтруктуруВСтроку(Структ)
	Результат = "";
	Если НЕ Структ = Неопределено Тогда
		Для каждого Элемент Из Структ Цикл
			Результат = ?(Результат = "", "", Результат + Символы.Таб) + Элемент.Ключ + Символы.Таб + КодироватьСтроку(Элемент.Значение, СпособКодированияСтроки.КодировкаURL);
		КонецЦикла;
	КонецЕсли;
	Возврат Результат;
КонецФункции


Функция Раскодировать(знПараметра)
	Возврат РаскодироватьСтроку(знПараметра, СпособКодированияСтроки.КодировкаURL);
КонецФункции


Функция Кодировать(знПараметра)
	Возврат КодироватьСтроку(знПараметра, СпособКодированияСтроки.КодировкаURL);
КонецФункции


Функция УдаленныйУзелАдрес(УдаленныйУзел)
	Возврат Лев(УдаленныйУзел, Найти(УдаленныйУзел, ":") - 1);
КонецФункции


// расшифровывает данные по ключу
Функция Расшифровать(Шифр, КлючШифрования) Экспорт
	бШифр = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ПолучитьДвоичныеДанныеИзBase64Строки(Шифр));
	бКлючШифрования = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ПолучитьДвоичныеДанныеИзBase64Строки(КлючШифрования));
	ЗакодированныеДанные = Новый БуферДвоичныхДанных(32);
	Для Счетчик = 0 ПО 31 Цикл
		ЗначениеКлюча = бКлючШифрования.Получить(Счетчик);
		ЗакодированноеЗначение 	= бШифр.Получить(Счетчик);
		ЗначениеИсходныхДанных = ЗакодированноеЗначение - ЗначениеКлюча;
		Если ЗначениеИсходныхДанных < 0 Тогда
			ЗначениеИсходныхДанных = ЗначениеИсходныхДанных + 256;
		КонецЕсли;
		ЗакодированныеДанные.Установить(Счетчик, ЗначениеИсходныхДанных);
	КонецЦикла;
	Возврат ПолучитьBase64СтрокуИзДвоичныхДанных(ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(ЗакодированныеДанные));
КонецФункции


Функция ПроверкаАвторизации(Параметры)
	Результат = Ложь;
	СтатусСубъекта = "Гость";
	Имя = "Гость";
	Если Параметры.Свойство("unm", Имя) Тогда
		СтатусСубъекта = "Не авторизован";
		Если НЕ "" + Имя = "" Тогда
			//Профиль = Профили.НайтиКлюч("Имя" + Символы.Таб + Имя + Символы.Таб);
			Профиль = Профили.НайтиЗаголовок("Имя", Имя);
			СтатусСубъекта = "Неизвестный субъект";
			Если НЕ Профиль = Неопределено Тогда
				СтатусСубъекта = "Неверный пароль";
				Если НЕ "" + Профиль.Пароль = "" Тогда
					Хэш = Новый ХешированиеДанных(ХешФункция.SHA256);
					Хэш.Добавить(Параметры.procid + Параметры.uid + Профиль.Пароль);
					Если ПолучитьBase64СтрокуИзДвоичныхДанных(Хэш.ХешСумма) = Параметры.pwd Тогда
						СтатусСубъекта = "Прошел авторизацию";
						Результат = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Параметры.Вставить("ПрошелАвторизацию", Результат);
	Параметры.Вставить("Субъект", Имя);
	Параметры.Вставить("СтатусСубъекта", СтатусСубъекта);
	Сообщить(СтатусСубъекта);
	Возврат Результат;
КонецФункции // ПроверкаАвторизации()


Функция ВыполнитьРегистрацию(Параметры)
	Перем Имя;
	Перем Почта;
	Перем Профиль;
	Перем Пароль;
	Результат = Ложь;
	ТекстСообщение = "Введите свое имя";
	ТекстСтатус = "Внимание";
	Если Параметры.Свойство("unm", Имя) Тогда
		Если НЕ Имя = "" Тогда
			//Профиль = Профили.НайтиКлюч("Имя" + Символы.Таб + Имя + Символы.Таб);
			Профиль = Профили.НайтиЗаголовок("Имя", Имя);
			Если Профиль = Неопределено Тогда
				Сообщить("Профиль не найден");
				Профиль = Новый Структура("Имя, Пароль, Почта, Ключ, Дата, УдаленныйУзел", Имя, "", "", "", ТекущаяДата(), Параметры.УдаленныйУзел);
			КонецЕсли;
			Если НЕ Профиль.Пароль = "" Тогда
				ТекстСообщение = "Такое имя уже существует";
			Иначе
				ТекстСообщение = "Укажите свой почтовый ящик";
				Если Параметры.Свойство("mail", Почта) Тогда
					Если НЕ Почта = "" Тогда
						Параметры.Вставить("Этап", "Подтверждение");
						Профиль.Почта = Почта;
						Если Профиль.Ключ = "" Тогда
							Хэш = Новый ХешированиеДанных(ХешФункция.SHA256);
							Хэш.Добавить(Соль + ТекущаяУниверсальнаяДатаВМиллисекундах());
							Ключ = ПолучитьBase64СтрокуИзДвоичныхДанных(Хэш.ХешСумма);
							Профиль.Ключ = Ключ;
							//ТекстСообщение = "Секретный ключ отправлен на почту";
							ТекстСообщение = "Секретный ключ:<br><br>" + Ключ;
							ТекстСтатус = "Информация";
							Сообщить(Ключ);
							Профили.ДобавитьДанные(Профиль);
						Иначе
							ТекстСообщение = "Введите пароль два раза";
							Если Параметры.Свойство("pwd2", Пароль) Тогда
								Хэш = Новый ХешированиеДанных(ХешФункция.SHA256);
								Хэш.Добавить("");
								ПустойПароль = ПолучитьBase64СтрокуИзДвоичныхДанных(Хэш.ХешСумма);
								Пароль = Расшифровать(Пароль, Профиль.Ключ);
								Если НЕ Пароль = ПустойПароль Тогда // не пустой
									ТекстСообщение = "Пароли не совпадают";
									Хэш.Добавить(Параметры.procid + Параметры.uid + Пароль);
									Если ПолучитьBase64СтрокуИзДвоичныхДанных(Хэш.ХешСумма) = Параметры.pwd Тогда
										Параметры.Вставить("Этап", "");
										ТекстСообщение = "Регистрация выполнена";
										ТекстСтатус = "Информация";
										Профиль.Пароль = Пароль;
										Результат = Истина;
										Профили.ДобавитьДанные(Профиль);
									КонецЕсли;
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Параметры.Вставить("ПрошелАвторизацию", Результат);
	Параметры.Вставить("Субъект", Имя);
	Параметры.Вставить("ТекстСтатус", ТекстСтатус);
	Параметры.Вставить("ТекстСообщение", ТекстСообщение);
	Возврат Результат;
КонецФункции // ВыполнитьРегистрацию()


Функция ОбработатьДанные(Соединение, Запрос)
	Перем Команда, ИмяДанных, БазаДанных, ПозицияДанных, КлючИмя, КлючЗначение;

	ВремяНачало = ТекущаяДата();

	Запрос.Свойство("cmd", Команда);

	Если НЕ "" + Команда = "" Тогда // выполнить команду
		Если Команда = "auth" Тогда
			ПроверкаАвторизации(Запрос);
		ИначеЕсли Команда = "reg" Тогда
			ВыполнитьРегистрацию(Запрос);
		КонецЕсли;
		Ответ = ПолучитьДвоичныеДанныеИзСтроки(СтруктуруВСтроку(Запрос));

	Иначе

		Запрос.Свойство("osdb", БазаДанных);
		Запрос.Свойство("data", ИмяДанных);

		ИмяФайлаДанных = ОбъединитьПути(ТекущийКаталог(), "data", ".files", ИмяДанных);
		Ответ = ПолучитьДвоичныеДанныеИзСтроки("");

		Если НЕ "" + БазаДанных = "" Тогда // имя контейнера указано
			Данные = ВсеДанные.Получить(БазаДанных);
			Если Данные = Неопределено Тогда // открыть контейнер
				Данные = Новый dbaccess(ОбъединитьПути(ТекущийКаталог(), "data" , БазаДанных));
				ВсеДанные.Вставить(БазаДанных, Данные);
			КонецЕсли;
		КонецЕсли;

		Если Запрос.Свойство("datatype") Тогда // запись данных
			Попытка
				Соединение.ОтправитьДвоичныеДанные(ПолучитьДвоичныеДанныеИзСтроки("?"));
				дДанные = Соединение.ПрочитатьДвоичныеДанные();
				Если НЕ "" + БазаДанных = "" Тогда // имя контейнера указано
					Если Данные.ОткрытьПотокДанных(Истина) Тогда
						Запрос.Вставить("date", "" + ТекущаяДата());
						Ответ = ПолучитьДвоичныеДанныеИзСтроки(Данные.ДобавитьДанные(Запрос, дДанные));
					КонецЕсли;
				Иначе
					дДанные.Записать(ИмяФайлаДанных);
				КонецЕсли;
			Исключение
				Сообщить(ОписаниеОшибки());
			КонецПопытки;

		ИначеЕсли НЕ "" + БазаДанных = "" Тогда // чтение данных

			Запрос.Свойство("dataposition", ПозицияДанных);
			Запрос.Свойство("keyname", КлючИмя);
			Запрос.Свойство("keyvalue", КлючЗначение);

			Если НЕ "" + КлючИмя = "" Тогда // найти заголовок по значению ключа
				Ответ = ПолучитьДвоичныеДанныеИзСтроки(СтруктуруВСтроку(Данные.НайтиЗаголовок(КлючИмя, КлючЗначение)));

			ИначеЕсли НЕ "" + ПозицияДанных = "" Тогда // прочитать файл по позиции в контейнере
				Ответ = Данные.ПолучитьДанные(Число(ПозицияДанных));

			Иначе // получить список контейнеров
				Ответ = ПолучитьДвоичныеДанныеИзСтроки(Данные.ПолучитьЗаголовки());
			КонецЕсли;
		Иначе // прочитать из файла
			Ответ = Новый ДвоичныеДанные(ИмяФайлаДанных);
		КонецЕсли;

	КонецЕсли;

	Сообщить(СокрЛП(ТекущаяДата()) + " time=" + (ТекущаяДата() - ВремяНачало) + Загрузка);

	Возврат Ответ;

КонецФункции


Процедура ОбработатьСоединения() Экспорт

	Соль = "123";

	Версия = "0.0.1";
	Хост = "127.0.0.1";

	Таймаут = 10;
	Если АргументыКоманднойСтроки.Количество() Тогда
		Порт = Число(АргументыКоманднойСтроки[0]);
	Иначе
		Порт = 8887;
	КонецЕсли;

	TCPСервер = Новый TCPСервер(Порт);
	TCPСервер.Запустить();
	Сообщить(СокрЛП(ТекущаяДата()) + " - Сервер данных запущен на порту: " + СокрЛП(Порт));

	ОстановитьСервер = Ложь;
	ПерезапуститьСервер = Ложь;
	Соединение = Неопределено;

	ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "dbaccess.os"), "dbaccess");
	ВсеДанные = Новый Соответствие();

	Профили = Новый dbaccess(ОбъединитьПути(ТекущийКаталог(), "data" , "users"));

	ПустойЦикл = 0;
	РабочийЦикл = 0;
	ЗамерВремени = ТекущаяДата();

	Пока Истина Цикл

		Если ПустойЦикл + РабочийЦикл > 999 Тогда
			ПредЗамер = ЗамерВремени;
			ЗамерВремени = ТекущаяДата();
			Загрузка = " " + РабочийЦикл / 10 + "% " + Цел(РабочийЦикл/(ЗамерВремени - ПредЗамер)) + " q/s";
			ПустойЦикл = 0;
			РабочийЦикл = 0;
		КонецЕсли;

		Попытка
			Соединение = TCPСервер.ОжидатьСоединения(Таймаут);
			Соединение.ТаймаутОтправки = 500;
			Соединение.ТаймаутЧтения = 50;
		Исключение
			ПустойЦикл = ПустойЦикл + 1;
			Продолжить;
		КонецПопытки;

		Попытка
			ТекстовыеДанныеВходящие	= ПолучитьСтрокуИзДвоичныхДанных(Соединение.ПрочитатьДвоичныеДанные());
		Исключение
			ТекстовыеДанныеВходящие = "";
		КонецПопытки;

		Если ТекстовыеДанныеВходящие = "" Тогда
			Если НЕ Соединение = Неопределено Тогда
				Соединение.Закрыть();
			КонецЕсли;
			ПустойЦикл = ПустойЦикл + 1;
			Продолжить;
		КонецЕсли;

		РабочийЦикл = РабочийЦикл + 1;

		//Сообщить(ТекстовыеДанныеВходящие);
		Попытка
			Соединение.ОтправитьДвоичныеДанные(ОбработатьДанные(Соединение, СтрокуВСтруктуру(ТекстовыеДанныеВходящие)));
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		Если НЕ Соединение = Неопределено Тогда
			Соединение.Закрыть();
		КонецЕсли;

		Если ПерезапуститьСервер ИЛИ ОстановитьСервер Тогда
			Прервать;
		КонецЕсли;

		Соединение = Неопределено;

	КонецЦикла;

	TCPСервер.Остановить();

	Если ПерезапуститьСервер Тогда
		ЗапуститьПриложение("oscript dataserver.os " + Порт, ТекущийКаталог());
	КонецЕсли;

КонецПроцедуры

ОбработатьСоединения();
