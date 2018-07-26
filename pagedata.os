// Сделано на основе https://github.com/tsukanov-as/kojura

Перем Данные;
Перем КодУзла;
Перем Узлы Экспорт;
Перем Окружение Экспорт;
Перем Изменены Экспорт;
Перем Количество Экспорт;

Функция СтруктуруВСтроку(Структ)
	Если НЕ ТипЗнч(Структ) = Тип("Структура") Тогда
		Возврат Структ;
	КонецЕсли;
	Результат = "";
	Для каждого Элемент Из Структ Цикл
		Если НЕ ТипЗнч(Элемент.Значение) = Тип("Структура") И НЕ (Элемент.Значение = Неопределено) И НЕ (Элемент.Ключ = "Код") Тогда
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

Процедура ОткрытьОкружение(Окружение) Экспорт
	Окружение = Новый Структура("ВнешнееОкружение, Элементы", Окружение, Новый Соответствие);
КонецПроцедуры // ОткрытьОкружение()

Процедура ЗакрытьОкружение(Окружение) Экспорт
	Окружение = Окружение.ВнешнееОкружение;
КонецПроцедуры // ЗакрытьОкружение()

Функция ЭлементОкружения(Знач Окружение, Знач ИмяЭлемента) Экспорт
	Перем Элемент;
	Элемент = Окружение.Элементы[ИмяЭлемента];
	Пока Элемент = Неопределено И Окружение.ВнешнееОкружение <> Неопределено Цикл
		Окружение = Окружение.ВнешнееОкружение;
		Элемент = Окружение.Элементы[ИмяЭлемента];
	КонецЦикла;
	Если Элемент = Неопределено Тогда
		ВызватьИсключение СтрШаблон("Неизвестный объект %1", ИмяЭлемента);
	КонецЕсли;
	Возврат Элемент;
КонецФункции // ЭлементОкружения()

#КонецОбласти // Окружение

#Область Интерпретатор

Функция Сумма(Знач Окружение, Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Окружение, Аргумент);
	Аргумент = Соседний(Аргумент);
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение + Интерпретировать(Окружение, Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Сумма()

Функция Разность(Знач Окружение, Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Окружение, Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		Возврат -Значение;
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение - Интерпретировать(Окружение, Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Разность()

Функция Произведение(Знач Окружение, Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Окружение, Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение * Интерпретировать(Окружение, Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Произведение()

Функция Частное(Знач Окружение, Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Окружение, Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение / Интерпретировать(Окружение, Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Частное()

Функция Остаток(Знач Окружение, Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Окружение, Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение % Интерпретировать(Окружение, Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Остаток()

Функция ЗначениеФункции(Знач Окружение, Знач Параметр, Знач Аргумент)
	Перем Значения;
	ОткрытьОкружение(Окружение);
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
			Окружение.Элементы[Параметр.Значение] = Интерпретировать(Окружение, Аргумент);
			Параметр = Соседний(Параметр);
			Аргумент = Соседний(Аргумент);
		КонецЦикла;
	Иначе
		Окружение.Элементы[Параметр.Значение] = Интерпретировать(Окружение, Аргумент);
	КонецЕсли;
	Если Выражение.Имя = "Список" Тогда
		Выражение = Дочерний(Выражение);
		Пока Выражение <> Неопределено Цикл
			Значение = Интерпретировать(Окружение, Выражение);
			Выражение = Соседний(Выражение);
		КонецЦикла;
	Иначе
		Значение = Интерпретировать(Окружение, Выражение);
	КонецЕсли;
	ЗакрытьОкружение(Окружение);
	Возврат Значение;
КонецФункции // ЗначениеФункции()

Функция Лямбда(Знач Окружение, Знач Параметр)
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


Функция ЗначениеВыраженияЕсли(Знач Окружение, Знач Узел)
	Перем СписокЕсли, СписокТогда, СписокИначе;
	СписокЕсли = Узел;
	СписокТогда = Соседний(СписокЕсли);
	СписокИначе = Соседний(СписокТогда);
	Если Интерпретировать(Окружение, СписокЕсли) = Истина Тогда
		Возврат Интерпретировать(Окружение, СписокТогда)
	ИначеЕсли НЕ СписокИначе = Неопределено Тогда
		Возврат Интерпретировать(Окружение, СписокИначе)
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции // ЗначениеВыраженияЕсли()

Функция ЗначениеВыраженияВыбор(Знач Окружение, Знач Список)
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
		Если Интерпретировать(Окружение, СписокКогда) Тогда
			Возврат Интерпретировать(Окружение, СписокТогда);
		КонецЕсли;
		СписокКогда = Соседний(СписокТогда);
	КонецЦикла;
	ВызватьИсключение "Ни одно из условий не сработало!";
КонецФункции // ЗначениеВыраженияВыбор()

Функция Равно(Знач Окружение, Знач Аргумент)
	Перем Значение, Результат;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Интерпретировать(Окружение, Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Результат = Результат И Значение = Интерпретировать(Окружение, Аргумент);
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // Равно()

Функция Больше(Знач Окружение, Знач Аргумент)
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Интерпретировать(Окружение, Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Интерпретировать(Окружение, Аргумент);
		Результат = Результат И Значение1 > Значение2;
		Значение1 = Значение2;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // Больше()

Функция Меньше(Знач Окружение, Знач Аргумент)
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Интерпретировать(Окружение, Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Интерпретировать(Окружение, Аргумент);
		Результат = Результат И Значение1 < Значение2;
		Значение1 = Значение2;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // Меньше()

Функция БольшеИлиРавно(Знач Окружение, Знач Аргумент)
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Интерпретировать(Окружение, Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Интерпретировать(Окружение, Аргумент);
		Результат = Результат И Значение1 >= Значение2;
		Значение1 = Значение2;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // БольшеИлиРавно()

Функция МеньшеИлиРавно(Знач Окружение, Знач Аргумент)
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Интерпретировать(Окружение, Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Интерпретировать(Окружение, Аргумент);
		Результат = Результат И Значение1 <= Значение2;
		Значение1 = Значение2;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // МеньшеИлиРавно()

Функция НеРавно(Знач Окружение, Знач Аргумент)
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Интерпретировать(Окружение, Аргумент);
	Аргумент = Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Интерпретировать(Окружение, Аргумент);
		Результат = Результат И Значение1 <> Значение2;
		Значение1 = Значение2;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // НеРавно()

Функция ЛогическоеИ(Знач Окружение, Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение = Интерпретировать(Окружение, Аргумент);
		Результат = Результат И Значение;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // ЛогическоеИ()

Функция ЛогическоеИли(Знач Окружение, Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Ложь;
	Пока Аргумент <> Неопределено И Не Результат Цикл
		Значение = Интерпретировать(Окружение, Аргумент);
		Результат = Результат Или Значение;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // ЛогическоеИли()

Функция ЛогическоеНе(Знач Окружение, Знач Аргумент)
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение = Интерпретировать(Окружение, Аргумент);
		Результат = Результат И Не Значение;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // ЛогическоеНе()

Функция ВывестиСообщение(Знач Окружение, Знач Аргумент)
	Перем Значения;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значения = Новый Массив;
	Пока Аргумент <> Неопределено Цикл
		Значения.Добавить(Интерпретировать(Окружение, Аргумент));
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Сообщить(СтрСоединить(Значения, " "));
	Возврат Неопределено;
КонецФункции // ВывестиСообщение

Функция Интерпретировать(Знач Окружение, Знач Узел) Экспорт
	Сообщить(Узел.Код + " Узел:" + Символы.Таб + СтруктуруВСтроку(Узел));
	Значение = Интерпретировать1(Окружение, Узел);
	Если ТипЗнч(Значение) = Тип("Структура") Тогда
		Сообщить(Узел.Код + " Знач структ:" + Символы.Таб + СтруктуруВСтроку(Значение));
	Иначе
		Сообщить(Узел.Код + " Знач: " + Значение);
	КонецЕсли;
	Возврат Значение;
КонецФункции

Функция Интерпретировать1(Знач Окружение, Знач Узел) Экспорт
	Перем Имя, Значение, Лямбда;

	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		//Возврат Узел;
		ВызватьИсключение "Неверный узел: " + Узел;
	КонецЕсли;

	Имя = Узел.Имя;
	Значение = УзелСвойство(Узел, "Значение");

	Если Имя = "Объект" Тогда
		//Сообщить(Значение);
		Если Значение = "Пустой" Тогда
			Возврат (Интерпретировать(Окружение, Дочерний(Узел)) = Неопределено);
		ИначеЕсли Значение = "Первый" ИЛИ Значение = "Соседний" Тогда
			Элемент = Интерпретировать(Окружение, Дочерний(Узел));
			Если НЕ Элемент = Неопределено Тогда
				Если Значение = "Соседний" Тогда
					Элемент = Соседний(Элемент);
				КонецЕсли;
			КонецЕсли;
			Возврат Элемент;
		ИначеЕсли Значение = "Если" Тогда
			Возврат ЗначениеВыраженияЕсли(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "Выбор" Тогда
			Возврат ЗначениеВыраженияВыбор(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "Сообщить" Тогда
			Возврат ВывестиСообщение(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "+" Тогда
			Возврат Сумма(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "-" Тогда
			Возврат Разность(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "*" Тогда
			Возврат Произведение(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "/" Тогда
			Возврат Частное(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "%" Тогда
			Возврат Остаток(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "=" Тогда
			Возврат Равно(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = ">" Тогда
			Возврат Больше(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "<" Тогда
			Возврат Меньше(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = ">=" Тогда
			Возврат БольшеИлиРавно(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "<=" Тогда
			Возврат МеньшеИлиРавно(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "<>" Тогда
			Возврат НеРавно(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "И" Тогда
			Возврат ЛогическоеИ(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "ИЛИ" Тогда
			Возврат ЛогическоеИли(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "НЕ" Тогда
			Возврат ЛогическоеНе(Окружение, Дочерний(Узел));
		ИначеЕсли Значение = "Истина" Тогда
			Возврат Истина;
		ИначеЕсли Значение = "Ложь" Тогда
			Возврат Ложь;
		ИначеЕсли Значение = "Неопределено" Тогда
			Возврат Неопределено;
		Иначе
			ЭлементОкружения = ЭлементОкружения(Окружение, Значение);
			Если ТипЗнч(ЭлементОкружения) = Тип("Структура") Тогда
				Если ЭлементОкружения.Имя = "Функция" ИЛИ ЭлементОкружения.Имя = "Лямбда" Тогда
					Возврат ЗначениеФункции(Окружение, Дочерний(ЭлементОкружения), Дочерний(Узел));
				КонецЕсли;
				Возврат Интерпретировать(Окружение, ЭлементОкружения);
			КонецЕсли;
			Возврат ЭлементОкружения;
		КонецЕсли;
	ИначеЕсли Имя = "Пусть" Тогда
		Окружение.Элементы[Значение] = Дочерний(Узел);
		Возврат Неопределено;
	ИначеЕсли Имя = "Число" Тогда
		Возврат Число(Значение);
	ИначеЕсли Имя = "Строка" Тогда
		Возврат Значение;
	ИначеЕсли Имя = "Функция" Тогда
		Окружение.Элементы[Значение] = Узел;
		Возврат Неопределено;
	ИначеЕсли Имя = "Узел" Тогда
		Узел.Вставить("Окружение", Окружение);
		Возврат Дочерний(Узел);
	ИначеЕсли Имя = "Свойство" Тогда
		Возврат УзелСвойство(Интерпретировать(Окружение, Дочерний(Узел)), Значение);
	ИначеЕсли Имя = "Значение" Тогда
		Возврат Интерпретировать(Окружение, Дочерний(Узел));
	ИначеЕсли Имя = "Список" Тогда
		Возврат Дочерний(Узел);
	ИначеЕсли Имя = "Лямбда" Тогда
		Параметры = Дочерний(Узел);
		Аргументы = Лямбда(Окружение, Параметры);
		Возврат ЗначениеФункции(Окружение, Параметры, Аргументы);
	Иначе
		ВызватьИсключение("Неизвестный узел " + Имя);
	КонецЕсли;
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

Функция НовыйУзел(СтруктураУзла) Экспорт
	Данные.ДобавитьСтроку("");
	Количество = Данные.КоличествоСтрок();
	Узел = Новый Структура(СтруктураУзла);
	Узел.Вставить("Код", "" + Количество);
	Узел.Вставить("Состояние", Неопределено);
	Узлы.Вставить(Узел.Код, Узел);
	Возврат Узел;
КонецФункции // НовыйУзел(СтруктураУзла)

Функция НовыйДочерний(Старший, СтруктураУзла) Экспорт
	СтруктураУзла.Вставить("Старший", Старший.Код);
	УзелСоседний = Дочерний(Старший);
	Если НЕ УзелСоседний = Неопределено Тогда
		СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
	КонецЕсли;
	НовыйУзел = НовыйУзел(СтруктураУзла);
	Старший.Вставить("Дочерний", НовыйУзел.Код);
	Если НЕ УзелСоседний = Неопределено Тогда
		УзелСоседний.Вставить("Старший", НовыйУзел.Код);
	КонецЕсли;
	Возврат НовыйУзел;
КонецФункции // НовыйДочерний()

Функция НовыйСоседний(Старший, СтруктураУзла) Экспорт
	СтруктураУзла.Вставить("Старший", Старший.Код);
	УзелСоседний = Соседний(Старший);
	Если НЕ УзелСоседний = Неопределено Тогда
		СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
	КонецЕсли;
	НовыйУзел = НовыйУзел(СтруктураУзла);
	Старший.Вставить("Соседний", НовыйУзел.Код);
	Если НЕ УзелСоседний = Неопределено Тогда
		УзелСоседний.Вставить("Старший", НовыйУзел.Код);
	КонецЕсли;
	Возврат НовыйУзел;
КонецФункции // НовыйСоседний()

Функция НовыйАтрибут(Старший, СтруктураУзла) Экспорт
	СтруктураУзла.Вставить("Старший", Старший.Код);
	УзелСоседний = Атрибут(Старший);
	Если НЕ УзелСоседний = Неопределено Тогда
		СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
	КонецЕсли;
	НовыйУзел = НовыйУзел(СтруктураУзла);
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

	Если Совсем Тогда
		Если НЕ УзелСвойство(Узел, "Атрибут") = Неопределено Тогда
			УдалитьУзел(Атрибут(Узел), Совсем, Ложь);
		КонецЕсли;
		Если НЕ УзелСвойство(Узел, "Дочерний") = Неопределено Тогда
			УдалитьУзел(Дочерний(Узел), Совсем, Ложь);
		КонецЕсли;
		Узлы.Удалить(Узел.Код);
		Данные.ЗаменитьСтроку(Узел.Код, "");
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

Функция ВставитьУзел(Буфер, КодУзла, ЭтоАтрибут = Ложь, ПервыйВызов = Истина) Экспорт

	Узел = НовыйУзел(Буфер.Получить(КодУзла));

	Если НЕ ЭтоАтрибут Тогда

		Если НЕ УзелСвойство(Узел, "Атрибут") = Неопределено Тогда
			УзелАтрибут = ВставитьУзел(Буфер, Узел.Атрибут, , Ложь);
			УзелАтрибут.Старший = Узел.Код;
			Узел.Атрибут = УзелАтрибут.Код;
		КонецЕсли;

		Если НЕ УзелСвойство(Узел, "Дочерний") = Неопределено Тогда
			УзелДочерний = ВставитьУзел(Буфер, Узел.Дочерний, , Ложь);
			УзелДочерний.Старший = Узел.Код;
			Узел.Дочерний = УзелДочерний.Код;
		КонецЕсли;

		Если ПервыйВызов Тогда
			Узел.Вставить("Соседний", Неопределено);
		Иначе
			Если НЕ УзелСвойство(Узел, "Соседний") = Неопределено Тогда
				УзелСоседний = ВставитьУзел(Буфер, Узел.Соседний, , Ложь);
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
КонецФункции // Найти()

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

Функция Родитель(Знач Узел, НайтиРодителя = Ложь) Экспорт
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
		Если НЕ элУзел.Значение = Неопределено Тогда
			Данные.ЗаменитьСтроку(ЭлУзел.Ключ, СтруктуруВСтроку(элУзел.Значение));
		КонецЕсли;
	КонецЦикла;
	Данные.Записать(ИмяФайлаДанных);
КонецФункции // СохранитьДанные()

Функция ПриСозданииОбъекта(ИмяФайлаДанных = Неопределено)
	Количество = 0;
	Данные = Новый ТекстовыйДокумент;
	Если НЕ ИмяФайлаДанных = Неопределено Тогда
		Сообщить(ИмяФайлаДанных);
		Данные.Прочитать(ИмяФайлаДанных);
		Количество = Данные.КоличествоСтрок();
	КонецЕсли;
	Узлы = Новый Соответствие;
	ОткрытьОкружение(Окружение);
	Изменены = Ложь;
КонецФункции
