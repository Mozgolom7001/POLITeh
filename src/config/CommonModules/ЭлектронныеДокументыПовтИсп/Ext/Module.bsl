﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронныеДокументыПовтИсп: механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Заполняет массив актуальными видами электронных документов.
//
// Возвращаемое значение:
//  Массив - виды актуальных ЭД.
//
Функция ПолучитьАктуальныеВидыЭД() Экспорт
	
	МассивЭД = Новый Массив;
	ЭлектронныеДокументыПереопределяемый.ПолучитьАктуальныеВидыЭД(МассивЭД);
	
	Если ЗначениеЗаполнено(МассивЭД) Тогда
		МассивЭД.Добавить(Перечисления.ВидыЭД.Подтверждение);
		МассивЭД.Добавить(Перечисления.ВидыЭД.ИзвещениеОПолучении);
		МассивЭД.Добавить(Перечисления.ВидыЭД.УведомлениеОбУточнении);
		МассивЭД.Добавить(Перечисления.ВидыЭД.ПредложениеОбАннулировании);
	КонецЕсли;
	
	МассивЭД.Добавить(Перечисления.ВидыЭД.ПроизвольныйЭД);
	
	Возврат ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивЭД);
	
КонецФункции


// Формирует таблицу сведений о форматах электронных документов.
// Сведения задаются в макете Обработки.ЭлектронныеДокументы.ВерсииФорматовЭД.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - состав и типы колонок указаны в макете Обработки.ЭлектронныеДокументы.ВерсииФорматовЭД.
//
Функция СведенияОФорматахЭлектронныхДокументов() Экспорт

	Результат = Новый ТаблицаЗначений;
	Макет = Обработки.ЭлектронныеДокументы.ПолучитьМакет("ВерсииФорматовЭД");
	ОбрабатываемыеСсылочныеТипы = Новый Массив;
	ОбрабатываемыеСсылочныеТипы.Добавить(ОбщегоНазначения.ИмяТипаПеречисления());
	ОбрабатываемыеСсылочныеТипы.Добавить(ОбщегоНазначения.ИмяТипаПланыВидовХарактеристик());
	ОбрабатываемыеСсылочныеТипы.Добавить(ОбщегоНазначения.ИмяТипаСправочники());
	
	// Получим колонки таблицы форматов
	ОбластьШапки = Макет.ПолучитьОбласть("Шапка");
	Для Сч = 1 По ОбластьШапки.ШиринаТаблицы Цикл
		ИмяКолонки = ОбластьШапки.Область(1, Сч).Текст;
		Если ЗначениеЗаполнено(ИмяКолонки) Тогда
			ПредставлениеТипаКолонки = ОбластьШапки.Область(2, Сч).Текст;
			ТипКолонки = Новый ОписаниеТипов(ПредставлениеТипаКолонки);
			
			Результат.Колонки.Добавить(ИмяКолонки, ТипКолонки);
		КонецЕсли;
	КонецЦикла;
	
	// Заполним строки
	ОбластьСтрок = Макет.ПолучитьОбласть("Строки");
	Для НомерСтроки = 1 По ОбластьСтрок.ВысотаТаблицы Цикл
		Если ЗначениеЗаполнено(ОбластьСтрок.Область(НомерСтроки, 1).Текст) Тогда
			НоваяСтрока = Результат.Добавить();
			
			Для НомерКолонки = 1 По Результат.Колонки.Количество() Цикл
				Колонка = Результат.Колонки[НомерКолонки - 1];
				
				ТекстЯчейки = СокрЛП(ОбластьСтрок.Область(НомерСтроки, НомерКолонки).Текст);
				ТипЗначения = Колонка.ТипЗначения.Типы()[0];
				Если ОбщегоНазначения.ЭтоСсылка(ТипЗначения) Тогда
					МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗначения);
					ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
					ИмяБазовогоТипа = ОбщегоНазначения.ИмяБазовогоТипаПоОбъектуМетаданных(МетаданныеОбъекта);
					
					Если ОбрабатываемыеСсылочныеТипы.Найти(ИмяБазовогоТипа) <> Неопределено Тогда
						МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъекта);
						ЗначениеЯчейки = МенеджерОбъекта[ТекстЯчейки];
					Иначе
						ШаблонОшибки = НСтр("ru='В макете %1 использован неподдерживаемый ссылочный тип (%2)'");
						СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки, 
							Метаданные.Обработки.ЭлектронныеДокументы.Макеты.ВерсииФорматовЭД.Синоним, ПолноеИмяОбъекта);
						ВызватьИсключение СтрокаОшибки;
					КонецЕсли;
				Иначе	
					Если ТипЗначения = Тип("Дата") И ЗначениеЗаполнено(ТекстЯчейки) Тогда
						ЗначениеЯчейки = ЭлектронныеДокументыВнутренний.ДатаИзСтроки(ТекстЯчейки);
					ИначеЕсли ТипЗначения = Тип("Массив") И ЗначениеЗаполнено(ТекстЯчейки) Тогда
						 ПространстваИмен = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекстЯчейки, ",", Истина);
						 ЗначениеЯчейки = Новый Массив;
						 Для Каждого ПространствоИмен Из ПространстваИмен Цикл
						 	ЗначениеЯчейки.Добавить(СокрЛП(ПространствоИмен));
						 КонецЦикла;
					Иначе
						ЗначениеЯчейки = Колонка.ТипЗначения.ПривестиЗначение(ТекстЯчейки);
					КонецЕсли;
				КонецЕсли;
				
				НоваяСтрока[Колонка.Имя] = ЗначениеЯчейки;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

// Только для внутреннего использования
Функция ИмяНаличиеОбъектаРеквизитаВПрикладномРешении(ИмяПараметра) Экспорт
	
	СоответствиеРеквизитовОбъекта = Новый Соответствие;
	ЭлектронныеДокументыПереопределяемый.ПолучитьСоответствиеНаименованийОбъектовМДиРеквизитов(СоответствиеРеквизитовОбъекта);
	
	Возврат СоответствиеРеквизитовОбъекта.Получить(ИмяПараметра);
	
КонецФункции

// Возвращает пустую ссылку на справочник.
//
// Параметры:
//  ИмяСправочника - строка, название справочника.
//
// Возвращаемое значение:
//  Ссылка - пустая ссылка на справочник.
//
Функция ПолучитьПустуюСсылку(ИмяСправочника) Экспорт
	
	Результат = Неопределено;
	
	ИмяПрикладногоСправочника = ПолучитьИмяПрикладногоСправочника(ИмяСправочника);
	Если ЗначениеЗаполнено(ИмяПрикладногоСправочника) Тогда
		Результат = Справочники[ИмяПрикладногоСправочника].ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает имя прикладного справочника по имени библиотечного справочника.
//
// Параметры:
//  ИмяСправочника - строка - название справочника из библиотеки.
//
// Возвращаемое значение:
//  ИмяПрикладногоСправочника - строковое имя прикладного справочника.
//
Функция ПолучитьИмяПрикладногоСправочника(ИмяСправочника) Экспорт
	
	СоответствиеСправочников = Новый Соответствие;
	ЭлектронныеДокументыПереопределяемый.ПолучитьСоответствиеСправочников(СоответствиеСправочников);
	
	ИмяПрикладногоСправочника = СоответствиеСправочников.Получить(ИмяСправочника);
	Если ИмяПрикладногоСправочника = Неопределено Тогда // не задано соответствие
		ШаблонСообщения = НСтр("ru = 'В коде прикладного решения необходимо указать соответствие для справочника %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяСправочника);
		ЭлектронныеДокументыСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(ТекстСообщения,
			2, УровеньЖурналаРегистрации.Предупреждение);
	КонецЕсли;
	
	Возврат ИмяПрикладногоСправочника;
	
КонецФункции

// Только для внутреннего использования
Функция ПрикладноеПредставлениеРеквизита(Код) Экспорт
	
	СоответствиеКодовРеквизитовИПредставлений = Новый Соответствие;
	
	Макет = Обработки.ЭлектронныеДокументы.ПолучитьМакет("ПрикладноеПредставлениеРеквизитов");
	ВысотаТаблицы = Макет.ВысотаТаблицы;
	Для НСтр = 1 По ВысотаТаблицы Цикл
		СоответствиеКодовРеквизитовИПредставлений.Вставить(СокрЛП(Макет.Область(НСтр, 1).Текст), СокрЛП(Макет.Область(НСтр,2).Текст));
	КонецЦикла;
	
	ЭлектронныеДокументыПереопределяемый.СоответствиеКодовРеквизитовИПредставлений(СоответствиеКодовРеквизитовИПредставлений);
	Возврат СоответствиеКодовРеквизитовИПредставлений.Получить(Код);
	
КонецФункции

// Получает значение перечисления по имени объектов метаданных.
// 
// Параметры:
//  Наименование - Строка, наименование перечисления.
//  ПредставлениеПеречисления - Строка, наименование значения перечисления.
//
// Возвращаемое значение:
//  НайденноеЗначение - значение искомого перечисления.
//
Функция НайтиПеречисление(Знач ИмяПеречисления, ПредставлениеПеречисления) Экспорт
	
	НайденноеЗначение = Неопределено;
	
	СоответствиеПеречислений = Новый Соответствие;
	ЭлектронныеДокументыПереопределяемый.ПолучитьСоответствиеПеречислений(СоответствиеПеречислений);
	
	ИмяПрикладногоПеречисления = СоответствиеПеречислений.Получить(ИмяПеречисления);
	Если ИмяПрикладногоПеречисления = Неопределено Тогда // не задано соответствие
		ШаблонСообщения = НСтр("ru = 'В коде прикладного решения необходимо указать соответствие для перечисления %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяПеречисления);
		ЭлектронныеДокументыСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(ТекстСообщения,
			2, УровеньЖурналаРегистрации.Предупреждение);
	ИначеЕсли ЗначениеЗаполнено(ИмяПрикладногоПеречисления) Тогда // задано какое-то значение
		ЭлектронныеДокументыПереопределяемый.ПолучитьЗначениеПеречисления(
			ИмяПрикладногоПеречисления, ПредставлениеПеречисления, НайденноеЗначение);
		Если НайденноеЗначение = Неопределено Тогда
			Для Каждого ЭлПеречисления Из Метаданные.Перечисления[ИмяПрикладногоПеречисления].ЗначенияПеречисления Цикл
				Если Врег(ЭлПеречисления.Синоним) = Врег(ПредставлениеПеречисления)
					ИЛИ Врег(ЭлПеречисления.Имя) = Врег(ПредставлениеПеречисления) Тогда
					НайденноеЗначение = Перечисления[ИмяПрикладногоПеречисления][ЭлПеречисления.Имя];
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НайденноеЗначение;
	
КонецФункции

// Возвращает описание параметра для прикладного решения.
//
// Параметры:
//  Источник - ссылка, к которой относится параметр.
//  Параметр - строка, наименование реквизита.
//
// Возвращаемое значение:
//  Результат - строка - пользовательское описание реквизита.
//
Функция ПолучитьПользовательскоеПредставление(Источник, Параметр) Экспорт
	
	Результат = Параметр;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипИсточника", ТипЗнч(Источник));
	ПараметрыОтбора.Вставить("Параметр", Параметр);
	
	ТаблицаЗначений = ПолучитьТаблицуСоответствияПараметровПользовательскимПредставлениям();
	
	НайденныеСтроки = ТаблицаЗначений.НайтиСтроки(ПараметрыОтбора);
	Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
		
		ПользовательскоеПредставление = НайденныеСтроки[0].Представление;
		Если ЗначениеЗаполнено(ПользовательскоеПредставление) Тогда
			Результат = ПользовательскоеПредставление;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает таблицу с ключевыми реквизитами объекта
// 
// Параметры 
//  ИмяОбъекта - строка, имя объекта конфигурации, ключевые реквизиты которого необходимо получить.
//
Функция ПолучитьТаблицуКлючевыхРеквизитовОбъекта(ИмяОбъекта) Экспорт
	
	ТаблицаРеквизитов = ИнициализацияТаблицыРеквизитовОбъектов();
	
	Если ИмяОбъекта = "Документ.ПакетЭД" Тогда
		Возврат ТаблицаРеквизитов;
	КонецЕсли;
	
	СтруктураКлючевыхРеквизитов = Новый Структура;
	Если ИмяОбъекта = "Документ.ПроизвольныйЭД" Тогда
		СтрокаРеквизитовОбъекта = "Организация, Контрагент";
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
	Иначе
		ЭлектронныеДокументыПереопределяемый.ПолучитьСтруктуруКлючевыхРеквизитовОбъекта(ИмяОбъекта, СтруктураКлючевыхРеквизитов);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(СтруктураКлючевыхРеквизитов) Тогда
		ШаблонСообщения = НСтр("ru = 'Не определена структура ключевых реквизитов для объекта %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяОбъекта);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	ТекПорядок = -50;
	Для Каждого ТекЭлемент Из СтруктураКлючевыхРеквизитов Цикл
		НовСтрока                            = ТаблицаРеквизитов.Добавить();
		НовСтрока.Порядок                    = ТекПорядок;
		НовСтрока.ИмяОбъекта                 = ИмяОбъекта;
		НовСтрока.ИмяТабличнойЧасти          = ?(ТекЭлемент.Ключ = "Шапка", "", ТекЭлемент.Ключ);
		НовСтрока.РеквизитыОбъекта           = ТекЭлемент.Значение;
		НовСтрока.СтруктураРеквизитовОбъекта = Новый Структура(ТекЭлемент.Значение);
		ТекПорядок = ТекПорядок + 100;
	КонецЦикла;
	
	ТаблицаРеквизитов.Сортировать("Порядок Возр");
	
	Возврат ТаблицаРеквизитов;
	
КонецФункции

// Процедура возвращает признак использования справочника Партнеров в качестве
// дополнительной аналитики к справочнику Контрагенты.
//
// Возвращаемое значение:
//  ИспользуетсяСправочникПартнеры - Булево - флаг использования в библиотеке справочника Партеры.
//
Функция ИспользуетсяДополнительнаяАналитикаКонтрагентовСправочникПартнеры() Экспорт

	ИспользуетсяСправочникПартнеры = Ложь;
	ЭлектронныеДокументыПереопределяемый.ДополнительнаяАналитикаКонтрагентовСправочникПартнеры(ИспользуетсяСправочникПартнеры);
	
	Возврат ИспользуетсяСправочникПартнеры;
	
КонецФункции

// Функция возвращает признак использования справочника "Характеристики номенклатуры" в качестве
// дополнительной аналитики к справочнику Номенклатура.
//
// Возвращаемое значение:
//  Булево - флаг использования в библиотеке справочника "Характеристики номенклатуры".
//
Функция ДополнительнаяАналитикаСправочникХарактеристикиНоменклатуры() Экспорт

	ИспользуетсяСправочникХарактеристикиНоменклатуры = Ложь;
	ЭлектронныеДокументыПереопределяемый.ДополнительнаяАналитикаСправочникХарактеристикиНоменклатуры(ИспользуетсяСправочникХарактеристикиНоменклатуры);
	
	Возврат ИспользуетсяСправочникХарактеристикиНоменклатуры;
	
КонецФункции

// Функция возвращает признак использования справочника "Упаковки номенклатуры" в качестве
// дополнительной аналитики к справочнику Номенклатура.
//
// Возвращаемое значение:
//  Булево - флаг использования в библиотеке справочника "Упаковки номенклатуры".
//
Функция ДополнительнаяАналитикаСправочникУпаковкиНоменклатуры() Экспорт

	ИспользуетсяСправочникУпаковкиНоменклатуры = Ложь;
	ЭлектронныеДокументыПереопределяемый.ДополнительнаяАналитикаСправочникУпаковкиНоменклатуры(ИспользуетсяСправочникУпаковкиНоменклатуры);
	
	Возврат ИспользуетсяСправочникУпаковкиНоменклатуры;
	
КонецФункции

// Возвращает версию пакета xdto схемы CML 2.06.
Функция ВерсияСхемыCML2() Экспорт
	
	Возврат "CML 2.08";
	
КонецФункции

// Возвращает версию пакета xdto схемы CML 4.02.
Функция ВерсияСхемыCML402() Экспорт
	
	Возврат "CML 4.02";
	
КонецФункции

// Возвращает пространство имен используемой схемы CML
Функция ПространствоИменCML() Экспорт
	
	Возврат "urn:1C.ru:commerceml_2";
	
КонецФункции

// Только для внутреннего использования
Функция СоответствиеКириллицыИЛатиницы() Экспорт
	// транслитерация, используемая в загранпаспортах 1997-2010 гг.
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("а","a");
	Соответствие.Вставить("б","b");
	Соответствие.Вставить("в","v");
	Соответствие.Вставить("г","g");
	Соответствие.Вставить("д","d");
	Соответствие.Вставить("е","e");
	Соответствие.Вставить("ё","e");
	Соответствие.Вставить("ж","zh");
	Соответствие.Вставить("з","z");
	Соответствие.Вставить("и","i");
	Соответствие.Вставить("й","y");
	Соответствие.Вставить("к","k");
	Соответствие.Вставить("л","l");
	Соответствие.Вставить("м","m");
	Соответствие.Вставить("н","n");
	Соответствие.Вставить("о","o");
	Соответствие.Вставить("п","p");
	Соответствие.Вставить("р","r");
	Соответствие.Вставить("с","s");
	Соответствие.Вставить("т","t");
	Соответствие.Вставить("у","u");
	Соответствие.Вставить("ф","f");
	Соответствие.Вставить("х","kh");
	Соответствие.Вставить("ц","ts");
	Соответствие.Вставить("ч","ch");
	Соответствие.Вставить("ш","sh");
	Соответствие.Вставить("щ","shch");
	Соответствие.Вставить("ъ","""");
	Соответствие.Вставить("ы","y");
	Соответствие.Вставить("ь",""); // пропускается
	Соответствие.Вставить("э","e");
	Соответствие.Вставить("ю","yu");
	Соответствие.Вставить("я","ya");
	
	Возврат Соответствие;
КонецФункции

Функция СопоставлениеИменПолейАдресаФНС_CML(ИмяПоля, CMLвФНС = Истина) Экспорт
	
	СопоставленноеИмя = ИмяПоля;
	ТЗСопоставления = ТЗСопоставленияПолейАдресаФНС_CML();
	СтрокаТЗ = ТЗСопоставления.Найти(ИмяПоля, ?(CMLвФНС, "ПредставлениеCML", "ПредставлениеФНС"));
	Если СтрокаТЗ <> Неопределено Тогда
		СопоставленноеИмя = СтрокаТЗ[?(CMLвФНС, "ПредставлениеФНС", "ПредставлениеCML")];
	КонецЕсли;
	
	Возврат СопоставленноеИмя;
	
КонецФункции

// Функция возвращает соответствующее переданному параметру значение ставки НДС.
// Если в функцию передан параметр ПредставлениеБЭД, то функция вернет ПрикладноеЗначение ставки НДС и наоборот.
//
// Параметры:
//   ПредставлениеБЭД - Строка - строковое представление ставки НДС.
//   ПрикладноеЗначение - ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - прикладное представление
//     соответствующего значения ставки НДС.
//
// Возвращаемое значение:
//   Строка, ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - соответствующее представление ставки НДС.
//
Функция СтавкаНДСИзСоответствия(ПредставлениеБЭД = "", ПрикладноеЗначение = Неопределено) Экспорт
	
	Соответствие = Новый Соответствие;
	ЭлектронныеДокументыПереопределяемый.ЗаполнитьСоответствиеСтавокНДС(Соответствие);
	Значение = Неопределено;
	Если ЗначениеЗаполнено(ПредставлениеБЭД) Тогда
		Значение = Соответствие.Получить(ПредставлениеБЭД);
	Иначе
		Для Каждого КлючИЗначение Из Соответствие Цикл
			Если КлючИЗначение.Значение = ПрикладноеЗначение Тогда
				Значение = КлючИЗначение.Ключ;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

// Функция преобразует строковое представление ставки НДС (внутреннее представление БЭД) в числовое.
//
// Параметры:
//   СтрокаСтавкаНДС - Строка - строковое представление ставки НДС.
//
// Возвращаемое значение:
//   Число - числовое представление ставки НДС.
//
Функция СтавкаНДСЧислом(СтрокаСтавкаНДС) Экспорт
	
	СтавкаНДС = СтрЗаменить(СтрокаСтавкаНДС, "\", "/");
	ПозицияСимвола = Найти(СтавкаНДС, "/");
	Если ПозицияСимвола > 0 Тогда
		СтавкаЧислом = Окр(Вычислить(СтавкаНДС) * 100, 4);
	Иначе
		СтавкаЧислом = Число(СтавкаНДС);
	КонецЕсли;
	
	Возврат СтавкаЧислом;
	
КонецФункции

// Функция возвращает соответствующее переданному параметру значение ставки НДС.
// Если в функцию передан параметр ПредставлениеБЭД, то функция вернет ПрикладноеЗначение ставки НДС и наоборот.
//
// Параметры:
//   ПредставлениеБЭД - Строка - строковое представление ставки НДС.
//   ПрикладноеЗначение - ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - прикладное представление
//     соответствующего значения ставки НДС.
//
// Возвращаемое значение:
//   Строка, ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - соответствующее представление ставки НДС.
//
Функция СтавкаНДСПеречисление(СтавкаНДС) Экспорт
	
	Соответствие = Новый Соответствие;
	ЭлектронныеДокументыПереопределяемый.ЗаполнитьСоответствиеСтавокНДС(Соответствие);
	
	Для Каждого КлючИЗначение Из Соответствие Цикл
		Если КлючИЗначение.Значение = СтавкаНДС Тогда
			Значение = КлючИЗначение.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Значение = "0" Или Значение = "10" Или Значение = "18" Тогда
		Значение = Значение + "%";
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

// Функция преобразует из представления ставки НДС в значение перечисления.
//
// Параметры:
//  СтавкаЧислом - Число - численное представление ставки НДС;
//               - Строка - строковое представление ставки НДС.
//
// Возвращаемое значение:
//   ПеречислениеСсылка, СправочникСсылка, Неопределено - значение ставки НДС прикладного решения.
//
Функция СтавкаНДСИзПредставления(ПредставлениеСтавкиНДС) Экспорт
	
	ЗначениеНДС = Неопределено;
	
	Если ТипЗнч(ПредставлениеСтавкиНДС) = Тип("Строка") Тогда
		СтрСтавкаНДС = СокрЛП(ПредставлениеСтавкиНДС);
	ИначеЕсли ТипЗнч(ПредставлениеСтавкиНДС) = Тип("Число") Тогда
		СтрСтавкаНДС = Строка(ПредставлениеСтавкиНДС);
	Иначе // неправильный тип
		СтрСтавкаНДС = Неопределено;
	КонецЕсли;
	
	Если СтрСтавкаНДС = Неопределено ИЛИ Найти("БЕЗ НДС", ВРег(СтрСтавкаНДС)) > 0 Тогда
		ЗначениеНДС = "без НДС";
	Иначе
		СтрСтавкаНДС = СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрСтавкаНДС, ",", "."), "\", "/"), " ", ""), "%", "");
		// # - разделитель представлений ставок.
		Если Найти("0", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "0";
		ИначеЕсли Найти("10#0.1#0.10", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "10";
		ИначеЕсли Найти("18#0.18", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "18";
		ИначеЕсли Найти("20#0.2#0.20", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "20";
		ИначеЕсли Найти("10/110#0.0909#9.0909", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "10/110";
		ИначеЕсли Найти("18/118#0.1525#15.2542", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "18/118";
		ИначеЕсли Найти("20/120#0.1667#16.6667", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "20/120";
		Иначе
			ЗначениеНДС = ПредставлениеСтавкиНДС;
		КонецЕсли;
	КонецЕсли;
	
	СтавкаНДС = СтавкаНДСИзСоответствия(ЗначениеНДС);
	
	Возврат СтавкаНДС;
	
КонецФункции

// Возвращает КНД, соответствующий переданному в параметре Виду ЭД
//
// Параметры:
//   ВидЭД - ПеречислениеСсылка.ВидыЭД.
//
// Возвращаемое значение:
//   Строка - соотвествующий переданному виду ЭД КНД.
//   Неопределено, если для переданного вида ЭД не указано соответствие КНД.
//
Функция КНДПоВидуЭД(СвойстваДокумента) Экспорт
	
	ВидЭД = СвойстваДокумента.ВидЭД;
	ТипЭлементаВерсииЭД = СвойстваДокумента.ТипЭлементаВерсииЭД;
	
	Подтверждение = Ложь;
	Если СвойстваДокумента.Свойство("Подтверждение") Тогда
		 Подтверждение = Истина;
	КонецЕсли;
	
	Если ВидЭД = Перечисления.ВидыЭД.СчетФактура Тогда
		Если ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовВерсииЭД.ЭСФ Тогда
			КНД = "1115101";
		Иначе
			КНД = "1115125";
			Если Подтверждение Тогда
				КНД = "1115126";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидЭД = Перечисления.ВидыЭД.КорректировочныйСчетФактура Тогда
		Если ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовВерсииЭД.ЭСФ Тогда
			КНД = "1115108";
		Иначе
			КНД = "1115127";
			Если Подтверждение Тогда
				КНД = "1115128";
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;

	Если ВидЭД = Перечисления.ВидыЭД.ТОРГ12Продавец Тогда
		Если ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовВерсииЭД.ПервичныйЭД Тогда
			КНД = "1175004";
			Если Подтверждение Тогда
				КНД = "1175005";
			КонецЕсли;

		Иначе
			КНД = "1175010";
			Если Подтверждение Тогда
				КНД = "1175011";
			КонецЕсли;

		КонецЕсли;
		
	КонецЕсли;
	
	Если ВидЭД = Перечисления.ВидыЭД.АктИсполнитель Тогда
		Если ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовВерсииЭД.ПервичныйЭД Тогда
			КНД = "1175006";
			Если Подтверждение Тогда
				КНД = "1175007";
			КонецЕсли;
		Иначе
			КНД = "1175012";
			Если Подтверждение Тогда
				КНД = "1175013";
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;
	
	Возврат КНД;
	
КонецФункции


// Возвращает представление документа ИБ для вида электронного документа.
//
// Параметры:
//  ВидЭД - перечисление - вид электронного документа.
//
// Возвращаемое значение:
//  ПредставлениеОснования - строковое имя документа информационной базы, на основании которого формируется исходящий ЭД.
//
Функция ПредставлениеОснованияДляВидаЭД(ВидЭД) Экспорт
	
	МассивЭД = Новый Массив;
	ЭлектронныеДокументыПереопределяемый.ПолучитьАктуальныеВидыЭД(МассивЭД);
	
	СоответствиеВидовЭДДокументамИБ = Новый Соответствие;
	Для каждого ЭлементВидЭД Из МассивЭД Цикл
		Если ЭлементВидЭД <> Перечисления.ВидыЭД.ТОРГ12Покупатель
			И ЭлементВидЭД <> Перечисления.ВидыЭД.АктЗаказчик
			И ЭлементВидЭД <> Перечисления.ВидыЭД.СоглашениеОбИзмененииСтоимостиПолучатель
			И ЭлементВидЭД <> Перечисления.ВидыЭД.ПередачаТоваровМеждуОрганизациями
			И ЭлементВидЭД <> Перечисления.ВидыЭД.ВозвратТоваровМеждуОрганизациями
			И ЭлементВидЭД <> Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
		
			СоответствиеВидовЭДДокументамИБ.Вставить(ЭлементВидЭД, "");
		КонецЕсли;
	КонецЦикла;
	
	ЭлектронныеДокументыПереопределяемый.СоответствиеИсходящихВидовЭДДокументамИБ(СоответствиеВидовЭДДокументамИБ);
	
	// Электронное взаимодействие
	СоответствиеВидовЭДДокументамИБ.Вставить(Перечисления.ВидыЭД.ПроизвольныйЭД, НСтр("ru = 'Исходящий произвольный документ'"));
	
	ПредставлениеОснования = СоответствиеВидовЭДДокументамИБ.Получить(ВидЭД);
	Если ПредставлениеОснования = Неопределено Тогда // не задано соответствие
		ШаблонСообщения = НСтр("ru = 'В переопределяемом модуле прикладного решения необходимо указать представление документаИБ(основания) и хоз. операции для вида ЭД %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ВидЭД);
		ЭлектронныеДокументыСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(ТекстСообщения, 0, УровеньЖурналаРегистрации.Предупреждение);
	КонецЕсли;
	
	Возврат ПредставлениеОснования;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработка ошибок

// Возвращает текст сообщения пользователю по коду ошибки.
//
// Параметры:
//  КодОшибки - строка, код ошибки;
//  СтороннееОписаниеОшибки - строка, описание ошибки переданное другой системой.
//
// Возвращаемое значение:
//  ТекстСообщения - строка - переопределенное описание ошибки.
//
Функция ПолучитьСообщениеОбОшибке(КодОшибки, СтороннееОписаниеОшибки = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ШаблонСообщения = НСтр("ru = 'Код ошибки %1. %2'");
	
	СообщенияОшибок = Новый Соответствие;
	ИнициализацияСообщенийОшибок(СообщенияОшибок);
	
	СообщениеОбОшибке = СообщенияОшибок.Получить(КодОшибки);
	Если СообщениеОбОшибке = Неопределено ИЛИ НЕ ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
		СообщениеОбОшибке = СтороннееОписаниеОшибки;
	КонецЕсли;
	
	ЭлектронныеДокументыПереопределяемый.ИзменитьСообщениеОбОшибке(КодОшибки, СообщениеОбОшибке);
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КодОшибки, СообщениеОбОшибке);
	
	Возврат ТекстСообщения;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Получает таблицу соответствий параметров для типов метаданных их пользовательским представлениям.
//
// Параметры:
//  ТаблицаСоответствия - таблица - соответствие параметров для типов метаданных их пользовательским представлениям.
//
Функция ПолучитьТаблицуСоответствияПараметровПользовательскимПредставлениям()
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("ТипИсточника");
	ТаблицаЗначений.Колонки.Добавить("Параметр");
	ТаблицаЗначений.Колонки.Добавить("Представление");
	
	ЭлектронныеДокументыПереопределяемый.ПолучитьТаблицуСоответствияПараметровПользовательскимПредставлениям(
		ТаблицаЗначений);
	
	Возврат ТаблицаЗначений;
	
КонецФункции

Функция ИнициализацияТаблицыРеквизитовОбъектов()
	
	ТаблицаРеквизитов = Новый ТаблицаЗначений;
	
	Колонки = ТаблицаРеквизитов.Колонки;
	Колонки.Добавить("Порядок",                    Новый ОписаниеТипов("Число"));
	Колонки.Добавить("ИмяОбъекта",                 Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("ИмяТабличнойЧасти",          Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("РеквизитыОбъекта",           Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("СтруктураРеквизитовОбъекта", Новый ОписаниеТипов("Структура"));
	
	ТаблицаРеквизитов.Индексы.Добавить("ИмяОбъекта");
	
	Возврат ТаблицаРеквизитов;
	
КонецФункции

Процедура ИнициализацияСообщенийОшибок(СообщенияОшибок)
	
	// Общие коды ошибок
	СообщенияОшибок.Вставить("001", );
	СообщенияОшибок.Вставить("002", );
	СообщенияОшибок.Вставить("003", );
	СообщенияОшибок.Вставить("004", );
	СообщенияОшибок.Вставить("005", );
	СообщенияОшибок.Вставить("006", НСтр("ru = 'Невозможно извлечь файлы из архива. Путь к файлам архива должен быть короче 256 символов.
										|Возможные способы устранения ошибки:
										| - в настройках операционнной системы, в переменных среды, изменить путь к временным файлам;
										| - изменить размещение каталога временных файлов в процедуре ""ЭлектронныеДокументыПереопределяемый.ТекущийКаталогВременныхФайлов"".'"));
	// Коды ошибок 1С
	СообщенияОшибок.Вставить("0", НСтр("ru = 'Одна из имеющихся в запросе подписей принадлежит неизвестному лицу.'"));
	СообщенияОшибок.Вставить("2", НСтр("ru = 'Одна из подписей неверна'"));
	СообщенияОшибок.Вставить("3", НСтр("ru = 'Должны быть представлены две разные подписи.'"));
	СообщенияОшибок.Вставить("4", НСтр("ru = 'Неверный тип содержимого: двоичный.'"));
	СообщенияОшибок.Вставить("5", НСтр("ru = 'Должна быть предоставлена хотя бы одна подпись.'"));
	СообщенияОшибок.Вставить("6", НСтр("ru = 'Не все подписи отличаются.'"));
	СообщенияОшибок.Вставить("7", НСтр("ru = 'Все подписи не обеспечивают уровень полномочий, необходимых для операции.'"));
	СообщенияОшибок.Вставить("8", НСтр("ru = 'Один из подписантов неизвестен.'"));
	СообщенияОшибок.Вставить("9", НСтр("ru = 'Содержимое типа транспортного сообщения является неправильным, ожидается: application/xml.'"));
	СообщенияОшибок.Вставить("10", НСтр("ru = 'Содержимое типа делового сообщения неверно, ожидается: application/xml.'"));
	СообщенияОшибок.Вставить("11", НСтр("ru = 'Не все подписи соответствуют одному и тому же клиенту.'"));
	СообщенияОшибок.Вставить("12", НСтр("ru = 'Всех имеющихся в запросе подписей недостаточно для того, чтобы получить право на доступ к запрашиваемому счету.'"));
	СообщенияОшибок.Вставить("13", НСтр("ru = 'HTTP запрос URL неверный. Поддерживаются только запросы ресурсов и состояния.'"));
	СообщенияОшибок.Вставить("14", НСтр("ru = 'Ошибка проверки транспортного контейнера.'"));
	СообщенияОшибок.Вставить("15", НСтр("ru = 'Ошибка проверки контейнера бизнес данных.
	                                          |Необходимо обратиться в тех.поддержку банка'"));
	СообщенияОшибок.Вставить("16", НСтр("ru = 'В выписке счета слишком малая начальная дата.'"));
	СообщенияОшибок.Вставить("17", НСтр("ru = 'В выписке счета слишком большая конечная дата.'"));
	СообщенияОшибок.Вставить("18", НСтр("ru = 'Неверная дата документа.'"));
	СообщенияОшибок.Вставить("19", НСтр("ru = 'Счет банка не соответствует БИК.'"));
	СообщенияОшибок.Вставить("21", НСтр("ru = 'Неразрешенная инструкция.'"));
	
	СообщенияОшибок.Вставить("100", НСтр("ru = 'Не удалось создать менеджер криптографии на компьютере.'"));
	СообщенияОшибок.Вставить("101", НСтр("ru = 'Сертификат не найден в хранилище сертификатов на компьютере.'"));
	СообщенияОшибок.Вставить("102", НСтр("ru = 'Сертификат не действителен.'"));
	СообщенияОшибок.Вставить("103", НСтр("ru = 'Не удалось выполнить операции шифрования/расшифровки на компьютере.'"));
	СообщенияОшибок.Вставить("104", НСтр("ru = 'Не удалось выполнить операции формирования/проверки ЭЦП на компьютере.'"));
	СообщенияОшибок.Вставить("105", НСтр("ru = 'Нет доступных сертификатов в хранилище сертификатов на компьютере.'"));
	
	СообщенияОшибок.Вставить("110", НСтр("ru = 'Не удалось создать менеджер криптографии на сервере.'"));
	СообщенияОшибок.Вставить("111", НСтр("ru = 'Сертификат не найден в хранилище сертификатов на сервере.'"));
	СообщенияОшибок.Вставить("112", НСтр("ru = 'Сертификат не действителен.'"));
	СообщенияОшибок.Вставить("113", НСтр("ru = 'Не удалось выполнить операции шифрования/расшифровки на сервере.'"));
	СообщенияОшибок.Вставить("114", НСтр("ru = 'Не удалось выполнить операции формирования/проверки ЭЦП на сервере.'"));
	СообщенияОшибок.Вставить("115", НСтр("ru = 'Нет доступных сертификатов в хранилище сертификатов на сервере.'"));
	
	СообщенияОшибок.Вставить("106", НСтр("ru = 'Версия платформы 1С ниже ""8.2.17"".'"));
	СообщенияОшибок.Вставить("107", НСтр("ru = 'Не удалось создать каталоги обмена.'"));
	
	СообщенияОшибок.Вставить("121", НСтр("ru = 'Не удалось соединиться с FTP сервером.'"));
	СообщенияОшибок.Вставить("122", НСтр("ru = 'Невозможно создать каталог, так как на FTP ресурсе существует файл с таким именем.'"));
	СообщенияОшибок.Вставить("123", НСтр("ru = 'Невозможно создать каталог.'"));
	СообщенияОшибок.Вставить("124", НСтр("ru = 'Невозможно открыть каталог.'"));
	СообщенияОшибок.Вставить("125", НСтр("ru = 'Произошла ошибка при поиске файлов на FTP ресурсе.'"));
	СообщенияОшибок.Вставить("126", НСтр("ru = 'Различаются данные записанного, а затем прочитанного тестового файла в каталоге.'"));
	СообщенияОшибок.Вставить("127", НСтр("ru = 'Не удалось записать файл в каталог.'"));
	СообщенияОшибок.Вставить("128", НСтр("ru = 'Не удалось прочитать файл в каталоге."));
	СообщенияОшибок.Вставить("129", НСтр("ru = 'Не удалось удалить файл.'"));
	
	// Коды ошибок оператора Такском
	// Метод CertificateLogin: идентификация и авторизация
	// Синхронный режим без обращения к БД
	СообщенияОшибок.Вставить("2501", ); // Не указан идентификатор вендора (название параметра?) 400 0501
	СообщенияОшибок.Вставить("3109", ); // Не указан сертификат 403 3100
	СообщенияОшибок.Вставить("3107", ); // Некорректное тело сертификата 403 3107
	СообщенияОшибок.Вставить("3101", ); // Сертификат просрочен 403 3101
	СообщенияОшибок.Вставить("3102", ); // Для указанного сертификата не удалось построить цепочку доверия 403 3102
	
	// Синхронный режим с обращением в БД
	СообщенияОшибок.Вставить("1301", ); // Вендор с указанным идентификатором не прошел авторизацию 401 1300
	СообщенияОшибок.Вставить("3103", ); // Сертификат не связан ни с одним абонентом Такском 403 3103
	СообщенияОшибок.Вставить("3104", ); // Сертификат связан с несколькими абонентами, но не указан идентификатор абонента (TaxcomID) 403 3104
	СообщенияОшибок.Вставить("3105", ); // Сертификат связан с несколькими абонентами, но указанный идентификатор абонента (TaxcomID) имеет неправильный формат 403 3105
	СообщенияОшибок.Вставить("3106", ); // Сертификат связан с несколькими абонентами, но указанный идентификатор абонента (TaxcomID) не связан ни с одним абонентом Такском 403 3106
	СообщенияОшибок.Вставить("1102", ); // Абоненту запрещен доступ к API 401 1100
	СообщенияОшибок.Вставить("1101", ); // Доступ для данного абонента заблокирован 401 1101
	СообщенияОшибок.Вставить("3108", ); // Сертификат отозван (в будущем) 403 3108
	
	// Метод SendMessage: загрузка транспортных контейнеров
	// Синхронный режим без обращения к БД
	СообщенияОшибок.Вставить("1201", ); // Истек 5-ти минутный срок действия токена (требуется повторная авторизация) 401 1200
	СообщенияОшибок.Вставить("2118", ); // Размер отправляемого контейнера не соответствует допустимому диапазону от 0 до (цифра!) 400 0100
	СообщенияОшибок.Вставить("2107", ); // Отправляемый контейнер не является ZIP-архивом 400 0107
	СообщенияОшибок.Вставить("2108", ); // В контейнере отсутствует необходимый файл meta.xml 400 0108
	СообщенияОшибок.Вставить("2109", ); // Файл meta.xml не является XML-файлом (стандарты?) 400 0109
	СообщенияОшибок.Вставить("2111", ); // Структура файла meta.xml не соответствует принятой схеме 400 0111
	СообщенияОшибок.Вставить("2101", ); // В файле meta.xml не указан корректный идентификатор документооборота (DocFlowID) 400 0101
	СообщенияОшибок.Вставить("2102", ); // В отправляемом контейнере обнаружены файлы, связанные более чем с одним документооборотом 400 0102
	СообщенияОшибок.Вставить("2113", ); // В данном документообороте возможна отправка только одного файла 400 0113
	СообщенияОшибок.Вставить("2103", ); // В файле meta.xml отсутствует код регламента (ReglamentCode) 400 0103
	СообщенияОшибок.Вставить("2114", ); // В файле meta.xml указан некорректный код регламента (ReglamentCode) 400 0114
	СообщенияОшибок.Вставить("2104", ); // В файле meta.xml отсутствует код транзакции (TransactionCode) 400 0104
	СообщенияОшибок.Вставить("2303", ); // Транзакция с кодом <TransactionCode> недопустима в документообороте < ReglamentCode > 400 0300
	СообщенияОшибок.Вставить("3108", ); // Файл <имя файла>, указанный в meta.xml, не найден в отправляемом контейнере 400 0105
	СообщенияОшибок.Вставить("0110", ); // Файл card.xml не является XML-файлом 400 0110
	СообщенияОшибок.Вставить("0112", ); // Структура файла card.xml не соответствует принятой схеме 400 0112
	СообщенияОшибок.Вставить("0106", НСтр("ru = 'В соглашении указан идентификатор организации некорректного формата.'")); // Неверный формат идентификатора отправителя (название параметра?) в файле card.xml 400 0106
	СообщенияОшибок.Вставить("0115", ); // Неверный формат идентификатора получателя (название параметра?) в файле card.xml 400 0115
	
	// Синхронный режим с обращением к БД
	СообщенияОшибок.Вставить("0201", ); // Идентификатор отправителя (название параметра?) соответствует учетной записи 400 0201
	СообщенияОшибок.Вставить("0401", ); // Документооборот с указанным идентификатором уже зарегистрирован (DocFlowID) 400 0401
	СообщенияОшибок.Вставить("0402", ); // Документооборот с указанным идентификатором не зарегистрирован (DocFlowID) 400 0402
	СообщенияОшибок.Вставить("0301", ); // Данная транзакция <код транзакции> уже была осуществлена для данного документооборота < DocFlowID > 400 0301
	
	// Асинхронный режим
	СообщенияОшибок.Вставить("0202", НСтр("ru = 'В соглашении указан идентификатор контрагента не зарегистрированный в Такском.'")); // Получатель с указанным идентификатором не зарегистрирован 0202
	СообщенияОшибок.Вставить("0203", ); // Получатель с указанным идентификатором не является контрагентом отправителя 0203
	СообщенияОшибок.Вставить("3200", ); // Документ не может быть отправлен в связи с ограничениями тарификации 3200
	
	// Метод GetMessageList: получение входящих транспортных контейнеров
	// Синхронный режим без обращения к БД
	СообщенияОшибок.Вставить("0503", ); // Отсутствует обязательный параметр «метка времени (название параметра)» 400 0503
	СообщенияОшибок.Вставить("0504", ); // Некорректный формат метки времени 400 0504
	
	// Метод GetMessage: выгрузка входящих транспортных контейнеров
	// Синхронный режим без обращения к БД
	СообщенияОшибок.Вставить("0505", ); // Отсутствует обязательный параметр идентификатор контейнера (документооборота) 400 0505
	СообщенияОшибок.Вставить("0502", ); // Неправильный формат идентификатора документооборота 400 0502
	
	// Синхронный режим с обращением к БД
	СообщенияОшибок.Вставить("4100", ); // Сообщение с данным <DocFlowID> идентификатором документооборота не найдено 404 4100
	
	// Общие ошибки сервера Такском
	СообщенияОшибок.Вставить("5101", ); // Внутренняя ошибка сервера 500 0000
	
КонецПроцедуры

Функция ТЗСопоставленияПолейАдресаФНС_CML()
	
	ТЗ = Новый ТаблицаЗначений;
	
	ТЗ.Колонки.Добавить("ПредставлениеФНС");
	ТЗ.Колонки.Добавить("ПредставлениеCML");
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Индекс";
	НоваяСтрока.ПредставлениеCML = "Почтовый индекс";
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "КодРегион";
	НоваяСтрока.ПредставлениеCML = "Регион";
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "НаселПункт";
	НоваяСтрока.ПредставлениеCML = "Населенный пункт";
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Город";
	НоваяСтрока.ПредставлениеCML = "Город";
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Улица";
	НоваяСтрока.ПредставлениеCML = "Улица";
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Дом";
	НоваяСтрока.ПредставлениеCML = "Дом";
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Корпус";
	НоваяСтрока.ПредставлениеCML = "Корпус";
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Кварт";
	НоваяСтрока.ПредставлениеCML = "Квартира";
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "КодСтр";
	НоваяСтрока.ПредставлениеCML = "Страна";
	
	Возврат ТЗ;
	
КонецФункции
