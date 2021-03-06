﻿Функция Печать() Экспорт

	ТабДокумент = ПечатьСчетаЗаказаКорректировки("Счет");

	Возврат ТабДокумент;

КонецФункции // Печать()

Функция ПечатьСчетаЗаказаКорректировки(Тип)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.УстановитьПараметр("ПустойКонтрагент", Справочники.Контрагенты.ПустаяСсылка());
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	Организация,
	|	Контрагент КАК Получатель,
	|	ВЫБОР КОГДА Грузоотправитель = &ПустойКонтрагент
	|	      ТОГДА Организация
	|	      ИНАЧЕ Грузоотправитель КОНЕЦ КАК Грузоотправитель,
	|	ВЫБОР КОГДА Грузополучатель = &ПустойКонтрагент
	|	      ТОГДА Контрагент
	|	      ИНАЧЕ Грузополучатель КОНЕЦ КАК Грузополучатель,
	|	Организация КАК Руководители,
	|	Организация КАК Поставщик,
	|	СуммаДокумента,
	|	ВалютаДокумента,
	|	УчитыватьНДС,
	|	СуммаВключаетНДС
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|
	|ГДЕ
	|	ЗаказПокупателя.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказПокупателя_СчетЗаказ";

	СтрокаВыборкиПоляСодержания = ОбработкаТабличныхЧастей.ПолучитьЧастьЗапросаДляВыбораСодержания("ЗаказПокупателя");
	СтрокаВыборкиКорректировкиПоляСодержания = ОбработкаТабличныхЧастей.ПолучитьЧастьЗапросаДляВыбораСодержания("КорректировкаЗаказаПокупателя");
	
	Запрос = Новый Запрос;
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.НомерТЧ,
	|	Минимум(ВложенныйЗапрос.ПризнакКорректировка) 	КАК ПризнакКорректировка,
	|	Минимум(ВложенныйЗапрос.НомерСтроки) 			КАК НомерСтроки,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.НаименованиеПолное,
	|	ВложенныйЗапрос.Номенклатура.Артикул            КАК Артикул,
	|	ВложенныйЗапрос.Номенклатура.Код                КАК Код,
	|	СУММА(ВложенныйЗапрос.Количество)               КАК КоличествоТовара,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление  КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.ПроцентСкидкиНаценки 
	|	+ ВложенныйЗапрос.ПроцентАвтоматическихСкидок   КАК Скидка,
	|	СУММА(ВложенныйЗапрос.СуммаНДС)                 КАК СуммаНДС,
	|	ВложенныйЗапрос.Цена                            КАК Цена,
	|	СУММА(ВложенныйЗапрос.Сумма)                    КАК Сумма,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры      КАК Характеристика,
	|	NULL                                            КАК Серия
	|ИЗ
	|
	|(
	|ВЫБРАТЬ
	|		ЗаказПокупателя.Номенклатура                КАК Номенклатура,
	|		ВЫРАЗИТЬ (ЗаказПокупателя.Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК НаименованиеПолное,
	|		ЗаказПокупателя.ЕдиницаИзмерения            КАК ЕдиницаИзмерения,
	|		ЗаказПокупателя.Цена                        КАК Цена,
	|		ЗаказПокупателя.ПроцентСкидкиНаценки        КАК ПроцентСкидкиНаценки,
	|		ЗаказПокупателя.ПроцентАвтоматическихСкидок КАК ПроцентАвтоматическихСкидок,
	|		ЗаказПокупателя.ХарактеристикаНоменклатуры  КАК ХарактеристикаНоменклатуры,
	|		ЗаказПокупателя.СуммаНДС                    КАК СуммаНДС,
	|		ЗаказПокупателя.Сумма                       КАК Сумма,
	|		ЗаказПокупателя.Количество                  КАК Количество,
	|		(1)                                         КАК НомерТЧ,
	|		(0)                                         КАК ПризнакКорректировка,
	|		ЗаказПокупателя.НомерСтроки 				КАК НомерСтроки
	|	ИЗ
	|		Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателя
	|
	|	ГДЕ
	|		ЗаказПокупателя.Ссылка = &ТекущийДокумент
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|		КорректировкаЗаказаПокупателя.Номенклатура               КАК Номенклатура,
	|		ВЫРАЗИТЬ (КорректировкаЗаказаПокупателя.Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК НаименованиеПолное,
	|		КорректировкаЗаказаПокупателя.ЕдиницаИзмерения           КАК ЕдиницаИзмерения,
	|		КорректировкаЗаказаПокупателя.Цена                       КАК Цена,
	|		КорректировкаЗаказаПокупателя.ПроцентСкидкиНаценки       КАК ПроцентСкидкиНаценки,
	|		КорректировкаЗаказаПокупателя.ПроцентАвтоматическихСкидок КАК ПроцентАвтоматическихСкидок,
	|		КорректировкаЗаказаПокупателя.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		КорректировкаЗаказаПокупателя.СуммаНДС                   КАК СуммаНДС,
	|		КорректировкаЗаказаПокупателя.Сумма                      КАК Сумма,
	|		КорректировкаЗаказаПокупателя.Количество                 КАК Количество,
	|	   (1)                                                       КАК НомерТЧ,
	|		(1)                                         			 КАК ПризнакКорректировка,
	|		КорректировкаЗаказаПокупателя.НомерСтроки				 КАК НомерСтроки
	|	ИЗ
	|		Документ.КорректировкаЗаказаПокупателя.Товары КАК КорректировкаЗаказаПокупателя
	|
	|	ГДЕ
	|		КорректировкаЗаказаПокупателя.Ссылка.ЗаказПокупателя = &ТекущийДокумент
	|		И КорректировкаЗаказаПокупателя.Ссылка.Проведен      = Истина
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|		ЗаказПокупателя.Номенклатура                         КАК Номенклатура,
	|		" + СтрокаВыборкиПоляСодержания + "                  КАК НаименованиеПолное,
	|		ЗаказПокупателя.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|		ЗаказПокупателя.Цена                                 КАК Цена,
	|		ЗаказПокупателя.ПроцентСкидкиНаценки                 КАК ПроцентСкидкиНаценки,
	|		ЗаказПокупателя.ПроцентАвтоматическихСкидок          КАК ПроцентАвтоматическихСкидок,
	|		NULL                                                 КАК ХарактеристикаНоменклатуры,
	|		ЗаказПокупателя.СуммаНДС                             КАК СуммаНДС,
	|		ЗаказПокупателя.Сумма                                КАК Сумма,
	|		ЗаказПокупателя.Количество                           КАК Количество,
	|		(2)                                                  КАК НомерТЧ,
	|		(0)                                         		 КАК ПризнакКорректировка,
	|		ЗаказПокупателя.НомерСтроки 						 КАК НомерСтроки
	|	ИЗ
	|		Документ.ЗаказПокупателя.Услуги КАК ЗаказПокупателя
	|
	|	ГДЕ
	|		ЗаказПокупателя.Ссылка = &ТекущийДокумент
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|		КорректировкаЗаказаПокупателя.Номенклатура                         КАК Номенклатура,
	|" + СтрокаВыборкиКорректировкиПоляСодержания + "						   КАК НаименованиеПолное,
	|		КорректировкаЗаказаПокупателя.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|		КорректировкаЗаказаПокупателя.Цена                                 КАК Цена,
	|		КорректировкаЗаказаПокупателя.ПроцентСкидкиНаценки                 КАК ПроцентСкидкиНаценки,
	|		КорректировкаЗаказаПокупателя.ПроцентАвтоматическихСкидок          КАК ПроцентАвтоматическихСкидок,
	|		NULL                                                               КАК ХарактеристикаНоменклатуры,
	|		КорректировкаЗаказаПокупателя.СуммаНДС                             КАК СуммаНДС,
	|		КорректировкаЗаказаПокупателя.Сумма                                КАК Сумма,
	|		КорректировкаЗаказаПокупателя.Количество                           КАК Количество,
	|		(2)                                                                КАК НомерТЧ,
	|		(1)                                         					   КАК ПризнакКорректировка,
	|		КорректировкаЗаказаПокупателя.НомерСтроки				 		   КАК НомерСтроки
	|	ИЗ
	|		Документ.КорректировкаЗаказаПокупателя.Услуги КАК КорректировкаЗаказаПокупателя
	|
	|	ГДЕ
	|		КорректировкаЗаказаПокупателя.Ссылка.ЗаказПокупателя = &ТекущийДокумент
	|		И КорректировкаЗаказаПокупателя.Ссылка.Проведен      = Истина
	|";
	
	Если Тип <> "Счет" Тогда
		ТекстЗапроса = ТекстЗапроса +
		" 
		|ОБЪЕДИНИТЬ ВСЕ
		|ВЫБРАТЬ
		|		ЗаказПокупателя.Номенклатура                КАК Номенклатура,
		|		ВЫРАЗИТЬ (ЗаказПокупателя.Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК НаименованиеПолное,
		|		ЗаказПокупателя.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
		|		ЗаказПокупателя.Цена                        КАК Цена,
		|		0									        КАК ПроцентСкидкиНаценки,
		|		0 											КАК ПроцентАвтоматическихСкидок,
		|		NULL 										КАК ХарактеристикаНоменклатуры,
		|		0						                    КАК СуммаНДС,
		|		ЗаказПокупателя.Сумма                       КАК Сумма,
		|		ЗаказПокупателя.Количество                  КАК Количество,
		|		(3)                                         КАК НомерТЧ,
		|		(0)                                         КАК ПризнакКорректировка,
		|		ЗаказПокупателя.НомерСтроки 				КАК НомерСтроки
		|	ИЗ
		|		Документ.ЗаказПокупателя.ВозвратнаяТара КАК ЗаказПокупателя
		|
		|	ГДЕ
		|		ЗаказПокупателя.Ссылка = &ТекущийДокумент
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|		КорректировкаЗаказаПокупателя.Номенклатура               КАК Номенклатура,
		|		ВЫРАЗИТЬ (КорректировкаЗаказаПокупателя.Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК НаименованиеПолное,
		|		КорректировкаЗаказаПокупателя.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
		|		КорректировкаЗаказаПокупателя.Цена                       КАК Цена,
		|		0														 КАК ПроцентСкидкиНаценки,
		|		0														 КАК ПроцентАвтоматическихСкидок,
		|		NULL 													 КАК ХарактеристикаНоменклатуры,
		|		0														 КАК СуммаНДС,
		|		КорректировкаЗаказаПокупателя.Сумма                      КАК Сумма,
		|		КорректировкаЗаказаПокупателя.Количество                 КАК Количество,
		|	   (3)                                                       КАК НомерТЧ,
		|		(1)                                         			 КАК ПризнакКорректировка,
		|		КорректировкаЗаказаПокупателя.НомерСтроки				 КАК НомерСтроки
		|	ИЗ
		|		Документ.КорректировкаЗаказаПокупателя.ВозвратнаяТара КАК КорректировкаЗаказаПокупателя
		|
		|	ГДЕ
		|		КорректировкаЗаказаПокупателя.Ссылка.ЗаказПокупателя = &ТекущийДокумент
		|		И КорректировкаЗаказаПокупателя.Ссылка.Проведен      = Истина
		|";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса+
	"
	|) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.НомерТЧ,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.ЕдиницаИзмерения,
	|	ВложенныйЗапрос.ПроцентСкидкиНаценки,
	|	ВложенныйЗапрос.ПроцентАвтоматическихСкидок,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	|	ВложенныйЗапрос.Цена,
	|	ВложенныйЗапрос.НаименованиеПолное
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.НомерТЧ, ПризнакКорректировка, НомерСтроки
	|";
	
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.Текст = ТекстЗапроса;
	ЗапросТовары = Запрос.Выполнить().Выгрузить();

	Макет = ПолучитьМакет("СчетЗаказ");

	// Выводим шапку накладной

	СведенияОПоставщике = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата);
	Если Тип = "Счет" Тогда
		ОбластьМакета       = Макет.ПолучитьОбласть("ЗаголовокСчета");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ИНН = СведенияОПоставщике.ИНН;
		ОбластьМакета.Параметры.КПП = СведенияОПоставщике.КПП;
		СтруктурнаяЕдиница = СсылкаНаОбъект.СтруктурнаяЕдиница;
		Банк = СсылкаНаОбъект.СтруктурнаяЕдиница.Банк;
		Если ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
			Банк       = СтруктурнаяЕдиница.Банк;
			БИК        = Банк.Код;
			КоррСчет   = Банк.КоррСчет;
			ГородБанка = Банк.Город;
			НомерСчета = СтруктурнаяЕдиница.НомерСчета;

			ОбластьМакета.Параметры.БИКБанкаПолучателя               = БИК;
			ОбластьМакета.Параметры.БанкПолучателя                   = Банк;
			ОбластьМакета.Параметры.БанкПолучателяПредставление      = СокрЛП(Банк) + " " + ГородБанка;
			ОбластьМакета.Параметры.СчетБанкаПолучателя              = КоррСчет;
			ОбластьМакета.Параметры.СчетБанкаПолучателяПредставление = КоррСчет;
			ОбластьМакета.Параметры.СчетПолучателяПредставление      = НомерСчета;
			ОбластьМакета.Параметры.СчетПолучателя                   = НомерСчета;
			ОбластьМакета.Параметры.ПредставлениеПоставщикаДляПлатПоручения = СтруктурнаяЕдиница.ТекстКорреспондента;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ОбластьМакета.Параметры.ПредставлениеПоставщикаДляПлатПоручения) Тогда
			ОбластьМакета.Параметры.ПредставлениеПоставщикаДляПлатПоручения = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,");
		КонецЕсли;
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЕсли; 

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	Если Тип = "Счет" Тогда
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Счет на оплату");
	Иначе
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Заказ покупателя");
	КонецЕсли;
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	
	Если Тип = "Счет" Тогда
		ОбластьМакета.Параметры.ТекстПоставщик = "Поставщик:";
		Если Шапка.Организация = Шапка.Грузоотправитель Тогда
			ОбластьМакета.Параметры.ПредставлениеГрузоотправителя = ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата), "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		Иначе
			ОбластьМакета.Параметры.ПредставлениеГрузоотправителя = ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Грузоотправитель, Шапка.Дата), "ПолноеНаименование,ИНН,КПП,ФактическийАдрес,Телефоны,");
		КонецЕсли;
	Иначе
		ОбластьМакета.Параметры.ТекстПоставщик = "Исполнитель:"
	КонецЕсли;
	
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата), "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,");
	ТабДокумент.Вывести(ОбластьМакета);

	СведенияОПолучателе = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата);
	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	
	Если Тип = "Счет" Тогда
		ОбластьМакета.Параметры.ТекстПокупатель = "Покупатель:";
		ОбластьМакета.Параметры.ПредставлениеГрузополучателя = ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Грузополучатель, Шапка.Дата), "ПолноеНаименование,ИНН,КПП,ФактическийАдрес,Телефоны,");
	Иначе
		ОбластьМакета.Параметры.ТекстПокупатель = "Заказчик:"
	КонецЕсли;
	
	ОбластьМакета.Параметры.ПредставлениеПолучателя = ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата), "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,");
	ТабДокумент.Вывести(ОбластьМакета);

	ЕстьСкидки = Ложь;
	Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 
		Если ЗначениеЗаполнено(ВыборкаСтрокТовары.Скидка) Тогда
			ЕстьСкидки = Истина;
			Прервать;
		КонецЕсли; 
	КонецЦикла;

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
	ОбластьСкидок = Макет.ПолучитьОбласть("ШапкаТаблицы|Скидка");
	ОбластьСуммы  = Макет.ПолучитьОбласть("ШапкаТаблицы|Сумма");

	ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|Товар");
	Если Не ВыводитьКоды И ЕстьСкидки Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|ТоварБезКодов");
	ИначеЕсли НЕ ЕстьСкидки И ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|ТоварБезСкидок");
	ИначеЕсли НЕ ЕстьСкидки И НЕ ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|ТоварБезКодовИСкидок");
	КонецЕсли;
			ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|ТоварСПримечанием");
	
			ОбластьПримечаниеШапка = Макет.ПолучитьОбласть("ШапкаТаблицы|вцПримечание");
	
	
	ТабДокумент.Вывести(ОбластьНомера);
	Если ВыводитьКоды Тогда
		ОбластьКодов.Параметры.ИмяКолонкиКодов = Колонка;
		ТабДокумент.Присоединить(ОбластьКодов);
	КонецЕсли;
	ОбластьТовар.Параметры.Товар = "Товары (работы, услуги)";
	ТабДокумент.Присоединить(ОбластьТовар);
	ТабДокумент.Присоединить(ОбластьДанных);
	Если ЕстьСкидки Тогда
		ТабДокумент.Присоединить(ОбластьСкидок);
	КонецЕсли;
	ТабДокумент.Присоединить(ОбластьСуммы);

			
		ТабДокумент.Присоединить(ОбластьПримечаниеШапка);
		
	
	
	ОбластьНомера = Макет.ПолучитьОбласть("Строка|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("Строка|Данные");
	ОбластьСкидок = Макет.ПолучитьОбласть("Строка|Скидка");
	ОбластьСуммы  = Макет.ПолучитьОбласть("Строка|Сумма");

	ОбластьТовар = Макет.ПолучитьОбласть("Строка|Товар");
	Если Не ВыводитьКоды И ЕстьСкидки Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Строка|ТоварБезКодов");
	ИначеЕсли НЕ ЕстьСкидки И ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Строка|ТоварБезСкидок");
	ИначеЕсли НЕ ЕстьСкидки И НЕ ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Строка|ТоварБезКодовИСкидок");
	КонецЕсли;
		ОбластьТовар = Макет.ПолучитьОбласть("Строка|ТоварСПримечанием");

	

		
		ОбластьСтрокаПримечание = Макет.ПолучитьОбласть("Строка|вцПримечание");
	
	Сумма    = 0;
	СуммаНДС = 0;
	ВсегоСкидок    = 0;
	ВсегоБезСкидок = 0;
	НумераторСтрок = 0;

	Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 

		Если ВыборкаСтрокТовары.КоличествоТовара = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
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

		ОбластьТовар.Параметры.Товар = СокрП(ВыборкаСтрокТовары.НаименованиеПолное) + ФормированиеПечатныхФорм.ПредставлениеСерий(ВыборкаСтрокТовары)
																+ ?(ВыборкаСтрокТовары.НомерТЧ = 3, " (возвратная тара)", "");
		ТабДокумент.Присоединить(ОбластьТовар);
		ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТовары);
		ОбластьДанных.Параметры.Количество = ВыборкаСтрокТовары.КоличествоТовара;
		ТабДокумент.Присоединить(ОбластьДанных);

		Скидка = Ценообразование.ПолучитьСуммуСкидки(ВыборкаСтрокТовары.Сумма, ВыборкаСтрокТовары.Скидка);

		Если ЕстьСкидки Тогда
			ОбластьСкидок.Параметры.Скидка         = Скидка;
			ОбластьСкидок.Параметры.СуммаБезСкидки = ВыборкаСтрокТовары.Сумма + Скидка;
			ТабДокумент.Присоединить(ОбластьСкидок);
		КонецЕсли;

		ОбластьСуммы.Параметры.Заполнить(ВыборкаСтрокТовары);
		ТабДокумент.Присоединить(ОбластьСуммы);
		Сумма          = Сумма       + ВыборкаСтрокТовары.Сумма;
		СуммаНДС       = СуммаНДС    + ВыборкаСтрокТовары.СуммаНДС;
		ВсегоСкидок    = ВсегоСкидок + Скидка;
		ВсегоБезСкидок = Сумма       + ВсегоСкидок;

					
			ТабДокумент.Присоединить(ОбластьСтрокаПримечание);
		
		
	КонецЦикла;

	// Вывести Итого
	ОбластьНомера = Макет.ПолучитьОбласть("Итого|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("Итого|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("Итого|Данные");
	ОбластьСкидок = Макет.ПолучитьОбласть("Итого|Скидка");
	ОбластьСуммы  = Макет.ПолучитьОбласть("Итого|Сумма");

	ОбластьТовар = Макет.ПолучитьОбласть("Итого|Товар");
	Если Не ВыводитьКоды И ЕстьСкидки Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Итого|ТоварБезКодов");
	ИначеЕсли НЕ ЕстьСкидки И ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Итого|ТоварБезСкидок");
	ИначеЕсли НЕ ЕстьСкидки И НЕ ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Итого|ТоварБезКодовИСкидок");
		
	КонецЕсли;

	ТабДокумент.Вывести(ОбластьНомера);
	Если ВыводитьКоды Тогда
		ТабДокумент.Присоединить(ОбластьКодов);
	КонецЕсли;
	ТабДокумент.Присоединить(ОбластьТовар);
	ТабДокумент.Присоединить(ОбластьДанных);
	Если ЕстьСкидки Тогда
		ОбластьСкидок.Параметры.ВсегоСкидок    = ВсегоСкидок;
		ОбластьСкидок.Параметры.ВсегоБезСкидок = ВсегоБезСкидок;
		ТабДокумент.Присоединить(ОбластьСкидок);
	КонецЕсли;
	ОбластьСуммы.Параметры.Всего = ОбщегоНазначения.ФорматСумм(Сумма);
	ТабДокумент.Присоединить(ОбластьСуммы);

	// Вывести ИтогоНДС
	Если Шапка.УчитыватьНДС И ЗапросТовары.Количество()>0 Тогда
		ОбластьНомера = Макет.ПолучитьОбласть("ИтогоНДС|НомерСтроки");
		ОбластьКодов  = Макет.ПолучитьОбласть("ИтогоНДС|КолонкаКодов");
		ОбластьДанных = Макет.ПолучитьОбласть("ИтогоНДС|Данные");
		ОбластьСкидок = Макет.ПолучитьОбласть("ИтогоНДС|Скидка");
		ОбластьСуммы  = Макет.ПолучитьОбласть("ИтогоНДС|Сумма");

		ОбластьТовар = Макет.ПолучитьОбласть("ИтогоНДС|Товар");
		Если Не ВыводитьКоды И ЕстьСкидки Тогда
			ОбластьТовар = Макет.ПолучитьОбласть("ИтогоНДС|ТоварБезКодов");
		ИначеЕсли НЕ ЕстьСкидки И ВыводитьКоды Тогда
			ОбластьТовар = Макет.ПолучитьОбласть("ИтогоНДС|ТоварБезСкидок");
		ИначеЕсли НЕ ЕстьСкидки И НЕ ВыводитьКоды Тогда
			ОбластьТовар = Макет.ПолучитьОбласть("ИтогоНДС|ТоварБезКодовИСкидок");
		КонецЕсли;

		ТабДокумент.Вывести(ОбластьНомера);
		Если ВыводитьКоды Тогда
			ТабДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		ОбластьТовар.Параметры.Заполнить(ВыборкаСтрокТовары);
		ТабДокумент.Присоединить(ОбластьТовар);
		ОбластьДанных.Параметры.НДС = ?(Шапка.СуммаВключаетНДС, "В том числе НДС:", "Сумма НДС:");
		ТабДокумент.Присоединить(ОбластьДанных);
		Если ЕстьСкидки Тогда
			ТабДокумент.Присоединить(ОбластьСкидок);
		КонецЕсли;
		ОбластьСуммы.Параметры.ВсегоНДС = ОбщегоНазначения.ФорматСумм(ЗапросТовары.Итог("СуммаНДС"));
		ТабДокумент.Присоединить(ОбластьСуммы);
		
		Если Тип = "Счет" Тогда
			ОбластьНомера = Макет.ПолучитьОбласть("ВсегоКОплате|НомерСтроки");
			ОбластьКодов  = Макет.ПолучитьОбласть("ВсегоКОплате|КолонкаКодов");
			ОбластьДанных = Макет.ПолучитьОбласть("ВсегоКОплате|Данные");
			ОбластьСкидок = Макет.ПолучитьОбласть("ВсегоКОплате|Скидка");
			ОбластьСуммы  = Макет.ПолучитьОбласть("ВсегоКОплате|Сумма");

			ОбластьТовар = Макет.ПолучитьОбласть("ВсегоКОплате|Товар");
			Если Не ВыводитьКоды И ЕстьСкидки Тогда
				ОбластьТовар = Макет.ПолучитьОбласть("ВсегоКОплате|ТоварБезКодов");
			ИначеЕсли НЕ ЕстьСкидки И ВыводитьКоды Тогда
				ОбластьТовар = Макет.ПолучитьОбласть("ВсегоКОплате|ТоварБезСкидок");
			ИначеЕсли НЕ ЕстьСкидки И НЕ ВыводитьКоды Тогда
				ОбластьТовар = Макет.ПолучитьОбласть("ВсегоКОплате|ТоварБезКодовИСкидок");
			КонецЕсли;

			ТабДокумент.Вывести(ОбластьНомера);
			Если ВыводитьКоды Тогда
				ТабДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			ОбластьТовар.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабДокумент.Присоединить(ОбластьТовар);
			ТабДокумент.Присоединить(ОбластьДанных);
			Если ЕстьСкидки Тогда
				ТабДокумент.Присоединить(ОбластьСкидок);
			КонецЕсли;
			ОбластьСуммы.Параметры.ВсегоКОплате = ОбщегоНазначения.ФорматСумм(Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС));
			ТабДокумент.Присоединить(ОбластьСуммы);
			
		КонецЕсли;
	КонецЕсли;

	// Вывести Сумму прописью
	ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
	СуммаКПрописи = Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС);
	ОбластьМакета.Параметры.ИтоговаяСтрока ="Всего наименований " + НумераторСтрок
	+ ", на сумму " + ОбщегоНазначения.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента);
	ОбластьМакета.Параметры.СуммаПрописью = ОбщегоНазначения.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента);
	ТабДокумент.Вывести(ОбластьМакета);

	// Вывести подписи
	Если Тип = "Счет" Тогда
		//Если  СсылкаНаОбъект.вцПечататьФаксимиле Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ПодвалСчетаСФаксимилле");
		//Иначе
			
		//	ОбластьМакета = Макет.ПолучитьОбласть("ПодвалСчета");
		//КонецЕсли;
		Руководители = РегламентированнаяОтчетность.ОтветственныеЛицаОрганизации(Шапка.Руководители, Шапка.Дата,);
		Руководитель = Руководители.Руководитель;
		ДолжностьРуководителя = Руководители.РуководительДолжность;
		Бухгалтер    = Руководители.ГлавныйБухгалтер;

		ОбластьМакета.Параметры.ФИОРуководителя  		= Руководитель;
		ОбластьМакета.Параметры.ДолжностьРуководителя  	= ДолжностьРуководителя;
		ОбластьМакета.Параметры.ФИОБухгалтера    		= Бухгалтер;
		
		Если НЕ ЗначениеЗаполнено(СсылкаНаОбъект.Ответственный.ФизЛицо) Тогда
			ФИООтветственный = СсылкаНаОбъект.Ответственный.Наименование;
		Иначе
			ФамилияИмяОтчествоФизЛица      	 = ФормированиеПечатныхФорм.ФамилияИмяОтчество(СсылкаНаОбъект.Ответственный.ФизЛицо, Шапка.Дата);
			ФамилияИмяОтчествоОтветственного = ФамилияИмяОтчествоФизЛица.Фамилия + " " + ФамилияИмяОтчествоФизЛица.Имя + " " + ФамилияИмяОтчествоФизЛица.Отчество;
			ФИООтветственный         		 = ОбщегоНазначения.ФамилияИнициалыФизЛица(ФамилияИмяОтчествоОтветственного);
		КонецЕсли;
		ОбластьМакета.Параметры.ФИООтветственный = ФИООтветственный;

	Иначе
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалЗаказа");
	КонецЕсли; 
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;

КонецФункции // ПечатьСчетаЗаказаКорректировки()