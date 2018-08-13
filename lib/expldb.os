

Функция СписокБаз(Данные, Параметр) Экспорт
	Узел = Данные.НовыйУзел(Новый Структура("Имя", "Узел"));
	родУзел = Узел;
	СписокБаз = НайтиФайлы(ОбъединитьПути(ТекущийКаталог(), "data"), "*.osdb", Истина);
	Если СписокБаз.Количество() Тогда
		Для каждого БазаДанных Из СписокБаз Цикл
			стрУзел = Новый Структура("Имя, Значение", "Строка", БазаДанных.ИмяБезРасширения);
			Если Узел.Имя = "Узел" Тогда
				Узел = Данные.НовыйДочерний(Узел, стрУзел);
			Иначе
				Узел = Данные.НовыйСоседний(Узел, стрУзел);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат родУзел;
КонецФункции


Функция СписокДанных(Данные, Параметр) Экспорт
	БазаДанных = Параметр.Значение;
	ИндексИмя = ОбъединитьПути(ТекущийКаталог(), "data", БазаДанных + ".files", "index");
	Индекс = Новый Файл(ИндексИмя);
	Если НЕ Индекс.Существует() Тогда
		Соединение = Неопределено;
		Данные.ПередатьСтроку(Соединение, "osdb	" + БазаДанных);
		Попытка
			Соединение.ПрочитатьСтроку();
			Соединение.Закрыть();
		Исключение
			Сообщить(ОписаниеОшибки());
			Возврат Неопределено;
		КонецПопытки;
	КонецЕсли;
	Индекс = Новый ТекстовыйДокумент;
	Индекс.Прочитать(ИндексИмя);
	Узел = Данные.НовыйУзел(Новый Структура("Имя", "Узел"));
	родУзел = Узел;
	Для н = 1 По Индекс.КоличествоСтрок() Цикл
		нУзел = Данные.СтрокуВСтруктуру(Индекс.ПолучитьСтроку(н));
		стрУзел = Новый Структура("Имя, Значение", "Строка", нУзел.data);
		Если Узел.Имя = "Узел" Тогда
			Узел = Данные.НовыйДочерний(Узел, стрУзел);
		Иначе
			Узел = Данные.НовыйСоседний(Узел, стрУзел);
		КонецЕсли;
		Данные.НовыйАтрибут(Узел, Новый Структура("Имя, Значение", "dataposition", нУзел.dataposition));
		Данные.НовыйАтрибут(Узел, Новый Структура("Имя, Значение", "date", Данные.УзелСвойство(нУзел, "date")));
	КонецЦикла;
	Возврат родУзел;
КонецФункции


Функция СписокФайлов(Данные, Параметр) Экспорт
	Узел = Данные.НовыйУзел(Новый Структура("Имя", "Список"));
	родУзел = Узел;
	СписокФайлов = НайтиФайлы(ОбъединитьПути(ТекущийКаталог(), "data", ".files"), "*.*", Истина);
	Если СписокФайлов.Количество() Тогда
		Для каждого элФайл Из СписокФайлов Цикл
			стрУзел = Новый Структура("Имя, Значение", "Строка", элФайл.Имя);
			Если Узел.Имя = "Список" Тогда
				Узел = Данные.НовыйДочерний(Узел, стрУзел);
			Иначе
				Узел = Данные.НовыйСоседний(Узел, стрУзел);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат родУзел;
КонецФункции
