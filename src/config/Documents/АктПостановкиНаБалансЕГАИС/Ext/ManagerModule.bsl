﻿
//#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыДокумента(
		"АктПостановкиНаБалансЕГАИС",
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
	
КонецПроцедуры

//#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//#Область ПрограммныйИнтерфейс

// Добавляет на форму списка условное оформление состояния фиксации.
//
//  Параметры:
//   Форма - УправляемаяФорма – форма документа.
//   ОформляемоеПоле - Строка – имя поля для оформления.
//   ПутьКДанным - Строка - путь к реквизиту СтатусОбработки.
//
Процедура УстановитьУсловноеОформлениеСтатусаОбработки(Форма, ОформляемоеПоле = "Список", ПутьКДанным = "Список.СтатусОбработки") Экспорт
	
	УсловноеОформлениеКД = Форма.УсловноеОформление;
	
	// Представление статуса Передается
	ПредставлениеЭлемента = НСтр("ru = 'Документ передается в ЕГАИС'");
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ПередаетсяВЕГАИС);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ПередаетсяЗапросНаОтменуПроведения);
	
	ЭлементУсловногоОформления = УсловноеОформлениеКД.Элементы.Добавить();
	ЭлементУсловногоОформления.Представление = ПредставлениеЭлемента;
	ЭлементУсловногоОформления.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиПередается);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ОформляемоеПоле);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементУсловногоОформления.Отбор,
		ПутьКДанным,
		СписокСтатусов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		ПредставлениеЭлемента,
		Истина);
	
	
	// Представление статуса ОшибкаПередачи
	ПредставлениеЭлемента = НСтр("ru = 'Получена ошибка передачи в ЕГАИС'");
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ОшибкаПередачиВЕГАИС);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ОшибкаПередачиЗапросаНаОтменуПроведения);
	
	ЭлементУсловногоОформления = УсловноеОформлениеКД.Элементы.Добавить();
	ЭлементУсловногоОформления.Представление = ПредставлениеЭлемента;
	ЭлементУсловногоОформления.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ОформляемоеПоле);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементУсловногоОформления.Отбор,
		ПутьКДанным,
		СписокСтатусов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		ПредставлениеЭлемента,
		Истина);
	
КонецПроцедуры

// Возвращает данные акта в виде структуры перед выгрузкой в УТМ.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.АктПостановкиНаБалансЕГАИС - выгружаемый акт,
//  ВидДокумента - ПеречислениеСсылка.ВидыДокументаЕГАИС - вид выгружаемого документа.
//
// Возвращаемое значение:
//   Структура - данные акта.
//
Функция ИнициализироватьДанныеДокументаДляВыгрузки(ДокументСсылка, ВидДокумента) Экспорт
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБаланс Тогда
		Возврат ИнициализироватьДанныеАктаПостановкиНаБаланс(ДокументСсылка);
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВТорговомЗале Тогда
		Возврат ИнициализироватьДанныеАктаПостановкиНаБалансВТорговомЗале(ДокументСсылка);
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияАктаПостановкиНаБаланс Тогда
		Возврат ИнициализироватьДанныеЗапросаНаОтменуПроведенияАктаПостановкиНаБаланс(ДокументСсылка);
		
	Иначе
		ТекстОшибки = НСтр("ru='Неподдерживаемый вид документа %1 для акта постановки на баланс'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ВидДокумента);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецФункции

//#КонецОбласти

//#Область СлужебныеПроцедурыИФункции

// Возвращает данные акта постановки на баланс.
//
Функция ИнициализироватьДанныеАктаПостановкиНаБаланс(ДокументСсылка)
	
	ДанныеАкта = СтруктураДанныхАктаПостановкиНаБаланс();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АктПостановкиНаБалансЕГАИС.Номер КАК Номер,
	|	АктПостановкиНаБалансЕГАИС.Дата КАК Дата,
	|	АктПостановкиНаБалансЕГАИС.ПричинаПостановкиНаБаланс КАК ПричинаПостановкиНаБаланс,
	|	ВЫБОР
	|		КОГДА АктПостановкиНаБалансЕГАИС.ПричинаПостановкиНаБаланс = ЗНАЧЕНИЕ(Перечисление.ПричиныПостановкиНаБалансЕГАИС.Пересортица)
	|			ТОГДА ЕСТЬNULL(АктПостановкиНаБалансЕГАИС.АктСписанияЕГАИС.ИдентификаторЕГАИС, НЕОПРЕДЕЛЕНО)
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ИдентификаторАктаСписания,
	|	АктПостановкиНаБалансЕГАИС.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС КАК АктПостановкиНаБалансЕГАИС
	|ГДЕ
	|	АктПостановкиНаБалансЕГАИС.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ДанныеАкта, Выборка);
	ДанныеАкта.Идентификатор = Строка(ДокументСсылка.УникальныйИдентификатор());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Количество КАК Количество,
	|	Товары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	Товары.КоличествоПоСправкеА КАК КоличествоПоСправкеА,
	|	Товары.НомерТТН КАК НомерТТН,
	|	Товары.ДатаТТН КАК ДатаТТН,
	|	Товары.ДатаРозлива КАК ДатаРозлива,
	|	Товары.НомерПодтвержденияЕГАИС КАК НомерПодтвержденияЕГАИС,
	|	Товары.ДатаПодтвержденияЕГАИС КАК ДатаПодтвержденияЕГАИС,
	|	ЕСТЬNULL(АкцизныеМарки.КодАкцизнойМарки, """") КАК КодАкцизнойМарки,
	|	Товары.СправкаБ.НомерСправкиА КАК НомерСправкиА,
	|	Товары.СправкаБ.РегистрационныйНомер КАК НомерСправкиБ
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктПостановкиНаБалансЕГАИС.АкцизныеМарки КАК АкцизныеМарки
	|		ПО (АкцизныеМарки.Ссылка = &Ссылка)
	|			И Товары.КлючСвязи = АкцизныеМарки.КлючСвязи
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|ИТОГИ
	|	МАКСИМУМ(Количество),
	|	МАКСИМУМ(АлкогольнаяПродукция),
	|	МАКСИМУМ(КоличествоПоСправкеА),
	|	МАКСИМУМ(НомерТТН),
	|	МАКСИМУМ(ДатаТТН),
	|	МАКСИМУМ(ДатаРозлива),
	|	МАКСИМУМ(НомерПодтвержденияЕГАИС),
	|	МАКСИМУМ(ДатаПодтвержденияЕГАИС),
	|	МАКСИМУМ(НомерСправкиА),
	|	МАКСИМУМ(НомерСправкиБ)
	|ПО
	|	НомерСтроки";
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		СтрокаАкта = СтруктураДанныхСтрокиАктаПостановкиНаБаланс();
		ЗаполнитьЗначенияСвойств(СтрокаАкта, Выборка);
		СтрокаАкта.ИдентификаторСтроки = Формат(Выборка.НомерСтроки, "ЧГ=0");
		
		ВыборкаМарки = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаМарки.Следующий() Цикл
			Если ЗначениеЗаполнено(ВыборкаМарки.КодАкцизнойМарки) Тогда
				СтрокаАкта.АкцизныеМарки.Добавить(ВыборкаМарки.КодАкцизнойМарки);
			КонецЕсли;
		КонецЦикла;
		
		ДанныеАкта.ТаблицаТоваров.Добавить(СтрокаАкта);
	КонецЦикла;
	
	Возврат ДанныеАкта;
	
КонецФункции

// Возвращает данные акта постановки на баланс в торговом зале.
//
Функция ИнициализироватьДанныеАктаПостановкиНаБалансВТорговомЗале(ДокументСсылка)
	
	ДанныеАкта = СтруктураДанныхАктаПостановкиНаБаланс();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АктПостановкиНаБалансЕГАИС.Номер КАК Номер,
	|	АктПостановкиНаБалансЕГАИС.Дата КАК Дата,
	|	АктПостановкиНаБалансЕГАИС.ПричинаПостановкиНаБаланс КАК ПричинаПостановкиНаБаланс,
	|	ВЫБОР
	|		КОГДА АктПостановкиНаБалансЕГАИС.ПричинаПостановкиНаБаланс = ЗНАЧЕНИЕ(Перечисление.ПричиныПостановкиНаБалансЕГАИС.Пересортица)
	|			ТОГДА ЕСТЬNULL(АктПостановкиНаБалансЕГАИС.АктСписанияЕГАИС.ИдентификаторЕГАИС, НЕОПРЕДЕЛЕНО)
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ИдентификаторАктаСписания,
	|	АктПостановкиНаБалансЕГАИС.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС КАК АктПостановкиНаБалансЕГАИС
	|ГДЕ
	|	АктПостановкиНаБалансЕГАИС.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ДанныеАкта, Выборка);
	ДанныеАкта.Идентификатор = Строка(ДокументСсылка.УникальныйИдентификатор());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АктПостановкиНаБалансЕГАИСТовары.НомерСтроки КАК НомерСтроки,
	|	АктПостановкиНаБалансЕГАИСТовары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	АктПостановкиНаБалансЕГАИСТовары.Количество КАК Количество
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС.Товары КАК АктПостановкиНаБалансЕГАИСТовары
	|ГДЕ
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаАкта = СтруктураДанныхСтрокиАктаПостановкиНаБалансВТорговомЗале();
		ЗаполнитьЗначенияСвойств(СтрокаАкта, Выборка);
		СтрокаАкта.ИдентификаторСтроки = Формат(Выборка.НомерСтроки, "ЧГ=0");
		
		ДанныеАкта.ТаблицаТоваров.Добавить(СтрокаАкта);
	КонецЦикла;
	
	Возврат ДанныеАкта;
	
КонецФункции

// Возвращает данные запроса на отмену проведения акта постановки на баланс.
//
Функция ИнициализироватьДанныеЗапросаНаОтменуПроведенияАктаПостановкиНаБаланс(ДокументСсылка)
	
	ДанныеЗапроса = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхЗапросаНаОтменуПроведения();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Дата"  , ТекущаяДатаСеанса());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АктПостановкиНаБалансЕГАИС.ОрганизацияЕГАИС.Код КАК ИдентификаторФСРАР,
	|	АктПостановкиНаБалансЕГАИС.Номер КАК Номер,
	|	&Дата КАК Дата,
	|	АктПостановкиНаБалансЕГАИС.ИдентификаторЕГАИС КАК ИдентификаторЕГАИС
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС КАК АктПостановкиНаБалансЕГАИС
	|ГДЕ
	|	АктПостановкиНаБалансЕГАИС.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ДанныеЗапроса, Выборка);
	
	Возврат ДанныеЗапроса;
	
КонецФункции

// Возвращает структуру, необходимую для выгрузки акта постановки на баланс в УТМ.
//
Функция СтруктураДанныхАктаПостановкиНаБаланс()
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор"            , Неопределено); // Идентификатор накладной (клиентский, к заполнению необязательный).
	Результат.Вставить("Номер"                    , "");           // Номер документа.
	Результат.Вставить("Дата"                     , '00010101');   // Дата акта постановки на баланс.
	Результат.Вставить("ПричинаПостановкиНаБаланс", Неопределено); // Причина постановки на баланс.
	Результат.Вставить("ИдентификаторАктаСписания", Неопределено); // Идентификатор ЕГАИС акта списания при пересортице.
	Результат.Вставить("Комментарий"              , Неопределено); // Произвольный комментарий.
	Результат.Вставить("ТаблицаТоваров"           , Новый Массив); // Массив строк акта.
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру, необходимую для выгрузки строки акта постановки на баланс в УТМ.
//
Функция СтруктураДанныхСтрокиАктаПостановкиНаБаланс()
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторСтроки"    , "");           // Идентификатор позиции внутри акта.
	Результат.Вставить("АлкогольнаяПродукция"   , Неопределено); // Элемент справочника КлассификаторАлкогольнойПродукцииЕГАИС.
	Результат.Вставить("Количество"             , 0);            // Количество единиц приходуемого товара.
	Результат.Вставить("КоличествоПоСправкеА"   , 0);            // Количество единиц отгруженной продукции по справке А.
	Результат.Вставить("НомерТТН"               , "");           // Номер ТТН из справки А.
	Результат.Вставить("ДатаТТН"                , '00010101');   // Дата ТТН из справки А.
	Результат.Вставить("ДатаРозлива"            , '00010101');   // Дата розлива продукции из справки А.
	Результат.Вставить("НомерПодтвержденияЕГАИС", "");           // Номер подтверждения справки А в ЕГАИС.
	Результат.Вставить("ДатаПодтвержденияЕГАИС" , '00010101');   // Дата подтверждения справки А в ЕГАИС.
	Результат.Вставить("НомерСправкиА"          , "");           // Номер справки А.
	Результат.Вставить("НомерСправкиБ"          , "");           // Номер справки Б.
	Результат.Вставить("АкцизныеМарки"          , Новый Массив); // Массив штрих-кодов акцизных марок для маркируемой продукции.
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру, необходимую для выгрузки строки акта постановки на баланс в торговом зале в УТМ.
//
Функция СтруктураДанныхСтрокиАктаПостановкиНаБалансВТорговомЗале()
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторСтроки" , "");           // Идентификатор позиции внутри акта.
	Результат.Вставить("АлкогольнаяПродукция", Неопределено); // Элемент справочника КлассификаторАлкогольнойПродукцииЕГАИС.
	Результат.Вставить("Количество"          , 0);            // Количество единиц приходуемого товара.
	
	Возврат Результат;
	
КонецФункции

//#КонецОбласти

#КонецЕсли