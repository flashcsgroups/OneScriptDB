// MIT License
// Copyright (c) 2019 Vladimir Vasiliev
// https://github.com/vasvl123/OneScriptDB
//


Перем Хост, Порт;
Перем ОстановитьСервер;
Перем Ресурсы;
Перем Загрузка;
Перем ВсеДанные;
Перем Профили;
Перем Соль;
Перем Контроллеры;
Перем МоментЗапуска;
Перем ОбновитьСписокФайлов;
Перем ОбновитьСписокБаз;


Функция ПолучитьИД()
	МоментЗапуска = МоментЗапуска - 1;
	Возврат Цел(ТекущаяУниверсальнаяДатаВМиллисекундах() - МоментЗапуска);
КонецФункции // ПолучитьИД()


Функция СтруктуруВДвоичныеДанные(знСтруктура)
	Результат = Новый Массив;
	Если НЕ знСтруктура = Неопределено Тогда
		Для каждого Элемент Из знСтруктура Цикл
			Ключ = Элемент.Ключ;
			Значение = Элемент.Значение;
			Если ТипЗнч(Значение) = Тип("Структура") Тогда
				Ключ = "*" + Ключ;
				дЗначение = СтруктуруВДвоичныеДанные(Значение);
			ИначеЕсли ТипЗнч(Значение) = Тип("ДвоичныеДанные") Тогда
				Ключ = "#" + Ключ;
				дЗначение = Значение;
			Иначе
				дЗначение = ПолучитьДвоичныеДанныеИзСтроки(Значение);
			КонецЕсли;
			дКлюч = ПолучитьДвоичныеДанныеИзСтроки(Ключ);
			рдКлюч = дКлюч.Размер();
			рдЗначение = дЗначение.Размер();
			бРезультат = Новый БуферДвоичныхДанных(6);
			бРезультат.ЗаписатьЦелое16(0, рдКлюч);
			бРезультат.ЗаписатьЦелое32(2, рдЗначение);
			Результат.Добавить(ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(бРезультат));
			Результат.Добавить(дКлюч);
			Результат.Добавить(дЗначение);
		КонецЦикла;
	КонецЕсли;
	Возврат СоединитьДвоичныеДанные(Результат);
КонецФункции


Функция ДвоичныеДанныеВСтруктуру(Данные, Рекурсия = Истина)
	Если ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
		рдДанные = Данные.Размер();
		Если рдДанные = 0 Тогда
			Возврат "";
		КонецЕсли;
		бдДанные = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("БуферДвоичныхДанных") Тогда
		рдДанные = Данные.Размер;
		бдДанные = Данные;
	Иначе
		Возврат Данные;
	КонецЕсли;
	Позиция = 0;
	знСтруктура = Новый Структура;
	Пока Позиция < рдДанные - 1 Цикл
		рдКлюч = бдДанные.ПрочитатьЦелое16(Позиция);
		рдЗначение = бдДанные.ПрочитатьЦелое32(Позиция + 2);
		Если рдКлюч + рдЗначение > рдДанные Тогда // Это не структура
			Возврат ПолучитьСтрокуИзДвоичныхДанных(Данные);
		КонецЕсли;
		Ключ = ПолучитьСтрокуИзДвоичныхДанных(ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(бдДанные.Прочитать(Позиция + 6, рдКлюч)));
		бЗначение = бдДанные.Прочитать(Позиция + 6 + рдКлюч, рдЗначение);
		Позиция = Позиция + 6 + рдКлюч + рдЗначение;
		Л = Лев(Ключ, 1);
		Если Л = "*" Тогда
			Если НЕ Рекурсия Тогда
				Продолжить;
			КонецЕсли;
			Ключ = Сред(Ключ, 2);
			Значение = ДвоичныеДанныеВСтруктуру(бЗначение);
		ИначеЕсли Л = "#" Тогда
			Ключ = Сред(Ключ, 2);
			Значение = ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(бЗначение);
		Иначе
			Значение = ПолучитьСтрокуИзДвоичныхДанных(ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(бЗначение));
		КонецЕсли;
		знСтруктура.Вставить(Ключ, Значение);
	КонецЦикла;
	Возврат знСтруктура;
КонецФункции


Функция ПередатьДанные(Хост, Порт, стрДанные) Экспорт
	Попытка
		Соединение = Новый TCPСоединение(Хост, Порт);
		Соединение.ТаймаутОтправки = 50;
		Соединение.ОтправитьДвоичныеДанные(СтруктуруВДвоичныеДанные(стрДанные));
		Соединение.Закрыть();
		Возврат Истина;
	Исключение
		Сообщить("Хост недоступен: " + Хост + ":" + Порт);
		Если НЕ Соединение = Неопределено Тогда
			Соединение.Закрыть();
		КонецЕсли;
	КонецПопытки;
	Возврат Ложь;
КонецФункции // ПередатьДанные()


Функция УдаленныйУзелАдрес(УдаленныйУзел)
	Возврат Лев(УдаленныйУзел, Найти(УдаленныйУзел, ":") - 1);
КонецФункции


Функция НовоеУсловиеОтбора(ЗапросДанных = Неопределено, КлючИмя, Сравнение, КлючЗначение)
	Если ЗапросДанных = Неопределено Тогда
		ЗапросДанных = Новый Структура("УсловияОтбора", Новый Структура);
	КонецЕсли;
	ЗапросДанных.УсловияОтбора.Вставить(КлючИмя, Новый Структура("Сравнение, Значение", Сравнение, КлючЗначение));
	Возврат ЗапросДанных;
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
	ПрошелАвторизацию = Ложь;
	СтатусСубъекта = "Гость";
	Имя = "Гость";
	Результат = Новый Структура;
	Если Параметры.Свойство("unm", Имя) Тогда
		СтатусСубъекта = "Не авторизован";
		Если НЕ "" + Имя = "" Тогда
			//Профиль = Профили.НайтиКлюч("Имя" + Символы.Таб + Имя + Символы.Таб);
			ЗапросДанных = НовоеУсловиеОтбора(, "Имя", "Равно", Имя);
			СтатусСубъекта = "Неизвестный субъект";
			Если НЕ Профили.НайтиЗаголовок(ЗапросДанных) = "ОшибкаПотокаДанных" Тогда
				Если ЗапросДанных.ЗаголовокНайден Тогда
					Профиль = ЗапросДанных.Заголовок;
					СтатусСубъекта = "Неверный пароль";
					Если НЕ "" + Профиль.Пароль = "" Тогда
						Хэш = Новый ХешированиеДанных(ХешФункция.SHA256);
						Хэш.Добавить(Параметры.procid + Параметры.uid + Профиль.Пароль);
						Если ПолучитьBase64СтрокуИзДвоичныхДанных(Хэш.ХешСумма) = Параметры.pwd Тогда
							СтатусСубъекта = "Прошел авторизацию";
							ПрошелАвторизацию = Истина;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Параметры.Вставить("ПрошелАвторизацию", ПрошелАвторизацию);
	Параметры.Вставить("СтатусСубъекта", СтатусСубъекта);
	Сообщить(СтатусСубъекта);
	Возврат СтатусСубъекта;
КонецФункции // ПроверкаАвторизации()


Функция ВыполнитьРегистрацию(Параметры)
	Перем Имя;
	Перем Почта;
	Перем Профиль;
	Перем Пароль;
	ПрошелАвторизацию = Ложь;
	ТекстСообщение = "Введите свое имя";
	ТекстСтатус = "Внимание";
	Если Параметры.Свойство("unm", Имя) Тогда
		Если НЕ Имя = "" Тогда
			//Профиль = Профили.НайтиКлюч("Имя" + Символы.Таб + Имя + Символы.Таб);
			ЗапросДанных = НовоеУсловиеОтбора(, "Имя", "Равно", Имя);
			Если НЕ Профили.НайтиЗаголовок(ЗапросДанных) = "ОшибкаПотокаДанных" Тогда
				Если НЕ ЗапросДанных.ЗаголовокНайден Тогда
					Сообщить("Профиль не найден");
					Профиль = Новый Структура("Имя, Пароль, Почта, Ключ, Дата, УдаленныйУзел", Имя, "", "", "", ТекущаяДата(), Параметры.УдаленныйУзел);
				Иначе
					Профиль = ЗапросДанных.Заголовок;
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
								Хэш.Добавить(Соль + ПолучитьИД());
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
											ПрошелАвторизацию = Истина;
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
	КонецЕсли;
	Параметры.Вставить("ПрошелАвторизацию", ПрошелАвторизацию);
	Параметры.Вставить("ТекстСообщение", ТекстСообщение);
	Параметры.Вставить("ТекстСтатус", ТекстСтатус);
	Сообщить(ТекстСообщение);
	Возврат ТекстСообщение;
КонецФункции // ВыполнитьРегистрацию()


Функция ВыполнитьЗадачу(структЗадача)
	Перем Команда, ИмяДанных, БазаДанных, ПозицияДанных, ЗапросДанных, procid, Данные;

	Запрос = структЗадача.Запрос;

	Запрос.Свойство("БазаДанных", БазаДанных);

	Если НЕ структЗадача.Свойство("Данные", Данные) Тогда
		Если НЕ "" + БазаДанных = "" Тогда // имя контейнера указано
			Данные = ВсеДанные.Получить(БазаДанных);
			Если Данные = Неопределено Тогда // открыть контейнер
				Данные = Новый dbaccess(ОбъединитьПути(ТекущийКаталог(), "data" , БазаДанных));
				ВсеДанные.Вставить(БазаДанных, Данные);
				ОбновитьСписокБаз = ТекущаяДата();
			КонецЕсли;
			структЗадача.Вставить("Данные", Данные);
		КонецЕсли;
	КонецЕсли;

	Запрос.Свойство("procid", procid);
	Запрос.Свойство("cmd", Команда);

	Если Команда = Неопределено Тогда
		Запрос.Свойство("Команда", Команда);
	КонецЕсли;

	Сообщить(Команда);

	Если Команда = "init" Тогда // регистрация контроллера
		Если НЕ procid = Неопределено Тогда
			Контроллеры.Вставить(procid, Запрос);
		КонецЕсли;
		Возврат Ложь;

	ИначеЕсли Команда = "stopserver" Тогда
		Если procid = Неопределено Тогда
			ОстановитьСервер = Истина;
		Иначе
			Контроллеры.Удалить(procid); // удалить контроллер
		КонецЕсли;
		Возврат Ложь;

	ИначеЕсли Команда = "auth" Тогда
		структЗадача.Вставить("Ответ", ПроверкаАвторизации(Запрос.ЗапросДанные));
		структЗадача.Вставить("Результат", Запрос.ЗапросДанные);
	Возврат Истина;

	ИначеЕсли Команда = "reg" Тогда
		структЗадача.Вставить("Ответ", ВыполнитьРегистрацию(Запрос.ЗапросДанные));
		структЗадача.Вставить("Результат", Запрос.ЗапросДанные);
		Возврат Истина;

	ИначеЕсли Команда = "ЗаписатьЗаголовок" Тогда // запись заголовка
		Если Данные.ОткрытьПотокДанных(Истина) Тогда
			Если Запрос.Свойство("Заголовок") Тогда
				структЗадача.Вставить("Результат", Данные.ДобавитьДанные(Запрос.Заголовок));
			КонецЕсли;
		КонецЕсли;
		Возврат Истина;

	ИначеЕсли Команда = "ЗаписатьДанные" Тогда // запись данных
		Попытка
			Если НЕ "" + БазаДанных = "" Тогда // имя контейнера указано
				Если Данные.ОткрытьПотокДанных(Истина) Тогда
					Если Запрос.Свойство("Заголовок") Тогда
						структЗадача.Вставить("Результат", Данные.ДобавитьДанные(Запрос.Заголовок, Запрос.дДанные));
						структЗадача.Вставить("Ответ", "Успешно");
					КонецЕсли;
				КонецЕсли;
			Иначе // записать в файл
				ИмяФайлаДанных = ОбъединитьПути(ТекущийКаталог(), "data", ".files", Запрос.Заголовок.ИмяДанных);
				Запрос.дДанные.Записать(ИмяФайлаДанных);
				структЗадача.Вставить("Результат", "");
				структЗадача.Вставить("Ответ", "Успешно");
				ОбновитьСписокФайлов = ТекущаяДата();
			КонецЕсли;
		Исключение
			структЗадача.Вставить("Ответ", "Ошибка");
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		Возврат Истина;

	ИначеЕсли Команда = "ЗапросДанных" Тогда // выбрать данные по запросу

		Если Запрос.ЗапросДанных.Команда = "НайтиЗаголовок" Тогда // выбрать данные по запросу
			структЗадача.Вставить("Ответ",  Данные.НайтиЗаголовок(Запрос.ЗапросДанных));
			Сообщить("ЗаписейПрочитано: " + Запрос.ЗапросДанных.ЗаписейПрочитано + " за " + Запрос.ЗапросДанных.ВремяПоиска + " с.");
			Если Запрос.ЗапросДанных.ЗаголовокНайден = Истина ИЛИ структЗадача.Ответ = "ЗапросЗавершен" ИЛИ структЗадача.Ответ = "ЗапросПриостановлен" Тогда
				структЗадача.Вставить("Результат", Запрос.ЗапросДанных);
				Возврат Истина;
			КонецЕсли;

		ИначеЕсли Запрос.ЗапросДанных.Команда = "СписокБаз" ИЛИ Запрос.ЗапросДанных.Команда = "СписокФайлов" Тогда
			Если НЕ Запрос.Свойство("СписокФайлов") Тогда
				Запрос.Вставить("СписокФайлов", Новый Массив);
				Если Запрос.ЗапросДанных.Команда = "СписокБаз" Тогда
					СписокФайлов = НайтиФайлы(ОбъединитьПути(ТекущийКаталог(), "data"), "*.osdb", Истина);
				Иначе // СписокФайлов
					СписокФайлов = НайтиФайлы(ОбъединитьПути(ТекущийКаталог(), "data", ".files"), "*.*", Истина);
				КонецЕсли;
				Если СписокФайлов.Количество() Тогда
					Запрос.Вставить("ВсегоЭлементов", СписокФайлов.Количество());
					Для каждого элФайл Из СписокФайлов Цикл
						Заголовок = Новый Структура;
						Если Запрос.ЗапросДанных.Команда = "СписокБаз" Тогда
							ИмяФайла = элФайл.ИмяБезРасширения;
							Если ИмяФайла = "web" ИЛИ ИмяФайла = "log" ИЛИ ИмяФайла = "users" Тогда // скрыть системные базы
								Продолжить;
							КонецЕсли;
						КонецЕсли;
						Заголовок.Вставить("ИмяФайла", элФайл.ИмяБезРасширения);
						Заголовок.Вставить("ВремяИзменения", элФайл.ПолучитьВремяИзменения());
						Заголовок.Вставить("Размер", элФайл.Размер());
						Запрос.СписокФайлов.Добавить(Заголовок);
					КонецЦикла;
				КонецЕсли;
				Если НЕ Запрос.ЗапросДанных.Свойство("Позиция") Тогда
					Запрос.ЗапросДанных.Вставить("Позиция", 0);
				КонецЕсли
			КонецЕсли;
			Позиция = Число(Запрос.ЗапросДанных.Позиция);
			Если Позиция < Запрос.СписокФайлов.Количество() Тогда
				Запрос.ЗапросДанных.Вставить("Заголовок", Запрос.СписокФайлов.Получить(Позиция));
				Позиция = Позиция + 1;
				Запрос.ЗапросДанных.Вставить("Позиция", Позиция);
				Запрос.ЗапросДанных.Вставить("ЗаголовокНайден", Истина);
				структЗадача.Вставить("Ответ", "ЗапросВыполняется");
			Иначе
				Запрос.ЗапросДанных.Вставить("ЗаголовокНайден", Ложь);
				структЗадача.Вставить("Ответ", "ЗапросЗавершен");
				Если Запрос.ЗапросДанных.Свойство("Обновление") Тогда
					Если Запрос.ЗапросДанных.Обновление = "Авто" Тогда
						структЗадача.Вставить("Ответ", "ЗапросПриостановлен");
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			структЗадача.Вставить("Результат", Запрос.ЗапросДанных);
			Возврат Истина;
		КонецЕсли;

		Возврат Ложь;

	ИначеЕсли Команда = "ПолучитьДанные" Тогда

		Если НЕ "" + БазаДанных = "" Тогда // чтение данных из контейнера

			Запрос.Свойство("ПозицияДанных", ПозицияДанных);

			Если НЕ "" + ПозицияДанных = "" Тогда // прочитать файл по позиции в контейнере
				структЗадача.Вставить("Результат", Данные.ПолучитьДанные(Число(ПозицияДанных)));

			Иначе // получить список контейнеров
				структЗадача.Вставить("Результат", Данные.ПолучитьЗаголовки());
			КонецЕсли;

			структЗадача.Вставить("Ответ", "Успешно");

		Иначе // прочитать из файла
			Попытка
				Если НЕ СтрНайти(Запрос.ИмяДанных, "..") Тогда
					ИмяФайлаДанных = ОбъединитьПути(ТекущийКаталог(), "data", ".files", Запрос.ИмяДанных);
					Файл = Новый Файл(ИмяФайлаДанных);
					Если Файл.Существует() Тогда
						структЗадача.Вставить("Результат", Новый ДвоичныеДанные(ИмяФайлаДанных));
						структЗадача.Вставить("Ответ", "Успешно");
					КонецЕсли;
				Иначе
					структЗадача.Вставить("Ответ", "Запрещено");
				КонецЕсли;
			Исключение
				структЗадача.Вставить("Ответ", "Ошибка");
				Сообщить(ОписаниеОшибки());
			КонецПопытки;
		КонецЕсли;

	КонецЕсли;

	Возврат Истина;

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
	Сообщить(СокрЛП(ТекущаяДата()) + " Дата-сервер запущен на порту: " + Порт);

	Задачи = Новый Соответствие;

	ОстановитьСервер = Ложь;
	ПерезапуститьСервер = Ложь;
	Соединение = Неопределено;

	ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "dbaccess.os"), "dbaccess");
	ВсеДанные = Новый Соответствие();

	Контроллеры = Новый Соответствие();

	Профили = Новый dbaccess(ОбъединитьПути(ТекущийКаталог(), "data" , "users"));

	ПустойЦикл = 0;
	РабочийЦикл = 0;
	ЗамерВремени = ТекущаяДата();
	НачалоЦикла = ТекущаяДата();
	ОбновитьСписокФайлов = ТекущаяДата();
	ОбновитьСписокБаз = ТекущаяДата();

	Пока НЕ ОстановитьСервер Цикл

		ВремяЦикла = ТекущаяДата() - НачалоЦикла;
		Если ВремяЦикла > 0.1 Тогда
			Сообщить("! ВремяЦикла=" + ВремяЦикла);
		КонецЕсли;
		НачалоЦикла = ТекущаяДата();

		Если Задачи.Количество() Тогда
			ПереченьЗадач = Новый Массив;
			Для каждого элЗадача Из Задачи Цикл
				ПереченьЗадач.Добавить(ЭлЗадача.Значение);
			КонецЦикла;
			Для каждого структЗадача Из ПереченьЗадач Цикл
				ЕстьРезультат = Ложь;
				Если структЗадача.Результат = Неопределено Тогда
					Если структЗадача.Ответ = "ЗапросПриостановлен" Тогда
						ВыполнитьЗадачу = Ложь;
						Если структЗадача.Запрос.Свойство("Команда") Тогда
							Если структЗадача.Запрос.Команда = "ЗапросДанных" Тогда
								Если структЗадача.Запрос.ЗапросДанных.Команда = "СписокФайлов" Тогда
									Если ОбновитьСписокФайлов > структЗадача.ВремяНачало Тогда
										структЗадача.Запрос.ЗапросДанных.Позиция = 0;
										структЗадача.Запрос.Удалить("СписокФайлов");
										структЗадача.ВремяНачало = ТекущаяДата();
										ВыполнитьЗадачу = Истина;
									КонецЕсли;
								КонецЕсли;
								Если структЗадача.Запрос.ЗапросДанных.Команда = "СписокБаз" Тогда
									Если ОбновитьСписокБаз > структЗадача.ВремяНачало Тогда
										структЗадача.Запрос.ЗапросДанных.Позиция = 0;
										структЗадача.Запрос.Удалить("СписокФайлов");
										структЗадача.ВремяНачало = ТекущаяДата();
										ВыполнитьЗадачу = Истина;
									КонецЕсли;
								КонецЕсли;
								Если структЗадача.Запрос.ЗапросДанных.Команда = "НайтиЗаголовок" Тогда
									Если структЗадача.Данные.ВремяИзменения > структЗадача.ВремяНачало Тогда
										структЗадача.Запрос.ЗапросДанных.Позиция = 0;
										структЗадача.Запрос.ЗапросДанных.Удалить("ПозицияДанных");
										структЗадача.ВремяНачало = ТекущаяДата();
										ВыполнитьЗадачу = Истина;
									КонецЕсли;
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
						Если НЕ ВыполнитьЗадачу Тогда
							Продолжить;
						КонецЕсли;
					КонецЕсли;
					РабочийЦикл = РабочийЦикл + 1;
					Попытка
						структЗадача.Вставить("Ответ", Неопределено);
						ЕстьРезультат = ВыполнитьЗадачу(структЗадача);
						Сообщить("" + ТекущаяДата() + " time=" + (ТекущаяДата() - структЗадача.ВремяНачало) + Загрузка);
					Исключение
						Сообщить(ОписаниеОшибки());
					КонецПопытки;
				КонецЕсли;
				Если ЕстьРезультат = Истина Тогда
					Попытка
						ОбратныйЗапрос = "";
						Если структЗадача.Запрос.Свойство("ОбратныйЗапрос", ОбратныйЗапрос) Тогда // возвращаем результат
							Контроллер = Контроллеры.Получить(структЗадача.Запрос.ИдПроцесса);
							Если НЕ Контроллер = Неопределено Тогда
								ОбратныйЗапрос.Вставить("РезультатДанные", Новый Структура("Ответ, Результат", структЗадача.Ответ, структЗадача.Результат));
								Если НЕ ПередатьДанные(Контроллер.Хост, Контроллер.Порт, ОбратныйЗапрос) Тогда
									Продолжить;
								КонецЕсли;
								структЗадача.Результат = Неопределено;
							КонецЕсли;
						КонецЕсли;
					Исключение
						Сообщить(ОписаниеОшибки());
					КонецПопытки;
				КонецЕсли;
				Если структЗадача.Ответ = "ЗапросВыполняется" ИЛИ структЗадача.Ответ = "ЗапросПриостановлен" Тогда
					Продолжить;
				КонецЕсли;
				Задачи.Удалить(структЗадача.ИдЗадачи);
			КонецЦикла;
		КонецЕсли;

		Если ПустойЦикл + РабочийЦикл > 999 Тогда
			ПредЗамер = ЗамерВремени;
			ЗамерВремени = ТекущаяДата();
			Загрузка = " " + РабочийЦикл / 10 + "% " + Цел(РабочийЦикл/(ЗамерВремени - ПредЗамер)) + " q/s";
			ПустойЦикл = 0;
			РабочийЦикл = 0;
		КонецЕсли;

		Соединение = TCPСервер.ОжидатьСоединения(Таймаут);

		Если НЕ Соединение = Неопределено Тогда

			Соединение.ТаймаутОтправки = 500;
			Соединение.ТаймаутЧтения = 50;

			Попытка
				Запрос = ДвоичныеДанныеВСтруктуру(Соединение.ПрочитатьДвоичныеДанные());
			Исключение
				Сообщить(ОписаниеОшибки());
				Запрос = "";
			КонецПопытки;

			Если НЕ Запрос = "" Тогда
				структЗадача = Новый Структура("ИдЗадачи, Запрос, Ответ, Результат, ВремяНачало", ПолучитьИД(), Запрос, Неопределено, Неопределено, ТекущаяДата());
				Задачи.Вставить(структЗадача.ИдЗадачи, структЗадача);
			КонецЕсли;

			Если НЕ Соединение = Неопределено Тогда
				Соединение.Закрыть();
			КонецЕсли;

		Иначе
			ПустойЦикл = ПустойЦикл + 1;
		КонецЕсли;

	КонецЦикла;

	TCPСервер.Остановить();

КонецПроцедуры

МоментЗапуска = ТекущаяУниверсальнаяДатаВМиллисекундах();
ОбработатьСоединения();
