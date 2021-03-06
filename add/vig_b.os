// Шифрование и расшифровка методом Виженера (с улучшениями)
// Источник https://infostart.ru/public/518576/
// переделано для двоичных данных

//Функция ПолучитьМаксимальноеЗначениеВДанных
// - получает максимальное значение в данных :
Функция ПолучитьМаксимальноеЗначениеВДанных(Данные)

	Буфер = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(Данные);
	МаксимальноеЗначение = 0;

	Для Счетчик = 0 По Буфер.Размер - 1 Цикл

		ТекущееЗначение = Буфер.Получить(Счетчик);

		Если ТекущееЗначение > МаксимальноеЗначение Тогда

			МаксимальноеЗначение = ТекущееЗначение;

		КонецЕсли;

	КонецЦикла;

	Возврат МаксимальноеЗначение;

КонецФункции // ПолучитьМаксимальноеЗначениеВДанных(Данные)


//Функция ПолучитьКлючШифрования
// - получает по паролю ключ шифрования с учетом псевдо случайного смещения:
Функция ПолучитьКлючШифрования(ддПароль, РазмерКодируемыхДанных)

	бПароль = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ддПароль);
	бПароль_Размер	= бПароль.Размер;
	КлючШифрования	= Новый БуферДвоичныхДанных(РазмерКодируемыхДанных);

	ЧислоДляИнциализацииГенератораСлучаныхЧисел = ПолучитьМаксимальноеЗначениеВДанных(ддПароль);

	ЧислоДляИнциализацииГенератораСлучаныхЧисел = ЧислоДляИнциализацииГенератораСлучаныхЧисел + РазмерКодируемыхДанных;

	ГенераторСлучаныхЧисел = Новый ГенераторСлучайныхЧисел(ЧислоДляИнциализацииГенератораСлучаныхЧисел);

	СчетчикПоПаролю = Неопределено;

	Для Счетчик = 0 По РазмерКодируемыхДанных - 1 Цикл

		Если (СчетчикПоПаролю = Неопределено) ИЛИ (СчетчикПоПаролю > бПароль_Размер - 1) Тогда

			СчетчикПоПаролю = 0;

		КонецЕсли;

		СлучайноеСмещение = ГенераторСлучаныхЧисел.СлучайноеЧисло(1, ЧислоДляИнциализацииГенератораСлучаныхЧисел);

		ТекущееЗначение = бПароль.Получить(СчетчикПоПаролю);

		ЗакодированноеЗначение = ТекущееЗначение + СлучайноеСмещение;
		Пока ЗакодированноеЗначение > 255 Цикл
			ЗакодированноеЗначение = ЗакодированноеЗначение - 255;
		КонецЦикла;

		КлючШифрования.Установить(Счетчик, ЗакодированноеЗначение);

		СчетчикПоПаролю = СчетчикПоПаролю + 1;

	КонецЦикла;

	Возврат ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(КлючШифрования);

КонецФункции


//Функция ЗашифроватьСтроку
// - шифрует данные шифром Виженера по ключу шифрования с учетом псевдо случайного смещения:
Функция ЗашифроватьСтроку(КодируемыеДанные, КлючШифрования)

	бКодируемыеДанные = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(КодируемыеДанные);
	бКлючШифрования = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(КлючШифрования);

	РазмерКодируемыхДанных = бКодируемыеДанные.Размер;

	ЧислоДляИнциализацииГенератораСлучаныхЧисел = ПолучитьМаксимальноеЗначениеВДанных(КлючШифрования);

	ЧислоДляИнциализацииГенератораСлучаныхЧисел = ЧислоДляИнциализацииГенератораСлучаныхЧисел + РазмерКодируемыхДанных;

	ГенераторСлучаныхЧисел = Новый ГенераторСлучайныхЧисел(ЧислоДляИнциализацииГенератораСлучаныхЧисел);

	ЗакодированныеДанные = Новый БуферДвоичныхДанных(РазмерКодируемыхДанных);

	Для Счетчик = 0 ПО РазмерКодируемыхДанных - 1 Цикл

		ЗначениеИсходныхДанных 	= бКодируемыеДанные.Получить(Счетчик);
		ЗначениеКлюча = бКлючШифрования.Получить(Счетчик);
		СлучайнаяСоставляющая = ГенераторСлучаныхЧисел.СлучайноеЧисло(1, ЧислоДляИнциализацииГенератораСлучаныхЧисел);

		ЗакодированноеЗначение = ЗначениеИсходныхДанных + ЗначениеКлюча + СлучайнаяСоставляющая;
		Пока ЗакодированноеЗначение > 255 Цикл
			ЗакодированноеЗначение = ЗакодированноеЗначение - 256;
		КонецЦикла;
		ЗакодированныеДанные.Установить(Счетчик, ЗакодированноеЗначение);

	КонецЦикла;

	Возврат ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(ЗакодированныеДанные);

КонецФункции


//Функция РасшифроватьСтроку
// - расшифровывает данные по ключу шифрования с учетом псевдо случайного смещения:
Функция РасшифроватьСтроку(КодируемыеДанные, КлючШифрования)

	бКодируемыеДанные = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(КодируемыеДанные);
	бКлючШифрования = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(КлючШифрования);

	РазмерКодируемыхДанных = бКодируемыеДанные.Размер;

	ЧислоДляИнциализацииГенератораСлучаныхЧисел = ПолучитьМаксимальноеЗначениеВДанных(КлючШифрования);

	ЧислоДляИнциализацииГенератораСлучаныхЧисел = ЧислоДляИнциализацииГенератораСлучаныхЧисел + РазмерКодируемыхДанных;

	ГенераторСлучаныхЧисел = Новый ГенераторСлучайныхЧисел(ЧислоДляИнциализацииГенератораСлучаныхЧисел);

	ЗакодированныеДанные = Новый БуферДвоичныхДанных(РазмерКодируемыхДанных);

	Для Счетчик = 0 ПО РазмерКодируемыхДанных - 1 Цикл

		ЗначениеКлюча = бКлючШифрования.Получить(Счетчик);
		ЗакодированноеЗначение 	= бКодируемыеДанные.Получить(Счетчик);

		СлучайнаяСоставляющая = ГенераторСлучаныхЧисел.СлучайноеЧисло(1, ЧислоДляИнциализацииГенератораСлучаныхЧисел);

		ЗначениеИсходныхДанных = ЗакодированноеЗначение - ЗначениеКлюча - СлучайнаяСоставляющая;

		Пока ЗначениеИсходныхДанных < 0 Цикл
			ЗначениеИсходныхДанных = ЗначениеИсходныхДанных + 256;
		КонецЦикла;

		ЗакодированныеДанные.Установить(Счетчик, ЗначениеИсходныхДанных);

	КонецЦикла;

	Возврат ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(ЗакодированныеДанные);

КонецФункции

Строка = "Это секретная строка 123";
Пароль = "123фыва";

ддс = ПолучитьДвоичныеДанныеИзСтроки(Строка);
ддп = ПолучитьДвоичныеДанныеИзСтроки(Пароль);

Ключ = ПолучитьКлючШифрования(ддп, ддс.Размер());

зд = ЗашифроватьСтроку(ддс, Ключ);

рд = РасшифроватьСтроку(зд, Ключ);

Сообщить(ПолучитьСтрокуИзДвоичныхДанных(рд));
