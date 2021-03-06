//// RSA для 1С
//﻿// Источник http://maintenance.kz/?q=node/9
//// адаптировал под OneScript vasvl123
//// функции работы с большими числами работают медленно и с ошибками(


Функция ЧислоВМассив(Знач Ч)
	Ч = Число(Ч);
	М = Новый Массив;
	М.Добавить(Ч);
	П = 0;
	Пока Ч > 999 Цикл
		Ч1 = Цел (Ч / 1000);
		М.Добавить(Ч1);
		М.Установить(П, Ч - Ч1 * 1000);
		П = П + 1;
		Ч = Ч1;
	КонецЦикла;
	Возврат М;
КонецФункции // ЧислоВМассив(Ч)

Функция МассивВЧисло(М)
	Ч = 0;
	П = М.Количество() - 1;
	Пока НЕ П < 0 И М.Получить(П) = 0 Цикл
		П = П - 1;
	КонецЦикла;
	Пока НЕ П < 0 Цикл
		Ч = Ч + М.Получить(П) * Pow(1000, П);
		П = П - 1;
	КонецЦикла;
	Возврат Ч;
КонецФункции // МассивВЧисло(М)

Функция ВычестьМ(М1, М2)

	М = Новый Массив;
	П1 = М1.Количество() - 1;
	П2 = М2.Количество() - 1;
	П = 0;
	О = 0;
	Пока П <= П2 ИЛИ П <= П1 Цикл
		З = -О;
		О = 0;
		Если П <= П1 Тогда
			З = З + М1.Получить(П);
		КонецЕсли;
		Если П <= П2 Тогда
			З = З - М2.Получить(П);
		КонецЕсли;
		Пока З < 0 Цикл
			З = З + 1000;
			О = О + 1;
		КонецЦикла;
		М.Добавить(З);
		П = П + 1;
	КонецЦикла;
	Если НЕ О = 0 Тогда
		М.Добавить(-О);
	КонецЕсли;
	Возврат М;

КонецФункции // ВычестьМ(М1, М2)

Функция СложитьМ(М1, М2)

	М = Новый Массив;
	П1 = М1.Количество() - 1;
	П2 = М2.Количество() - 1;
	П = 0;
	О = 0;
	Пока П <= П2 ИЛИ П <= П1 Цикл
		З = О;
		О = 0;
		Если П <= П1 Тогда
			З = З + М1.Получить(П);
		КонецЕсли;
		Если П <= П2 Тогда
			З = З + М2.Получить(П);
		КонецЕсли;
		Пока З > 999 Цикл
			З = З - 1000;
			О = О + 1;
		КонецЦикла;
		М.Добавить(З);
		П = П + 1;
	КонецЦикла;
	Если НЕ О = 0 Тогда
		М.Добавить(О);
	КонецЕсли;
	Возврат М;

КонецФункции // СложитьМ(М1, М2)

Функция УмножитьМ(М1, М2)

	М = Новый Массив;
	П1 = М1.Количество() - 1;
	П2 = М2.Количество() - 1;
	П11 = 0;
	П = - 1;
	Пока П11 <= П1 Цикл
		П22 = 0;
		О = 0;
		ЗП11 = М1.Получить(П11);
		Если НЕ ЗП11 = 0 Тогда
			Пока П22 <= П2 Цикл
				З = М2.Получить(П22);
				Если НЕ З = 0 ИЛИ НЕ О = 0 Тогда
					З = О + ЗП11 * З;
					О = Цел(З / 1000);
					З = З - О * 1000;
					Пока П11 + П22 > П Цикл
						М.Добавить(0);
						П = П + 1;
					КонецЦикла;
					З = М.Получить(П11 + П22) + З;
					Пока З > 999 Цикл
						З = З - 1000;
						О = О + 1;
					КонецЦикла;
					М.Установить(П11 + П22, З);
				КонецЕсли;
				П22 = П22 + 1;
			КонецЦикла;
			Если О > 0 Тогда
				Пока П11 + П22 > П Цикл
					М.Добавить(0);
					П = П + 1;
				КонецЦикла;
				М.Установить(П11 + П22, М.Получить(П11 + П22) + О);
			КонецЕсли;
		КонецЕсли;
		П11 = П11 + 1;
	КонецЦикла;

	Возврат М;

КонецФункции // УмножитьМ(М1, М2)

Функция РазделитьМ(Мас1, Мас2)

	КолМас1 = Мас1.Количество() - 1;
	КолМас2 = Мас2.Количество() - 1;

	МасЧаст = Новый Массив;

	// Копируем делимое в массив с остатком
	МасДелим = Новый Массив;
	КолМасДелим = КолМас1;
	Для П = 0 По КолМасДелим Цикл
		МасДелим.Добавить(Мас1.Получить(П));
		МасЧаст.Добавить(0);
	КонецЦикла;

	ПозДелит = КолМас2;
	ПозДелим = КолМасДелим;

	Пока НЕ ПозДелим < 0 И НЕ ПозДелим - ПозДелит < 0 Цикл

		// Получить делитель старшего разряда
		Ч = МасДелим.Получить(ПозДелим);

		З = Мас2.Получить(ПозДелит);

		Если НЕ Ч < З Тогда

			// Пересчитать остаток
			П = 0;
			Пока НЕ П > КолМас2 Цикл
				Если П > ПозДелим Тогда
					Прервать;
				КонецЕсли;
				Зн = МасДелим.Получить(ПозДелим - П) - Мас2.Получить(КолМас2 - П);
				Если Зн < 0 Тогда
					Зн = Зн + 1000;
					ЗнС = МасДелим.Получить(ПозДелим - П + 1) - 1;
					Если НЕ ЗнС < 0 Тогда
						МасДелим.Установить(ПозДелим - П + 1, ЗнС);
					Иначе
						Прервать;
					КонецЕсли;
				КонецЕсли;
				МасДелим.Установить(ПозДелим - П, Зн);
				П = П + 1;
			КонецЦикла;

			Если П > КолМас2 Тогда
				МасЧаст.Установить(ПозДелим - ПозДелит, МасЧаст.Получить(ПозДелим - ПозДелит) + 1);
			КонецЕсли;

		Иначе

			Если НЕ Ч = 0 Тогда
				Если ПозДелим > 0 Тогда
					МасДелим.Установить(ПозДелим - 1, МасДелим.Получить(ПозДелим - 1) + Ч * 1000);
					МасДелим.Установить(ПозДелим, МасДелим.Получить(ПозДелим) - Ч);
				КонецЕсли;
			КонецЕсли;

			ПозДелим = ПозДелим - 1;

		КонецЕсли;

	КонецЦикла;

	Возврат МасЧаст;

КонецФункции // РазделитьМ(М1, М2)

Функция СтепеньМ(ОснМ, Пок)
	ПокЦ = Число(Пок);
	Рез = ЧислоВМассив(1);
	ПокН = 1;
	РезТ = ОснМ;
	Пока ПокЦ > 0 Цикл
		ПокТ = ПокН;
		ПокН = ПокН + ПокН;
		Если НЕ ПокН > ПокЦ Тогда
			//РезТ = КвадратМ(РезТ);
			РезТ = УмножитьМ(РезТ, РезТ);
		Иначе
			ПокЦ = ПокЦ - ПокТ;
			Рез = УмножитьМ(Рез, РезТ);
			ПокН = 1;
			РезТ = ОснМ;
		КонецЕсли;
	КонецЦикла;
	Возврат Рез;
КонецФункции // СтепеньМ()

Функция СравнитьМ(Мас1, Мас2)
	КолМас1 = Мас1.Количество() - 1;
	КолМас2 = Мас2.Количество() - 1;

	Пока НЕ КолМас1 < 0 И Мас1.Получить(КолМас1) = 0 Цикл
		КолМас1 = КолМас1 - 1;
	КонецЦикла;

	Пока НЕ КолМас2 < 0 И Мас2.Получить(КолМас2) = 0 Цикл
		КолМас2 = КолМас2 - 1;
	КонецЦикла;

	Если КолМас1 < КолМас2 Тогда
		Возврат "Меньше";
	ИначеЕсли КолМас1 > КолМас2 Тогда
		Возврат "Больше";
	Иначе
		П = КолМас1;
		Пока НЕ П < 0 Цикл
			Зн1 = Мас1.Получить(П);
			Зн2 = Мас2.Получить(П);
			Если Зн1 < Зн2 Тогда
				Возврат "Меньше";
			ИначеЕсли Зн1 > Зн2 Тогда
				Возврат "Больше";
			КонецЕсли;
			П = П - 1;
		КонецЦикла;
		Возврат "Равно";
	КонецЕсли;

КонецФункции // СравнитьМ()

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
			Рез.Вставить(Ключ, знСтр);
			Ключ = Неопределено;
		КонецЕсли;
	КонецЦикла;
	Возврат Рез;
КонецФункции

Функция СтруктуруВСтроку(Структ)
	Результат = "";
	Если НЕ Структ = Неопределено Тогда
		Для каждого Элемент Из Структ Цикл
			Результат = ?(Результат = "", "", Результат + Символы.Таб) + Элемент.Ключ + Символы.Таб + Элемент.Значение;
		КонецЦикла;
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Функция проверяет является ли проверяемое число простым.
// Тест простоты (Перебор делителей).
// Параметры:
// 	- натуральное число.
// Возврат:
// 	- ИСТИНА - если число является простым.
Функция ТестПростоты(ЧислоДляПроверки)
	Индекс = 2;
	Признак = 0;
	Пока ((Индекс * Индекс) <= ЧислоДляПроверки) Цикл
		Если ЧислоДляПроверки%Индекс = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
		Если Индекс = 2 Тогда
			Индекс = 3;
		Иначе
			Индекс = Индекс + 2;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции

// Функция возвращает случайное простое число в заданном диапазоне.
// Параметры:
// 	- НижнийДиапазон - нижняя граница диапазона;
// 	- ВерхнийДиапазон - верхняя граница диапазона.
// Возврат:
// 	- случайное простое число.
Функция ПолучитьПростоеЧисло(НижнийДиапазон, ВерхнийДиапазон, НачальноеЗначение)
	ГСЧ = Новый ГенераторСлучайныхЧисел(НачальноеЗначение);
	ЕстьЧисло = Ложь;
	Пока Не ЕстьЧисло Цикл
		СлучайноеЧисло = ГСЧ.СлучайноеЧисло(НижнийДиапазон, ВерхнийДиапазон) * 6 - 1;
		ЕстьЧисло = ТестПростоты(СлучайноеЧисло);
		Если НЕ ЕстьЧисло Тогда
			ЕстьЧисло = ТестПростоты(СлучайноеЧисло + 2);
		КонецЕсли;
	КонецЦикла;
	НачальноеЗначение = ГСЧ.СлучайноеЧисло(НижнийДиапазон, ВерхнийДиапазон);
	Возврат СлучайноеЧисло;
КонецФункции

// Функция вычсляет взаимно простое число к заданному числу (Алгоритм Евклида).
// Параметры:
// 	- ЧислоОснова - число являющееся основой для поиска взаимно простых чисел.
// 	- ЧислоПоиска - число от которого начинается поиск взаимно простого числа.
// Возврат:
// 	- структура с взаимно простым числом и обратное число по модулю.
Функция ПолучитьВзаимноПростыеЧисла(ЧислоОснова, ЧислоПоиска)
	СтруктураВозврата = Новый Структура;

	Пока ЧислоПоиска < ЧислоОснова Цикл
		НаибольшийОбщийДелитель = 0;
		Делимое = ЧислоОснова;
		Делитель = ЧислоПоиска;
		Остаток = ЧислоПоиска;

		// Из соотношения Безу.
		АльфаМинус2 = 1;
		АльфаМинус1 = 0;

		ВитаМинус2 = 0;
		ВитаМинус1 = 1;

		Пока Остаток > 0 Цикл
			Частное = Делимое/Делитель;
			Остаток = Делимое - Делитель * Цел(Частное);

			Альфа = АльфаМинус2 - Цел(Частное) * АльфаМинус1;
			Вита = ВитаМинус2 - Цел(Частное) * ВитаМинус1;

			Если Остаток > 0 Тогда
				Делимое = Делитель;
				Делитель = Остаток;
			Иначе
				НаибольшийОбщийДелитель = Делитель;
			КонецЕсли;

			АльфаМинус2 = АльфаМинус1;
			АльфаМинус1 = Альфа;

			ВитаМинус2 = ВитаМинус1;
			ВитаМинус1 = Вита;
		КонецЦикла;

		Если НаибольшийОбщийДелитель = 1 И ВитаМинус2 > 0 Тогда //
			СтруктураВозврата.Вставить("НОД", ЧислоПоиска);
			СтруктураВозврата.Вставить("Вита", ВитаМинус2);

			Возврат СтруктураВозврата;
		КонецЕсли;

		ЧислоПоиска = ЧислоПоиска + 1;
	КонецЦикла;

	Возврат ПолучитьВзаимноПростыеЧисла(ЧислоОснова, Цел(ЧислоПоиска/2));

КонецФункции


// Функция формирует закрытый и открытый ключ.
// Возврат:
// 	- структура с набором ключей, открытый-(e, n) и закрытый-(d, n).
Функция СформироватьКлючи() Экспорт

	// Управление разрядностью ключа
	ВерхняяГраница = 6;
	НижняяГраница = 3;

	// p
	ЧастьПи = ПолучитьПростоеЧисло(НижняяГраница, ВерхняяГраница, 0);
	// q
	ЧастьКью = ЧастьПи;
	Пока ЧастьКью = ЧастьПи Цикл
		ЧастьКью = ПолучитьПростоеЧисло(НижняяГраница, ВерхняяГраница, 0);
	КонецЦикла;

	// n
	ЧастьЭн = ЧастьПи * ЧастьКью;


	// Вычисляем функцию Эйлера.
	ЗначениеЭйлера = (ЧастьПи - 1) * (ЧастьКью - 1);

	// Вычисляем случайное взаимно простое чисело.
	ГСЧ = Новый ГенераторСлучайныхЧисел(ЗначениеЭйлера);
	СлучайноеЧисло = ГСЧ.СлучайноеЧисло(1, ЗначениеЭйлера);

	// e, d
	СтруктураЗначений = ПолучитьВзаимноПростыеЧисла(ЗначениеЭйлера, СлучайноеЧисло);
	ЧастьЕ = СтруктураЗначений.НОД;
	ЧастьД = СтруктураЗначений.Вита;

	// Собираем готовые ключи
	СтруктураВозврата = Новый Структура;
	СтруктураКлюча = Новый Структура;
	СтруктураКлюча.Вставить("ЧастьЕ", ЧастьЕ);
	СтруктураКлюча.Вставить("ЧастьЭн", ЧастьЭн);
	СтруктураВозврата.Вставить("ОткрытыйКлюч", СтруктуруВСтроку(СтруктураКлюча));
	СтруктураКлюча = Новый Структура;
	СтруктураКлюча.Вставить("ЧастьЭн", ЧастьЭн);
	СтруктураКлюча.Вставить("ЧастьД", ЧастьД);
	СтруктураВозврата.Вставить("ЗакрытыйКлюч", СтруктуруВСтроку(СтруктураКлюча));

	Возврат СтруктураВозврата;

КонецФункции


// Функция шифрует текст с использованием открытого ключа.
// Параметры:
// 	- текст подлежащий шифрованию;
// 	- открытый ключ.
// Возврат:
// 	- шифротекст в виде строки чисел через ";".
Функция Шифрование(СтрокаСимволов, ОткрытыйКлюч) Экспорт
	СтрокаВозврата = "";
	СтруктураКлюча = СтрокуВСтруктуру(ОткрытыйКлюч);

	МассивСимволов = СтрРазделить(СтрокаСимволов, ";");
	Для Каждого Код ИЗ МассивСимволов Цикл
		Если НЕ Код = "" Тогда
			Степень = СтепеньМ(ЧислоВМассив(Код), СтруктураКлюча.ЧастьЕ);
			Шифрокод = МассивВЧисло(ВычестьМ(Степень, УмножитьМ(ЧислоВМассив(СтруктураКлюча.ЧастьЭн), РазделитьМ(Степень, ЧислоВМассив(СтруктураКлюча.ЧастьЭн)))));

			СтрокаВозврата = СтрокаВозврата + Шифрокод + ";"
		КонецЕсли;
	КонецЦикла;

	Возврат СтрокаВозврата;

КонецФункции


// Функция дешифрует текст с использованием закрытого ключа.
// Параметры:
// 	- шифротекст;
// 	- закрытый ключ.
// Возврат:
// 	- дешифрованный текст.
Функция Дешифрование(Шифротекст, ЗакрытыйКлюч) Экспорт
	СтрокаВозврата = "";
	СтруктураКлюча = СтрокуВСтруктуру(ЗакрытыйКлюч);

	СтрШифрокод = "";
	МассивКодов = СтрРазделить(Шифротекст, ";");
	Для Каждого Шифрокод ИЗ МассивКодов Цикл
		Если НЕ Шифрокод = "" Тогда
			Степень = СтепеньМ(ЧислоВМассив(Шифрокод), СтруктураКлюча.ЧастьД);
			Код = МассивВЧисло(ВычестьМ(Степень, УмножитьМ(ЧислоВМассив(СтруктураКлюча.ЧастьЭн), РазделитьМ(Степень, ЧислоВМассив(СтруктураКлюча.ЧастьЭн)))));

			СтрокаВозврата = СтрокаВозврата + Код + ";";
		КонецЕсли;
	КонецЦикла;

	Возврат СтрокаВозврата;

КонецФункции

Функция Закодировать(ШифруемыйТекст) Экспорт
	СтрокаВозврата = "";

	Для Индекс = 1 По СтрДлина(ШифруемыйТекст) Цикл
		Код = КодСимвола(ШифруемыйТекст, Индекс);
		СтрокаВозврата = СтрокаВозврата + Код + ";"
	КонецЦикла;

	Возврат СтрокаВозврата;

КонецФункции

Функция Раскодировать(СтрокаСимволов) Экспорт
	СтрокаВозврата = "";

	МассивСимволов = СтрРазделить(СтрокаСимволов, ";");
	Для Каждого Код ИЗ МассивСимволов Цикл
		Если НЕ Код = "" Тогда
			СтрокаВозврата = СтрокаВозврата + Символ(Код);
		КонецЕсли;
	КонецЦикла;

	Возврат СтрокаВозврата;

КонецФункции

Ключи1 = СформироватьКлючи();
Ключи2 = СформироватьКлючи();

Сообщить(Ключи1.ОткрытыйКлюч);
Сообщить(Ключи1.ЗакрытыйКлюч);

зн = Закодировать("abcd");

Сообщить(зн);
ш1 = Шифрование(зн, Ключи1.ОткрытыйКлюч);
Сообщить(ш1);

// ш2 = Шифрование(ш1, Ключи2.ОткрытыйКлюч);
// Сообщить(ш2);

// д2 = Дешифрование(ш2, Ключи2.ЗакрытыйКлюч);
// д1 = Дешифрование(д2, Ключи1.ЗакрытыйКлюч);

д1 = Дешифрование(ш1, Ключи1.ЗакрытыйКлюч);


зн1 = Раскодировать(д1);
Сообщить(зн1);
