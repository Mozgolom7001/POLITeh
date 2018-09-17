﻿Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Функция формирует табличный документ с печатной формой заказа или счета,
// разработанного методистами (без учета корректировок)
//
// Возвращаемое значение:
//  Табличный документ - сформированная печатная форма
//
Функция ПечатьСчетаЗаказа(Тип)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	Организация,
	|	Заказчик    КАК Заказчик,
	|	Организация КАК Руководители,
	|	Организация КАК Поставщик,
	|	Исполнитель КАК Исполнитель,
	|	ПодразделениеИсполнитель КАК ПодразделениеИсполнитель
	|ИЗ
	|	Документ.ВнутреннийЗаказ КАК ЗаказПокупателя
	|
	|ГДЕ
	|	ЗаказПокупателя.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВнутреннийЗаказ_СчетЗаказ";

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Номенклатура.Код КАК Код,
	|	ВложенныйЗапрос.Номенклатура.Артикул КАК Артикул,
	|	СУММА(ВложенныйЗапрос.Количество) КАК Количество,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры КАК Характеристика,
	|	NULL КАК Серия,
	|	МИНИМУМ(ВложенныйЗапрос.НомерСтроки) КАК НомерСтроки,
	|	ВложенныйЗапрос.НомерТЧ КАК НомерТЧ
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказПокупателя.Номенклатура КАК Номенклатура,
	|		ЗаказПокупателя.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ЗаказПокупателя.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		ЗаказПокупателя.Количество КАК Количество,
	|		1 КАК НомерТЧ,
	|		ЗаказПокупателя.НомерСтроки КАК НомерСтроки
	|	ИЗ
	|		Документ.ВнутреннийЗаказ.Товары КАК ЗаказПокупателя
	|	ГДЕ
	|		ЗаказПокупателя.Ссылка = &ТекущийДокумент
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗаказПокупателя.Номенклатура,
	|		ЗаказПокупателя.Номенклатура.ЕдиницаХраненияОстатков,
	|		NULL,
	|		ЗаказПокупателя.Количество,
	|		2,
	|		ЗаказПокупателя.НомерСтроки
	|	ИЗ
	|		Документ.ВнутреннийЗаказ.ВозвратнаяТара КАК ЗаказПокупателя
	|	ГДЕ
	|		ЗаказПокупателя.Ссылка = &ТекущийДокумент) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.ЕдиницаИзмерения,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	|	ВложенныйЗапрос.Номенклатура.Код,
	|	ВложенныйЗапрос.Номенклатура.Артикул,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление,
	|	ВложенныйЗапрос.НомерТЧ
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерТЧ,
	|	НомерСтроки";
	ЗапросТовары = Запрос.Выполнить().Выгрузить();

	Макет = ПолучитьМакет("СчетЗаказ");

	// Выводим шапку накладной
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Внутренний заказ");
	
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Заказчик");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ПредставлениеЗаказчика = ?(ЗначениеЗаполнено(Шапка.Заказчик), СокрЛП(Шапка.Заказчик.Наименование), "");
	ТабДокумент.Вывести(ОбластьМакета);

	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ВыводитьКоды = Истина;
		Колонка = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ВыводитьКоды = Истина;
		Колонка = "Код";
	Иначе
		ВыводитьКоды = Ложь;
	КонецЕсли;

	ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");

	ТабДокумент.Вывести(ОбластьНомера);
	Если ВыводитьКоды Тогда
		ОбластьКодов.Параметры.ИмяКолонкиКодов = Колонка;
		ТабДокумент.Присоединить(ОбластьКодов);
	КонецЕсли;
	ТабДокумент.Присоединить(ОбластьДанных);

	ОбластьКолонкаТовар = Макет.Область("Товар");
	Если Не ВыводитьКоды Тогда
		ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки + 
											Макет.Область("КолонкаКодов").ШиринаКолонки;
	КонецЕсли;

	ОбластьНомера = Макет.ПолучитьОбласть("Строка|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("Строка|Данные");

	Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 

		Если ВыборкаСтрокТовары.Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
			Сообщить("В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.", СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;

		ОбластьНомера.Параметры.НомерСтроки = ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1;
		ТабДокумент.Вывести(ОбластьНомера);

		Если ВыводитьКоды Тогда
			Если Колонка = "Артикул" Тогда
				ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТовары.Артикул;
			Иначе
				ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТовары.Код;
			КонецЕсли;
			ТабДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;

		ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТовары);
		ОбластьДанных.Параметры.Товар = ВыборкаСтрокТовары.Номенклатура.НаименованиеПолное + ФормированиеПечатныхФорм.ПредставлениеСерий(ВыборкаСтрокТовары);
		ТабДокумент.Присоединить(ОбластьДанных);

	КонецЦикла;

	// Вывести Итого
	ОбластьНомера = Макет.ПолучитьОбласть("Итого|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("Итого|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("Итого|Данные");

	ТабДокумент.Вывести(ОбластьНомера);
	Если ВыводитьКоды Тогда
		ТабДокумент.Присоединить(ОбластьКодов);
	КонецЕсли;
	ТабДокумент.Присоединить(ОбластьДанных);

	// Вывести Сумму прописью
	ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
	ОбластьМакета.Параметры.ИтоговаяСтрока ="Всего наименований " + ЗапросТовары.Количество();
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("ПодвалЗаказа");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ФИОИсполнитель = ОбщегоНазначения.ФамилияИнициалыФизЛица(Шапка.Исполнитель);
	ОбластьМакета.Параметры.ФИОИсполнителя = ПодразделениеИсполнитель.Наименование+?(ЗначениеЗаполнено(ПодразделениеИсполнитель) И ЗначениеЗаполнено(ФИОИсполнитель),"; ","")+ФИОИсполнитель;

	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;

КонецФункции // ПечатьСчетаЗаказаКорректировки()

// Функция формирует табличный документ с печатной формой заказа или счета,
// разработанного методистами (с учетом внесенных корректировок)
//
// Возвращаемое значение:
//  Табличный документ - сформированная печатная форма
//
Функция ПечатьСчетаЗаказаКорректировки(Тип)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	Организация,
	|	Заказчик    КАК Заказчик,
	|	Организация КАК Руководители,
	|	Организация КАК Поставщик,
	|	Исполнитель КАК Исполнитель,
	|	ПодразделениеИсполнитель КАК ПодразделениеИсполнитель
	|ИЗ
	|	Документ.ВнутреннийЗаказ КАК ЗаказПокупателя
	|
	|ГДЕ
	|	ЗаказПокупателя.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВнутреннийЗаказ_СчетЗаказ";

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Номенклатура.Код КАК Код,
	|	ВложенныйЗапрос.Номенклатура.Артикул КАК Артикул,
	|	СУММА(ВложенныйЗапрос.Количество) КАК Количество,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры КАК Характеристика,
	|	NULL КАК Серия,
	|	ВложенныйЗапрос.НомерТЧ,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КАК НаименованиеПолное
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказПокупателя.Номенклатура КАК Номенклатура,
	|		ЗаказПокупателя.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ЗаказПокупателя.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		ЗаказПокупателя.Количество КАК Количество,
	|		1 КАК НомерТЧ
	|	ИЗ
	|		Документ.ВнутреннийЗаказ.Товары КАК ЗаказПокупателя
	|	ГДЕ
	|		ЗаказПокупателя.Ссылка = &ТекущийДокумент
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗаказПокупателя.Номенклатура,
	|		ЗаказПокупателя.ЕдиницаИзмерения,
	|		ЗаказПокупателя.ХарактеристикаНоменклатуры,
	|		ЗаказПокупателя.Количество,
	|		1 КАК НомерТЧ
	|	ИЗ
	|		Документ.КорректировкаВнутреннегоЗаказа.Товары КАК ЗаказПокупателя
	|	ГДЕ
	|		ЗаказПокупателя.Ссылка.ВнутреннийЗаказ = &ТекущийДокумент
	|		И ЗаказПокупателя.Ссылка.Проведен
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗаказПокупателя.Номенклатура,
	|		ЗаказПокупателя.Номенклатура.ЕдиницаХраненияОстатков,
	|		NULL,
	|		ЗаказПокупателя.Количество,
	|		2 КАК НомерТЧ
	|	ИЗ
	|		Документ.ВнутреннийЗаказ.ВозвратнаяТара КАК ЗаказПокупателя
	|	ГДЕ
	|		ЗаказПокупателя.Ссылка = &ТекущийДокумент
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗаказПокупателя.Номенклатура,
	|		ЗаказПокупателя.Номенклатура.ЕдиницаХраненияОстатков,
	|		NULL,
	|		ЗаказПокупателя.Количество,
	|		2 КАК НомерТЧ
	|	ИЗ
	|		Документ.КорректировкаВнутреннегоЗаказа.ВозвратнаяТара КАК ЗаказПокупателя
	|	ГДЕ
	|		ЗаказПокупателя.Ссылка.ВнутреннийЗаказ = &ТекущийДокумент
	|		И ЗаказПокупателя.Ссылка.Проведен
	|) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.ЕдиницаИзмерения,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	|	ВложенныйЗапрос.НомерТЧ,
	|	ВложенныйЗапрос.Номенклатура.Код,
	|	ВложенныйЗапрос.Номенклатура.Артикул,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)),
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))";
	
	ЗапросТовары = Запрос.Выполнить().Выгрузить();

	Макет = ПолучитьМакет("СчетЗаказ");

	// Выводим шапку накладной
	СведенияОПоставщике = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата);
	Если Тип = "Счет" Тогда
		ОбластьМакета       = Макет.ПолучитьОбласть("ЗаголовокСчета");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЕсли; 

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Внутренний заказ");
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Заказчик");
	ОбластьМакета.Параметры.ПредставлениеЗаказчика = Шапка.Заказчик;
	ТабДокумент.Вывести(ОбластьМакета);

	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ВыводитьКоды = Истина;
		Колонка = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ВыводитьКоды = Истина;
		Колонка = "Код";
	Иначе
		ВыводитьКоды = Ложь;
	КонецЕсли;

	ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");

	ТабДокумент.Вывести(ОбластьНомера);
	Если ВыводитьКоды Тогда
		ОбластьКодов.Параметры.ИмяКолонкиКодов = Колонка;
		ТабДокумент.Присоединить(ОбластьКодов);
	КонецЕсли;
	ТабДокумент.Присоединить(ОбластьДанных);

	ОбластьКолонкаТовар = Макет.Область("Товар");
	Если Не ВыводитьКоды Тогда
		ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки + 
											Макет.Область("КолонкаКодов").ШиринаКолонки;
	КонецЕсли;

	ОбластьНомера = Макет.ПолучитьОбласть("Строка|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("Строка|Данные");

	НумераторСтрок = 0;

	Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 

		Если ВыборкаСтрокТовары.Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
			Сообщить("В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.", СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;

		НумераторСтрок = НумераторСтрок + 1;
		ОбластьНомера.Параметры.НомерСтроки = НумераторСтрок;
		ТабДокумент.Вывести(ОбластьНомера);

		Если ВыводитьКоды Тогда
			Если Колонка = "Артикул" Тогда
				ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТовары.Артикул;
			Иначе
				ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТовары.Код;
			КонецЕсли;
			ТабДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;

		ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТовары);
		ОбластьДанных.Параметры.Товар = СокрП(ВыборкаСтрокТовары.НаименованиеПолное) + ФормированиеПечатныхФорм.ПредставлениеСерий(ВыборкаСтрокТовары);
		ТабДокумент.Присоединить(ОбластьДанных);

	КонецЦикла;

	// Вывести Итого
	ОбластьНомера = Макет.ПолучитьОбласть("Итого|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("Итого|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("Итого|Данные");

	ТабДокумент.Вывести(ОбластьНомера);
	Если ВыводитьКоды Тогда
		ТабДокумент.Присоединить(ОбластьКодов);
	КонецЕсли;
	ТабДокумент.Присоединить(ОбластьДанных);

	ОбластьМакета = Макет.ПолучитьОбласть("ПодвалЗаказа");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ФИОИсполнитель = ОбщегоНазначения.ФамилияИнициалыФизЛица(Шапка.Исполнитель);
	ОбластьМакета.Параметры.ФИОИсполнителя = ПодразделениеИсполнитель.Наименование+?(ЗначениеЗаполнено(ПодразделениеИсполнитель) И ЗначениеЗаполнено(ФИОИсполнитель),"; ","")+ФИОИсполнитель;

	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;

КонецФункции // ПечатьСчетаЗаказаКорректировки()

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	// Получить экземпляр документа на печать
	Если ИмяМакета = "Заказ" тогда
		ТабДокумент = ПечатьСчетаЗаказа(ИмяМакета);
	ИначеЕсли ИмяМакета = "ЗаказКорректировка" тогда
		ТабДокумент = ПечатьСчетаЗаказаКорректировки(ИмяМакета);
	ИначеЕсли ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, ""), Ссылка);

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("Заказ, ЗаказКорректировка","Внутренний заказ", "Внутренний заказ (с учетом корректировок)");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Заполняет табличную часть при оперативном проведении, когда включены флаги авторазмещения и/или авторезервирования
//
// Параметры:
//  Параметры -  структура параметров на основании которых заполняется документ.
//
Процедура ЗаполнитьТабличныеЧастиПередПроведениемУпр(Параметры) Экспорт

	Параметры.Вставить("Заказ",ЭтотОбъект);
	Параметры.Вставить("РезервироватьПоСериям",ложь);
	УправлениеЗаказами.Заказ_ЗаполнитьТабличныеЧастиВозможнымРазмещением(Параметры, Товары, ВозвратнаяТара);

КонецПроцедуры // ЗаполнитьТабличныеЧастиПередПроведениемУпр()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// По виду операции определяет статус партии товаров (не возвратная тара!)
//
// Параметры: 
//  Нет.
//
// Возвращаемое значение:
//  Значение перечисления "Статусы партии товаров".
//
Функция ОпределитьСтатусПартии() 

	Статус = Перечисления.СтатусыПартийТоваров.Купленный; 
	
	Возврат Статус;

КонецФункции // ОпределитьСтатусПартииПрихода()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
Функция ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента)

	Возврат РезультатЗапросаПоТоварам.Выгрузить();

КонецФункции // ПодготовитьТаблицуТоваров()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТаре  - результат запроса по табличной части "ВозвратнаяТара",
//  СтруктураШапкиДокумента - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
Функция ПодготовитьТаблицуТары(РезультатЗапросаПоТаре, СтруктураШапкиДокумента)

	ТаблицаТары = РезультатЗапросаПоТаре.Выгрузить();

	ТаблицаТары.Колонки.Добавить("ХарактеристикаНоменклатуры", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаТары.Колонки.Добавить("СерияНоменклатуры", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));

	Возврат ТаблицаТары;

КонецФункции // ПодготовитьТаблицуТары()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Организация");
					
	// Склад заполняем только, если у нас есть строки в таблице "Товары" или "Возвратная тара"
	Если Товары.Количество() > 0 ИЛИ ВозвратнаяТара.Количество() > 0 Тогда
		СтруктураОбязательныхПолей.Вставить("Заказчик");
	КонецЕсли;

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок)

	ИмяТабличнойЧасти = "Товары";

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = 
	Новый Структура("Номенклатура, Количество");

	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОбязательныхПолей, Отказ, Заголовок);

	// Здесь услуг быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетУслуг(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь наборов-пакетов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетНаборов(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь наборов-комплектов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетКомплектов(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь не должно быть размещений по НТТ
	УправлениеЗапасами.ПроверитьЧтоСкладНеНТТ(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	Для Каждого СтрокаТЧ Из ТаблицаПоТоварам Цикл
		Если ТипЗнч(СтрокаТЧ.Размещение) = Тип("СправочникСсылка.Склады") Тогда
			Если СтрокаТЧ.Размещение.ВидСклада = Перечисления.ВидыСкладов.НТТ Тогда
				ОбщегоНазначения.СообщитьОбОшибке("В строке № " + СтрокаТЧ.НомерСтроки + " табличной части ""Товары"" выбрана НТТ. " + Символы.ПС + "Нельзя выбирать НТТ.", Отказ, Заголовок);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Для Каждого СтрокаТЧ Из ТаблицаПоТоварам Цикл
		Если ТипЗнч(СтрокаТЧ.Размещение) = Тип("СправочникСсылка.Склады")
			И ВидЗаказа = Перечисления.ВидыВнутреннегоЗаказа.НаСклад Тогда
			Если СтрокаТЧ.Размещение = Заказчик Тогда
				ОбщегоНазначения.СообщитьОбОшибке("В строке № " + СтрокаТЧ.НомерСтроки + " табличной части ""Товары"" выбран склад, совпадающий со складом-заказчиком внутреннего заказа. " + Символы.ПС + "Нельзя зарезервировать товар на складе-заказчике.", Отказ, Заголовок);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Проверяет правильность заполнения строк табличной части "Возвратная тара".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТаре           - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиВозвратнаяТара(ТаблицаПоТаре, СтруктураШапкиДокумента, 
	                                                      Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура, Количество");

	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ВозвратнаяТара", СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	// Здесь услуг быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетУслуг(ЭтотОбъект, "ВозвратнаяТара", ТаблицаПоТаре, Отказ, Заголовок);

	// Здесь наборов-пакетов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетНаборов(ЭтотОбъект, "ВозвратнаяТара", ТаблицаПоТаре, Отказ, Заголовок);
	
	// Здесь наборов-комплектов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетКомплектов(ЭтотОбъект, "ВозвратнаяТара", ТаблицаПоТаре, Отказ, Заголовок);

	// Здесь не должно быть размещений по НТТ
	УправлениеЗапасами.ПроверитьЧтоСкладНеНТТ(ЭтотОбъект, "ВозвратнаяТара", ТаблицаПоТаре, Отказ, Заголовок);

	// По возвратной таре не должен вестись учет по характеристикам.
	УправлениеЗапасами.ПроверитьЧтоНетНоменклатурыСХарактеристиками(ЭтотОбъект, "ВозвратнаяТара", ТаблицаПоТаре, Отказ, Заголовок);

	Для Каждого СтрокаТЧ Из ТаблицаПоТаре Цикл
		Если ТипЗнч(СтрокаТЧ.Размещение) = Тип("СправочникСсылка.Склады") Тогда
			Если СтрокаТЧ.Размещение.ВидСклада = Перечисления.ВидыСкладов.НТТ Тогда
				ОбщегоНазначения.СообщитьОбОшибке("В строке № " + СтрокаТЧ.НомерСтроки + " табличной части ""Тара"" выбрана НТТ. " + Символы.ПС + "Нельзя выбирать НТТ.", Отказ, Заголовок);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Для Каждого СтрокаТЧ Из ТаблицаПоТаре Цикл
		Если ТипЗнч(СтрокаТЧ.Размещение) = Тип("СправочникСсылка.Склады")
			И ВидЗаказа = Перечисления.ВидыВнутреннегоЗаказа.НаСклад Тогда
			Если СтрокаТЧ.Размещение = Заказчик Тогда
				ОбщегоНазначения.СообщитьОбОшибке("В строке № " + СтрокаТЧ.НомерСтроки + " табличной части ""Тара"" выбран склад, совпадающий со складом-заказчиком внутреннего заказа. " + Символы.ПС + "Нельзя зарезервировать товар на складе-заказчике.", Отказ, Заголовок);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиВозвратнаяТара()

// Функция удаляет из исходной таблицы строки не требующие размещения
// Возвращается КОПИЯ исходной таблицы
//
Функция СоздатьТаблицуРазмещенияЗаказов(ТаблицаПоТоварам)

	ТаблицаПоТоварамРазмещение = ТаблицаПоТоварам.Скопировать();
	Сч = 0;
	Пока Сч < ТаблицаПоТоварамРазмещение.Количество() Цикл
		СтрокаТаблицы = ТаблицаПоТоварамРазмещение.Получить(Сч);
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Размещение) 
		 Или ТипЗнч(СтрокаТаблицы.Размещение) <> Тип("ДокументСсылка.ЗаказПоставщику") Тогда
			 ТаблицаПоТоварамРазмещение.Удалить(СтрокаТаблицы);
		Иначе 
			Сч = Сч + 1;
		КонецЕсли; 
	КонецЦикла;
	
	ТаблицаПоТоварамРазмещение.Колонки.Размещение.Имя = "ЗаказПоставщику";
	
	Возврат ТаблицаПоТоварамРазмещение;
	
КонецФункции // СоздатьТаблицуРазмещенияЗаказов()

// Функция удаляет из исходной таблицы строки не требующие резервирования
// Возвращается КОПИЯ исходной таблицы
//
Функция СоздатьТаблицуРезервированияПодЗаказ(ТаблицаПоТоварам)

	ТаблицаПоТоварамРезервирование = ТаблицаПоТоварам.Скопировать();
	Сч = 0;
	Пока Сч < ТаблицаПоТоварамРезервирование.Количество() Цикл
		СтрокаТаблицы = ТаблицаПоТоварамРезервирование.Получить(Сч);
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Размещение) 
		 Или ТипЗнч(СтрокаТаблицы.Размещение) <> Тип("СправочникСсылка.Склады") Тогда
			 ТаблицаПоТоварамРезервирование.Удалить(СтрокаТаблицы);
		Иначе 
			Сч = Сч + 1;
		КонецЕсли; 
	КонецЦикла;
	
	ТаблицаПоТоварамРезервирование.Колонки.Размещение.Имя = "Склад";
	
	Возврат ТаблицаПоТоварамРезервирование;
		
КонецФункции // СоздатьТаблицуРезервированияПодЗаказ()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  ТаблицаПоТаре             - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, 
	                          ТаблицаПоТоварам, ТаблицаПоТаре,
	                          Отказ, Заголовок);

	ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам,
							ТаблицаПоТаре, Отказ, Заголовок);
							  
КонецПроцедуры // ДвиженияПоРегистрам()

// Формируем движения по упр. регистрам.
//
Процедура ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, 
	                          ТаблицаПоТоварам, ТаблицаПоТаре,
	                          Отказ, Заголовок);

	Если Не Отказ Тогда
	
		НаборДвижений = Движения.ВнутренниеЗаказы;
		
		СтруктТаблицДокумента = Новый Структура;
		СтруктТаблицДокумента.Вставить("ТаблицаПоТоварам", ТаблицаПоТоварам);
		СтруктТаблицДокумента.Вставить("ТаблицаПоТаре",    ТаблицаПоТаре);
					
		ТаблицыДанныхДокумента = ОбщегоНазначения.ЗагрузитьТаблицыДокументаВСтруктуру(НаборДвижений, СтруктТаблицДокумента);
				
		ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "ВнутреннийЗаказ", Ссылка);
		ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Заказчик",        Заказчик);
		ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "СтатусПартии",    ОпределитьСтатусПартии(),                         "ТаблицаПоТоварам");
		ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "СтатусПартии",    Перечисления.СтатусыПартийТоваров.ВозвратнаяТара, "ТаблицаПоТаре");
			
		ОбщегоНазначения.ЗаписатьТаблицыДокументаВРегистр(НаборДвижений, ВидДвиженияНакопления.Приход, ТаблицыДанныхДокумента, Дата);
			
		ТаблицаПоТоварамРазмещение = СоздатьТаблицуРазмещенияЗаказов(ТаблицаПоТоварам);
		ТаблицаПоТареРазмещение    = СоздатьТаблицуРазмещенияЗаказов(ТаблицаПоТаре);
		Если ТаблицаПоТоварамРазмещение.Количество() > 0 ИЛИ ТаблицаПоТареРазмещение.Количество() > 0 Тогда
			
			// По регистру РазмещениеЗаказовПокупателей
			НаборДвижений = Движения.РазмещениеЗаказовПокупателей;
			
			Если РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
				НаборДвижений.КонтрольОстатков(ЭтотОбъект, "Товары",         СтруктураШапкиДокумента, Отказ, Заголовок);
				НаборДвижений.КонтрольОстатков(ЭтотОбъект, "ВозвратнаяТара", СтруктураШапкиДокумента, Отказ, Заголовок);
			КонецЕсли;
			
			Если Не Отказ Тогда
			
				СтруктТаблицДокумента = Новый Структура;
				СтруктТаблицДокумента.Вставить("ТаблицаПоТоварам", ТаблицаПоТоварамРазмещение);
				СтруктТаблицДокумента.Вставить("ТаблицаПоТаре",    ТаблицаПоТареРазмещение);
							
				ТаблицыДанныхДокумента = ОбщегоНазначения.ЗагрузитьТаблицыДокументаВСтруктуру(НаборДвижений, СтруктТаблицДокумента);
						
				ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "ЗаказПокупателя", Ссылка);
				ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "ТоварТара",       Перечисления.ТоварТара.Товар, "ТаблицаПоТоварам");
				ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "ТоварТара",       Перечисления.ТоварТара.Тара,  "ТаблицаПоТаре");
					
				ОбщегоНазначения.ЗаписатьТаблицыДокументаВРегистр(НаборДвижений, ВидДвиженияНакопления.Приход, ТаблицыДанныхДокумента, Дата);
			
			КонецЕсли;
		
		КонецЕсли;
		
		ТаблицаПоТоварамРезервирование = СоздатьТаблицуРезервированияПодЗаказ(ТаблицаПоТоварам);
		ТаблицаПоТареРезервирование    = СоздатьТаблицуРезервированияПодЗаказ(ТаблицаПоТаре);
		Если ТаблицаПоТоварамРезервирование.Количество() > 0 ИЛИ ТаблицаПоТареРезервирование.Количество() > 0 Тогда
			
			НаборДвижений = Движения.ТоварыВРезервеНаСкладах;
			
			// Проверка остатков при оперативном проведении.
			Если РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
				НаборДвижений.КонтрольОстатков(ЭтотОбъект, "Товары",         СтруктураШапкиДокумента, Отказ, Заголовок);
				НаборДвижений.КонтрольОстатков(ЭтотОбъект, "ВозвратнаяТара", СтруктураШапкиДокумента, Отказ, Заголовок);
			КонецЕсли;
			
			Если НЕ Отказ Тогда
			
				СтруктТаблицДокумента = Новый Структура;
				СтруктТаблицДокумента.Вставить("ТаблицаПоТоварам", ТаблицаПоТоварамРезервирование);
				СтруктТаблицДокумента.Вставить("ТаблицаПоТаре",    ТаблицаПоТареРезервирование);
							
				ТаблицыДанныхДокумента = ОбщегоНазначения.ЗагрузитьТаблицыДокументаВСтруктуру(НаборДвижений, СтруктТаблицДокумента);
						
				ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "ДокументРезерва", Ссылка);
					
				ОбщегоНазначения.ЗаписатьТаблицыДокументаВРегистр(НаборДвижений, ВидДвиженияНакопления.Приход, ТаблицыДанныхДокумента, Дата);
				
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрамУпр()

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.Событие") Тогда

		// Заполнение шапки
		Комментарий       = Основание.Комментарий;
		Ответственный     = Основание.Ответственный;
		ДокументОснование = Основание;

	КонецЕсли;

КонецПроцедуры // ОбработкаЗаполнения()

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	Если ВидЗаказа = Перечисления.ВидыВнутреннегоЗаказа.ВПодразделение И ВозвратнаяТара.Количество()>0 Тогда
		ВозвратнаяТара.Очистить();
	КонецЕсли;
	
	// Проверка заполнения единицы измерения мест и количества мест
	ОбработкаТабличныхЧастей.ПриЗаписиПроверитьЕдиницуИзмеренияМест(Товары);

КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;

	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "УчетнаяПолитика", "ВестиПартионныйУчетПоСкладам", "ВестиПартионныйУчетПоСкладам");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	// Получим необходимые данные для проведения и проверки заполнения данных по табличной части "Товары".
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Номенклатура"              , "Номенклатура");
	СтруктураПолей.Вставить("Услуга"                    , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("Набор"                     , "Номенклатура.Набор");
	СтруктураПолей.Вставить("Комплект"                  , "Номенклатура.Комплект");
	СтруктураПолей.Вставить("Количество"                , "Количество * Коэффициент /Номенклатура.ЕдиницаХраненияОстатков.Коэффициент");
	СтруктураПолей.Вставить("ХарактеристикаНоменклатуры", "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить("ЕдиницаИзмерения"          , "ЕдиницаИзмерения");
	СтруктураПолей.Вставить("Размещение"                , "Размещение");
	СтруктураПолей.Вставить("ВидСкладаРазмещения"       , "Размещение.ВидСклада");

	РезультатЗапросаПоТоварам = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураПолей);

	// Подготовим таблицу товаров для проведения.
	ТаблицаПоТоварам = ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента);

	// Получим необходимые данные для проведения и проверки заполнения данных 
	// по табличной части "Возвратная тара".
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Номенклатура"              , "Номенклатура");
	СтруктураПолей.Вставить("Услуга"                    , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("Набор"                     , "Номенклатура.Набор");
	СтруктураПолей.Вставить("Комплект"                  , "Номенклатура.Комплект");
	СтруктураПолей.Вставить("Количество"                , "Количество");
	СтруктураПолей.Вставить("ВестиУчетПоХарактеристикам", "Номенклатура.ВестиУчетПоХарактеристикам");
	СтруктураПолей.Вставить("ЕдиницаИзмерения"          , "Номенклатура.ЕдиницаХраненияОстатков");
	СтруктураПолей.Вставить("Размещение"                , "Размещение");
	СтруктураПолей.Вставить("ВидСкладаРазмещения"       , "Размещение.ВидСклада");

	РезультатЗапросаПоТаре = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ВозвратнаяТара", СтруктураПолей);

	// Подготовим таблицу тары для проведения.
	ТаблицаПоТаре = ПодготовитьТаблицуТары(РезультатЗапросаПоТаре, СтруктураШапкиДокумента);

	// Проверить заполнение ТЧ "Товары" и "Возвратная тара".
	ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок);
	ПроверитьЗаполнениеТабличнойЧастиВозвратнаяТара(ТаблицаПоТаре, СтруктураШапкиДокумента, Отказ, Заголовок);

	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам,
		                    ТаблицаПоТаре, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)

	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);	

КонецПроцедуры // ОбработкаУдаленияПроведения


мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

