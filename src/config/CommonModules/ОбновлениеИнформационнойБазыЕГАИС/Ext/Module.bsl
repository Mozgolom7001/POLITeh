﻿////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы Библиотеки Интеграции с ЕГАИС (БЕГАИС).
// 
/////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Сведения о библиотеке (или конфигурации).

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаИнтеграцииЕГАИС";
	Описание.Версия = ИнтеграцияЕГАИСКлиентСервер.ВерсияПодсистемыЕГАИС();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре.
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.РежимВыполнения     = "Монопольно";
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	// Справки в ТТН
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.СоздатьСправкиВТТН";
	Обработчик.НачальноеЗаполнение = Ложь;
	//Обработчик.Комментарий = НСтр("ru = 'Создание справок А и Б в ТТН.'");
	
	// ТТН входящая ЕГАИС
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.ОбновитьСтатусыОбработкиЕГАИС";
	Обработчик.НачальноеЗаполнение = Ложь;
	//Обработчик.Комментарий = НСтр("ru = 'Обновление статусов ТТН.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.ЗаполнитьВидыОперацийТТНВходящей";
	Обработчик.НачальноеЗаполнение = Ложь;
	//Обработчик.Комментарий = НСтр("ru = 'Заполнение типов ТТН.'");
	
	// Протокол обмена
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.ЗаполнитьДокументОснованиеВПротоколеОбмена";
	Обработчик.НачальноеЗаполнение = Ложь;
	//Обработчик.Комментарий = НСтр("ru = 'Обновление данных в протоколе обмена.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.ЗаполнитьИдентификаторЗапроса";
	Обработчик.НачальноеЗаполнение = Ложь;
	//Обработчик.Комментарий = НСтр("ru = 'Обновление данных в протоколе обмена.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.ЗаполнитьТипЗапроса";
	Обработчик.НачальноеЗаполнение = Ложь;
	//Обработчик.Комментарий = НСтр("ru = 'Обновление данных в протоколе обмена.'");
	
	// Регламентное задание "Обработка ответов ЕГАИС"
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.УстановитьПризнакИспользованияОбработкиОтветов";
	Обработчик.НачальноеЗаполнение = Ложь;
	//Обработчик.Комментарий = НСтр("ru = 'Включение регламентного задания ""Обработка ответов ЕГАИС"".'");
	
	// Настройки обмена
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.ОбновитьНастройкиОбмена_1_1_0";
	Обработчик.НачальноеЗаполнение = Ложь;
	//Обработчик.Комментарий = НСтр("ru = 'Обновление настроек обмена.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.УстановитьПризнакПроведенияТТН";
	Обработчик.НачальноеЗаполнение = Ложь;
	//Обработчик.Комментарий = НСтр("ru = 'Установка признака проведения для входящих ТТН.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.ЗаполнитьТипОрганизацииЕГАИС";
	//Обработчик.Комментарий = НСтр("ru = 'Заполнение типа организации.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.ЗаполнитьПричинуПостановкиНаБаланс";
	//Обработчик.Комментарий = НСтр("ru = 'Заполнение причины постановки на баланс.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.ЗаполнитьФорматОбмена";
	//Обработчик.Комментарий = НСтр("ru = 'Заполнение используемого формата обмена.'");

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.1.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЕГАИС.ЗаполнитьВидДокумента";
	//Обработчик.Комментарий = НСтр("ru = 'Заполнение вида документа.'");

КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - если установить Истина, то будет выведена форма
//                                с описанием обновлений. По умолчанию, Истина.
//                                Возвращаемое значение.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример обхода выполненных обработчиков обновления:
//
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
 
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//                                           или "*", если нужно выполнять при переходе с любой конфигурации.
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
 
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБНОВЛЕНИЯ

// Создает справки А и Б в табличной части Товары ТТН.
//
Процедура СоздатьСправкиВТТН() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИСТовары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТТНВходящаяЕГАИСТовары.УдалитьНомерСправкиБ КАК РегистрационныйНомер,
	|	ТТНВходящаяЕГАИСТовары.Ссылка КАК ДокументОснование,
	|	ЕСТЬNULL(СправкиБЕГАИС.Ссылка, ЗНАЧЕНИЕ(Справочник.СправкиБЕГАИС.ПустаяСсылка)) КАК Справка,
	|	ТТНВходящаяЕГАИСТовары.Количество КАК Количество,
	|	ТТНВходящаяЕГАИСТовары.НомерСтроки КАК НомерСтроки,
	|	ТТНВходящаяЕГАИСТовары.УдалитьНомерСправкиА КАК НомерСправкиА
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС.Товары КАК ТТНВходящаяЕГАИСТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СправкиБЕГАИС КАК СправкиБЕГАИС
	|		ПО ТТНВходящаяЕГАИСТовары.УдалитьНомерСправкиБ = СправкиБЕГАИС.РегистрационныйНомер
	|			И ТТНВходящаяЕГАИСТовары.АлкогольнаяПродукция = СправкиБЕГАИС.АлкогольнаяПродукция
	|ГДЕ
	|	ТТНВходящаяЕГАИСТовары.СправкаБ = ЗНАЧЕНИЕ(Справочник.СправкиБЕГАИС.ПустаяСсылка)
	|	И ТТНВходящаяЕГАИСТовары.УдалитьНомерСправкиБ <> """"
	|ИТОГИ ПО
	|	ДокументОснование,
	|	НомерСтроки";
	
	СозданныеСправки = Новый ТаблицаЗначений;
	СозданныеСправки.Колонки.Добавить("РегистрационныйНомер", Новый ОписаниеТипов("Строка"));
	СозданныеСправки.Колонки.Добавить("АлкогольнаяПродукция", Новый ОписаниеТипов("СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС"));
	СозданныеСправки.Колонки.Добавить("ДокументОснование"   , );
	СозданныеСправки.Колонки.Добавить("НомерСправкиА"       , Новый ОписаниеТипов("Строка"));
	СозданныеСправки.Колонки.Добавить("Количество"          , Новый ОписаниеТипов("Число"));
	СозданныеСправки.Колонки.Добавить("Справка"             , Новый ОписаниеТипов("СправочникСсылка.СправкиБЕГАИС"));
	
	РеквизитыСправки = "РегистрационныйНомер, АлкогольнаяПродукция, ДокументОснование, НомерСправкиА, Количество";
	
	ВыборкаТТН = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаТТН.Следующий() Цикл
		ТТН = ВыборкаТТН.ДокументОснование.ПолучитьОбъект();
		
		ВыборкаНомерСтроки = ВыборкаТТН.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаНомерСтроки.Следующий() Цикл
			
			Выборка = ВыборкаНомерСтроки.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				Если НЕ Выборка.Справка.Пустая() Тогда
					Справка = Выборка.Справка;
				Иначе
					ПараметрыОтбора = Новый Структура(РеквизитыСправки);
					ЗаполнитьЗначенияСвойств(ПараметрыОтбора, Выборка);
					
					НайденныеСтроки = СозданныеСправки.НайтиСтроки(ПараметрыОтбора);
					Если НайденныеСтроки.Количество() > 0 Тогда
						Справка = НайденныеСтроки[0].Справка;
					Иначе
						ДанныеСправки = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхСправкиБ();
						ДанныеСправки.Наименование = Выборка.РегистрационныйНомер;
						ЗаполнитьЗначенияСвойств(ДанныеСправки, Выборка, РеквизитыСправки);
						
						ТекстОшибки = "";
						Справка = ИнтеграцияЕГАИС.СоздатьСправку(ДанныеСправки, Перечисления.ВидыДокументовЕГАИС.СправкаБ, Неопределено, ТекстОшибки, Ложь);
						
						Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
							ВызватьИсключение ТекстОшибки;
						КонецЕсли;
						
						СтрокаТаблицы = СозданныеСправки.Добавить();
						СтрокаТаблицы.Справка = Справка;
						
						ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка, РеквизитыСправки);
					КонецЕсли;
				КонецЕсли;
				
				ТТН.Товары[Выборка.НомерСтроки - 1]["СправкаБ"] = Справка;
				
			КонецЦикла;
			
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ТТН);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет статусы обработки запросов ЕГАИС.
//
Процедура ОбновитьСтатусыОбработкиЕГАИС() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИС.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящаяЕГАИС
	|ГДЕ
	|	ТТНВходящаяЕГАИС.СтатусОбработки = &ПустойСтатусОбработки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТТНВходящаяЕГАИС.Дата";
	
	Запрос.УстановитьПараметр("ПустойСтатусОбработки", Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПустаяСсылка());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокументОбъект.СтатусОбработки = Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПринятИзЕГАИС;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
	
	КонецЦикла;
	
КонецПроцедуры

// Заполняет виды операций входящей ТТН.
//
Процедура ЗаполнитьВидыОперацийТТНВходящей() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИС.Ссылка КАК Ссылка,
	|	ТТНВходящаяЕГАИС.Дата КАК Дата
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящаяЕГАИС
	|ГДЕ
	|	ТТНВходящаяЕГАИС.ВидОперации = &ПустойВидОперации
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Запрос.УстановитьПараметр("ПустойВидОперации", Перечисления.ВидыОперацийТТНВходящейЕГАИС.ПустаяСсылка());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокументОбъект.ВидОперации = Перечисления.ВидыОперацийТТНВходящейЕГАИС.ПриходнаяНакладная;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

// Заполнение регистра сведений Протокол обмена ЕГАИС.
//
Процедура ЗаполнитьДокументОснованиеВПротоколеОбмена() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИС.Ссылка КАК ДокументОснование,
	|	ТТНВходящаяЕГАИС.УдалитьЕстьОшибкиПередачиЗапроса КАК ПолученОтказ,
	|	ПротоколОбменаЕГАИС.ИдентификаторСессииОбмена КАК ИдентификаторСессииОбмена
	|ИЗ
	|	РегистрСведений.ПротоколОбменаЕГАИС КАК ПротоколОбменаЕГАИС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТТНВходящаяЕГАИС КАК ТТНВходящаяЕГАИС
	|		ПО ПротоколОбменаЕГАИС.ИдентификаторСессииОбмена = ТТНВходящаяЕГАИС.УдалитьИдентификаторПоследнегоЗапроса
	|ГДЕ
	|	ПротоколОбменаЕГАИС.ДокументОснование = НЕОПРЕДЕЛЕНО";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Запись = РегистрыСведений.ПротоколОбменаЕГАИС.СоздатьМенеджерЗаписи();
		Запись.ИдентификаторСессииОбмена = Выборка.ИдентификаторСессииОбмена;
		Запись.Прочитать();
		
		Запись.ДокументОснование = Выборка.ДокументОснование;
		Запись.ПолученОтказ = Выборка.ПолученОтказ;
		Запись.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Заполняет идентификатор запроса в списке запросов.
//
Процедура ЗаполнитьИдентификаторЗапроса() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПротоколОбменаЕГАИС.ИдентификаторСессииОбмена КАК ИдентификаторСессииОбмена
	|ИЗ
	|	РегистрСведений.ПротоколОбменаЕГАИС КАК ПротоколОбменаЕГАИС
	|ГДЕ
	|	ПротоколОбменаЕГАИС.ИдентификаторЗапроса = """"";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Запись = РегистрыСведений.ПротоколОбменаЕГАИС.СоздатьМенеджерЗаписи();
		Запись.ИдентификаторСессииОбмена = Выборка.ИдентификаторСессииОбмена;
		Запись.Прочитать();
		
		Запись.ИдентификаторЗапроса = Выборка.ИдентификаторСессииОбмена;
		Запись.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Заполняет тип запроса в списке запросов.
//
Процедура ЗаполнитьТипЗапроса() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПротоколОбменаЕГАИС.ИдентификаторСессииОбмена КАК ИдентификаторСессииОбмена
	|ИЗ
	|	РегистрСведений.ПротоколОбменаЕГАИС КАК ПротоколОбменаЕГАИС
	|ГДЕ
	|	ПротоколОбменаЕГАИС.ТипЗапроса = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовЕГАИС.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Запись = РегистрыСведений.ПротоколОбменаЕГАИС.СоздатьМенеджерЗаписи();
		Запись.ИдентификаторСессииОбмена = Выборка.ИдентификаторСессииОбмена;
		Запись.Прочитать();
		
		Запись.ТипЗапроса = Перечисления.ТипыЗапросовЕГАИС.Исходящий;
		Запись.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает признак Использование для регламентного задания ОбработкаОтветовЕГАИС.
//
Процедура УстановитьПризнакИспользованияОбработкиОтветов() Экспорт
	
	Задание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОбработкаОтветовЕГАИС);
	
	Если ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции")
		И НЕ Задание.Использование Тогда
		Задание.Использование = Истина;
		Задание.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Обновляет настройки обмена с УТМ при переходе на версию 1.1.0.*.
//
Процедура ОбновитьНастройкиОбмена_1_1_0() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиОбменаЕГАИС.ИдентификаторФСРАР КАК ИдентификаторФСРАР,
	|	НастройкиОбменаЕГАИС.УдалитьОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|	НастройкиОбменаЕГАИС.УдалитьОрганизацияЕГАИС.Код КАК КодОрганизацииЕГАИС,
	|	НастройкиОбменаЕГАИС.Организация,
	|	НастройкиОбменаЕГАИС.Склад
	|ИЗ
	|	РегистрСведений.НастройкиОбменаЕГАИС КАК НастройкиОбменаЕГАИС
	|ГДЕ
	|	НастройкиОбменаЕГАИС.ИдентификаторФСРАР = """"";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Запись = РегистрыСведений.НастройкиОбменаЕГАИС.СоздатьМенеджерЗаписи();
		Запись.ИдентификаторФСРАР = Выборка.ИдентификаторФСРАР;
		Запись.Организация        = Выборка.Организация;
		Запись.Склад              = Выборка.Склад;
		Запись.Прочитать();
		
		Запись.ИдентификаторФСРАР = Выборка.КодОрганизацииЕГАИС;
		Запись.Записать();
	КонецЦикла;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиОбменаЕГАИС.ЗагружатьВходящиеДокументы КАК ЗагружатьВходящиеДокументы
	|ИЗ
	|	РегистрСведений.НастройкиОбменаЕГАИС КАК НастройкиОбменаЕГАИС
	|ГДЕ
	|	НастройкиОбменаЕГАИС.ЗагружатьВходящиеДокументы";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиОбменаЕГАИС.ИдентификаторФСРАР КАК ИдентификаторФСРАР,
		|	НастройкиОбменаЕГАИС.Организация,
		|	НастройкиОбменаЕГАИС.Склад
		|ИЗ
		|	РегистрСведений.НастройкиОбменаЕГАИС КАК НастройкиОбменаЕГАИС";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Запись = РегистрыСведений.НастройкиОбменаЕГАИС.СоздатьМенеджерЗаписи();
			Запись.ИдентификаторФСРАР = Выборка.ИдентификаторФСРАР;
			Запись.Организация        = Выборка.Организация;
			Запись.Склад              = Выборка.Склад;
			Запись.Прочитать();
			
			Запись.ЗагружатьВходящиеДокументы = Истина;
			Запись.Записать();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает признак проведения для входящих ТТН.
//
Процедура УстановитьПризнакПроведенияТТН() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИС.Ссылка КАК Ссылка,
	|	ТТНВходящаяЕГАИС.Дата КАК Дата,
	|	ЕСТЬNULL(ТТНВходящаяЕГАИС.Грузополучатель.УчитыватьОстаткиАлкогольнойПродукции, ЛОЖЬ) КАК УчитыватьОстаткиАлкогольнойПродукции
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящаяЕГАИС
	|ГДЕ
	|	НЕ ТТНВходящаяЕГАИС.Проведен
	|	И НЕ ТТНВходящаяЕГАИС.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Док = Выборка.Ссылка.ПолучитьОбъект();
		Если Выборка.УчитыватьОстаткиАлкогольнойПродукции Тогда
			Док.Записать(РежимЗаписиДокумента.Проведение);
		Иначе
			Док.Проведен = Истина;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Док);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Заполняет тип организации.
//
Процедура ЗаполнитьТипОрганизацииЕГАИС() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА КлассификаторОрганизацийЕГАИС.УдалитьУНП <> """"
	|			ТОГДА КлассификаторОрганизацийЕГАИС.УдалитьУНП
	|		ИНАЧЕ КлассификаторОрганизацийЕГАИС.УдалитьРНН
	|	КОНЕЦ КАК ИдентификаторОрганизацииТС
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.ИдентификаторОрганизацииТС = """"
	|	И (КлассификаторОрганизацийЕГАИС.УдалитьУНП <> """"
	|			ИЛИ КлассификаторОрганизацийЕГАИС.УдалитьРНН <> """")";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОрганизацияЕГАИС = Выборка.Ссылка.ПолучитьОбъект();
		ОрганизацияЕГАИС.ИдентификаторОрганизацииТС = Выборка.ИдентификаторОрганизацииТС;
		Если ОрганизацияЕГАИС.ТипОрганизации.Пустая() Тогда
			ОрганизацияЕГАИС.ТипОрганизации = Перечисления.ТипыОрганизацийЕГАИС.КонтрагентТаможенногоСоюза;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ОрганизацияЕГАИС);
	КонецЦикла;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК Ссылка,
	|	КлассификаторОрганизацийЕГАИС.ИНН КАК ИНН,
	|	КлассификаторОрганизацийЕГАИС.КПП КАК КПП
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.ТипОрганизации = ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЕГАИС.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОрганизацияЕГАИС = Выборка.Ссылка.ПолучитьОбъект();
		
		Если ПустаяСтрока(Выборка.ИНН) И ПустаяСтрока(Выборка.КПП) Тогда
			ОрганизацияЕГАИС.ТипОрганизации = Перечисления.ТипыОрганизацийЕГАИС.ИностранныйКонтрагент;
		ИначеЕсли ПустаяСтрока(Выборка.КПП) И СтрДлина(СокрЛП(Выборка.ИНН)) = 12 Тогда
			ОрганизацияЕГАИС.ТипОрганизации = Перечисления.ТипыОрганизацийЕГАИС.ИндивидуальныйПредпринимательРФ;
		Иначе
			ОрганизацияЕГАИС.ТипОрганизации = Перечисления.ТипыОрганизацийЕГАИС.ЮридическоеЛицоРФ;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ОрганизацияЕГАИС);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет причину постановки на баланс в актах постановки на баланс.
//
Процедура ЗаполнитьПричинуПостановкиНаБаланс() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АктПостановкиНаБалансЕГАИС.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС КАК АктПостановкиНаБалансЕГАИС
	|ГДЕ
	|	АктПостановкиНаБалансЕГАИС.ПричинаПостановкиНаБаланс = ЗНАЧЕНИЕ(Перечисление.ПричиныПостановкиНаБалансЕГАИС.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Док = Выборка.Ссылка.ПолучитьОбъект();
		Док.ПричинаПостановкиНаБаланс = Перечисления.ПричиныПостановкиНаБалансЕГАИС.ЗакупкаДо2016;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Док);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет информацию об используемом формате обмена с УТМ.
//
Процедура ЗаполнитьФорматОбмена() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкиОбменаЕГАИС.ИдентификаторФСРАР КАК ИдентификаторФСРАР
	|ИЗ
	|	РегистрСведений.НастройкиОбменаЕГАИС КАК НастройкиОбменаЕГАИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФорматыОбменаЕГАИС КАК ФорматыОбменаЕГАИС
	|		ПО НастройкиОбменаЕГАИС.ИдентификаторФСРАР = ФорматыОбменаЕГАИС.ИдентификаторФСРАР
	|ГДЕ
	|	ФорматыОбменаЕГАИС.ФорматОбмена ЕСТЬ NULL ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Запись = РегистрыСведений.ФорматыОбменаЕГАИС.СоздатьМенеджерЗаписи();
		Запись.ИдентификаторФСРАР = Выборка.ИдентификаторФСРАР;
		Запись.ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V1;
		Запись.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Заполняет реквизит ВидДокумента в существующих документах.
//
Процедура ЗаполнитьВидДокумента() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустойВидДокумента", Перечисления.ВидыДокументовЕГАИС.ПустаяСсылка());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОстаткиЕГАИС.Ссылка КАК Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.ЗапросОстатков) КАК ВидДокумента
	|ИЗ
	|	Документ.ОстаткиЕГАИС КАК ОстаткиЕГАИС
	|ГДЕ
	|	ОстаткиЕГАИС.ВидДокумента = &ПустойВидДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АктПостановкиНаБалансЕГАИС.Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.АктПостановкиНаБаланс)
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС КАК АктПостановкиНаБалансЕГАИС
	|ГДЕ
	|	АктПостановкиНаБалансЕГАИС.ВидДокумента = &ПустойВидДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АктСписанияЕГАИС.Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.АктСписания)
	|ИЗ
	|	Документ.АктСписанияЕГАИС КАК АктСписанияЕГАИС
	|ГДЕ
	|	АктСписанияЕГАИС.ВидДокумента = &ПустойВидДокумента";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Док = Выборка.Ссылка.ПолучитьОбъект();
		Док.ВидДокумента = Выборка.ВидДокумента;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Док);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы Библиотеки Интеграции с ЕГАИС (БЕГАИС).
// 
/////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает номер версии библиотеки.
//
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат ИнтеграцияЕГАИСКлиентСервер.ВерсияПодсистемыЕГАИС();
	
КонецФункции // ВерсияБиблиотеки()

// Неинтерактивное обновление данных ИБ при смене версии библиотеки.
// Обязательная "точка входа" обновления ИБ в библиотеке.
//
Процедура ВыполнитьОбновлениеИнформационнойБазы() Экспорт
	
	ОбновлениеИнформационнойБазы.ВыполнитьИтерациюОбновления(
		"БиблиотекаИнтеграцииЕГАИС", ВерсияБиблиотеки(), ОбработчикиОбновления());
	
КонецПроцедуры

// Возвращает список процедур-обработчиков обновления библиотеки для всех поддерживаемых версий ИБ.
//
// Пример добавления процедуры-обработчика в список:
//    Обработчик = Обработчики.Добавить();
//    Обработчик.Версия = "1.0.0.0";
//    Обработчик.Процедура = "ОбновлениеИБ.ПерейтиНаВерсию_1_0_0_0";
//    Обработчик.Опциональный = Истина;
//
// Вызывается перед началом обновления данных ИБ.
//
Функция ОбработчикиОбновления()
	
	Обработчики = ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления();
	
	ПриДобавленииОбработчиковОбновления(Обработчики);
	
	Возврат Обработчики;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБНОВЛЕНИЯ

// Устанавливает признак передачи немаркируемой продукции в ЕГАИС
//
Процедура УстановитьПризнакВыгрузкиПродажНемаркируемойПродукции() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции") Тогда
		Константы.ВыгружатьПродажиНемаркируемойПродукцииВЕГАИС.Установить(Истина);
	КонецЕсли;
	
КонецПроцедуры // УстановитьПризнакВыгрузкиПродажНемаркируемойПродукции()
