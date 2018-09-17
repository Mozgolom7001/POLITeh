﻿
//#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыДокумента(
		"ВозвратИзТорговогоЗалаЕГАИС",
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
	
	ЭлементУсловногоОформления = УсловноеОформлениеКД.Элементы.Добавить();
	ЭлементУсловногоОформления.Представление = ПредставлениеЭлемента;
	ЭлементУсловногоОформления.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиПередается);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ОформляемоеПоле);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементУсловногоОформления.Отбор,
		ПутьКДанным,
		Перечисления.СтатусыОбработкиВозвратаИзТорговогоЗалаЕГАИС.ПередаетсяВЕГАИС,
		ВидСравненияКомпоновкиДанных.Равно,
		ПредставлениеЭлемента,
		Истина);
	
	// Представление статуса ОшибкаПередачи
	ПредставлениеЭлемента = НСтр("ru = 'Получена ошибка передачи в ЕГАИС'");
	
	ЭлементУсловногоОформления = УсловноеОформлениеКД.Элементы.Добавить();
	ЭлементУсловногоОформления.Представление = ПредставлениеЭлемента;
	ЭлементУсловногоОформления.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ОформляемоеПоле);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементУсловногоОформления.Отбор,
		ПутьКДанным,
		Перечисления.СтатусыОбработкиВозвратаИзТорговогоЗалаЕГАИС.ОшибкаПередачиВЕГАИС,
		ВидСравненияКомпоновкиДанных.Равно,
		ПредставлениеЭлемента,
		Истина);
	
КонецПроцедуры

// Возвращает данные документа в виде структуры перед выгрузкой в УТМ.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ПередачаВТорговыйЗал - выгружаемая передача.
//
// Возвращаемое значение:
//   Структура - данные передачи.
//
Функция ИнициализироватьДанныеДокументаДляВыгрузки(ДокументСсылка) Экспорт
	
	ДанныеДокумента = СтркуктураДанныхВозвратаИзТорговогоЗала();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратИзТорговогоЗалаЕГАИС.Номер КАК Номер,
	|	ВозвратИзТорговогоЗалаЕГАИС.Дата КАК Дата,
	|	ВозвратИзТорговогоЗалаЕГАИС.Идентификатор КАК Идентификатор,
	|	ВозвратИзТорговогоЗалаЕГАИС.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ВозвратИзТорговогоЗалаЕГАИС КАК ВозвратИзТорговогоЗалаЕГАИС
	|ГДЕ
	|	ВозвратИзТорговогоЗалаЕГАИС.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ДанныеДокумента, Выборка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратИзТорговогоЗалаЕГАИСТовары.НомерСтроки КАК НомерСтроки,
	|	ВозвратИзТорговогоЗалаЕГАИСТовары.АлкогольнаяПродукция.Код КАК КодАлкогольнойПродукции,
	|	ВозвратИзТорговогоЗалаЕГАИСТовары.Количество КАК Количество,
	|	ВозвратИзТорговогоЗалаЕГАИСТовары.СправкаБ.РегистрационныйНомер КАК НомерСправкиБ
	|ИЗ
	|	Документ.ВозвратИзТорговогоЗалаЕГАИС.Товары КАК ВозвратИзТорговогоЗалаЕГАИСТовары
	|ГДЕ
	|	ВозвратИзТорговогоЗалаЕГАИСТовары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаДокумента = СтркуктураДанныхСтрокиВозвратаИзТорговогоЗала();
		ЗаполнитьЗначенияСвойств(СтрокаДокумента, Выборка);
		СтрокаДокумента.ИдентификаторСтроки = Формат(Выборка.НомерСтроки, "ЧГ=0");
		
		ДанныеДокумента.ТаблицаТоваров.Добавить(СтрокаДокумента);
	КонецЦикла;
	
	Возврат ДанныеДокумента;
	
КонецФункции

//#КонецОбласти

//#Область СлужебныеПроцедурыИФункции

// Возвращает структуру, необходимую для выгрузки возврата из торгового зала в УТМ.
//
Функция СтркуктураДанныхВозвратаИзТорговогоЗала()
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор" , Неопределено); // Идентификатор документа (клиентский).
	Результат.Вставить("Номер"         , "");           // Номер документа.
	Результат.Вставить("Дата"          , '00010101');   // Дата составления.
	Результат.Вставить("Комментарий"   , Неопределено); // Произвольный комментарий к документу.
	Результат.Вставить("ТаблицаТоваров", Новый Массив); // Массив передаваемой продукции.
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру, необходимую для выгрузки строки возврата из торгового зала в УТМ.
//
Функция СтркуктураДанныхСтрокиВозвратаИзТорговогоЗала()
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторСтроки"    , ""); // Идентификатор позиции внутри документа.
	Результат.Вставить("КодАлкогольнойПродукции", ""); // Код возвращаемой алкогольной продукции.
	Результат.Вставить("Количество"             , 0);  // Количество единиц возвращаемого товара.
	Результат.Вставить("НомерСправкиБ"          , ""); // Номер справки Б, по которой товар поступил на склад.
	
	Возврат Результат;
	
КонецФункции

//#КонецОбласти

#КонецЕсли