Перем procid;
Перем Шаблон;
Перем Буфер;
Перем БуферУзел;
Перем События, ИдСобытия;
Перем Хост, Порт;
Перем Вкладки, ИдВкладки, ТекущаяВкладка;
Перем УзлыПоказать;


Функция СтрЭкранироватьСкрипт(Знач Стр)
	Стр = СтрЗаменить(Стр, """", "\""");
	Стр = СтрЗаменить(Стр, "'", "\'");
	Стр = СтрЗаменить(Стр, "<", "\<");
	Стр = СтрЗаменить(Стр, ">", "\>");
	Возврат Стр;
КонецФункции


Функция СтрЭкранироватьРазметку(Знач Стр)
	Стр = СтрЗаменить(Стр, "&", "&amp;");
	Стр = СтрЗаменить(Стр, """", "&quot;");
	Стр = СтрЗаменить(Стр, "'", "&#39;");
	Стр = СтрЗаменить(Стр, "<", "&lt;");
	Стр = СтрЗаменить(Стр, ">", "&gt;");
	Стр = СтрЗаменить(Стр, Символы.ПС, "<br/>");
	Возврат Стр;
КонецФункции


Функция ПоказатьПанель()
	Текст = "";
	ПараметрСкролл = 0;
	ПараметрыШаблона = Новый Структура;
	ПараметрыШаблона.Вставить("ПараметрИдПроцесса", procid);
	Для каждого элВкладка Из Вкладки Цикл
		Вкладка = элВкладка.Значение;
		ПараметрыШаблона.Вставить("ПараметрВкладка", элВкладка.Ключ);
		ПараметрыШаблона.Вставить("ПараметрКоманда", "tabselect");
		ПараметрыШаблона.Вставить("ПараметрЗаголовок", Вкладка.Заголовок);
		ПараметрыШаблона.Вставить("ПараметрАктивный", ?(элВкладка.Ключ = ТекущаяВкладка, "active", ""));
		Текст = Текст + Шаблон.ПолучитьОбласть("ОбластьВкладка", ПараметрыШаблона);
		Если элВкладка.Ключ = ТекущаяВкладка Тогда
			ПараметрыШаблона.Вставить("ПараметрКоманда", "tabclose");
			ПараметрыШаблона.Вставить("ПараметрЗаголовок", "✕");
			Текст = Текст + Шаблон.ПолучитьОбласть("ОбластьВкладка", ПараметрыШаблона);
			ПараметрСкролл = Вкладка.Скролл;
		КонецЕсли;
	КонецЦикла;
	ПараметрыШаблона.Вставить("ПараметрВкладка", "newtab");
	ПараметрыШаблона.Вставить("ПараметрКоманда", "newtab");
	ПараметрыШаблона.Вставить("ПараметрЗаголовок", "➕");
	ПараметрыШаблона.Вставить("ПараметрАктивный", "");
	Текст = Текст + Шаблон.ПолучитьОбласть("ОбластьВкладка", ПараметрыШаблона);
	Текст = Шаблон.ПолучитьОбласть("ОбластьПанель", Новый Структура("ПараметрВкладки, ПараметрСкролл", Текст, ПараметрСкролл));
	Возврат Текст;
КонецФункции // ПоказатьПанель()


Функция НоваяВкладка()
	УзлыПоказать = Новый Соответствие;
	Данные = Новый pagedata("slate.txt", Шаблон);
	ИдВкладки = ИдВкладки + 1;
	ТекущаяВкладка = "" + ИдВкладки;
	структВкладка = Новый Структура("ИдВкладки, Данные, Режим, ИдУзла, Заголовок, ОбновитьУзел, Скролл", ТекущаяВкладка, Данные, "view", "2", "newpage", Истина, 0);
	Вкладки.Вставить(ТекущаяВкладка, структВкладка);
	Возврат структВкладка;
КонецФункции


Функция НачальнаяСтраница()
	Текст = Шаблон.ПолучитьОбласть("ОбластьШапка", Новый Структура("ПараметрИдПроцесса", procid));
	Текст = Текст + Шаблон.ПолучитьОбласть("ОбластьПодвал");
	Вкладки = Новый Соответствие;
	Возврат Текст;
КонецФункции


Функция СтрокуВСтруктуру(Стр)
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
	Для каждого Элемент Из Структ Цикл
		Результат = Результат + ?(Результат = "", "", Символы.Таб) + Элемент.Ключ + Символы.Таб + Элемент.Значение;
	КонецЦикла;
	Возврат Результат;
КонецФункции


Функция ПоказатьУзел(Узел, ЭтоАтрибут = Ложь, Атрибуты = "", Дочерний = "") Экспорт

	Представление = "" + УзелСостояние(Узел, "Вид");

	Если НЕ Представление = "" Тогда
		Возврат Представление;
	КонецЕсли;

	Если ЭтоАтрибут Тогда

		АтрибутИмя = Узел.Имя;
		АтрибутИмя = СтрЗаменить(АтрибутИмя, "xml_lang", "xml:lang");
		АтрибутИмя = СтрЗаменить(АтрибутИмя, "_", "-");
		АтрибутЗначение = Узел.Значение;
		Представление = Представление + " " + АтрибутИмя + "=""" + АтрибутЗначение + """";

	Иначе

		Если Узел.Имя = "#text" Тогда
			Если Узел.Свойство("Значение") Тогда
				Представление = Представление + Узел.Значение;
			Иначе
				Представление = "";
			КонецЕсли;
		ИначеЕсли Узел.Имя = "#comment" Тогда
			Если Узел.Свойство("Значение") Тогда
				Представление = Представление + "<!-- " + Узел.Значение + " -->";
			КонецЕсли;
		Иначе
			Если Узел.Имя = "div" Тогда
				Атрибуты = " id=""" + Узел.Код + """" + Атрибуты;
			КонецЕсли;
			Представление = Представление + "<" + Узел.Имя + Атрибуты + ">" + Дочерний;
			Если Узел.Свойство("Значение") Тогда
				Представление = Представление + Узел.Значение;
			КонецЕсли;
			Представление = Представление + "</" + Узел.Имя + ">";
		КонецЕсли;

	КонецЕсли;

	УзелСостояниеЗначение(Узел, "Вид", Представление);

	Возврат Представление;

КонецФункции // ПоказатьУзел()


Функция ПоказатьСтруктуруУзла(Узел, ЭтоАтрибут = Ложь, Атрибуты = "", Дочерний = "") Экспорт

	Представление = "" + УзелСостояние(Узел, "Структура");

	Если НЕ Представление = "" Тогда
		Возврат Представление;
	КонецЕсли;

	УзелОткрыт = УзелСостояние(Узел, "УзелОткрыт");
	Если УзелОткрыт = Неопределено Тогда
		УзелОткрыт = Ложь;
	КонецЕсли;

	УзелИмя = Узел.Имя;

	УзелЗначение = "";
	Если Узел.Свойство("Значение") Тогда
		УзелЗначение = Узел.Значение;
	КонецЕсли;

	УзелРедактируется = УзелСостояние(Узел, "УзелРедактируется");
	АтрибутРедактируется = УзелСостояние(Узел, "АтрибутРедактируется");
	РедактироватьЗначение = УзелСостояние(Узел, "РедактироватьЗначение");
	РедактироватьИмя = УзелСостояние(Узел, "РедактироватьИмя");
	УзелПросмотр = УзелСостояние(Узел, "УзелПросмотр");

	Если АтрибутРедактируется = Истина Тогда
		УзелРедактируется = Истина;
		ЭтоАтрибут = Истина;
	КонецЕсли;

	Если этоАтрибут = Истина Тогда
		УзелИмя = СтрЗаменить(УзелИмя, "xml_lang", "xml:lang");
		УзелИмя = СтрЗаменить(УзелИмя, "_", "-");
	КонецЕсли;

	КнопкаУзел = "";

	Если НЕ УзелСвойство(Узел, "Дочерний") = Неопределено Тогда
		ПараметрыШаблона = Новый Структура;
		ПараметрыШаблона.Вставить("ПараметрИдУзла", Узел.Код);
		ПараметрыШаблона.Вставить("ПараметрИдПроцесса", procid);
		ПараметрыШаблона.Вставить("ПараметрКоманда", ?(УзелОткрыт, "nodeclose", "nodeopen"));
		ПараметрыШаблона.Вставить("ПараметрНадписьНаКнопке", ?(УзелОткрыт, "⚪" , "⚫"));
		КнопкаУзел = Шаблон.ПолучитьОбласть("ОбластьКнопкаУзел", ПараметрыШаблона);
	КонецЕсли;

	КнопкиИнструменты = "";
	ПараметрМенюИнструменты = "";

	Если УзелРедактируется = Истина Тогда

		ПараметрыШаблона = Новый Структура;
		ПараметрыШаблона.Вставить("ПараметрИдУзла", Узел.Код);
		ПараметрыШаблона.Вставить("ПараметрНеактивно", "");
		ПараметрыШаблона.Вставить("ПараметрИдПроцесса", procid);
		ПараметрыШаблона.Вставить("ПараметрВидимость", "");
		ПараметрыШаблона.Вставить("ПараметрРежим", "design");

		Если НЕ этоАтрибут = Истина Тогда
			ПараметрыШаблона.Вставить("ПараметрКоманда", ?(УзелПросмотр = Истина, "nopreview", "preview"));
			ПараметрыШаблона.Вставить("ПараметрПодсказка", ?(УзелПросмотр = Истина, "Скрыть", "Показать"));
			ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);

			ПараметрыШаблона.Вставить("ПараметрКоманда", "attradd");
			ПараметрыШаблона.Вставить("ПараметрПодсказка", "Новый атрибут");
			ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);

			ПараметрыШаблона.Вставить("ПараметрКоманда", "childadd");
			ПараметрыШаблона.Вставить("ПараметрПодсказка", "Новый дочерний");
			ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);
		КонецЕсли;

		ПараметрыШаблона.Вставить("ПараметрКоманда", "nextadd");
		ПараметрыШаблона.Вставить("ПараметрПодсказка", "Новый соседний");
		ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);

		ПараметрыШаблона.Вставить("ПараметрКоманда", "nodecut");
		ПараметрыШаблона.Вставить("ПараметрПодсказка", "Вырезать узел");
		ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);

		ПараметрыШаблона.Вставить("ПараметрКоманда", "nodecopy");
		ПараметрыШаблона.Вставить("ПараметрПодсказка", "Копировать узел");
		ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);

		Если НЕ этоАтрибут = Истина Тогда
			ПараметрыШаблона.Вставить("ПараметрКоманда", "nodepasteattr");
			ПараметрыШаблона.Вставить("ПараметрПодсказка", "Вставить атрибут");
			ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);

			ПараметрыШаблона.Вставить("ПараметрКоманда", "nodepastechild");
			ПараметрыШаблона.Вставить("ПараметрПодсказка", "Вставить дочерний");
			ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);
		КонецЕсли;

		ПараметрыШаблона.Вставить("ПараметрКоманда", "nodepastenext");
		ПараметрыШаблона.Вставить("ПараметрПодсказка", "Вставить соседний");
		ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);

		Если НЕ этоАтрибут = Истина Тогда
			ПараметрыШаблона.Вставить("ПараметрКоманда", "attremove");
			ПараметрыШаблона.Вставить("ПараметрПодсказка", "Удалить все атрибуты");
			ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);

			ПараметрыШаблона.Вставить("ПараметрКоманда", "childremove");
			ПараметрыШаблона.Вставить("ПараметрПодсказка", "Удалить все дочерние");
			ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);
		КонецЕсли;

		ПараметрыШаблона.Вставить("ПараметрКоманда", "noderemove");
		ПараметрыШаблона.Вставить("ПараметрПодсказка", "Удалить узел");
		ПараметрМенюИнструменты = ПараметрМенюИнструменты + Шаблон.ПолучитьОбласть("ОбластьМенюИнструменты", ПараметрыШаблона);

		ПараметрыШаблона = Новый Структура;
		ПараметрыШаблона.Вставить("ПараметрИдУзла", Узел.Код);
		ПараметрыШаблона.Вставить("ПараметрМенюИнструменты", ПараметрМенюИнструменты);
		КнопкиИнструменты = Шаблон.ПолучитьОбласть("ОбластьКнопкаИнструменты", ПараметрыШаблона);

	КонецЕсли;

	Если РедактироватьИмя = Истина Тогда

		ПараметрыШаблона = Новый Структура;
		ПараметрыШаблона.Вставить("ПараметрИдУзла", Узел.Код);
		ПараметрыШаблона.Вставить("ПараметрИдПроцесса", procid);
		ПараметрыШаблона.Вставить("ПараметрКоманда", "submitname");
		ПараметрыШаблона.Вставить("ПараметрИмяЗначение", СтрЭкранироватьСкрипт(УзелИмя));
		ПараметрИмя = Шаблон.ПолучитьОбласть("ОбластьИзменитьИмяЗначение", ПараметрыШаблона);

	Иначе

		ПараметрыШаблона = Новый Структура;
		ПараметрыШаблона.Вставить("ПараметрИдУзла", Узел.Код);
		ПараметрыШаблона.Вставить("ПараметрНеактивно", "");
		ПараметрыШаблона.Вставить("ПараметрИдПроцесса", procid);
		ПараметрыШаблона.Вставить("ПараметрКоманда", ?(УзелРедактируется = Истина, "namedit", ?(ЭтоАтрибут = Истина, "attredit", "nodedit")));
		ПараметрыШаблона.Вставить("ПараметрНадписьНаКнопке", СтрЭкранироватьРазметку(УзелИмя));
		ПараметрИмя = Шаблон.ПолучитьОбласть("ОбластьКнопкаИмяЗначение", ПараметрыШаблона);

	КонецЕсли;

	Если РедактироватьЗначение = Истина Тогда

		ПараметрыШаблона = Новый Структура;
		ПараметрыШаблона.Вставить("ПараметрИдУзла", Узел.Код);
		ПараметрыШаблона.Вставить("ПараметрИдПроцесса", procid);
		ПараметрыШаблона.Вставить("ПараметрКоманда", "submitvalue");
		ПараметрыШаблона.Вставить("ПараметрИмяЗначение", СтрЭкранироватьСкрипт(УзелЗначение));
		ПараметрЗначение = Шаблон.ПолучитьОбласть("ОбластьИзменитьИмяЗначение", ПараметрыШаблона);

	ИначеЕсли НЕ УзелЗначение = "" ИЛИ (УзелРедактируется = Истина) Тогда

		ПараметрыШаблона = Новый Структура;
		ПараметрыШаблона.Вставить("ПараметрИдУзла", Узел.Код);
		ПараметрыШаблона.Вставить("ПараметрНеактивно", ?(УзелРедактируется = Истина, "", "disabled"));
		ПараметрыШаблона.Вставить("ПараметрИдПроцесса", procid);
		ПараметрыШаблона.Вставить("ПараметрКоманда", "valuedit");
		ПараметрыШаблона.Вставить("ПараметрНадписьНаКнопке", СтрЭкранироватьРазметку(УзелЗначение));
		ПараметрЗначение = Шаблон.ПолучитьОбласть("ОбластьКнопкаИмяЗначение", ПараметрыШаблона);

	КонецЕсли;

	ПараметрыШаблона = Новый Структура;
	ПараметрыШаблона.Вставить("ПараметрИдУзла", Узел.Код);
	ПараметрыШаблона.Вставить("ПараметрИнструменты", КнопкиИнструменты);
	ПараметрыШаблона.Вставить("ПараметрИмя", ПараметрИмя);
	ПараметрыШаблона.Вставить("ПараметрЗначение", ПараметрЗначение);
	ПараметрИмяУзла = КнопкаУзел + Шаблон.ПолучитьОбласть("ОбластьИмяЗначение", ПараметрыШаблона);

	Если НЕ ЭтоАтрибут Тогда

		ПараметрЗаголовокУзла = ПараметрИмяУзла + Атрибуты;

		ПараметрДочернийУзел = Дочерний;

		ПараметрыШаблона = Новый Структура;
		ПараметрыШаблона.Вставить("ПараметрИдУзла", Узел.Код);
		ПараметрыШаблона.Вставить("ПараметрЗаголовокУзла", ПараметрЗаголовокУзла);
		ПараметрыШаблона.Вставить("ПараметрДочернийУзел", ПараметрДочернийУзел);
		Представление = Шаблон.ПолучитьОбласть("ОбластьУзел", ПараметрыШаблона);

	Иначе

		Представление = ПараметрИмяУзла;

	КонецЕсли;

	УзелСостояниеЗначение(Узел, "Структура", Представление);

	Возврат Представление;

КонецФункции


Функция ОтобразитьDOM(Вкладка, КодУзла, Знач ОбновитьУзел = Ложь, Знач ТипУзла = "", НачальныйУзел = Ложь)

	Данные = Вкладка.Данные;

	Узел = Данные.ПолучитьУзел(КодУзла);
	Если Узел = Неопределено Тогда
		Возврат "Узел " + КодУзла + " не найден!";
	КонецЕсли;

	Если НЕ ОбновитьУзел Тогда
		Если НЕ УзелСостояние(Узел, "ОбновитьУзел") = Ложь Тогда
			ОбновитьУзел = Истина;
			НачальныйУзел = Истина;
		КонецЕсли;
	КонецЕсли;

	Представление = "";

	Если ОбновитьУзел Тогда

		УзелСостояниеЗначение(Узел, "ОбновитьУзел", Ложь);

		Атрибуты = "";
		УзелАтрибут = УзелСвойство(Узел, "Атрибут");
		Если НЕ УзелАтрибут = Неопределено Тогда
			Атрибуты = ОтобразитьDOM(Вкладка, УзелАтрибут, ОбновитьУзел, "Атрибут");
		КонецЕсли;

		Дочерний = "";
		Если НЕ Вкладка.Режим = "design" ИЛИ УзелСостояние(Узел, "УзелОткрыт") = Истина  Тогда
			УзелДочерний = УзелСвойство(Узел, "Дочерний");
			Если НЕ УзелДочерний = Неопределено Тогда
				Дочерний = ОтобразитьDOM(Вкладка, УзелДочерний, ОбновитьУзел, "Дочерний");
			КонецЕсли;
		КонецЕсли;

		Если Вкладка.Режим = "design" Тогда
			Представление = ПоказатьСтруктуруУзла(Узел, (ТипУзла = "Атрибут"), Атрибуты, Дочерний);
		Иначе
			Представление = ПоказатьУзел(Узел, (ТипУзла = "Атрибут"), Атрибуты, Дочерний);
		КонецЕсли;

		Если НЕ НачальныйУзел Тогда
			УзелСоседний = УзелСвойство(Узел, "Соседний");
			Если НЕ УзелСоседний = Неопределено Тогда
				Соседний = ОтобразитьDOM(Вкладка, УзелСоседний, ОбновитьУзел, ТипУзла);
				Представление = Представление + Соседний;
			КонецЕсли;
		КонецЕсли;

	ИначеЕсли УзелСостояние(Узел, "ОбновитьПодчиненный") = Истина Тогда

		УзелАтрибут = УзелСвойство(Узел, "Атрибут");
		Если НЕ УзелАтрибут = Неопределено Тогда
			Представление = ОтобразитьDOM(Вкладка, УзелАтрибут, , "Атрибут");
		КонецЕсли;

		Если Представление = "" Тогда
			Если НЕ Вкладка.Режим = "design" ИЛИ УзелСостояние(Узел, "УзелОткрыт") = Истина Тогда
				УзелДочерний = УзелСвойство(Узел, "Дочерний");
				Если НЕ УзелДочерний = Неопределено Тогда
					Представление = ОтобразитьDOM(Вкладка, УзелДочерний, , "Дочерний");
				КонецЕсли;
			КонецЕсли;

			Если Представление = "" Тогда
				УзелСоседний = УзелСвойство(Узел, "Соседний");
				Если НЕ УзелСоседний = Неопределено Тогда
					Представление = ОтобразитьDOM(Вкладка, УзелСоседний, , ТипУзла);
				КонецЕсли;

				Если Представление = "" Тогда
					УзелСостояниеЗначение(Узел, "ОбновитьПодчиненный", Ложь);
				КонецЕсли;

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат Представление;

КонецФункции // ОтобразитьDOM()


Функция ОбработатьКоманду(структЗадача) Экспорт

	Запрос = структЗадача.Запрос;

	ДействиеИмя = УзелСвойство(Запрос, "cmd");

	Если НЕ ДействиеИмя = Неопределено Тогда

		Если ДействиеИмя 		= "domupdate"	Тогда ДействиеИмя = "ОбновитьDOM"
		ИначеЕсли ДействиеИмя 	= "nodeopen"	Тогда ДействиеИмя = "ОткрытьУзел"
		ИначеЕсли ДействиеИмя	= "nodeclose"	Тогда ДействиеИмя = "ЗакрытьУзел"
		ИначеЕсли ДействиеИмя	= "nodedit"		Тогда ДействиеИмя = "РедактироватьУзел"
		ИначеЕсли ДействиеИмя	= "attredit"	Тогда ДействиеИмя = "РедактироватьАтрибут"
		ИначеЕсли ДействиеИмя	= "preview"		Тогда ДействиеИмя = "УзелПросмотр"
		ИначеЕсли ДействиеИмя	= "nopreview"	Тогда ДействиеИмя = "СкрытьУзел"
		ИначеЕсли ДействиеИмя	= "nodereload"	Тогда ДействиеИмя = "ОбновитьУзел"
		ИначеЕсли ДействиеИмя	= "newtab"		Тогда ДействиеИмя = "НоваяВкладка"
		ИначеЕсли ДействиеИмя	= "tabselect"	Тогда ДействиеИмя = "ВыбратьВкладку"
		ИначеЕсли ДействиеИмя	= "tabclose"	Тогда ДействиеИмя = "ЗакрытьВкладку"
		ИначеЕсли ДействиеИмя	= "valuedit"	Тогда ДействиеИмя = "РедактироватьЗначение"
		ИначеЕсли ДействиеИмя	= "submitvalue"	Тогда ДействиеИмя = "НовоеЗначениеУзла"
		ИначеЕсли ДействиеИмя	= "submitname"	Тогда ДействиеИмя = "НовоеИмяУзла"
		ИначеЕсли ДействиеИмя	= "namedit"		Тогда ДействиеИмя = "РедактироватьИмя"
		ИначеЕсли ДействиеИмя	= "attradd"		Тогда ДействиеИмя = "НовыйАтрибут"
		ИначеЕсли ДействиеИмя	= "childadd"	Тогда ДействиеИмя = "НовыйДочерний"
		КонецЕсли;

		структЗадача.Действие = Новый Структура("Имя, Результат", ДействиеИмя);
		Возврат "ВыполнитьДействия";

	Иначе
		Возврат "СформироватьОтвет";
	КонецЕсли;

КонецФункции // ОбработатьКоманду()


Функция ЗапросВыполнитьЗадачу(структЗадача)

	Если структЗадача.Этап = "ВыполнитьЗадачу" Тогда

		Если Вкладки = Неопределено Тогда
			структЗадача.Результат = НачальнаяСтраница();
			структЗадача.Этап = "ЕстьРезультат";
			Возврат Истина;
		КонецЕсли;

		структЗадача.Этап = ОбработатьКоманду(структЗадача);

	КонецЕсли;

	Если структЗадача.Этап = "ВыполнитьДействия" Тогда
		Если ВыполнитьДействия(структЗадача) = Истина Тогда
			структЗадача.Этап = "СформироватьОтвет";
		КонецЕсли;
	КонецЕсли;

	Если структЗадача.Этап = "СформироватьОтвет" Тогда
		Вкладка = Вкладки.Получить(ТекущаяВкладка);
		Если НЕ Вкладка = Неопределено Тогда
			Ответ = "";
			Режим = Вкладка.Режим;
			Ответ = ОтобразитьDOM(Вкладка, Вкладка.ИдУзла, Вкладка.ОбновитьУзел);
			Вкладка.Вставить("ОбновитьУзел", Ложь);
			Если НЕ Ответ = "" Тогда
				структЗадача.Результат = Ответ;
				структЗадача.Этап = "ЕстьРезультат";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если структЗадача.Этап = "ЕстьРезультат" Тогда
		Соединение = Неопределено;
		Если ПередатьСтроку(Соединение, "<!--" + структЗадача.Запрос.taskid + "-->" + структЗадача.Результат + "<!--end-->") Тогда
			Если НЕ Соединение = Неопределено Тогда
				Соединение.Закрыть();
				структЗадача.Этап = "УдалитьЗадачу";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецФункции // ЗапросВыполнитьЗадачу()


Функция УзелСвойство(Узел, Свойство) Экспорт
	УзелСвойство = Неопределено;
	Если НЕ Узел = Неопределено Тогда
		Узел.Свойство(Свойство, УзелСвойство);
	КонецЕсли;
	Возврат УзелСвойство;
КонецФункции // УзелСвойство(Узел)


Функция УзелСвойствоЗначение(Узел, СвойствоИмя, СвойствоЗначение) Экспорт
	Если НЕ Узел = Неопределено Тогда
		Узел.Вставить(СвойствоИмя, СвойствоЗначение);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции // УзелСвойствоЗначение(Узел)


Функция УзелСостояние(Узел, СостояниеИмя = Неопределено) Экспорт
	УзелСостояние = Неопределено;
	Если НЕ Узел = Неопределено Тогда
		Узел.Свойство("Состояние", УзелСостояние);
		Если НЕ УзелСостояние = Неопределено Тогда
			Если НЕ СостояниеИмя = Неопределено Тогда
				УзелСостояние.Свойство(СостояниеИмя, УзелСостояние);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат УзелСостояние;
КонецФункции // УзелСостояние(Узел)


Функция УзелСостояниеЗначение(Узел, СостояниеИмя, СостояниеЗначение, Событие = Истина) Экспорт
	Если НЕ Узел = Неопределено Тогда
		Если УзелСвойство(Узел, "Состояние") = Неопределено Тогда
			Узел.Вставить("Состояние", Новый Структура());
		КонецЕсли;
		Узел.Состояние.Вставить(СостояниеИмя, СостояниеЗначение);
		// Если Событие Тогда
		// 	Сообщить(Узел.Код + " " + СостояниеИмя + "=" + Лев(СостояниеЗначение,30));
		// 	НовоеСобытие(Новый Структура("Имя, Узел, СостояниеИмя", "ОбновитьСостояние", Узел, СостояниеИмя));
		// КонецЕсли;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции // УзелСостояниеЗначение(Узел)


Функция НовоеСобытие(СтруктураСобытия)
	ИдСобытия = ИдСобытия + 1;
	Событие = Новый Структура(СтруктураСобытия);
	События.Вставить(ИдСобытия, Событие);
	Возврат Событие;
КонецФункции // НовоеСобытие()


Функция ОбработатьСобытия(Данные)
	Для каждого элСобытие Из События Цикл
		Событие = элСобытие.Значение;
		Если Событие.Имя = "ОбновитьСостояние" Тогда
			// Если Запрос.mode = "lisp" Тогда
			// 	Попытка
			// 		Значение = Данные.Интерпретировать(Данные.Окружение, Узел);
			// 	Исключение
			// 		Значение = ОписаниеОшибки();
			// 	КонецПопытки;
			// 	Узел.Вставить("Значение", Значение);
			// КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
КонецФункции // ОбработатьСобытия()


Функция ОбновитьСостояние(Данные, Узел, Состояние, Значение)

	Если Узел = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

	Результат = Истина;

	Если Состояние = "УзелПросмотр" И Значение = Истина Тогда
		Результат = ОбновитьСостояние(Данные, Узел, "УзелОткрыт", Истина);

	ИначеЕсли Состояние = "УзелПросмотр" И Значение = Ложь Тогда

	ИначеЕсли Состояние = "НовоеЗначениеУзла" Тогда
		ОбновитьСостояние(Данные, Узел, "РедактироватьЗначение", Ложь);
		УзелСвойствоЗначение(Узел, "Значение", Значение);

	ИначеЕсли Состояние = "НовоеИмяУзла" Тогда
		ОбновитьСостояние(Данные, Узел, "РедактироватьИмя", Ложь);
		УзелСвойствоЗначение(Узел, "Имя", Значение);

	ИначеЕсли Состояние = "ОбновитьПодчиненный" ИЛИ Состояние = "ОбновитьУзел" Тогда
		ОбновитьСостояние(Данные, Данные.Старший(Узел), "ОбновитьПодчиненный", Истина);

	КонецЕсли;

	Если НЕ Результат = Ложь Тогда
		УзелСостояниеЗначение(Узел, Состояние, Значение);
		Если НЕ Состояние = "ОбновитьПодчиненный" Тогда
			Если НЕ Состояние = "ОбновитьУзел" Тогда
				ОбновитьСостояние(Данные, Узел, "ОбновитьУзел", Истина);
			КонецЕсли;
		КонецЕсли;
		Узел.Состояние.Вставить("Структура", "");
		Узел.Состояние.Вставить("Вид", "");
	КонецЕсли;

	Возврат Результат;

КонецФункции // ОбновитьСостояние()


Функция ВыполнитьДействия(структЗадача)
	Перем Вкладка;

	Действие = УзелСвойство(структЗадача, "Действие");
	Если НЕ Действие = Неопределено Тогда

		Запрос = структЗадача.Запрос;
		tab =  УзелСвойство(Запрос, "tab");

		Если tab = Неопределено Тогда
			tab = ТекущаяВкладка;
		КонецЕсли;

		Если НЕ ТекущаяВкладка = Неопределено Тогда
			Вкладка = Вкладки.Получить(ТекущаяВкладка);
			Если Вкладка = Неопределено Тогда
				Возврат Ложь;
			КонецЕсли;
			scrolled =  УзелСвойство(Запрос, "scrolled");
			Если НЕ scrolled = Неопределено Тогда
				Вкладка.Вставить("Скролл", scrolled);
			КонецЕсли;
		КонецЕсли;

		Если Действие.Имя = "НоваяВкладка" Тогда
			Вкладка = НоваяВкладка();
			структЗадача.Результат = ПоказатьПанель();
			структЗадача.Этап = "ЕстьРезультат";
			Возврат Ложь;
		ИначеЕсли Действие.Имя = "ВыбратьВкладку" Тогда
			ТекущаяВкладка = tab;
			Вкладка = Вкладки.Получить(ТекущаяВкладка);
			Вкладка.Вставить("ОбновитьУзел", Истина);
			структЗадача.Результат = ПоказатьПанель();
			структЗадача.Этап = "ЕстьРезультат";
			Возврат Ложь;
		ИначеЕсли Действие.Имя = "ЗакрытьВкладку" Тогда
			Вкладка = Неопределено;
			Вкладка1 = Неопределено;
			Для каждого элВкладка Из Вкладки Цикл
				Вкладка1 = Вкладка;
				Вкладка = элВкладка.Ключ;
				Если ТекущаяВкладка = Вкладка1 Тогда
					Вкладка1 = Вкладка;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Вкладка = Вкладка1;
			Вкладки.Удалить(ТекущаяВкладка);
			Если НЕ Вкладка = Неопределено Тогда
				Вкладка = Вкладки.Получить(Вкладка);
			КонецЕсли;
			Если Вкладка = Неопределено Тогда
				Вкладка = НоваяВкладка();
			КонецЕсли;
			Вкладка.Вставить("ОбновитьУзел", Истина);
			ТекущаяВкладка = Вкладка.ИдВкладки;
			структЗадача.Результат = ПоказатьПанель();
			структЗадача.Этап = "ЕстьРезультат";
			Возврат Ложь;
		КонецЕсли;

		Данные = Вкладка.Данные;
		Если Данные = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;

		Узел = Данные.ПолучитьУзел(УзелСвойство(структЗадача.Запрос, "nodeid"));

		Если Действие.Имя = "ОткрытьУзел" Тогда
			Возврат ОбновитьСостояние(Данные, Узел, "УзелОткрыт", Истина);

		ИначеЕсли Действие.Имя = "ЗакрытьУзел" Тогда
			Возврат ОбновитьСостояние(Данные, Узел, "УзелОткрыт", Ложь);

		ИначеЕсли Действие.Имя = "РедактироватьУзел" Тогда
			Возврат ОбновитьСостояние(Данные, Узел, "УзелРедактируется", Истина);

		ИначеЕсли Действие.Имя = "РедактироватьАтрибут" Тогда
			Возврат ОбновитьСостояние(Данные, Узел, "АтрибутРедактируется", Истина);

		ИначеЕсли Действие.Имя = "РедактироватьЗначение" Тогда
			Возврат ОбновитьСостояние(Данные, Узел, "РедактироватьЗначение", Истина);

		ИначеЕсли Действие.Имя = "НовоеЗначениеУзла" Тогда
			Если Запрос.Свойство("valuedit") Тогда
				Возврат ОбновитьСостояние(Данные, Узел, "НовоеЗначениеУзла", Запрос.valuedit);
			Иначе
				Возврат ОбновитьСостояние(Данные, Узел, "РедактироватьЗначение", Ложь);
			КонецЕсли;

		ИначеЕсли Действие.Имя = "РедактироватьИмя" Тогда
			Возврат ОбновитьСостояние(Данные, Узел, "РедактироватьИмя", Истина);

		ИначеЕсли Действие.Имя = "НовоеИмяУзла" Тогда
			Если Запрос.Свойство("valuedit") Тогда
				Возврат ОбновитьСостояние(Данные, Узел, "НовоеИмяУзла", Запрос.valuedit);
			Иначе
				Возврат ОбновитьСостояние(Данные, Узел, "РедактироватьИмя", Ложь);
			КонецЕсли;

		ИначеЕсли Действие.Имя = "УзелПросмотр" Тогда
			Возврат ОбновитьСостояние(Данные, Узел, "УзелПросмотр", Истина);

		ИначеЕсли Действие.Имя = "СкрытьУзел" Тогда
			Возврат ОбновитьСостояние(Данные, Узел, "УзелПросмотр", Ложь);

		ИначеЕсли Действие.Имя = "НовыйАтрибут" Тогда
			СтруктураУзла = Новый Структура("Имя, Значение, Старший", "", "", Узел.Код);
			УзелСоседний = Данные.Атрибут(Узел);
			Если НЕ УзелСоседний = Неопределено Тогда
				СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
			КонецЕсли;
			НовыйУзел = Данные.НовыйУзел(СтруктураУзла);
			Узел.Вставить("Атрибут", НовыйУзел.Код);
			Если НЕ УзелСоседний = Неопределено Тогда
				УзелСоседний.Вставить("Старший", НовыйУзел.Код);
			КонецЕсли;
			ОбновитьСостояние(Данные, НовыйУзел, "УзелРедактируется", Истина);
			ОбновитьСостояние(Данные, НовыйУзел, "РедактироватьИмя", Истина);
			//ОбновитьСостояние(Данные, НовыйУзел, "РедактироватьЗначение", Истина);
			Возврат ОбновитьСостояние(Данные, Узел, "ОбновитьУзел", Истина);

		ИначеЕсли Действие.Имя = "НовыйДочерний" Тогда
			СтруктураУзла = Новый Структура("Имя, Значение, Старший", "", "", Узел.Код);
			УзелСоседний = Данные.Дочерний(Узел);
			Если НЕ УзелСоседний = Неопределено Тогда
				СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
			КонецЕсли;
			НовыйУзел = Данные.НовыйУзел(СтруктураУзла);
			Узел.Вставить("Дочерний", НовыйУзел.Код);
			Если НЕ УзелСоседний = Неопределено Тогда
				УзелСоседний.Вставить("Старший", НовыйУзел.Код);
			КонецЕсли;
			ОбновитьСостояние(Данные, НовыйУзел, "УзелРедактируется", Истина);
			ОбновитьСостояние(Данные, НовыйУзел, "РедактироватьИмя", Истина);
			//ОбновитьСостояние(Данные, НовыйУзел, "РедактироватьЗначение", Истина);
			ОбновитьСостояние(Данные, Узел, "УзелОткрыт", Истина);
			Возврат Истина;

		ИначеЕсли Действие.Имя = "nextadd" Тогда
			СтруктураУзла = Новый Структура("Имя, Значение, Старший", "", "", Узел.Код);
			УзелСоседний = Данные.Соседний(Узел);
			Если НЕ УзелСоседний = Неопределено Тогда
				СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
			КонецЕсли;
			НовыйУзел = Данные.НовыйУзел(СтруктураУзла);
			Узел.Вставить("Соседний", НовыйУзел.Код);
			Если НЕ УзелСоседний = Неопределено Тогда
				УзелСоседний.Вставить("Старший", НовыйУзел.Код);
			КонецЕсли;
			ОбновитьСостояние(Данные, НовыйУзел, "УзелРедактируется", Истина);
			ОбновитьСостояние(Данные, НовыйУзел, "РедактироватьИмя", Истина);
			//ОбновитьСостояние(Данные, НовыйУзел, "РедактироватьЗначение", Истина);
			ОбновитьСостояние(Данные, Узел, "ОбновитьУзел", Истина);
			Возврат ОбновитьСостояние(Данные, Данные.Родитель(Узел), "ОбновитьУзел", Истина);

		ИначеЕсли Действие.Имя = "noderemove" Тогда
			ДанныеРодительУзел = Данные.Родитель(Узел);
			Данные.УдалитьУзел(Узел);
			ОбновитьСостояние(Данные, ДанныеРодительУзел, "ОбновитьУзел", Истина);
			Возврат Истина;

		ИначеЕсли Действие.Имя = "nodecopy" Тогда
			Если НЕ Буфер = Неопределено Тогда
				ОсвободитьОбъект(Буфер);
			КонецЕсли;
			Буфер = Новый Соответствие;
			БуферУзел = Узел.Код;
			Данные.КопироватьУзел(Узел, Буфер);
			Возврат Истина;

		ИначеЕсли Действие.Имя = "nodecut" Тогда
			Если НЕ Буфер = Неопределено Тогда
				ОсвободитьОбъект(Буфер);
			КонецЕсли;
			Буфер = Новый Соответствие;
			БуферУзел = Узел.Код;
			Данные.КопироватьУзел(Узел, Буфер);
			ДанныеРодительУзел = Данные.Родитель(Узел);
			Данные.УдалитьУзел(Узел, Ложь);
			ОбновитьСостояние(Данные, ДанныеРодительУзел, "ОбновитьУзел", Истина);
			Возврат Истина;

		ИначеЕсли Действие.Имя = "nodepasteattr" Тогда
			Если НЕ Буфер = Неопределено Тогда
				НовыйУзел = Данные.ВставитьУзел(Буфер, БуферУзел, Истина);
				НовыйУзел.Вставить("Старший", Узел.Код);
				НовыйУзел.Вставить("Атрибут", Неопределено);
				НовыйУзел.Вставить("Дочерний", Неопределено);
				УзелАтрибут = Данные.Атрибут(Узел);
				Узел.Вставить("Атрибут", НовыйУзел.Код);
				Если НЕ УзелАтрибут = Неопределено Тогда
					НовыйУзел.Вставить("Соседний", УзелАтрибут.Код);
					УзелАтрибут.Вставить("Старший", НовыйУзел.Код);
				КонецЕсли;
			КонецЕсли;
			Возврат ОбновитьСостояние(Данные, Узел, "ОбновитьУзел", Истина);

		ИначеЕсли Действие.Имя = "nodepastechild" Тогда
			Если НЕ Буфер = Неопределено Тогда
				НовыйУзел = Данные.ВставитьУзел(Буфер, БуферУзел);
				НовыйУзел.Вставить("Старший", Узел.Код);
				УзелДочерний = Данные.Дочерний(Узел);
				Узел.Вставить("Дочерний", НовыйУзел.Код);
				Если НЕ УзелДочерний = Неопределено Тогда
					НовыйУзел.Вставить("Соседний", УзелДочерний.Код);
					УзелДочерний.Вставить("Старший", НовыйУзел.Код);
				КонецЕсли;
			КонецЕсли;
			Возврат ОбновитьСостояние(Данные, Узел, "ОбновитьУзел", Истина);

		ИначеЕсли Действие.Имя = "nodepastenext" Тогда
			Если НЕ Буфер = Неопределено Тогда
				НовыйУзел = Данные.ВставитьУзел(Буфер, БуферУзел);
				НовыйУзел.Вставить("Старший", Узел.Код);
				УзелСоседний = Данные.Соседний(Узел);
				Узел.Вставить("Соседний", НовыйУзел.Код);
				Если НЕ УзелСоседний = Неопределено Тогда
					НовыйУзел.Вставить("Соседний", УзелСоседний.Код);
					УзелСоседний.Вставить("Старший", НовыйУзел.Код);
				КонецЕсли;
			КонецЕсли;
			Возврат ОбновитьСостояние(Данные, Данные.Родитель(Узел), "ОбновитьУзел", Истина);

		ИначеЕсли Действие.Имя = "attremove" Тогда
			Если НЕ УзелСвойство(Узел, "Атрибут") = Неопределено Тогда
				Данные.УдалитьУзел(Данные.Атрибут(Узел), Ложь);
				//Узел.Удалить("Атрибут");
				Узел.Атрибут = Неопределено;
			КонецЕсли;
			Возврат ОбновитьСостояние(Данные, Узел, "ОбновитьУзел", Истина);

		ИначеЕсли Действие.Имя = "childremove" Тогда
			Если НЕ УзелСвойство(Узел, "Дочерний") = Неопределено Тогда
				Данные.УдалитьУзел(Данные.Дочерний(Узел), Ложь);
				//Узел.Удалить("Дочерний");
				Узел.Дочерний = Неопределено;
			КонецЕсли;
			Возврат ОбновитьСостояние(Данные, Узел, "ОбновитьУзел", Истина);

		ИначеЕсли Действие.Имя = "ОбновитьDOM" Тогда
			Возврат Истина;

		КонецЕсли;
	КонецЕсли;

	Возврат Ложь;
КонецФункции // ВыполнитьДействия()


Функция ПередатьСтроку(Соединение, СтрокаДанные)
	Попытка
		Соединение = Новый TCPСоединение(Хост, Порт);
		Соединение.ТаймаутОтправки = 100;
		Соединение.ОтправитьСтроку(СтрокаДанные);
		Возврат Истина;
	Исключение
		Соединение = Неопределено;
		Возврат Ложь;
	КонецПопытки;
КонецФункции // ПередатьСтроку()



Если АргументыКоманднойСтроки.Количество() Тогда
	procid = АргументыКоманднойСтроки[0];
Иначе
	procid = "1";
КонецЕсли;

Шаблон = ЗагрузитьСценарий(ОбъединитьПути(ТекущийКаталог(), "template.os"));
Шаблон.ЗагрузитьМакет("showdata");

//ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "dbaccess.os"), "dbaccess");
ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "pagedata.os"), "pagedata");

Буфер = Неопределено;

События = Новый Соответствие;
ИдСобытия = 0;
ИдВкладки = 0;

Таймаут = 10;
Хост = "127.0.0.1";
Порт = 8888;
Соединение = Неопределено;

Задачи = Новый Соответствие;

СтруктЗапрос = СтруктуруВСтроку(Новый Структура("procid", procid));
КоличествоПопыток = 100;

Попытка

	Пока Истина Цикл

		ПрерватьЦикл = Ложь;
		Пока Не ПрерватьЦикл Цикл
			ПрерватьЦикл = Истина;
			Для каждого элЗадача Из Задачи Цикл
				структЗадача = ЭлЗадача.Значение;
				Если структЗадача.Тип = "Запрос" Тогда
					ЗапросВыполнитьЗадачу(структЗадача);
				КонецЕсли;
				Если структЗадача.Этап = "УдалитьЗадачу" Тогда
					Задачи.Удалить(элЗадача.Ключ);
					ПрерватьЦикл = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;

		Если Соединение = Неопределено Тогда
			Если НЕ ПередатьСтроку(Соединение, СтруктЗапрос) Тогда
				КоличествоПопыток = КоличествоПопыток - 1;
				Если КоличествоПопыток = 0 Тогда
					Сообщить("Хост недоступен");
					Прервать;
				КонецЕсли;
				Продолжить;
			КонецЕсли;
			КоличествоПопыток = 100;
		Иначе
			Если НЕ Соединение.Активно Тогда
				Соединение = Неопределено;
				Продолжить;
			КонецЕсли;
		КонецЕсли;

		Попытка
			ЗадачиКоличество = Задачи.Количество();
			Если ЗадачиКоличество Тогда
				Соединение.ТаймаутЧтения = 100;
			КонецЕсли;
			Запрос = Соединение.ПрочитатьСтроку();
		Исключение
			//Сообщить("Осталось задач: " + ЗадачиКоличество);
			Продолжить;
		КонецПопытки;

		Попытка
			Запрос = СтрокуВСтруктуру(Запрос);
			структЗадача = Новый Структура("Тип, Этап, Запрос, Действие, Результат", "Запрос", "ВыполнитьЗадачу", Запрос);
		Исключение
			структЗадача = Новый Структура("Тип, Этап, Запрос, Результат", "Запрос", "ЕстьРезультат", Неопределено, "Неверный запрос");
		КонецПопытки;

		Задачи.Вставить(Запрос.taskid, структЗадача);

		Соединение.Закрыть();
		Соединение = Неопределено;

	КонецЦикла;

Исключение
	Сообщить(ОписаниеОшибки());
КонецПопытки;
