Перем ОстановитьСервер;
Перем СтатусыHTTP;
Перем СоответствиеРасширенийТипамMIME;
Перем Задачи, ИдЗадачи;
Перем Ресурсы;
Перем Процессы, ИдПроцесса;


Функция ПолучитьОбласть(ИмяОбласти, ЗначенияПараметров = Неопределено)
	
	Если ИмяОбласти = "ОбластьШапка" Тогда	ОбластьТекст = "<!DOCTYPE html><html lang=""ru""><head><meta charset=""utf-8""/></head><body>";
	ИначеЕсли ИмяОбласти = "ОбластьПодвал" Тогда ОбластьТекст = "</body></html>";
	Иначе ОбластьТекст = "";
	КонецЕсли;
	
	Возврат ОбластьТекст;
	
КонецФункции


Функция СтруктураВКод(Стр)
	Код = "Данные = Новый Структура();";
	Для Каждого Параметр Из Стр Цикл
		Код = Код + " Данные.Вставить(""" + Параметр.Ключ + """, """ + Параметр.Значение + """);"
	КонецЦикла;
	Возврат Код;
КонецФункции


// Разбирает вошедший запрос и возвращает структуру запроса
Функция РазобратьЗапросКлиента(ТекстЗапроса)
	
	Перем ИмяКонтроллера;
	Перем ИмяМетода;
	Перем ПараметрыМетода;

	Заголовок = Новый Соответствие();
	
	мТекстовыеДанные = ТекстЗапроса;
	Пока Найти(мТекстовыеДанные,Символы.ПС) > 0 Цикл
		П = Найти(мТекстовыеДанные,Символы.ПС);
		Подстрока = Лев(мТекстовыеДанные, П);
		мТекстовыеДанные = Прав(мТекстовыеДанные,СтрДлина(мТекстовыеДанные)-П);
		// Разбираем ключ значение
		Если Найти(Подстрока,"HTTP/1.1") > 0 Тогда
			// Это строка протокола
			// Определим метод
			П1 = 0;
			Метод = Неопределено;
			Если Найти(Подстрока,"POST") > 0 Тогда
				Метод ="POST";
				П1 = 4;
			ИначеЕсли Найти(Подстрока,"PUT") > 0 Тогда
				Метод = "PUT";
				П1 = 3;
			ИначеЕсли Найти(Подстрока,"DELETE") > 0 Тогда
				Метод ="DELETE";
				П1 = 6;
			ИначеЕсли Найти(Подстрока,"GET") > 0 Тогда
				Метод ="GET";
				П1 = 3;
			КонецЕсли;
			Заголовок.Вставить("Method", Метод);
			// Определим Путь
			П2 = Найти(Подстрока,"HTTP/1.1");
			Путь = СокрЛП(Сред(Подстрока,П1+1,СтрДлина(Подстрока)-10-П1));
			Заголовок.Вставить("Path", Путь);
			
		Иначе
			Если Найти(Подстрока,":") > 0 Тогда
				П3 = Найти(Подстрока,":");
				Ключ 		= СокрЛП(Лев(Подстрока,П3-1));
				Значение	= СокрЛП(Прав(Подстрока,СтрДлина(Подстрока)-П3));
				Заголовок.Вставить(Ключ, Значение);
			Иначе
				Ключ 		= "unkown";
				Значение	= СокрЛП(Подстрока);
				Если СтрДлина(Значение) > 0 Тогда
					Заголовок.Вставить(Ключ, Значение);	
				КонецЕсли;					
			КонецЕсли;			 
		КонецЕсли;
	КонецЦикла;
	
	// Получим данные запроса 
	ПД = Найти(мТекстовыеДанные,Символы.ВК+Символы.ПС+Символы.ВК+Символы.ПС);
	POSTДанные = Сред(мТекстовыеДанные,ПД,СтрДлина(мТекстовыеДанные)-ПД);
	POSTДанные = РаскодироватьСтроку(POSTДанные, СпособКодированияСтроки.КодировкаURL); 
	// Разбираем данные пост
	Если СтрДлина(POSTДанные) > 0 Тогда
		POSTДанные = POSTДанные + "&";
	КонецЕсли;
	Заголовок.Вставить("POSTДанные", POSTДанные);	
	POSTСтруктура = Новый Структура();
	Пока Найти(POSTДанные,"&") > 0 Цикл
		П1 = Найти(POSTДанные,"&");
		П2 = Найти(POSTДанные,"=");
		Ключ = Лев(POSTДанные, П2-1);
		Значение = Сред(POSTДанные,П2+1, П1-(П2+1));
		POSTДанные = Прав(POSTДанные,СтрДлина(POSTДанные)-П1);
		POSTСтруктура.Вставить(Ключ,Значение);
	КонецЦикла;
	Заголовок.Вставить("POSTData", POSTСтруктура);	
	//Сообщить(ПД);
	// Разбор пути на имена контроллеров
	Путь = СокрЛП(Заголовок.Получить("Path"));
	// ПараметрыМетода = Новый Массив();
	Если Не Путь = Неопределено Тогда
		Если Лев(Путь,1) = "/" Тогда
			Путь = Прав(Путь,СтрДлина(Путь)-1);
		КонецЕсли;
		Если Прав(Путь,1) <> "/" Тогда
			Путь = Путь+"/";
		КонецЕсли;
		Сч = 0;
		Пока Найти(Путь,"/") > 0 Цикл
			П = Найти(Путь,"/");
			Сч = Сч + 1;
			ЗначениеПараметра = Лев(Путь,П-1);
			Путь = Прав(Путь,СтрДлина(Путь)-П);
			Если Сч = 1 Тогда
				ИмяКонтроллера = ЗначениеПараметра;
			ИначеЕсли Сч = 2 Тогда
				ИмяМетода = ЗначениеПараметра;
			Иначе
				Прервать;
				// ПараметрыМетода.Добавить(ЗначениеПараметра);
			КонецЕсли;
		КонецЦикла;
		Если СокрЛП(ИмяКонтроллера) = "" Тогда
			// Контроллер по умолчанию
			ИмяКонтроллера = "system";
		КонецЕсли;
		GETСтруктура = Новый Структура();
		// Метод по умолчанию
		Если СокрЛП(ИмяМетода) = "" Тогда
			ИмяМетода = "showdata";
		Иначе
			Если Найти(ИмяМетода, "?") Тогда
				GETДанные = ИмяМетода;
				ИмяМетода = Лев(GETДанные, Найти(GETДанные, "?") - 1);
				GETДанные = СтрЗаменить(GETДанные, ИмяМетода + "?", "") + "&";
				// Разбираем данные гет
				Пока Найти(GETДанные, "&") > 0 Цикл
					П1 = Найти(GETДанные, "&");
					П2 = Найти(GETДанные, "=");
					Ключ = Лев(GETДанные, П2-1);
					Значение = Сред(GETДанные, П2 + 1, П1 - (П2 + 1));
					GETДанные = Прав(GETДанные, СтрДлина(GETДанные) - П1);
					GETСтруктура.Вставить(Ключ, Значение);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Заголовок.Вставить("GETData", GETСтруктура);	

	Запрос = Новый Структура;
	Запрос.Вставить("Заголовок", Заголовок);
	Запрос.Вставить("ИмяКонтроллера", ИмяКонтроллера);
	Запрос.Вставить("ИмяМетода", ИмяМетода);
	// Запрос.Вставить("ПараметрыМетода", ПараметрыМетода);
	
	Возврат Запрос;
	
КонецФункции


Функция ОбработатьЗапросКлиента(Запрос, Знач Соединение)

	ПараметрыЗапроса = Запрос.Заголовок.Получить(Запрос.Заголовок.Получить("Method") + "Data");

	Задача = Новый Структура;
	ИдЗадачи = ИдЗадачи + 1;
	Задачи.Вставить("" + ИдЗадачи, Задача);
	Задача.Вставить("ИдЗадачи", "" + ИдЗадачи);
	Задача.Вставить("ИмяМетода", Запрос.ИмяМетода);
	Задача.Вставить("ИмяКонтроллера", Запрос.ИмяКонтроллера);
	Задача.Вставить("Процесс", Неопределено);
	Задача.Вставить("ВремяНачало", ТекущаяДата());
	Задача.Вставить("Соединение", Соединение);
	Задача.Вставить("Результат", Неопределено);
	
	Если Запрос.ИмяКонтроллера = "tasks" Тогда
		Если Запрос.ИмяМетода = "stopserver" Тогда
			Задача.Вставить("Результат", "Сервер остановлен");
			ОстановитьСервер = Истина;
		КонецЕсли;
	ИначеЕсли Запрос.ИмяКонтроллера = "resource" Тогда

		Задача.Вставить("ПутьКФайлу", Запрос.Заголовок.Получить("Path"));
		Задача.Вставить("Результат", "Файл");

	ИначеЕсли Запрос.ИмяКонтроллера = "mm" Тогда

		Задача.Вставить("ПутьКФайлу", Запрос.Заголовок.Получить("Path"));
		Задача.Вставить("Результат", "Файл");

	ИначеЕсли Запрос.ИмяКонтроллера = "system" Тогда
	
		Задача.Вставить("ПараметрыЗапроса", ПараметрыЗапроса);
	
	Иначе

		Задача.Результат = "404";
	
	КонецЕсли;
	
	Сообщить(СокрЛП(ТекущаяДата()) + " -> taskid=" + Задача.ИдЗадачи + " " + СокрЛП(Запрос.Заголовок.Получить("Method")) + " " + Запрос.Заголовок.Получить("Path"));

КонецФункции


Процедура ОбработатьОтветСервера(Задача)

	Перем ИмяФайла;

	СтатусОтвета = 200;
	Заголовок = Новый Соответствие();
	ДвоичныеДанныеОтвета = Неопределено;
	ТекстОтвета = Задача.Результат;
	Размер = 0;
	
	// Разбор маршрута
	Если Задача.Свойство("ПутьКФайлу") Тогда
		
		ЗаголовокФайла = Ресурсы.ПолучитьФайл(Задача.ПутьКФайлу);
		
		Если НЕ ЗаголовокФайла = Неопределено Тогда
	
			ИмяФайла = ОбъединитьПути(Ресурсы.КаталогФайловДанных, ЗаголовокФайла.ПозицияДанныхФайла);
			Расширение = ЗаголовокФайла.Расширение;
			Размер		= ЗаголовокФайла.ОбъемДанных;
			
		Иначе
			
			ИмяФайла = ТекущийКаталог() + Задача.ПутьКФайлу;

			Сообщить(ИмяФайла);
			
			Файл = Новый Файл(ИмяФайла);
			Расширение = Файл.Расширение;
			
			Если НЕ Файл.Существует() Тогда
				ИмяФайла = СтрЗаменить(ИмяФайла, "/", "\");
				Файл = Новый Файл(ИмяФайла);
				// Если НЕ Файл.Существует() Тогда
					// СтатусОтвета = 500;
				// КонецЕсли;
			КонецЕсли;
			
			Если Файл.Существует() Тогда
				Размер	= Файл.Размер();
				Ресурсы.ДобавитьДанные(Новый Структура("ИмяФайла, ПутьКФайлу, Расширение", ИмяФайла, Задача.ПутьКФайлу, Расширение));
			Иначе
				СтатусОтвета = 500;
			КонецЕсли;
		
		КонецЕсли;
				
		Если НЕ СтатусОтвета = 500 Тогда
			MIME = СоответствиеРасширенийТипамMIME.Получить(Расширение);
			Если MIME = Неопределено Тогда
				MIME = СоответствиеРасширенийТипамMIME.Получить("default");
			КонецЕсли;
			ДвоичныеДанные = Новый ДвоичныеДанные(СокрЛП(ИмяФайла));
			ДвоичныеДанныеОтвета = ДвоичныеДанные;
			
			Заголовок.Вставить("Content-Length", Размер);
			Заголовок.Вставить("Content-Type", MIME);
		КонецЕсли;
	КонецЕсли;

	Если Задача.Соединение.Активно Тогда
	
		ПС = Символы.ВК + Символы.ПС;
		мЗаголовок = СокрЛП(СтатусыHTTP[Число(СтатусОтвета)]) + ПС;
		Задача.Соединение.ОтправитьСтроку(мЗаголовок);
		ТекстОтветаКлиенту = "";
		Для Каждого СтрокаЗаголовкаответа из Заголовок Цикл
			ТекстОтветаКлиенту = ТекстОтветаКлиенту + СтрокаЗаголовкаответа.Ключ + ":" + СтрокаЗаголовкаответа.Значение + ПС;
		КонецЦикла;
		//ТекстОтветаКлиенту = ТекстОтветаКлиенту + "Content-Length:"+Строка((СтрДлина(Ответ.ТекстОтвета)-2)*2)+ПС+ПС;
		
		Попытка
			Задача.Соединение.ОтправитьСтроку(ТекстОтветаКлиенту);
			Задача.Соединение.ОтправитьСтроку(ПС);
			
			Если НЕ ДвоичныеДанныеОтвета = Неопределено Тогда
				Задача.Соединение.ОтправитьДвоичныеДанные(ДвоичныеДанныеОтвета);
			Иначе
				Задача.Соединение.ОтправитьСтроку(СокрЛП(ТекстОтвета));
			КонецЕсли;
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		
		Задача.Соединение.Закрыть();

	КонецЕсли;
	
	Задача.Соединение = Неопределено;
	Задача.Результат = Неопределено;
	
КонецПроцедуры


Процедура ОбработатьЗадачи()

	Для каждого элПроцесс Из Процессы Цикл

		Процесс = ЭлПроцесс.Значение;
		
		Если НЕ Процесс.Свободен Тогда
			Если НЕ Процесс.Процесс = Неопределено Тогда
				Пока Процесс.Процесс.ПотокВывода.ЕстьДанные Цикл
					Если Процесс.Сообщение = Неопределено Тогда
						Процесс.Сообщение =  Новый Структура("Параметры, Ответ");
						СтрокаДанные = Процесс.Процесс.ПотокВывода.ПрочитатьСтроку();
						Если Лев(СтрокаДанные, 8) = "Данные =" Тогда
							Попытка
								Данные = Неопределено;
								Выполнить(СтрокаДанные);
								Процесс.Сообщение.Параметры = Данные;
								СтрокаДанные = Неопределено;
							Исключение
								Сообщить("Ошибка разбора параметров");
							КонецПопытки;
						КонецЕсли;
					Иначе
						СтрокаДанные = Процесс.Процесс.ПотокВывода.Прочитать();
						Процесс.Сообщение.Ответ = ?(Процесс.Сообщение.Ответ = Неопределено, "", Процесс.Сообщение.Ответ) + СтрокаДанные;
						Процесс.Свободен = Истина;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	
	КонецЦикла;
	
	Для каждого элЗадача Из Задачи Цикл
		
		Задача = элЗадача.Значение;

		Если НЕ Задача.Результат = Неопределено Тогда
			
			Если НЕ Задача.Соединение = Неопределено Тогда
				Если Задача.Соединение.Активно Тогда
					ОбработатьОтветСервера(Задача);	
					Сообщить(СокрЛП(ТекущаяДата()) + " <- taskid=" + СокрЛП(Задача.ИдЗадачи) + " time=" + (ТекущаяДата() - Задача.ВремяНачало));
				КонецЕсли;
			КонецЕсли;
	
			Задачи.Удалить(элЗадача.Ключ);
			Прервать;
		
		Иначе

			Если Задача.Процесс = Неопределено Тогда
				
				Если Задача.ПараметрыЗапроса.Свойство("procid") Тогда
					Процесс = Процессы.Получить(Задача.ПараметрыЗапроса.procid);
					Если НЕ Процесс = Неопределено Тогда
						Если Процесс.Процесс.Завершен Тогда
							Процессы.Удалить(Задача.ПараметрыЗапроса.procid);
							Продолжить;
						КонецЕсли;
						Если НЕ Процесс.Свободен Тогда
							Продолжить;
						КонецЕсли;
						Задача.Процесс = Процесс;
					Иначе
						Задача.Результат = "Процесс не найден!";
					КонецЕсли;
				КонецЕсли;
				
				Если Задача.Процесс = Неопределено Тогда
					ИдПроцесса = ИдПроцесса + 1;
					Процесс = Новый Структура("ИдПроцесса, Процесс", ИдПроцесса, СоздатьПроцесс("oscript " + ОбъединитьПути(ТекущийКаталог(), Задача.ИмяКонтроллера, Задача.ИмяМетода + ".os"), , Истина, Истина));
					Сообщить("Запустил процесс " + Задача.ИмяМетода + " procid=" + ИдПроцесса); 
					Задача.Вставить("Процесс", Процесс);
					Задача.Процесс.Процесс.Запустить();
					Процессы.Вставить("" + ИдПроцесса, Задача.Процесс);
				КонецЕсли;
				
				Задача.ПараметрыЗапроса.Вставить("taskid", Задача.ИдЗадачи);
				Задача.ПараметрыЗапроса.Вставить("procid", Задача.Процесс.ИдПроцесса);

				//Сообщить(Задача.Процесс.ИдПроцесса);
				Задача.Вставить("ВремяНачало", ТекущаяДата());
				Задача.Процесс.Вставить("Свободен", Ложь);
				Задача.Процесс.Вставить("Сообщение", Неопределено);
				Задача.Процесс.Процесс.ПотокВвода.ЗаписатьСтроку(СтруктураВКод(Задача.ПараметрыЗапроса));
				Приостановить(1);
				
			КонецЕсли;

			Если НЕ Задача.Процесс.Сообщение = Неопределено Тогда

				// Если Прав(Сообщение, 5) = ".html" Тогда
					// ФайлРезультат = Новый ТекстовыйДокумент;
					// ФайлРезультат.Прочитать(Сообщение);
					// Сообщение = ФайлРезультат.ПолучитьТекст();
				// КонецЕсли;
				
				Если НЕ Задача.Процесс.Сообщение.Параметры = Неопределено Тогда
					Если НЕ Задача.Процесс.Сообщение.Параметры.taskid = Задача.ИдЗадачи Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				
				Если НЕ Задача.Процесс.Сообщение.Ответ = Неопределено Тогда
					Ответ = Задача.Процесс.Сообщение.Ответ;
					
					Задача.Процесс.Сообщение = Неопределено;
					
					Если НЕ Лев(Ответ, 1) = "<" Тогда
						Ответ = ПолучитьОбласть("ОбластьШапка") + Ответ + ПолучитьОбласть("ОбластьПодвал");
					КонецЕсли;
					
					Задача.Результат = Ответ;
					Задача.Процесс.Свободен = Истина;
				КонецЕсли;
			
			КонецЕсли;

		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры


Процедура ОбработатьСоединения() Экспорт
	
	Версия = "0.0.1";
	Хост = "http://localhost/";
	
	Таймаут = 10;
	Если АргументыКоманднойСтроки.Количество() Тогда
		Порт = АргументыКоманднойСтроки[0];
	Иначе
		Порт = 8888;	
	КонецЕсли;

	TCPСервер = Новый TCPСервер(Порт);
	TCPСервер.Запустить();
	Сообщить(СокрЛП(ТекущаяДата()) + " - Сервер запущен на порту: " + СокрЛП(Порт));
	
	ОстановитьСервер = Ложь;
	Соединение = Неопределено;
	
	Задачи = Новый Соответствие;
	ИдЗадачи = 0;
	
	Процессы = Новый Соответствие;
	ИдПроцесса = 0;
	
	ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "dbaccess.os"), "dbaccess");
	Ресурсы = Новый dbaccess("resource"); 
	
	Пока Истина Цикл

		ОбработатьЗадачи();
	
		Если ОстановитьСервер Тогда
			Прервать;
		КонецЕсли;

		Попытка

			Если Соединение = Неопределено Тогда
				Соединение = TCPСервер.ОжидатьСоединения(Таймаут);
				Если Соединение = Неопределено Тогда
					Продолжить;
				КонецЕсли;

				Соединение.ТаймаутОтправки = 100; 
				Соединение.ТаймаутЧтения = 100;

				Запрос	= Неопределено;
				ТекстовыеДанныеВходящие = "";

			Иначе
				Соединение.Закрыть();
				Соединение = Неопределено;
				Продолжить;
			КонецЕсли;
			
			Попытка
				ТекстовыеДанныеВходящие	= Соединение.ПрочитатьСтроку();
				//Сообщить(ТекстовыеДанныеВходящие);
			Исключение
				Продолжить;
			КонецПопытки;

			Если ТекстовыеДанныеВходящие = "" Тогда
				Продолжить;
			КонецЕсли;
			
			Запрос = РазобратьЗапросКлиента(ТекстовыеДанныеВходящие);						
			ОбработатьЗапросКлиента(Запрос, Соединение);
			
			Соединение = Неопределено;

		Исключение
			Сообщить(СокрЛП(ТекущаяДата())+ " " + ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;

	Для каждого элПроцесс Из Процессы Цикл
		Процесс = ЭлПроцесс.Значение.Процесс;
		Процесс.ПотокВвода.ЗаписатьСтроку("");
	КонецЦикла;

КонецПроцедуры

СтатусыHTTP = Новый Массив(1000);
СтатусыHTTP.Вставить(200,"HTTP/1.1 200 OK");
СтатусыHTTP.Вставить(400,"HTTP/1.1 400 Bad Request");
СтатусыHTTP.Вставить(401,"HTTP/1.1 401 Unauthorized");
СтатусыHTTP.Вставить(402,"HTTP/1.1 402 Payment Required");
СтатусыHTTP.Вставить(403,"HTTP/1.1 403 Forbidden");
СтатусыHTTP.Вставить(404,"HTTP/1.1 404 Not Found");
СтатусыHTTP.Вставить(405,"HTTP/1.1 405 Method Not Allowed");
СтатусыHTTP.Вставить(406,"HTTP/1.1 406 Not Acceptable");
СтатусыHTTP.Вставить(500,"HTTP/1.1 500 Internal Server Error");
СтатусыHTTP.Вставить(501,"HTTP/1.1 501 Not Implemented");
СтатусыHTTP.Вставить(502,"HTTP/1.1 502 Bad Gateway");
СтатусыHTTP.Вставить(503,"HTTP/1.1 503 Service Unavailable");
СтатусыHTTP.Вставить(504,"HTTP/1.1 504 Gateway Timeout");
СтатусыHTTP.Вставить(505,"HTTP/1.1 505 HTTP Version Not Supported");

СоответствиеРасширенийТипамMIME = Новый Соответствие();
СоответствиеРасширенийТипамMIME.Вставить(".html","text/html");
СоответствиеРасширенийТипамMIME.Вставить(".css","text/css");
СоответствиеРасширенийТипамMIME.Вставить(".js","text/javascript");
СоответствиеРасширенийТипамMIME.Вставить(".jpg","image/jpeg");
СоответствиеРасширенийТипамMIME.Вставить(".jpeg","image/jpeg");
СоответствиеРасширенийТипамMIME.Вставить(".png","image/png");
СоответствиеРасширенийТипамMIME.Вставить(".gif","image/gif");
СоответствиеРасширенийТипамMIME.Вставить(".ico","image/x-icon");
СоответствиеРасширенийТипамMIME.Вставить(".zip","application/x-compressed");
СоответствиеРасширенийТипамMIME.Вставить(".rar","application/x-compressed");

СоответствиеРасширенийТипамMIME.Вставить("default","text/plain");

ОбработатьСоединения();

				Метод ="POST";
				П1 = 4;
			ИначеЕсли Найти(Подстрока,"PUT") > 0 Тогда
				Метод = "PUT";
				П1 = 3;
			ИначеЕсли Найти(Подстрока,"DELETE") > 0 Тогда
				Метод ="DELETE";
				П1 = 6;
			ИначеЕсли Найти(Подстрока,"GET") > 0 Тогда
				Метод ="GET";
				П1 = 3;
			КонецЕсли;
			Заголовок.Вставить("Method", Метод);
			// Определим Путь
			П2 = Найти(Подстрока,"HTTP/1.1");
			Путь = СокрЛП(Сред(Подстрока,П1+1,СтрДлина(Подстрока)-10-П1));
			Заголовок.Вставить("Path", Путь);
			
		Иначе
			Если Найти(Подстрока,":") > 0 Тогда
				П3 = Найти(Подстрока,":");
				Ключ 		= СокрЛП(Лев(Подстрока,П3-1));
				Значение	= СокрЛП(Прав(Подстрока,СтрДлина(Подстрока)-П3));
				Заголовок.Вставить(Ключ, Значение);
			Иначе
				Ключ 		= "unkown";
				Значение	= СокрЛП(Подстрока);
				Если СтрДлина(Значение) > 0 Тогда
					Заголовок.Вставить(Ключ, Значение);	
				КонецЕсли;					
			КонецЕсли;			 
		КонецЕсли;
	КонецЦикла;
	
	// Получим данные запроса 
	ПД = Найти(мТекстовыеДанные,Символы.ВК+Символы.ПС+Символы.ВК+Символы.ПС);
	POSTДанные = Сред(мТекстовыеДанные,ПД,СтрДлина(мТекстовыеДанные)-ПД);
	POSTДанные = РаскодироватьСтроку(POSTДанные, СпособКодированияСтроки.КодировкаURL); 
	// Разбираем данные пост
	Если СтрДлина(POSTДанные) > 0 Тогда
		POSTДанные = POSTДанные + "&";
	КонецЕсли;
	Заголовок.Вставить("POSTДанные", POSTДанные);	
	POSTСтруктура = Новый Структура();
	Пока Найти(POSTДанные,"&") > 0 Цикл
		П1 = Найти(POSTДанные,"&");
		П2 = Найти(POSTДанные,"=");
		Ключ = Лев(POSTДанные, П2-1);
		Значение = Сред(POSTДанные,П2+1, П1-(П2+1));
		POSTДанные = Прав(POSTДанные,СтрДлина(POSTДанные)-П1);
		POSTСтруктура.Вставить(Ключ,Значение);
	КонецЦикла;
	Заголовок.Вставить("POSTData", POSTСтруктура);	
	//Сообщить(ПД);
	// Разбор пути на имена контроллеров
	Путь = СокрЛП(Заголовок.Получить("Path"));
	// ПараметрыМетода = Новый Массив();
	Если Не Путь = Неопределено Тогда
		Если Лев(Путь,1) = "/" Тогда
			Путь = Прав(Путь,СтрДлина(Путь)-1);
		КонецЕсли;
		Если Прав(Путь,1) <> "/" Тогда
			Путь = Путь+"/";
		КонецЕсли;
		Сч = 0;
		Пока Найти(Путь,"/") > 0 Цикл
			П = Найти(Путь,"/");
			Сч = Сч + 1;
			ЗначениеПараметра = Лев(Путь,П-1);
			Путь = Прав(Путь,СтрДлина(Путь)-П);
			Если Сч = 1 Тогда
				ИмяКонтроллера = ЗначениеПараметра;
			ИначеЕсли Сч = 2 Тогда
				ИмяМетода = ЗначениеПараметра;
			Иначе
				Прервать;
				// ПараметрыМетода.Добавить(ЗначениеПараметра);
			КонецЕсли;
		КонецЦикла;
		Если СокрЛП(ИмяКонтроллера) = "" Тогда
			// Контроллер по умолчанию
			ИмяКонтроллера = "system";
		КонецЕсли;
		GETСтруктура = Новый Структура();
		// Метод по умолчанию
		Если СокрЛП(ИмяМетода) = "" Тогда
			ИмяМетода = "showdata";
		Иначе
			Если Найти(ИмяМетода, "?") Тогда
				GETДанные = ИмяМетода;
				ИмяМетода = Лев(GETДанные, Найти(GETДанные, "?") - 1);
				GETДанные = СтрЗаменить(GETДанные, ИмяМетода + "?", "") + "&";
				// Разбираем данные гет
				Пока Найти(GETДанные, "&") > 0 Цикл
					П1 = Найти(GETДанные, "&");
					П2 = Найти(GETДанные, "=");
					Ключ = Лев(GETДанные, П2-1);
					Значение = Сред(GETДанные, П2 + 1, П1 - (П2 + 1));
					GETДанные = Прав(GETДанные, СтрДлина(GETДанные) - П1);
					GETСтруктура.Вставить(Ключ, Значение);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Заголовок.Вставить("GETData", GETСтруктура);	

	Запрос = Новый Структура;
	Запрос.Вставить("Заголовок", Заголовок);
	Запрос.Вставить("ИмяКонтроллера", ИмяКонтроллера);
	Запрос.Вставить("ИмяМетода", ИмяМетода);
	// Запрос.Вставить("ПараметрыМетода", ПараметрыМетода);
	
	Возврат Запрос;
	
КонецФункции


Функция ОбработатьЗапросКлиента(Запрос, Знач Соединение)

	ПараметрыЗапроса = Запрос.Заголовок.Получить(Запрос.Заголовок.Получить("Method") + "Data");

	Задача = Новый Структура;
	ИдЗадачи = ИдЗадачи + 1;
	Задачи.Вставить("" + ИдЗадачи, Задача);
	Задача.Вставить("ИдЗадачи", "" + ИдЗадачи);
	Задача.Вставить("ИмяМетода", Запрос.ИмяМетода);
	Задача.Вставить("ИмяКонтроллера", Запрос.ИмяКонтроллера);
	Задача.Вставить("Процесс", Неопределено);
	Задача.Вставить("ВремяНачало", ТекущаяДата());
	Задача.Вставить("Соединение", Соединение);
	Задача.Вставить("Результат", Неопределено);
	
	Если Запрос.ИмяКонтроллера = "tasks" Тогда
		Если Запрос.ИмяМетода = "stopserver" Тогда
			Задача.Вставить("Результат", "Сервер остановлен");
			ОстановитьСервер = Истина;
		КонецЕсли;
	ИначеЕсли Запрос.ИмяКонтроллера = "resource" Тогда

		Задача.Вставить("ПутьКФайлу", Запрос.Заголовок.Получить("Path"));
		Задача.Вставить("Результат", "Файл");

	ИначеЕсли Запрос.ИмяКонтроллера = "system" Тогда
	
		Задача.Вставить("ПараметрыЗапроса", ПараметрыЗапроса);
	
	Иначе

		Задача.Результат = "404";
	
	КонецЕсли;
	
	Сообщить(СокрЛП(ТекущаяДата()) + " -> taskid=" + Задача.ИдЗадачи + " " + СокрЛП(Запрос.Заголовок.Получить("Method")) + " " + Запрос.Заголовок.Получить("Path"));

КонецФункции


Процедура ОбработатьОтветСервера(Задача)

	Перем ИмяФайла;

	СтатусОтвета = 200;
	Заголовок = Новый Соответствие();
	ДвоичныеДанныеОтвета = Неопределено;
	ТекстОтвета = Задача.Результат;
	Размер = 0;
	
	// Разбор маршрута
	Если Задача.Свойство("ПутьКФайлу") Тогда
		
		ЗаголовокФайла = Ресурсы.ПолучитьФайл(Задача.ПутьКФайлу);
		
		Если НЕ ЗаголовокФайла = Неопределено Тогда
	
			ИмяФайла = ОбъединитьПути(Ресурсы.КаталогФайловДанных, ЗаголовокФайла.ПозицияДанныхФайла);
			Расширение = ЗаголовокФайла.Расширение;
			Размер		= ЗаголовокФайла.ОбъемДанных;
			
		Иначе
			
			ИмяФайла = ТекущийКаталог() + Задача.ПутьКФайлу;

			Файл = Новый Файл(ИмяФайла);
			Расширение = Файл.Расширение;
			
			// Если НЕ Файл.Существует() Тогда
				// ИмяФайла = СтрЗаменить(ИмяФайла, "/", "\");
				// Файл = Новый Файл(ИмяФайла);
				// Если НЕ Файл.Существует() Тогда
					// СтатусОтвета = 500;
				// КонецЕсли;
			// КонецЕсли;
			
			Если Файл.Существует() Тогда
				Размер	= Файл.Размер();
				Ресурсы.ДобавитьДанные(Новый Структура("ИмяФайла, ПутьКФайлу, Расширение", ИмяФайла, Задача.ПутьКФайлу, Расширение));
			Иначе
				СтатусОтвета = 500;
			КонецЕсли;
		
		КонецЕсли;
				
		Если НЕ СтатусОтвета = 500 Тогда
			MIME = СоответствиеРасширенийТипамMIME.Получить(Расширение);
			Если MIME = Неопределено Тогда
				MIME = СоответствиеРасширенийТипамMIME.Получить("default");
			КонецЕсли;
			ДвоичныеДанные = Новый ДвоичныеДанные(СокрЛП(ИмяФайла));
			ДвоичныеДанныеОтвета = ДвоичныеДанные;
			
			Заголовок.Вставить("Content-Length", Размер);
			Заголовок.Вставить("Content-Type", MIME);
		КонецЕсли;
	КонецЕсли;

	Если Задача.Соединение.Активно Тогда
	
		ПС = Символы.ВК + Символы.ПС;
		мЗаголовок = СокрЛП(СтатусыHTTP[Число(СтатусОтвета)]) + ПС;
		Задача.Соединение.ОтправитьСтроку(мЗаголовок);
		ТекстОтветаКлиенту = "";
		Для Каждого СтрокаЗаголовкаответа из Заголовок Цикл
			ТекстОтветаКлиенту = ТекстОтветаКлиенту + СтрокаЗаголовкаответа.Ключ + ":" + СтрокаЗаголовкаответа.Значение + ПС;
		КонецЦикла;
		//ТекстОтветаКлиенту = ТекстОтветаКлиенту + "Content-Length:"+Строка((СтрДлина(Ответ.ТекстОтвета)-2)*2)+ПС+ПС;
		
		Попытка
			Задача.Соединение.ОтправитьСтроку(ТекстОтветаКлиенту);
			Задача.Соединение.ОтправитьСтроку(ПС);
			
			Если НЕ ДвоичныеДанныеОтвета = Неопределено Тогда
				Задача.Соединение.ОтправитьДвоичныеДанные(ДвоичныеДанныеОтвета);
			Иначе
				Задача.Соединение.ОтправитьСтроку(СокрЛП(ТекстОтвета));
			КонецЕсли;
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		
		Задача.Соединение.Закрыть();

	КонецЕсли;
	
	Задача.Соединение = Неопределено;
	Задача.Результат = Неопределено;
	
КонецПроцедуры


Процедура ОбработатьЗадачи()

	Для каждого элПроцесс Из Процессы Цикл

		Процесс = ЭлПроцесс.Значение;
		
		Если НЕ Процесс.Свободен Тогда
			Если НЕ Процесс.Процесс = Неопределено Тогда
				ДанныеВывода = Новый Структура("Параметры, Ответ");
				Пока Процесс.Процесс.ПотокВывода.ЕстьДанные Цикл
					Если ДанныеВывода.Параметры = Неопределено Тогда
						СтрокаДанные = Процесс.Процесс.ПотокВывода.ПрочитатьСтроку();
						Если Лев(СтрокаДанные, 8) = "Данные =" Тогда
							Попытка
								Данные = Неопределено;
								Выполнить(СтрокаДанные);
								ДанныеВывода.Параметры = Данные;
								СтрокаДанные = Неопределено;
							Исключение
								Сообщить("Ошибка разбора параметров");
							КонецПопытки;
						КонецЕсли;
					Иначе
						СтрокаДанные = Процесс.Процесс.ПотокВывода.Прочитать();
					КонецЕсли;
					Если НЕ СтрокаДанные = Неопределено Тогда
						ДанныеВывода.Ответ = ?(ДанныеВывода.Ответ = Неопределено, "", ДанныеВывода.Ответ) + СтрокаДанные;
					Иначе
						Приостановить(1);
					КонецЕсли;
				КонецЦикла;
				Если НЕ ДанныеВывода.Ответ = Неопределено Тогда
					Процесс.Сообщение = ДанныеВывода;
					Процесс.Свободен = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	
	КонецЦикла;
	
	Для каждого элЗадача Из Задачи Цикл
		
		Задача = элЗадача.Значение;

		Если НЕ Задача.Результат = Неопределено Тогда
			
			Если НЕ Задача.Соединение = Неопределено Тогда
				Если Задача.Соединение.Активно Тогда
					ОбработатьОтветСервера(Задача);	
					Сообщить(СокрЛП(ТекущаяДата()) + " <- taskid=" + СокрЛП(Задача.ИдЗадачи) + " time=" + (ТекущаяДата() - Задача.ВремяНачало));
				КонецЕсли;
			КонецЕсли;
	
			Задачи.Удалить(элЗадача.Ключ);
			Прервать;
		
		Иначе

			Если Задача.Процесс = Неопределено Тогда
				
				Если Задача.ПараметрыЗапроса.Свойство("procid") Тогда
					Процесс = Процессы.Получить(Задача.ПараметрыЗапроса.procid);
					Если НЕ Процесс = Неопределено Тогда
						Если Процесс.Процесс.Завершен Тогда
							Процессы.Удалить(Задача.ПараметрыЗапроса.procid);
							Продолжить;
						КонецЕсли;
						Если НЕ Процесс.Свободен Тогда
							Продолжить;
						КонецЕсли;
						Задача.Процесс = Процесс;
					Иначе
						Задача.Результат = "Процесс не найден!";
					КонецЕсли;
				КонецЕсли;
				
				Если Задача.Процесс = Неопределено Тогда
					ИдПроцесса = ИдПроцесса + 1;
					Процесс = Новый Структура("ИдПроцесса, Процесс", ИдПроцесса, СоздатьПроцесс("c:\os\bin\oscript.exe " + ОбъединитьПути(ТекущийКаталог(), Задача.ИмяКонтроллера, Задача.ИмяМетода + ".os"), , Истина, Истина));
					Сообщить("Запустил процесс " + Задача.ИмяМетода + " procid=" + ИдПроцесса); 
					Задача.Вставить("Процесс", Процесс);
					Задача.Процесс.Процесс.Запустить();
					Процессы.Вставить("" + ИдПроцесса, Задача.Процесс);
				КонецЕсли;
				
				Задача.ПараметрыЗапроса.Вставить("taskid", Задача.ИдЗадачи);
				Задача.ПараметрыЗапроса.Вставить("procid", Задача.Процесс.ИдПроцесса);

				//Сообщить(Задача.Процесс.ИдПроцесса);
				Задача.Вставить("ВремяНачало", ТекущаяДата());
				Задача.Процесс.Вставить("Свободен", Ложь);
				Задача.Процесс.Вставить("Сообщение", Неопределено);
				Задача.Процесс.Процесс.ПотокВвода.ЗаписатьСтроку(СтруктураВКод(Задача.ПараметрыЗапроса));
				Приостановить(1);
				
			КонецЕсли;

			Если НЕ Задача.Процесс.Сообщение = Неопределено Тогда

				// Если Прав(Сообщение, 5) = ".html" Тогда
					// ФайлРезультат = Новый ТекстовыйДокумент;
					// ФайлРезультат.Прочитать(Сообщение);
					// Сообщение = ФайлРезультат.ПолучитьТекст();
				// КонецЕсли;
				
				Если НЕ Задача.Процесс.Сообщение.Параметры = Неопределено Тогда
					Если НЕ Задача.Процесс.Сообщение.Параметры.taskid = Задача.ИдЗадачи Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				
				Ответ = Задача.Процесс.Сообщение.Ответ;
				
				Задача.Процесс.Сообщение = Неопределено;
				
				Если НЕ Лев(Ответ, 1) = "<" Тогда
					Ответ = ПолучитьОбласть("ОбластьШапка") + Ответ + ПолучитьОбласть("ОбластьПодвал");
				КонецЕсли;
				
				Задача.Результат = Ответ;
				Задача.Процесс.Свободен = Истина;
			
			КонецЕсли;

		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры


Процедура ОбработатьСоединения() Экспорт
	
	Версия = "0.0.1";
	Хост = "http://localhost/";
	
	Таймаут = 10;
	Если АргументыКоманднойСтроки.Количество() Тогда
		Порт = АргументыКоманднойСтроки[0];
	Иначе
		Порт = 8888;	
	КонецЕсли;

	TCPСервер = Новый TCPСервер(Порт);
	TCPСервер.Запустить();
	Сообщить(СокрЛП(ТекущаяДата()) + " - Сервер запущен на порту: " + СокрЛП(Порт));
	
	ОстановитьСервер = Ложь;
	Соединение = Неопределено;
	
	Задачи = Новый Соответствие;
	ИдЗадачи = 0;
	
	Процессы = Новый Соответствие;
	ИдПроцесса = 0;
	
	ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "dbaccess.os"), "dbaccess");
	Ресурсы = Новый dbaccess("resource"); 
	
	Пока Истина Цикл

		ОбработатьЗадачи();
	
		Если ОстановитьСервер Тогда
			Прервать;
		КонецЕсли;

		Попытка

			Если Соединение = Неопределено Тогда
				Соединение = TCPСервер.ОжидатьСоединения(Таймаут);
				Если Соединение = Неопределено Тогда
					Продолжить;
				КонецЕсли;

				Соединение.ТаймаутОтправки = 100; 
				Соединение.ТаймаутЧтения = 100;

				Запрос	= Неопределено;
				ТекстовыеДанныеВходящие = "";

			Иначе
				Соединение.Закрыть();
				Соединение = Неопределено;
				Продолжить;
			КонецЕсли;
			
			Попытка
				ТекстовыеДанныеВходящие	= Соединение.ПрочитатьСтроку();
				//Сообщить(ТекстовыеДанныеВходящие);
			Исключение
				Продолжить;
			КонецПопытки;

			Если ТекстовыеДанныеВходящие = "" Тогда
				Продолжить;
			КонецЕсли;
			
			Запрос = РазобратьЗапросКлиента(ТекстовыеДанныеВходящие);						
			ОбработатьЗапросКлиента(Запрос, Соединение);
			
			Соединение = Неопределено;

		Исключение
			Сообщить(СокрЛП(ТекущаяДата())+ " " + ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;

	Для каждого элПроцесс Из Процессы Цикл
		Процесс = ЭлПроцесс.Значение.Процесс;
		Процесс.ПотокВвода.ЗаписатьСтроку("");
	КонецЦикла;

КонецПроцедуры

СтатусыHTTP = Новый Массив(1000);
СтатусыHTTP.Вставить(200,"HTTP/1.1 200 OK");
СтатусыHTTP.Вставить(400,"HTTP/1.1 400 Bad Request");
СтатусыHTTP.Вставить(401,"HTTP/1.1 401 Unauthorized");
СтатусыHTTP.Вставить(402,"HTTP/1.1 402 Payment Required");
СтатусыHTTP.Вставить(403,"HTTP/1.1 403 Forbidden");
СтатусыHTTP.Вставить(404,"HTTP/1.1 404 Not Found");
СтатусыHTTP.Вставить(405,"HTTP/1.1 405 Method Not Allowed");
СтатусыHTTP.Вставить(406,"HTTP/1.1 406 Not Acceptable");
СтатусыHTTP.Вставить(500,"HTTP/1.1 500 Internal Server Error");
СтатусыHTTP.Вставить(501,"HTTP/1.1 501 Not Implemented");
СтатусыHTTP.Вставить(502,"HTTP/1.1 502 Bad Gateway");
СтатусыHTTP.Вставить(503,"HTTP/1.1 503 Service Unavailable");
СтатусыHTTP.Вставить(504,"HTTP/1.1 504 Gateway Timeout");
СтатусыHTTP.Вставить(505,"HTTP/1.1 505 HTTP Version Not Supported");

СоответствиеРасширенийТипамMIME = Новый Соответствие();
СоответствиеРасширенийТипамMIME.Вставить(".html","text/html");
СоответствиеРасширенийТипамMIME.Вставить(".css","text/css");
СоответствиеРасширенийТипамMIME.Вставить(".js","text/javascript");
СоответствиеРасширенийТипамMIME.Вставить(".jpg","image/jpeg");
СоответствиеРасширенийТипамMIME.Вставить(".jpeg","image/jpeg");
СоответствиеРасширенийТипамMIME.Вставить(".png","image/png");
СоответствиеРасширенийТипамMIME.Вставить(".gif","image/gif");
СоответствиеРасширенийТипамMIME.Вставить(".ico","image/x-icon");
СоответствиеРасширенийТипамMIME.Вставить(".zip","application/x-compressed");
СоответствиеРасширенийТипамMIME.Вставить(".rar","application/x-compressed");

СоответствиеРасширенийТипамMIME.Вставить("default","text/plain");

ОбработатьСоединения();
