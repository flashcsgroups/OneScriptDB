// Сделано на основе https://github.com/tsukanov-as/kojura

Перем Данные;
Перем КодУзла;
Перем Узлы Экспорт;
Перем Изменены Экспорт;
Перем Количество Экспорт;
Перем Пустой;
Перем УзлыОбновить Экспорт;
Перем Обновить Экспорт;
Перем Представление Экспорт;
Перем Библиотеки;
Перем Рефлектор;
Перем Процесс;
Перем Корень Экспорт;
Перем Фронт Экспорт;

Функция ПередатьСтроку(Соединение, СтрокаДанные) Экспорт
	Процесс.ПередатьСтроку(Соединение, СтрокаДанные);
КонецФункции // ПередатьСтроку()


Функция УзелСостояние(Узел, СостояниеИмя) Экспорт
	Перем УзелСостояния, УзелСостояние;
	Если Узел.Свойство("Состояния", УзелСостояния) Тогда
		УзелСостояния.Свойство(СостояниеИмя, УзелСостояние);
	КонецЕсли;
	Возврат УзелСостояние;
КонецФункции // УзелСостояние(Узел)

Функция УзелСостояниеЗначение(Узел, СостояниеИмя, СостояниеЗначение) Экспорт
	Перем УзелСостояния;
	Если НЕ Узел.Свойство("Состояния", УзелСостояния) Тогда
		УзелСостояния = Новый Структура();
		Узел.Вставить("Состояния", УзелСостояния);
	КонецЕсли;
	УзелСостояния.Вставить(СостояниеИмя, СостояниеЗначение);
	//Сообщить("" + Узел.Код + " " + СостояниеИмя + "=" + (Лев(СостояниеЗначение,30)));
	Возврат СостояниеЗначение;
КонецФункции // УзелСостояниеЗначение(Узел)

Функция СтруктуруВСтроку(Структ)
	Если НЕ ТипЗнч(Структ) = Тип("Структура") Тогда
		Возврат Структ;
	КонецЕсли;
	Результат = "";
	Для каждого Элемент Из Структ Цикл
		Если НЕ ТипЗнч(Элемент.Значение) = Тип("Структура") И НЕ ("" + Элемент.Значение = "") И НЕ (Элемент.Ключ = "Код") Тогда
			Результат = Результат + ?(Результат = "", "", Символы.Таб) + Элемент.Ключ + Символы.Таб + Элемент.Значение;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция УзелСвойство(Узел, Свойство) Экспорт
	УзелСвойство = Неопределено;
	Если НЕ Узел = Неопределено Тогда
		Узел.Свойство(Свойство, УзелСвойство);
	КонецЕсли;
	Возврат УзелСвойство;
КонецФункции // УзелСвойство(Узел)

#Область Окружение

Функция ОбновитьОбъект(Знач Узел) Экспорт
	Объекты = Новый Соответствие;
	Объекты.Вставить(Узел.Код, Узел);
	УзлыОбновить.Вставить("ОбновитьОбъект", Объекты);
КонецФункции

// Установка значения объекта узла
Функция ОбъектЗначение(Знач Узел, Знач ИмяЭлемента, Знач Значение)
	ЭтоФункция = Ложь;
	Узел = Родитель(Узел);
	УзелРодитель = Узел;
	// поиск узла где инициализирован объект
	Пока НЕ Узел = Неопределено Цикл
		Окружение = УзелСостояние(Узел, "Окружение");
		Если НЕ Окружение = Неопределено Тогда
			Если НЕ Окружение[ИмяЭлемента] = Неопределено Тогда
				// объявление объекта найдено, продолжим поиск
				УзелРодитель = Узел;
				ЭтоФункция = Ложь;
			КонецЕсли;
		КонецЕсли;
		// объявленные внутри функции объекты обновлять не нужно
		Если Узел.Имя = "Функция" Тогда
			ЭтоФункция = Истина;
		КонецЕсли;
		Узел = Родитель(Узел);
	КонецЦикла;
	Окружение = УзелСостояние(УзелРодитель, "Окружение");
	Если Окружение = Неопределено Тогда
		Окружение = Новый Соответствие;
		УзелСостояниеЗначение(УзелРодитель, "Окружение", Окружение);
	КонецЕсли;
	Если НЕ ЭтоФункция Тогда
		// Установить для обновления узлы которые нужно обновить
		знОкружение = Окружение[ИмяЭлемента];
		Если НЕ знОкружение = Неопределено Тогда //И НЕ знОкружение = Значение Тогда
			Объекты = УзелСостояние(УзелРодитель, "Объекты");
			Если НЕ Объекты = Неопределено Тогда
				Объекты = Объекты[ИмяЭлемента];
				Если НЕ Объекты = Неопределено Тогда
					УзлыОбновить.Вставить(ИмяЭлемента, Объекты);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Окружение[ИмяЭлемента] = Значение;
КонецФункции

// Чтение значения объекта
Функция ЭлементОкружения(Знач Узел, Знач ИмяЭлемента) Экспорт
	Перем Элемент;
	НачальныйУзел = Узел;
	// Поиск объявления объекта
	Пока НЕ Узел = Неопределено Цикл
		Окружение = УзелСостояние(Узел, "Окружение");
		Если НЕ Окружение = Неопределено Тогда
			Элемент = Окружение[ИмяЭлемента];
			Если НЕ Элемент = Неопределено Тогда
				// объявление найдено, зарегистрируем свой узел для обновлений
				Объекты = УзелСостояние(Узел, "Объекты");
				Если Объекты = Неопределено Тогда
					Объекты = Новый Соответствие;
					УзелСостояниеЗначение(Узел, "Объекты", Объекты);
				КонецЕсли;
				Если Объекты[ИмяЭлемента] = Неопределено Тогда
					Объекты[ИмяЭлемента] = Новый Соответствие;
				КонецЕсли;
				Объекты[ИмяЭлемента].Вставить(НачальныйУзел.Код, НачальныйУзел);
				Прервать;
			КонецЕсли;
		КонецЕсли;
		Узел = Родитель(Узел);
	КонецЦикла;
	Если Элемент = Неопределено Тогда
		Процесс.ЗаписатьСобытие("Интерпретатор", СтрШаблон("Неизвестный объект %1", ИмяЭлемента), 3);
	КонецЕсли;
	Возврат Элемент;
КонецФункции // ЭлементОкружения()

Функция ПоказатьУзел(Узел, Атрибуты = "", Дочерний = "", ЭтоАтрибут = Ложь) Экспорт

	Представление = "";

	УзелИмя = Узел.Имя;
	УзелЗначение = "";
	Если Узел.Свойство("Значение") Тогда
		УзелЗначение = 	Узел.Значение;
	КонецЕсли;

	Если ЭтоАтрибут Тогда

		АтрибутИмя = СтрЗаменить(УзелИмя, "xml_lang", "xml:lang");
		АтрибутИмя = СтрЗаменить(АтрибутИмя, "_", "-");
		Представление = Представление + " " + АтрибутИмя + "=""" + УзелЗначение + """";

	Иначе

		Если УзелИмя = "Узел" Тогда
			УзелИмя = "div";
			УзелЗначение = "";
		КонецЕсли;

		Если Узел.Имя = "comment" Тогда
			Представление = Представление + "<!-- " + УзелЗначение + " -->";
		Иначе
			Представление = Представление + "<" + УзелИмя + Атрибуты + " id=""" + "_" + Узел.Код + """>";
			Представление = Представление + УзелЗначение;
			Представление = Представление + Дочерний + "</" + УзелИмя + ">";
		КонецЕсли;

	КонецЕсли;

	Возврат Представление;

КонецФункции // ПоказатьУзел()


#КонецОбласти // Окружение

#Область Интерпретатор

Функция Сумма(Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Аргумент);
	Аргумент = Соседний(Аргумент);
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение + Интерпретировать(Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Сумма()

Функция Разность(Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		Возврат -Значение;
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение - Интерпретировать(Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Разность()

Функция Произведение(Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение * Интерпретировать(Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Произведение()

Функция Частное(Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение / Интерпретировать(Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Частное()

Функция Остаток(Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение % Интерпретировать(Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Остаток()

Функция ЗначениеФункции(Знач Параметр, Знач Аргумент)
	Перем Значения;
	Выражение = Соседний(Параметр);
	Если Выражение = Неопределено Тогда
		ВызватьИсключение "Ожидается тело функции";
	КонецЕсли;
	Если Параметр.Имя = "Список" Тогда
		Параметр = Дочерний(Параметр);
		Пока Параметр <> Неопределено Цикл
			Если Аргумент = Неопределено Тогда
				ВызватьИсключение "Недостаточно фактических параметров";
			КонецЕсли;
			ОбъектЗначение(Выражение, Параметр.Значение, Интерпретировать(Аргумент));
			Параметр = Соседний(Параметр);
			Аргумент = Соседний(Аргумент);
		КонецЦикла;
	Иначе
		ОбъектЗначение(Выражение, Параметр.Значение, Интерпретировать(Аргумент));
	КонецЕсли;
	Если Выражение.Имя = "Список" Тогда
		Выражение = Дочерний(Выражение);
		Пока Выражение <> Неопределено Цикл
			Значение = Интерпретировать(Выражение);
			Выражение = Соседний(Выражение);
		КонецЦикла;
	Иначе
		Значение = Интерпретировать(Выражение);
	КонецЕсли;
	Возврат Значение;
КонецФункции // ЗначениеФункции()

Функция Лямбда(Знач Параметр)
	Выражение = Соседний(Параметр);
	Аргумент = Соседний(Выражение);
	Если Параметр.Имя = "Список" Тогда
		Параметр = Дочерний(Параметр);
		Если Не ПараметрыКорректны(Параметр) Тогда
			ВызватьИсключение "Ожидается имя параметра";
		КонецЕсли;
	ИначеЕсли Параметр.Имя <> "Объект" Тогда
		ВызватьИсключение "Ожидается имя параметра";
	КонецЕсли;
	Возврат Аргумент;
КонецФункции // Лямбда()

// вспомогательная функция
Функция ПараметрыКорректны(Параметр)
	Возврат Параметр = Неопределено Или Параметр.Имя = "Объект" И ПараметрыКорректны(Соседний(Параметр));
КонецФункции // ПараметрыКорректны()

Функция ЗначениеВыраженияЕсли(Знач Узел)
	Перем СписокЕсли, СписокТогда, СписокИначе;
	СписокЕсли = Узел;
	СписокТогда = Соседний(СписокЕсли);
	СписокИначе = Соседний(СписокТогда);
	Если Интерпретировать(СписокЕсли) = Истина Тогда
		Возврат Интерпретировать(СписокТогда)
	ИначеЕсли НЕ СписокИначе = Неопределено Тогда
		Возврат Интерпретировать(СписокИначе)
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции // ЗначениеВыраженияЕсли()

Функция ЗначениеВыраженияВыбор(Знач Список)
	Перем СписокКогда, СписокТогда;
	СписокКогда = Список;
	Если СписокКогда = Неопределено Тогда
		ВызватьИсключение "Ожидается условие";
	КонецЕсли;
	Пока СписокКогда <> Неопределено Цикл
		СписокТогда = Соседний(СписокКогда);
		Если СписокТогда = Неопределено Тогда
			ВызватьИсключение "Ожидается выражение";
		КонецЕсли;
		Если Интерпретировать(СписокКогда) = Истина Тогда
			Возврат Интерпретировать(СписокТогда);
		КонецЕсли;
		СписокКогда = Соседний(СписокТогда);
	КонецЦикла;
	ВызватьИсключение "Ни одно из условий не сработало!";
КонецФункции // ЗначениеВыраженияВыбор()

Функция Равно(Знач Аргумент)
	Перем Значение, Результат;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Результат = Результат И Значение = Интерпретировать(Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // Равно()

Функция Больше(Знач Аргумент)
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Интерпретировать(Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Интерпретировать(Аргумент);
		Результат = Результат И Значение1 > Значение2;
		Значение1 = Значение2;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // Больше()

Функция Меньше(Знач Аргумент)
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Интерпретировать(Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Интерпретировать(Аргумент);
		Результат = Результат И Значение1 < Значение2;
		Значение1 = Значение2;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // Меньше()

Функция БольшеИлиРавно(Знач Аргумент)
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Интерпретировать(Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Интерпретировать(Аргумент);
		Результат = Результат И Значение1 >= Значение2;
		Значение1 = Значение2;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // БольшеИлиРавно()

Функция МеньшеИлиРавно(Знач Аргумент)
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Интерпретировать(Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Интерпретировать(Аргумент);
		Результат = Результат И Значение1 <= Значение2;
		Значение1 = Значение2;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // МеньшеИлиРавно()

Функция НеРавно(Знач Аргумент)
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Интерпретировать(Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Интерпретировать(Аргумент);
		Результат = Результат И Значение1 <> Значение2;
		Значение1 = Значение2;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // НеРавно()

Функция ЛогическоеИ(Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение = Интерпретировать(Аргумент);
		Результат = Результат И Значение;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // ЛогическоеИ()

Функция ЛогическоеИли(Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Ложь;
	Пока Аргумент <> Неопределено И Не Результат Цикл
		Значение = Интерпретировать(Аргумент);
		Результат = Результат Или Значение;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // ЛогическоеИли()

Функция ЛогическоеНе(Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение = Интерпретировать(Аргумент);
		Результат = Результат И Не Значение;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // ЛогическоеНе()

Функция ВывестиСообщение(Знач Аргумент)
	Перем Значения;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значения = Новый Массив;
	Пока Аргумент <> Неопределено Цикл
		Значения.Добавить(Интерпретировать(Аргумент));
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Процесс.ЗаписатьСобытие("Интерпретатор", СтрСоединить(Значения, " "), 1);
	Возврат Неопределено;
КонецФункции // ВывестиСообщение

Функция ОкружениеУзла(Узел) Экспорт
	Перем Элементы;
	Элементы = НовыйУзел(Новый Структура("Имя", "Окружение"), Истина);
	Окружение = УзелСостояние(Узел, "Окружение");
	Если НЕ Окружение = Неопределено Тогда
		Для каждого элСоответсвие Из Окружение Цикл
			Если ТипЗнч(элСоответсвие.Значение) = Тип("Структура") Тогда
				НовыйДочерний(Элементы, Новый Структура("Имя, Дочерний", элСоответсвие.Ключ, элСоответсвие.Значение.Код), Истина);
			Иначе
				НовыйДочерний(Элементы, Новый Структура("Имя, Значение", элСоответсвие.Ключ, элСоответсвие.Значение), Истина);
			КонецЕсли;
			// НовыйДочерний(Элементы, Новый Структура("Имя, Значение", элСоответсвие.Ключ, элСоответсвие.Значение), Истина);
		КонецЦикла;
	КонецЕсли;
	Возврат Элементы;
КонецФункции // ОкружениеУзла(Узел)

Функция ОбновитьПредставление(знОбновить = Ложь) Экспорт
	Представление = "";
	Если знОбновить Тогда
		Обновить = Истина;
	КонецЕсли;
	Если Обновить Тогда
		Представление = Интерпретировать(Фронт);
	КонецЕсли;

	Циклов = 0;
	Пока Циклов < 5 И УзлыОбновить.Количество() Цикл

		СписокУзлов = Новый Соответствие;
		Для каждого элУзел Из УзлыОбновить Цикл
			Объекты = элУзел.Значение;
			Для каждого элОбъект Из Объекты Цикл
				РодительУзел = элОбъект.Значение;
				ПервыйНайден = Ложь;
				Пока НЕ РодительУзел = Неопределено Цикл
					Если РодительУзел.Имя = "Функция" Тогда
						Сообщить("Функцию не нужно обновлять");
						Прервать;
					ИначеЕсли РодительУзел.Имя = "Пусть" Тогда
						СписокУзлов.Вставить(РодительУзел.Код, РодительУзел);
						Прервать;
					ИначеЕсли РодительУзел.Имя = "Узел" Тогда
						УзелСостояниеЗначение(РодительУзел, "Состояние", Неопределено);
						Если НЕ ПервыйНайден Тогда
							СписокУзлов.Вставить(РодительУзел.Код, РодительУзел);
							УзелСостояниеЗначение(РодительУзел, "ОбновитьУзел", Истина);
							ПервыйНайден = Истина;
						КонецЕсли;
					КонецЕсли;
					РодительУзел = Родитель(РодительУзел);
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		УзлыОбновить.Очистить();

		Если СписокУзлов.Количество() Тогда
			Для каждого элУзел Из СписокУзлов Цикл
				Если НЕ элУзел.Значение = Корень Тогда
					Представление = Представление + Интерпретировать(элУзел.Значение);
				Иначе
					Сообщить("Зачем корень обновлять?");
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

		Циклов = Циклов + 1;
		Сообщить("цикл:" + Циклов);

	КонецЦикла;
	УзлыОбновить.Очистить();

	Обновить = Ложь;
КонецФункции


Функция Интерпретировать(Знач Узел, ЭтоАтрибут = Ложь, НачальныйУзел = Истина) Экспорт
	Перем Имя, Значение, Лямбда, Состояние;

	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		//Возврат Узел;
		ВызватьИсключение "Неверный узел: " + Узел;
	КонецЕсли;

	Состояние = "";

	Имя = Узел.Имя;
	Значение = УзелСвойство(Узел, "Значение");

	Если Имя = "Объект" Тогда
		//Сообщить(Значение);
		Если Значение = "Пустой" Тогда
			Состояние = (Интерпретировать(Дочерний(Узел)) = Пустой);
		ИначеЕсли Значение = "Если" Тогда
			Состояние = ЗначениеВыраженияЕсли(Дочерний(Узел));
		ИначеЕсли Значение = "Выбор" Тогда
			Состояние = ЗначениеВыраженияВыбор(Дочерний(Узел));
		ИначеЕсли Значение = "Сообщить" Тогда
			ВывестиСообщение(Дочерний(Узел));
		ИначеЕсли Значение = "+" Тогда
			Состояние = Сумма(Дочерний(Узел));
		ИначеЕсли Значение = "-" Тогда
			Состояние = Разность(Дочерний(Узел));
		ИначеЕсли Значение = "*" Тогда
			Состояние = Произведение(Дочерний(Узел));
		ИначеЕсли Значение = "/" Тогда
			Состояние = Частное(Дочерний(Узел));
		ИначеЕсли Значение = "%" Тогда
			Состояние = Остаток(Дочерний(Узел));
		ИначеЕсли Значение = "=" Тогда
			Состояние = Равно(Дочерний(Узел));
		ИначеЕсли Значение = ">" Тогда
			Состояние = Больше(Дочерний(Узел));
		ИначеЕсли Значение = "<" Тогда
			Состояние = Меньше(Дочерний(Узел));
		ИначеЕсли Значение = ">=" Тогда
			Состояние = БольшеИлиРавно(Дочерний(Узел));
		ИначеЕсли Значение = "<=" Тогда
			Состояние = МеньшеИлиРавно(Дочерний(Узел));
		ИначеЕсли Значение = "<>" Тогда
			Состояние = НеРавно(Дочерний(Узел));
		ИначеЕсли Значение = "И" Тогда
			Состояние = ЛогическоеИ(Дочерний(Узел));
		ИначеЕсли Значение = "ИЛИ" Тогда
			Состояние = ЛогическоеИли(Дочерний(Узел));
		ИначеЕсли Значение = "НЕ" Тогда
			Состояние = ЛогическоеНе(Дочерний(Узел));
		ИначеЕсли Значение = "Истина" Тогда
			Состояние = Истина;
		ИначеЕсли Значение = "Ложь" Тогда
			Состояние = Ложь;
		ИначеЕсли Значение = "Неопределено" Тогда
			Состояние = Неопределено;
		Иначе
			ЭлементОкружения = ЭлементОкружения(Узел, Значение);
			Состояние = ЭлементОкружения;
			Если ТипЗнч(ЭлементОкружения) = Тип("Структура") И НЕ ЭлементОкружения = Пустой Тогда
				Если ЭлементОкружения.Имя = "Функция" ИЛИ ЭлементОкружения.Имя = "Лямбда" Тогда
					Состояние = ЗначениеФункции(Дочерний(ЭлементОкружения), Дочерний(Узел));
				ИначеЕсли ЭлементОкружения.Имя = "Библиотека" Тогда
					Параметры = Новый Массив;
					Параметры.Добавить(ЭтотОбъект);
					Параметры.Добавить(Дочерний(Узел));
					Состояние = Рефлектор.ВызватьМетод(Библиотеки.Получить(ЭлементОкружения.Значение), Значение, Параметры);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Имя = "Пустой" Тогда
		Состояние = Пустой;
	ИначеЕсли Имя = "Перем" Тогда
		ОбъектЗначение(Узел, Значение, "");
	ИначеЕсли Имя = "Пусть" Тогда
		ОбъектЗначение(Узел, Значение, Интерпретировать(Дочерний(Узел)));
	ИначеЕсли Имя = "Ссылка" Тогда
		Состояние = Дочерний(Узел);
	ИначеЕсли Имя = "Число" Тогда
		Состояние = Число(Значение);
	ИначеЕсли Имя = "Строка" Тогда
		Состояние = "" + Значение;
	ИначеЕсли Имя = "Функция" Тогда
		ОбъектЗначение(Узел, Значение, Узел);
	ИначеЕсли Имя = "Свойство" Тогда
		Элемент = Интерпретировать(Дочерний(Узел));
		Состояние = УзелСвойство(Элемент, Значение);
	ИначеЕсли Имя = "Значение" Тогда
		Элемент = Интерпретировать(Дочерний(Узел));
		Состояние = Интерпретировать(Элемент);
	ИначеЕсли Имя = "Атрибут" Тогда
		Элемент = Интерпретировать(Дочерний(Узел));
		Состояние = НайтиАтрибут(Атрибут(Элемент), Значение);
	ИначеЕсли Имя = "Первый" Тогда
		Список = Интерпретировать(Дочерний(Узел));
		Элемент = Дочерний(Список);
		Если Элемент = Неопределено Тогда
			Элемент = Пустой;
		КонецЕсли;
		Состояние = Элемент;
	ИначеЕсли Имя = "Соседний" Тогда
		Элемент = Интерпретировать(Дочерний(Узел));
		Если НЕ Элемент = Неопределено Тогда
			Элемент = Соседний(Элемент);
		КонецЕсли;
		Если Элемент = Неопределено Тогда
			Элемент = Пустой;
		КонецЕсли;
		Состояние = Элемент;
	ИначеЕсли Имя = "Список" Тогда
		Состояние = Интерпретировать(Дочерний(Узел), , Ложь);
	ИначеЕсли Имя = "Лямбда" Тогда
		Параметры = Дочерний(Узел);
		Аргументы = Лямбда(Параметры);
		Состояние = ЗначениеФункции(Параметры, Аргументы);
	ИначеЕсли Имя = "Использовать" Тогда
		Значение = СтрЗаменить(Значение, "..", "");
		Библиотека = ЗагрузитьСценарий(ОбъединитьПути(ТекущийКаталог(), "lib", Значение + ".os"));
		Библиотеки.Вставить(Значение, Библиотека);
		Рефлектор = Новый Рефлектор;
		ТаблицаМетодов = Рефлектор.ПолучитьТаблицуМетодов(Библиотека);
		Для каждого Метод Из ТаблицаМетодов Цикл
			ОбъектЗначение(Узел, Метод.Имя, Новый Структура("Имя, Значение", "Библиотека", Значение));
		КонецЦикла;

	Иначе

		Если Имя = "Узел" Тогда

			Состояние = Неопределено;

			Если Значение = "Фронт" Тогда
				Если Фронт = Неопределено Тогда
					Фронт = Узел;
					Состояние = "";
				КонецЕсли;
			КонецЕсли;

			Если УзелСостояние(Узел, "ОбновитьУзел") = Ложь ИЛИ Обновить Тогда
				Если НачальныйУзел И НЕ Обновить Тогда
					Состояние = "";
				Иначе
					Состояние = УзелСостояние(Узел, "Состояние");
				КонецЕсли;
			КонецЕсли;

			Если Состояние = Неопределено Тогда
				УзелДочерний = Дочерний(Узел);
				Если НЕ УзелДочерний = Неопределено Тогда
					Состояние = ПоказатьУзел(Узел, , Интерпретировать(Дочерний(Узел), , Ложь));
				Иначе
					Состояние = "";
				КонецЕсли;
				УзелСостояниеЗначение(Узел, "Состояние", Состояние);
				УзелСостояниеЗначение(Узел, "ОбновитьУзел", Ложь);
			КонецЕсли;

		Иначе

			УзелДочерний = Дочерний(Узел);
			УзелАтрибут = Атрибут(Узел);
			Если НЕ ЭтоАтрибут Тогда
				Если НЕ УзелДочерний = Неопределено Тогда
					ЗначениеУзелДочерний = Интерпретировать(УзелДочерний, , Ложь);
				КонецЕсли;
				Если НЕ УзелАтрибут = Неопределено Тогда
					ЗначениеУзелАтрибут = Интерпретировать(УзелАтрибут, Истина, Ложь);
				КонецЕсли;
				Состояние = ПоказатьУзел(Узел, ЗначениеУзелАтрибут, ЗначениеУзелДочерний);
			Иначе
				Состояние = ПоказатьУзел(Узел, , , Истина);
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Если НЕ НачальныйУзел Тогда
		УзелСоседний = Соседний(Узел);
		Если НЕ УзелСоседний = Неопределено Тогда
			Состояние = "" + Состояние + Интерпретировать(УзелСоседний, ЭтоАтрибут, Ложь);
		КонецЕсли;
	КонецЕсли;

	Возврат Состояние;

КонецФункции // Интерпретировать()

#КонецОбласти // Интерпретатор

Функция ПолучитьУзел(Код) Экспорт
	Рез = Узлы.Получить(Код);
	Если НЕ Рез = Неопределено Тогда
		Возврат Рез;
	КонецЕсли;
	Стр = Данные.ПолучитьСтроку(Число(Код));
	Стр = СтрРазделить(Стр, Символы.Таб);
	Ключ = Неопределено;
	Для Каждого знСтр Из Стр Цикл
		Если Ключ = Неопределено Тогда
			Ключ = знСтр;
		Иначе
			Если Рез = Неопределено Тогда
				Рез = Новый Структура("Код", Код);
			КонецЕсли;
			Рез.Вставить(Ключ, знСтр);
			Ключ = Неопределено;
		КонецЕсли;
	КонецЦикла;
	Узлы.Вставить(Код, Рез);
	Возврат Рез;
КонецФункции // ПолучитьУзел()

Функция НовыйУзел(СтруктураУзла, Служебный = Ложь) Экспорт
	Данные.ДобавитьСтроку("");
	Узел = Новый Структура(СтруктураУзла);
	Если Служебный Тогда
		Количество = "s" + Узлы.Количество();
	Иначе
		Количество = Данные.КоличествоСтрок();
	КонецЕсли;
	Узел.Вставить("Код", "" + Количество);
	Узел.Вставить("Состояния", Новый Структура);
	Узлы.Вставить(Узел.Код, Узел);
	Возврат Узел;
КонецФункции // НовыйУзел(СтруктураУзла)

Функция НовыйРодитель(Дочерний, СтруктураУзла, Служебный = Ложь) Экспорт
	СтруктураУзла.Вставить("Старший", Дочерний.Старший);
	СтруктураУзла.Вставить("Родитель", Дочерний.Родитель);
	СтруктураУзла.Вставить("Дочерний", Дочерний.Код);
	НовыйУзел = НовыйУзел(СтруктураУзла, Служебный);
	СтаршийУзел = Старший(Дочерний);
	Если НЕ Дочерний(СтаршийУзел) = Неопределено Тогда
		Если СтаршийУзел.Дочерний = Дочерний.Код Тогда
			СтаршийУзел.Дочерний = НовыйУзел.Код;
		КонецЕсли;
	КонецЕсли;
	Если НЕ Соседний(СтаршийУзел) = Неопределено Тогда
		Если СтаршийУзел.Соседний = Дочерний.Код Тогда
			СтаршийУзел.Соседний = НовыйУзел.Код;
		КонецЕсли;
	КонецЕсли;
	СоседнийУзел = Соседний(Дочерний);
	Если НЕ СоседнийУзел = Неопределено Тогда
		СоседнийУзел.Старший = НовыйУзел.Код;
		НовыйУзел.Вставить("Соседний", СоседнийУзел.Код);
	КонецЕсли;
	Дочерний.Вставить("Соседний", Неопределено);
	Дочерний.Вставить("Старший", НовыйУзел.Код);
	Дочерний.Вставить("Родитель", НовыйУзел.Код);
	Возврат НовыйУзел;
КонецФункции // НовыйРодитель()

Функция УдалитьРодителя(Дочерний) Экспорт
	РодительУзел = Родитель(Дочерний);
	СтаршийУзел = Старший(РодительУзел);
	Если УзелСвойство(СтаршийУзел, "Дочерний") = РодительУзел.Код Тогда
		СтаршийУзел.Дочерний = Дочерний.Код;
	КонецЕсли;
	Если УзелСвойство(СтаршийУзел, "Соседний") = РодительУзел.Код Тогда
		СтаршийУзел.Соседний = Дочерний.Код;
	КонецЕсли;
	Дочерний.Вставить("Старший", РодительУзел.Старший);
	Дочерний.Вставить("Родитель", РодительУзел.Родитель);
	СоседнийУзел = Дочерний;
	Пока НЕ УзелСвойство(СоседнийУзел, "Соседний") = Неопределено Цикл
		СоседнийУзел = Соседний(СоседнийУзел);
	КонецЦикла;
	СоседнийУзелРодитель = Соседний(РодительУзел);
	Если НЕ СоседнийУзелРодитель = Неопределено Тогда
		СоседнийУзел.Вставить("Соседний", СоседнийУзелРодитель.Код);
		СоседнийУзелРодитель.Старший = СоседнийУзел.Код;
	КонецЕсли;
КонецФункции // УдалитьРодителя()

Функция НовыйДочерний(Старший, СтруктураУзла, Служебный = Ложь) Экспорт
	СтруктураУзла.Вставить("Старший", Старший.Код);
	УзелСоседний = Дочерний(Старший);
	Если НЕ УзелСоседний = Неопределено Тогда
		СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
	КонецЕсли;
	НовыйУзел = НовыйУзел(СтруктураУзла, Служебный);
	Старший.Вставить("Дочерний", НовыйУзел.Код);
	Если НЕ УзелСоседний = Неопределено Тогда
		УзелСоседний.Вставить("Старший", НовыйУзел.Код);
	КонецЕсли;
	Возврат НовыйУзел;
КонецФункции // НовыйДочерний()

Функция НовыйСоседний(Старший, СтруктураУзла, Служебный = Ложь) Экспорт
	СтруктураУзла.Вставить("Старший", Старший.Код);
	УзелСоседний = Соседний(Старший);
	Если НЕ УзелСоседний = Неопределено Тогда
		СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
	КонецЕсли;
	НовыйУзел = НовыйУзел(СтруктураУзла, Служебный);
	Старший.Вставить("Соседний", НовыйУзел.Код);
	Если НЕ УзелСоседний = Неопределено Тогда
		УзелСоседний.Вставить("Старший", НовыйУзел.Код);
	КонецЕсли;
	Возврат НовыйУзел;
КонецФункции // НовыйСоседний()

Функция НовыйАтрибут(Старший, СтруктураУзла, Служебный = Ложь) Экспорт
	СтруктураУзла.Вставить("Старший", Старший.Код);
	УзелСоседний = Атрибут(Старший);
	Если НЕ УзелСоседний = Неопределено Тогда
		СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
	КонецЕсли;
	НовыйУзел = НовыйУзел(СтруктураУзла, Служебный);
	Старший.Вставить("Атрибут", НовыйУзел.Код);
	Если НЕ УзелСоседний = Неопределено Тогда
		УзелСоседний.Вставить("Старший", НовыйУзел.Код);
	КонецЕсли;
	Возврат НовыйУзел;
КонецФункции // НовыйАтрибут()

Функция УдалитьУзел(Узел, Совсем = Истина, НачальныйУзел = Истина) Экспорт

	УзелСоседний = Соседний(Узел);

	Если НачальныйУзел Тогда
		УзелСтарший = Старший(Узел);
		Если НЕ УзелСвойство(УзелСтарший, "Атрибут") = Неопределено Тогда
			Если УзелСтарший.Атрибут = Узел.Код Тогда
				Если УзелСоседний = Неопределено Тогда
					//УзелСтарший.Удалить("Атрибут");
					УзелСтарший.Атрибут = Неопределено;
				Иначе
					УзелСтарший.Атрибут = УзелСоседний.Код;
					УзелСоседний.Старший = УзелСтарший.Код;
				КонецЕсли
			КонецЕсли;
		КонецЕсли;
		Если НЕ УзелСвойство(УзелСтарший, "Дочерний") = Неопределено Тогда
			Если УзелСтарший.Дочерний = Узел.Код Тогда
				Если УзелСоседний = Неопределено Тогда
					//УзелСтарший.Удалить("Дочерний");
					УзелСтарший.Дочерний = Неопределено;
				Иначе
					УзелСтарший.Дочерний = УзелСоседний.Код;
					УзелСоседний.Старший = УзелСтарший.Код;
				КонецЕсли
			КонецЕсли;
		КонецЕсли;
		Если НЕ УзелСвойство(УзелСтарший, "Соседний") = Неопределено Тогда
			Если УзелСтарший.Соседний = Узел.Код Тогда
				Если УзелСоседний = Неопределено Тогда
					//УзелСтарший.Удалить("Соседний");
					УзелСтарший.Соседний = Неопределено;
				Иначе
					УзелСтарший.Соседний = УзелСоседний.Код;
					УзелСоседний.Старший = УзелСтарший.Код;
				КонецЕсли
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если НЕ УзелСоседний = Неопределено Тогда
			УдалитьУзел(УзелСоседний, Совсем, Ложь);
		КонецЕсли;
	КонецЕсли;

	Узлы.Удалить(Узел.Код);
	Если НЕ Лев(Узел.Код, 1) = "s" Тогда
		Данные.ЗаменитьСтроку(Узел.Код, "");
	КонецЕсли;

	Если Совсем Тогда
		Если НЕ УзелСвойство(Узел, "Атрибут") = Неопределено Тогда
			УдалитьУзел(Атрибут(Узел), Совсем, Ложь);
		КонецЕсли;
		Если НЕ УзелСвойство(Узел, "Дочерний") = Неопределено Тогда
			УдалитьУзел(Дочерний(Узел), Совсем, Ложь);
		КонецЕсли;
		ОсвободитьОбъект(Узел);
	КонецЕсли;

КонецФункции // УдалитьУзел(Узел)

Функция КопироватьУзел(Узел, Буфер, ПервыйВызов = Истина) Экспорт

	Буфер.Вставить(Узел.Код, Узел);

	Если НЕ УзелСвойство(Узел, "Атрибут") = Неопределено Тогда
		КопироватьУзел(Атрибут(Узел), Буфер, Ложь);
	КонецЕсли;

	Если НЕ УзелСвойство(Узел, "Дочерний") = Неопределено Тогда
		КопироватьУзел(Дочерний(Узел), Буфер, Ложь);
	КонецЕсли;

	Если НЕ ПервыйВызов Тогда
		Если НЕ УзелСвойство(Узел, "Соседний") = Неопределено Тогда
			КопироватьУзел(Соседний(Узел), Буфер, Ложь);
		КонецЕсли;
	КонецЕсли;

КонецФункции // КопироватьУзел()

Функция ВставитьУзел(Буфер, КодУзла, ЭтоАтрибут = Ложь, ПервыйВызов = Истина, Служебный = Ложь) Экспорт

	Узел = НовыйУзел(Буфер.Получить(КодУзла), Служебный);
	Узел.Вставить("Родитель", Неопределено);

	Если НЕ ЭтоАтрибут Тогда

		Если НЕ УзелСвойство(Узел, "Атрибут") = Неопределено Тогда
			УзелАтрибут = ВставитьУзел(Буфер, Узел.Атрибут, , Ложь, Служебный);
			УзелАтрибут.Старший = Узел.Код;
			Узел.Атрибут = УзелАтрибут.Код;
		КонецЕсли;

		Если НЕ УзелСвойство(Узел, "Дочерний") = Неопределено Тогда
			УзелДочерний = ВставитьУзел(Буфер, Узел.Дочерний, , Ложь, Служебный);
			УзелДочерний.Старший = Узел.Код;
			Узел.Дочерний = УзелДочерний.Код;
		КонецЕсли;

		Если ПервыйВызов Тогда
			Узел.Вставить("Соседний", Неопределено);
		Иначе
			Если НЕ УзелСвойство(Узел, "Соседний") = Неопределено Тогда
				УзелСоседний = ВставитьУзел(Буфер, Узел.Соседний, , Ложь, Служебный);
				УзелСоседний.Старший = Узел.Код;
				Узел.Соседний = УзелСоседний.Код;
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

	Возврат Узел;

КонецФункции // ВставитьУзел()

Функция НайтиСоседний(Знач Узел, ИмяУзла) Экспорт
	Пока НЕ Узел = Неопределено Цикл
		Если Узел.Имя = ИмяУзла Тогда
			Прервать;
		КонецЕсли;
		Узел = Соседний(Узел);
	КонецЦикла;
	Возврат Узел;
КонецФункции // НайтиСоседний()

Функция НайтиАтрибут(Знач Узел, ИмяАтрибута) Экспорт
	Пока НЕ Узел = Неопределено Цикл
		Если Узел.Имя = ИмяАтрибута Тогда
			Возврат Узел.Значение;
		КонецЕсли;
		Узел = Соседний(Узел);
	КонецЦикла;
	Возврат Неопределено;
КонецФункции // НайтиАтрибут()

Функция Соседний(Знач Узел) Экспорт
	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		ВызватьИсключение "Неверный узел";
	КонецЕсли;
	Узел = УзелСвойство(Узел, "Соседний");
	Если НЕ Узел = Неопределено Тогда
		Если ТипЗнч(Узел) = Тип("Строка") Тогда
			Узел = ПолучитьУзел(Узел);
		КонецЕсли;
	КонецЕсли;
	Возврат Узел;
КонецФункции // Соседний()

Функция Дочерний(Знач Узел) Экспорт
	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		ВызватьИсключение "Неверный узел";
	КонецЕсли;
	Узел = УзелСвойство(Узел, "Дочерний");
	Если НЕ Узел = Неопределено Тогда
		Узел = ПолучитьУзел(Узел);
	КонецЕсли;
	Возврат Узел;
КонецФункции // Дочерний()

Функция Старший(Знач Узел) Экспорт
	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		ВызватьИсключение "Неверный узел";
	КонецЕсли;
	Узел = УзелСвойство(Узел, "Старший");
	Если НЕ Узел = Неопределено Тогда
		Узел = ПолучитьУзел(Узел);
	КонецЕсли;
	Возврат Узел;
КонецФункции // Старший()

Функция Родитель(Знач Узел, НайтиРодителя = Истина) Экспорт
	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		ВызватьИсключение "Неверный узел";
	КонецЕсли;
	Если НЕ НайтиРодителя Тогда
		Если НЕ УзелСвойство(Узел, "Родитель") = Неопределено Тогда
			УзелРодитель = ПолучитьУзел(Узел.Родитель);
			Если НЕ УзелРодитель = Неопределено Тогда
				Возврат УзелРодитель;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	УзелКод = Узел.Код;
	СтаршийУзел = Старший(Узел);
	Пока НЕ СтаршийУзел = Неопределено Цикл
		Если НЕ УзелСвойство(СтаршийУзел, "Атрибут") = Неопределено Тогда
			Если СтаршийУзел.Атрибут = УзелКод Тогда
				Узел.Вставить("Родитель", СтаршийУзел.Код);
				Возврат СтаршийУзел;
			КонецЕсли;
		КонецЕсли;
		Если НЕ УзелСвойство(СтаршийУзел, "Дочерний") = Неопределено Тогда
			Если СтаршийУзел.Дочерний = УзелКод Тогда
				Узел.Вставить("Родитель", СтаршийУзел.Код);
				Возврат СтаршийУзел;
			КонецЕсли;
		КонецЕсли;
		УзелКод = СтаршийУзел.Код;
		СтаршийУзел = Старший(СтаршийУзел);
	КонецЦикла;
	//ВызватьИсключение "Родитель узла " + Узел.Код + " не найден";
	Возврат Неопределено;
КонецФункции // Родитель()

Функция Атрибут(Знач Узел) Экспорт
	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		ВызватьИсключение "Неверный узел";
	КонецЕсли;
	Узел = УзелСвойство(Узел, "Атрибут");
	Если НЕ Узел = Неопределено Тогда
		Узел = ПолучитьУзел(Узел);
	КонецЕсли;
	Возврат Узел;
КонецФункции // Атрибут()

Функция СохранитьДанные(ИмяФайлаДанных) Экспорт
	Для каждого элУзел Из Узлы Цикл
		Если НЕ элУзел.Значение = Неопределено И НЕ Лев(элУзел.Ключ, 1) = "s" Тогда
			Данные.ЗаменитьСтроку(ЭлУзел.Ключ, СтруктуруВСтроку(элУзел.Значение));
		КонецЕсли;
	КонецЦикла;
	Данные.Записать(ИмяФайлаДанных);
КонецФункции // СохранитьДанные()


Функция ПрочитатьВетку(Знач Узел)
	Если НЕ Узел = Неопределено Тогда
		ПолучитьУзел(Узел.Код);
		ПрочитатьВетку(Атрибут(Узел));
		ПрочитатьВетку(Дочерний(Узел));
		ПрочитатьВетку(Соседний(Узел));
	КонецЕсли;
КонецФункции

Функция ПроверитьДанные()
	ПрочитатьВетку(Дочерний(Корень));
	Для нСтр = 1 По Данные.КоличествоСтрок() Цикл
		Если Узлы.Получить(Строка(нСтр)) = Неопределено Тогда
			Стр = Данные.ПолучитьСтроку(нСтр);
			Если НЕ Стр = "" Тогда
				Сообщить("Забытая строка " + нСтр);
				Данные.ЗаменитьСтроку(нСтр, "");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецФункции


Функция ПриСозданииОбъекта(обПроцесс, ИмяФайлаДанных = Неопределено)
	Процесс = обПроцесс;
	Количество = 0;
	Пустой = Новый Структура;
	Данные = Новый ТекстовыйДокумент;
	Если НЕ ИмяФайлаДанных = Неопределено Тогда
		Сообщить(ИмяФайлаДанных);
		Данные.Прочитать(ИмяФайлаДанных);
		Количество = Данные.КоличествоСтрок();
	КонецЕсли;
	Библиотеки = Новый Соответствие;
	Узлы = Новый Соответствие;
	УзлыОбновить = Новый Соответствие;
	Корень = ПолучитьУзел("1");
	Обновить = Ложь;
	Изменены = Ложь;
	ПроверитьДанные();
	Интерпретировать(Корень);
	Если Фронт = Неопределено Тогда
		Сообщить("Фронт не найден");
		Фронт = Корень;
	КонецЕсли;
КонецФункции
