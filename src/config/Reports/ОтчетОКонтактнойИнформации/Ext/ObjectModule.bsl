﻿#Если Клиент Тогда

// Список значений типов объектов отчета
Перем мСписокОбъектовОтчета Экспорт;

// Соответствие, содержащая назначения свойств и категорий именам
Перем мСоответствиеНазначений Экспорт;

// Структура, ключи которой - имена отборов Построителя, значения - параметры Построителя
Перем мСтруктураДляОтбораПоКатегориям Экспорт;

// Макет отчета
Перем мМакет;

// Количество строк заголовка отчета
Перем мКоличествоВыведенныхСтрокЗаголовка;

// Количество столбцов отчета - видов контактной информации
Перем мКолВоСтолбов;

// Список значений, выводимые в отчет виды КИ
Перем мСписокВсехВидовКИ;

// Структура, содержащая связь полей быстрого отбора с путями к данным отбора Построителя
Перем мСтруктураСвязиЭлементовСДанными Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура меняет видимость заголовка поля табличного документа
// 
// Параметры
//  Таб - табличный документ
//
// Возвращаемые значения
//  НЕТ
Процедура ИзменитьВидимостьЗаголовка(Таб) Экспорт

	ОбластьВидимости = Таб.Область(1,,мКоличествоВыведенныхСтрокЗаголовка,);
	ОбластьВидимости.Видимость = ПоказыватьЗаголовок;

КонецПроцедуры

// Функция определяет для объекта отчета вид объекта контактнйо информации
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ВидыОбъектовКонтактнойИнформации
//
Функция ПолучитьВидОбъектаКИ()

	Если ОбъектОтчета = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		Возврат Перечисления.ВидыОбъектовКонтактнойИнформации.КонтактныеЛица;
	ИначеЕсли ОбъектОтчета = Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат Перечисления.ВидыОбъектовКонтактнойИнформации.Контрагенты;
	ИначеЕсли ОбъектОтчета = Тип("СправочникСсылка.Организации") Тогда
		Возврат Перечисления.ВидыОбъектовКонтактнойИнформации.Организации;
	ИначеЕсли ОбъектОтчета = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Возврат Перечисления.ВидыОбъектовКонтактнойИнформации.ФизическиеЛица;
	ИначеЕсли ОбъектОтчета = Тип("СправочникСсылка.Пользователи") Тогда
		Возврат Перечисления.ВидыОбъектовКонтактнойИнформации.Пользователи;
	ИначеЕсли ОбъектОтчета = Тип("СправочникСсылка.КонтактныеЛицаКонтрагентов") Тогда
		Возврат Перечисления.ВидыОбъектовКонтактнойИнформации.КонтактныеЛицаКонтрагентов;
	ИначеЕсли ОбъектОтчета = Тип("СправочникСсылка.ЛичныеКонтакты") Тогда
		Возврат Перечисления.ВидыОбъектовКонтактнойИнформации.ЛичныеКонтакты;
	Иначе
		Возврат Перечисления.ВидыОбъектовКонтактнойИнформации.ПустаяСсылка();
	КонецЕсли; 

КонецФункции // ПолучитьВидОбъектаКИ()

// Процедура заполняет таблицу видоа контактной информации - показателей отчета
// Возвращаемые значения
//  НЕТ
Процедура СформироватьСписокВидовКИ() Экспорт

Если ИспользоватьРегистрПриЗаполненииВидовКИ Тогда
		
		Запрос = Новый Запрос;
		
		ТекстЗапроса = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КонтактнаяИнформация.Вид КАК Вид,
		|	КонтактнаяИнформация.Тип КАК Тип
		|ИЗ
		|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Объект ССЫЛКА " + ПолучитьИмяСсылкиОбъектаОтчета() + "
		|	И
		|	Вид ССЫЛКА Справочник.ВидыКонтактнойИнформации
		|";
		
		// если по Контактным лицам и выбрана группировка Контрагенты - добавим КИ и Контрагентов
		Если ОбъектОтчета = Тип("СправочникСсылка.КонтактныеЛицаКонтрагентов") И ПостроительОтчета.ИзмеренияСтроки.Найти("Контрагент") <> Неопределено Тогда
			ТекстЗапроса = ТекстЗапроса + "
			| ИЛИ КонтактнаяИнформация.Объект ССЫЛКА Справочник.Контрагенты"; 
		КонецЕсли;
		
		Запрос.Текст = ТекстЗапроса;
		
		ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
		
	Иначе

		Запрос = Новый Запрос;
		
		ТекстЗапроса = "
		|ВЫБРАТЬ
		|	ВидыКонтактнойИнформации.Ссылка     КАК Вид,
		|	ВидыКонтактнойИнформации.Ссылка.Тип КАК Тип
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
		|
		|ГДЕ
		|	ВидыКонтактнойИнформации.ВидОбъектаКонтактнойИнформации = &ВыбВидОбъектаКонтактнойИнформации
		|";

		// если по Контактным лицам и выбрана группировка Контрагенты - добавим КИ и Контрагентов
		Если ОбъектОтчета = Тип("СправочникСсылка.КонтактныеЛицаКонтрагентов") И ПостроительОтчета.ИзмеренияСтроки.Найти("Контрагент") <> Неопределено Тогда
			ТекстЗапроса = ТекстЗапроса + "
			| ИЛИ ВидыКонтактнойИнформации.ВидОбъектаКонтактнойИнформации = &ВыбВидОбъектаКонтактнойИнформацииКонтрагенты";
			
			Запрос.УстановитьПараметр("ВыбВидОбъектаКонтактнойИнформацииКонтрагенты", Перечисления.ВидыОбъектовКонтактнойИнформации.Контрагенты);
		КонецЕсли;

		Запрос.Текст = ТекстЗапроса;
		
		Запрос.УстановитьПараметр("ВыбВидОбъектаКонтактнойИнформации", ПолучитьВидОбъектаКИ());

		ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
		
	КонецЕсли;
	
	// Удалим несуществующие ссылки и лишние строки
	ИндексСтроки = 0;
	Пока Истина Цикл
		
		Если ИндексСтроки > ВидыКонтактнойИнформации.Количество() - 1 Тогда
			Прервать;
		КонецЕсли; 
		
		СтрокаТаблицы = ВидыКонтактнойИнформации[ИндексСтроки];
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.ВидКонтактнойИнформации) Тогда
			ВидыКонтактнойИнформации.Удалить(СтрокаТаблицы);
		ИначеЕсли СтрокаТаблицы.ВидКонтактнойИнформации.ПолучитьОбъект() = Неопределено Тогда
			ВидыКонтактнойИнформации.Удалить(СтрокаТаблицы);
		ИначеЕсли (ПолучитьВидОбъектаКИ() <> СтрокаТаблицы.ВидКонтактнойИнформации.ВидОбъектаКонтактнойИнформации
				И НЕ(ОбъектОтчета = Тип("СправочникСсылка.КонтактныеЛицаКонтрагентов")))
			  ИЛИ ТаблицаЗапроса.Найти(СтрокаТаблицы.ВидКонтактнойИнформации, "Вид") = Неопределено Тогда
			ВидыКонтактнойИнформации.Удалить(СтрокаТаблицы);
		Иначе
			ИндексСтроки = ИндексСтроки + 1;
		КонецЕсли; 
	
	КонецЦикла;
	
	// Добавим новые виды КИ
	Для каждого СтрокаТаблицыЗапроса Из ТаблицаЗапроса Цикл
		
		Если ВидыКонтактнойИнформации.Найти(СтрокаТаблицыЗапроса.Вид, "ВидКонтактнойИнформации") <> Неопределено Тогда
			Продолжить;
		КонецЕсли; 
	
		НоваяСтрока = ВидыКонтактнойИнформации.Добавить();
		НоваяСтрока.ВидКонтактнойИнформации = СтрокаТаблицыЗапроса.Вид;
		НоваяСтрока.ТипКонтактнойИнформации = СтрокаТаблицыЗапроса.Тип;
		
	КонецЦикла;
	
	Если ВидыКонтактнойИнформации.Найти(Истина, "Использование") = Неопределено И ВидыКонтактнойИнформации.Количество() > 0 Тогда
		// Скорее всего поменяли объект отчета, надо по умолчанию пометить все виды КИ для отображения
		Для каждого СтрокаТаблицы Из ВидыКонтактнойИнформации Цикл
			СтрокаТаблицы.Использование = Истина;
		КонецЦикла; 
	КонецЕсли; 

КонецПроцедуры

// Функция определеяет и возвращает имя ссылки объекта отчета, как оно задано в конфигураторе
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Строка
//
Функция ПолучитьИмяСсылкиОбъектаОтчета()

	Если ОбъектОтчета = ТипЗнч(Неопределено) ИЛИ ОбъектОтчета = Неопределено Тогда
		Возврат "";
	Иначе
		СсылкаОбъекта = Новый (ОбъектОтчета);
		Возврат "Справочник." + СсылкаОбъекта.Метаданные().Имя;
	КонецЕсли; 

КонецФункции // ПолучитьИмяСсылкиОбъектаОтчета()

// Процедура передает построителю отчета запрос
//
// Параметры
//  НЕТ
//
// Возвращаемое значение
//  НЕТ
//
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	Если ОбъектОтчета = ТипЗнч(Неопределено) ИЛИ ОбъектОтчета = Неопределено Тогда
		Предупреждение("Задайте объект отчета.");
		Возврат;
	КонецЕсли;
	
	Если ОбъектОтчета <> Тип("СправочникСсылка.КонтактныеЛицаКонтрагентов") Тогда
		
		СтрокаВиртуальныхПараметров = "
		|	КонтактнаяИнформацияВнутр.Объект ССЫЛКА " + ПолучитьИмяСсылкиОбъектаОтчета() + "
		|	И
		|	((&ОбрабатыватьПерсональныеВидыКИ = Истина И (ВЫРАЗИТЬ (КонтактнаяИнформацияВнутр.Вид КАК СТРОКА) ПОДОБНО &ВыбСтрокаВида))
		|	ИЛИ
		|	КонтактнаяИнформацияВнутр.Вид В (&СписокВидовКИ))
		|";
		
		ТекстЗапроса = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ //РАЗЛИЧНЫЕ
		|	КонтактнаяИнформация.ОбъектВнутр        КАК Объект,
		|	КонтактнаяИнформация.ВидВнутр           КАК Вид,
		|	КонтактнаяИнформация.ТипВнутр           КАК Тип,
		|	КонтактнаяИнформация.ПредставлениеВнутр КАК Представление
		|{ВЫБРАТЬ
		|	КонтактнаяИнформация.ОбъектВнутр.*      КАК Объект
		|	//СВОЙСТВА
		|}
		|
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВЫРАЗИТЬ(КонтактнаяИнформацияВнутр.Объект КАК " + ПолучитьИмяСсылкиОбъектаОтчета() + ") КАК ОбъектВнутр,
		|		КонтактнаяИнформацияВнутр.Вид           КАК ВидВнутр,
		|		КонтактнаяИнформацияВнутр.Тип           КАК ТипВнутр,
		|		ВЫРАЗИТЬ(КонтактнаяИнформацияВнутр.Представление КАК СТРОКА(1000)) КАК ПредставлениеВнутр
		|
		|	ИЗ
		|		РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформацияВнутр
		|
		|	ГДЕ
		|		" + СтрокаВиртуальныхПараметров + "
		//|	{ГДЕ
		//|		Объект.* КАК Объект}
		|
		|	) КАК КонтактнаяИнформация
		|	//СОЕДИНЕНИЯ
		|
		|{ГДЕ
		|	КонтактнаяИнформация.ОбъектВнутр.* КАК Объект
		|	//СВОЙСТВА
		|	//КАТЕГОРИИ
		|}
		|
		|{УПОРЯДОЧИТЬ ПО
		|	КонтактнаяИнформация.ОбъектВнутр.* КАК Объект
		|	//СВОЙСТВА
		|}
		|ИТОГИ ПО
		|	Вид
		|{ИТОГИ ПО
		|	КонтактнаяИнформация.ОбъектВнутр.* КАК Объект
		|	//СВОЙСТВА
		|}
		|
		|";
		
	Иначе
		
		// формула запроса:
		// ((КонтактныеЛицаКонтрагентов><Контрагенты) + (КонтактныеЛицаКонтрагентов><Контрагенты))<КонтактнаяИнформация
		// где '<' - левое соединение, '><' - внутренннее соединение, '+' - объединение

		ТекстЗапроса = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ //РАЗЛИЧНЫЕ
		|	СписокКонтактов.Контакт             КАК Объект,
		|	КонтактнаяИнформация.Вид            КАК Вид,
		|	КонтактнаяИнформация.Тип            КАК Тип,
		|	КонтактнаяИнформация.Представление  КАК Представление
		|
		|{ВЫБРАТЬ
		|	СписокКонтактов.Контакт.*           КАК Объект,
		|	СписокКонтактов.Контрагент.*        КАК Контрагент
		|	//СВОЙСТВА
		|}
		|ИЗ
		|
		|	(
		|	ВЫБРАТЬ 
		|		ВЫБОР КОГДА Контакты.КонтактноеЛицо ССЫЛКА Справочник.КонтактныеЛицаКонтрагентов  
		|			ТОГДА Контакты.КонтактноеЛицо ИНАЧЕ Контакты.Контрагент КОНЕЦ КАК Контакт, 
		|		Контакты.Контрагент     КАК Контрагент,
		|		Контакты.КонтактноеЛицо КАК КонтактноеЛицо
		|	ИЗ
		//		Формируем таблицу из Контактных лиц и их Владельцев (Контрагентов) со строкой по контрагенту без указания Контактного лица (группировка)
		|		(
		//		Таблица Контрагент - Контактное Лицо
		|		ВЫБРАТЬ 
		|			Контрагенты.Ссылка             КАК Контрагент,
		|			КонтактныеЛица.Ссылка  КАК КонтактноеЛицо
		|		ИЗ
		|			Справочник.КонтактныеЛицаКонтрагентов  КАК КонтактныеЛица
		|	
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|			Справочник.Контрагенты        КАК Контрагенты
		|		ПО
		|			Контрагенты.Ссылка = КонтактныеЛица.Владелец
		|
		|		ОБЪЕДИНИТЬ ВСЕ
		|
		//		Таблица Контрагент - пустое Контактное лицо
		|		ВЫБРАТЬ 
		|			КонтактныеЛица.Владелец     КАК Контрагент,
		|			&ПустаяСтрока               КАК КонтактноеЛицо
		|		ИЗ
		|			Справочник.КонтактныеЛицаКонтрагентов КАК КонтактныеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|			Справочник.Контрагенты КАК Контрагенты
		|		ПО
		|			Контрагенты.Ссылка = КонтактныеЛица.Владелец
		|		СГРУППИРОВАТЬ ПО КонтактныеЛица.Владелец
		|		) КАК Контакты
		|	СГРУППИРОВАТЬ ПО Контрагент,Контакты.КонтактноеЛицо
		|	) КАК СписокКонтактов
		|
		// Для каждой записи таблицы СписокКонтактов (Контрагент или Контактное лицо) добавляем контактную информацию
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	(
		|	ВЫБРАТЬ  //РАЗЛИЧНЫЕ
		|		КонтактнаяИнформация.Объект         КАК Объект,
		|		КонтактнаяИнформация.Вид            КАК Вид,
		|		КонтактнаяИнформация.Тип            КАК Тип,
		|       ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(1000)) КАК Представление
		|	ИЗ
		|		РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|	) КАК КонтактнаяИнформация
		|ПО
		|	КонтактнаяИнформация.Объект = СписокКонтактов.Контакт
		|
		|	//СОЕДИНЕНИЯ
		|
		|ГДЕ  КонтактнаяИнформация.Представление <> &ПустаяСтрока
		|{ГДЕ
		|	СписокКонтактов.Контакт.*           КАК Объект,
		|	СписокКонтактов.Контрагент.*        КАК Контрагент
		|	//СВОЙСТВА
		|	//КАТЕГОРИИ
		|}
		| УПОРЯДОЧИТЬ По Контрагент,КонтактноеЛицо
		|{УПОРЯДОЧИТЬ ПО
		|	СписокКонтактов.Контакт.*           КАК Объект,
		|	СписокКонтактов.Контрагент.*        КАК Контрагент
		|	//СВОЙСТВА
		|}
		|ИТОГИ ПО
		|	Вид
		|{ИТОГИ ПО
		|	СписокКонтактов.Контакт.*           КАК Объект,
		|	СписокКонтактов.Контрагент.*        КАК Контрагент
		|	//СВОЙСТВА
		|}
		|
		|";
		
	КонецЕсли;

	
	СтруктураПредставлениеПолей = Новый Структура("Вид, Объект", "Вид котактной информации", мСписокОбъектовОтчета.НайтиПоЗначению(ОбъектОтчета).Представление);
	
	мСоответствиеНазначений = Новый Соответствие;

	ПостроительОтчета = Новый ПостроительОтчета;
	
	Если ИспользоватьСвойстваИКатегории Тогда
		
		// Свойства и категории, назначаемые пользователем:
		//Имя поля                    Имя назначения свойств и категорий объектов
		//СкладКомпании               Справочник_СкладКомпании
		//Номенклатура                Справочник_Номенклатура
		//ХарактеристикаНоменклатуры  Справочник_ХарактеристикиНоменклатуры
		//Заказ                       Документы
		//ДокументПоставки            Документы

		ТаблицаПолей = Новый ТаблицаЗначений;
		ТаблицаПолей.Колонки.Добавить("ПутьКДанным");  // описание поля запроса поля, для которого добавляются свойства и категории. Используется в условии соединения с регистром сведений, хранящим значения свойств или категорий
		ТаблицаПолей.Колонки.Добавить("Представление");// представление поля, для которого добавляются свойства и категории. 
		ТаблицаПолей.Колонки.Добавить("Назначение");   // назначение свойств/категорий объектов для данного поля
		ТаблицаПолей.Колонки.Добавить("ТипЗначения");  // тип значения поля, для которого добавляются свойства и категории. Используется, если не установлено назначение
		ТаблицаПолей.Колонки.Добавить("НетКатегорий"); // признак НЕиспользования категорий для объекта

		НоваяСтрока = ТаблицаПолей.Добавить();
		НоваяСтрока.ПутьКДанным   = ?(ОбъектОтчета = Тип("СправочникСсылка.КонтактныеЛицаКонтрагентов"),"СписокКонтактов.Контакт","КонтактнаяИнформация.ОбъектВнутр");
		НоваяСтрока.Представление = мСписокОбъектовОтчета.НайтиПоЗначению(ОбъектОтчета).Представление;
		СсылкаОбъекта = Новый (ОбъектОтчета);
		НоваяСтрока.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов["Справочник_" + СсылкаОбъекта.Метаданные().Имя];
		

		ТекстПоляКатегорий = "";
		ТекстПоляСвойств = "";

		// Добавим строки запроса, необходимые для использования свойств и категорий
		УправлениеОтчетами.ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, ТекстЗапроса, СтруктураПредставлениеПолей, мСоответствиеНазначений, ПостроительОтчета.Параметры, , ТекстПоляКатегорий, ТекстПоляСвойств, , , , , , мСтруктураДляОтбораПоКатегориям);

	КонецЕсли;
	
	ПостроительОтчета.Текст = ТекстЗапроса;
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(ОбъектОтчета);
	ПостроительОтчета.ДоступныеПоля.Объект.ТипЗначения = Новый ОписаниеТипов(МассивТипов);
	
	СсылкаОбъекта = Новый (ОбъектОтчета);
	Если ИспользоватьСвойстваИКатегории И ЗначениеЗаполнено(ТекстПоляСвойств) Тогда
		УправлениеОтчетами.УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстПоляКатегорий, ТекстПоляСвойств, мСоответствиеНазначений, СтруктураПредставлениеПолей);
	КонецЕсли;

	УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	
	// Установим имены быстрых отборов
	Если ПостроительОтчета.Отбор.Найти("Объект") = Неопределено Тогда
		ПостроительОтчета.Отбор.Добавить("Объект");
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ПЕЧАТНОЙ ФОРМЫ ОТЧЕТА

// Процедура заполняет ПолеТабличногоДокумента
//
// Параметры - Таб - ПолеТабличногоДокумента
Процедура СформироватьОтчет(Таб, ТолькоЗаголовок = Ложь) Экспорт

	СписокВидовКИ = Новый СписокЗначений;
	
	Для каждого СтрокаТаблицы Из ВидыКонтактнойИнформации Цикл
		Если НЕ СтрокаТаблицы.Использование Тогда
			Продолжить;
		КонецЕсли;
		СписокВидовКИ.Добавить(СтрокаТаблицы.ВидКонтактнойИнформации);
	КонецЦикла;
	
	ПостроительОтчета.Параметры.Вставить("ОбрабатыватьПерсональныеВидыКИ", ОбрабатыватьПерсональныеВидыКИ);
	ПостроительОтчета.Параметры.Вставить("ВыбСтрокаВида"                 , ("%" + СтрокаПерсональныхВидовКИ + "%"));
	ПостроительОтчета.Параметры.Вставить("СписокВидовКИ"                 , СписокВидовКИ);
	ПостроительОтчета.Параметры.Вставить("ПустаяСтрока"                  , "");
	
	Если НЕ УправлениеОтчетами.ЗадатьПараметрыОтбораПоКатегориям(ПостроительОтчета, мСтруктураДляОтбораПоКатегориям) Тогда
		Предупреждение("По одной категории нельзя устанавливать несколько отборов");
		Возврат;
	КонецЕсли;

	УправлениеОтчетами.ПроверитьПорядокПостроителяОтчета(ПостроительОтчета);

	ПостроительОтчета.Выполнить();
	
	Таб.Очистить();
	
	СекцияШапка = мМакет.ПолучитьОбласть("ШапкаВерх");
	СекцияШапка.Параметры.НаименованиеОтчета = "Отчет о контактной информации, объект - " + мСписокОбъектовОтчета.НайтиПоЗначению(ОбъектОтчета).Представление;
	Таб.Вывести(СекцияШапка);
	
	СекцияИнтервал = мМакет.ПолучитьОбласть("ШапкаИнтервал");
	СекцияИнтервал.Параметры.СтрокаИнтервал = "Дата формирования отчета: " + Формат(ТекущаяДата(), "ДФ=dd.MM.yyyy");
	Таб.Вывести(СекцияИнтервал);
	мКоличествоВыведенныхСтрокЗаголовка = 4;
	
	СтрокаГруппировок = УправлениеОтчетами.СформироватьСтрокуИзмерений(ПостроительОтчета.ИзмеренияСтроки);
	Если НЕ ПустаяСтрока(СтрокаГруппировок) Тогда
		СтрокаГруппировок = "Группировки строк: " + СтрокаГруппировок;
		СекцияГруппировки = мМакет.ПолучитьОбласть("ШапкаГруппировки");
		СекцияГруппировки.Параметры.СтрокаГруппировок = СтрокаГруппировок;
		Таб.Вывести(СекцияГруппировки);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли; 

	СтрокаОтборов = УправлениеОтчетами.СформироватьСтрокуОтборов(ПостроительОтчета.Отбор);
	Если НЕ ПустаяСтрока(СтрокаОтборов) Тогда
		СтрокаОтборов = "Отбор: " + СтрокаОтборов;
		СекцияОтбор = мМакет.ПолучитьОбласть("ШапкаОтбор");
		СекцияОтбор.Параметры.СтрокаОтборов = СтрокаОтборов;
		Таб.Вывести(СекцияОтбор);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли; 
	
	СтрокаПорядка = УправлениеОтчетами.СформироватьСтрокуПорядка(ПостроительОтчета.Порядок);
	Если НЕ ПустаяСтрока(СтрокаПорядка) Тогда
		СтрокаПорядка = "Сортировка: " + СтрокаПорядка;
		СекцияПорядок = мМакет.ПолучитьОбласть("ШапкаПорядок");
		СекцияПорядок.Параметры.СтрокаПорядка = СтрокаПорядка;
		Таб.Вывести(СекцияПорядок);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли;
	
	Если ТолькоЗаголовок Тогда
		ИзменитьВидимостьЗаголовка(Таб);
		Возврат;
	КонецЕсли; 
	
	Если ПостроительОтчета.ИзмеренияСтроки.Количество() = 0 Тогда
		Предупреждение("Необходимо выбрать хотя бы одну группировку в отчете.");
		Возврат;
	КонецЕсли; 
	
	Если СписокВидовКИ.Количество() = 0 И НЕ ОбрабатыватьПерсональныеВидыКИ Тогда
		Предупреждение("Для формирования отчета необходимо отметить виды контактной информации в настройке отчета.");
		Возврат;
	КонецЕсли; 
	
	Секция = мМакет.ПолучитьОбласть("ШапкаВидыКИ|Значение");
	Таб.Вывести(Секция);
	
	РезультатЗапроса = ПостроительОтчета.Результат;
	
	мКолВоСтолбов = 0;
	
	мСписокВсехВидовКИ.Очистить();
	
	Для каждого СтрокаТаблицы Из ВидыКонтактнойИнформации Цикл
		
		Если НЕ СтрокаТаблицы.Использование Тогда
			Продолжить;
		КонецЕсли; 
		
		мСписокВсехВидовКИ.Добавить(СтрокаТаблицы.ВидКонтактнойИнформации);
		
		Секция = мМакет.ПолучитьОбласть("ШапкаВидыКИ|Показатель");
		Секция.Параметры.ИмяПоказателя = Строка(СтрокаТаблицы.ВидКонтактнойИнформации.Тип) + ": " + СокрЛП(СтрокаТаблицы.ВидКонтактнойИнформации);
		Таб.Присоединить(Секция);
		мКолВоСтолбов = мКолВоСтолбов + 1;
	
	КонецЦикла;
	
	ВыборкаВидов = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Вид");
	Пока ВыборкаВидов.Следующий() Цикл
		
		Если ТипЗнч(ВыборкаВидов.Вид) <> Тип("Строка") Тогда
			Продолжить;
		КонецЕсли; 
		
		ВыборкаДетальныхЗаписей = ВыборкаВидов.Выбрать();
		Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
		
			Если ВыборкаДетальныхЗаписей.ТипЗаписи() <> ТипЗаписиЗапроса.ДетальнаяЗапись Тогда
				Продолжить;
			КонецЕсли;
		
			мСписокВсехВидовКИ.Добавить(ВыборкаДетальныхЗаписей.Вид);
			
			Секция = мМакет.ПолучитьОбласть("ШапкаВидыКИ|Показатель");
			Секция.Параметры.ИмяПоказателя = Строка(ВыборкаДетальныхЗаписей.Тип) + ": " + СокрЛП(ВыборкаДетальныхЗаписей.Вид);
			Таб.Присоединить(Секция);
			мКолВоСтолбов = мКолВоСтолбов + 1;
		
		КонецЦикла;
		
	КонецЦикла;
	
	Таб.Область(2, 2, мКоличествоВыведенныхСтрокЗаголовка, (мКолВоСтолбов + 2)).ПоВыделеннымКолонкам = Истина;
	
	Таб.НачатьАвтогруппировкуСтрок();
	
	ВывестиСтроки(0, РезультатЗапроса, Таб);
	
	Таб.ЗакончитьАвтогруппировкуСтрок();
	
	ИзменитьВидимостьЗаголовка(Таб);
	
	Таб.ТолькоПросмотр = Истина;
	Таб.Показать();

КонецПроцедуры

// Процедура выводит строки в ПолеТабличногоДокумента
// 
// Параметры
//  Таб - ПолеТабличногоДокумента
//  Выборка - выборка запроса, из которой выводить строки
//  ТекущийИндекс - число, индекс выводимой группировки
// 
// Возвращаемое значение
//  НЕТ
Процедура ВывестиСтроки(ТекущийИндекс, Выборка, Таб)

	Если ТекущийИндекс > ПостроительОтчета.ИзмеренияСтроки.Количество() - 1 Тогда
		Возврат;
	КонецЕсли; 
	
	Если РаскрашиватьГруппировки Тогда
		Если ТекущийИндекс <> ПостроительОтчета.ИзмеренияСтроки.Количество() - 1 Тогда
			ИндексЦвета = ТекущийИндекс;
			Если ИндексЦвета >= 10 Тогда
				ИндексЦвета = (ТекущийИндекс/10 - Цел(ТекущийИндекс/10))*10;
			КонецЕсли; 
			ТекущийЦвет = мМакет.Области["Цвет"+СокрЛП(ИндексЦвета)].ЦветФона;
		Иначе
			ТекущийЦвет = Новый Цвет;
		КонецЕсли;
	КонецЕсли; 
		
	НаименованиеГруппировки = ПостроительОтчета.ИзмеренияСтроки[ТекущийИндекс].Имя;
	
	// Если добавить в группировки строк одинаковые значения, то в именах групировок
	// добавляется цифра 1,2,3..., а поля таблицы запроса естественно не добавляются с такими именами
	// поэтому из имени группировки удалим последние цифры в имени
	
	а = СтрДлина(НаименованиеГруппировки);
	Пока а > 0 Цикл
		Если КодСимвола(Сред(НаименованиеГруппировки, а, 1)) >= 49 И КодСимвола(Сред(НаименованиеГруппировки, а, 1)) <= 57 Тогда
			а = а - 1;
			Продолжить;
		КонецЕсли;
		Прервать;
	КонецЦикла;
	
	НаименованиеГруппировки = Лев(НаименованиеГруппировки, а);
	
	ТекущаяГруппировкаОтчета = ПостроительОтчета.ИзмеренияСтроки[ТекущийИндекс];
	
	ТекущаяВыборка = Выборка.Выбрать(?(ТекущаяГруппировкаОтчета.ТипИзмерения = ТипИзмеренияПостроителяОтчета.Иерархия, ОбходРезультатаЗапроса.ПоГруппировкам, ОбходРезультатаЗапроса.ПоГруппировкамСИерархией), ПостроительОтчета.ИзмеренияСтроки[ТекущийИндекс].Имя);
	
	ОбходКонтрагентовПриКонтактныхЛицах = (НаименованиеГруппировки = "Контрагент"  И ОбъектОтчета = Тип("СправочникСсылка.КонтактныеЛицаКонтрагентов"));
	
	Пока ТекущаяВыборка.Следующий() Цикл
		
		// если тип объекта отличается от Объекта отчета - пропустим (особенность обхода Контактных лиц когда Объект - Контрагент)
		Если НаименованиеГруппировки = "Объект" Тогда
			Если ТипЗнч(ТекущаяВыборка.Объект) <> ОбъектОтчета Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;

		Секция = мМакет.ПолучитьОбласть("Строка|Значение");
		Секция.Параметры.ИмяЗначенияГруппировки = ТекущаяВыборка[НаименованиеГруппировки];
		Секция.Области.ЯчейкаИмяЗначенияГруппировкиСтрока.Расшифровка = ТекущаяВыборка[НаименованиеГруппировки];
		Если ПустаяСтрока(Секция.Параметры.ИмяЗначенияГруппировки) Тогда
			Секция.Параметры.ИмяЗначенияГруппировки = "<...>";
		КонецЕсли; 
		Секция.Области.ЯчейкаИмяЗначенияГруппировкиСтрока.Отступ = ТекущийИндекс;
		Если РаскрашиватьГруппировки Тогда
			Секция.Области.ЯчейкаИмяЗначенияГруппировкиСтрока.ЦветФона = ТекущийЦвет;
		КонецЕсли;
		СекцияГруппировки = Таб.Вывести(Секция, ТекущийИндекс);
		
		Если (НаименованиеГруппировки = "Объект" ИЛИ ОбходКонтрагентовПриКонтактныхЛицах) И НЕ ТекущаяВыборка[НаименованиеГруппировки].ЭтоГруппа Тогда
		
			ТекущаяВыборкаВидовКИ = ТекущаяВыборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Вид");

			Для каждого ЭлементСписка Из мСписокВсехВидовКИ Цикл
				
				ТекущаяВыборкаВидовКИ.Сбросить();
				
				Секция = мМакет.ПолучитьОбласть("Строка|Показатель");
				// если обходим контрагентов при контактных лицах - выберем по виду только нужные реквизиты из общего списка
				Если ОбходКонтрагентовПриКонтактныхЛицах И ЭлементСписка.Значение.ВидОбъектаКонтактнойИнформации <> Перечисления.ВидыОбъектовКонтактнойИнформации.Контрагенты Тогда
					Секция.Параметры.ЗначениеПоказателя = "";		
				ИначеЕсли ТекущаяВыборкаВидовКИ.НайтиСледующий(Новый Структура("Вид", ЭлементСписка.Значение)) Тогда
					ВыборкаКонечныхЗаписей = ТекущаяВыборкаВидовКИ.Выбрать();
					ПредставлениеДетальнойЗаписи = "";
					Пока ВыборкаКонечныхЗаписей.Следующий() Цикл
						Если ВыборкаКонечныхЗаписей.ТипЗаписи() = ТипЗаписиЗапроса.ДетальнаяЗапись Тогда
							ПредставлениеДетальнойЗаписи = СокрЛП(ВыборкаКонечныхЗаписей.Представление);
							Прервать;
						КонецЕсли; 
					КонецЦикла;
					Секция.Параметры.ЗначениеПоказателя = ПредставлениеДетальнойЗаписи;
				Иначе
					Секция.Параметры.ЗначениеПоказателя = "";
				КонецЕсли;
				
				Если РаскрашиватьГруппировки Тогда
					Секция.Области.ЗначениеПоказателя.ЦветФона = ТекущийЦвет;
				КонецЕсли;
				Таб.Присоединить(Секция);
			
			КонецЦикла; 
			
		Иначе
			
			ОбластьГруппировки = Таб.Область(СекцияГруппировки.Верх, 2, СекцияГруппировки.Низ, (мКолВоСтолбов + 2));
			ОбластьГруппировки.Объединить();
			ОбластьГруппировки.ГраницаСправа = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
			ОбластьГруппировки.ГраницаСлева  = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
			ОбластьГруппировки.ГраницаСверху = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
			ОбластьГруппировки.ГраницаСнизу  = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
			Если РаскрашиватьГруппировки Тогда
				ОбластьГруппировки.ЦветФона = ТекущийЦвет;
			КонецЕсли;
			Если НаименованиеГруппировки = "Объект" Тогда
				ОбластьГруппировки.Шрифт = Новый Шрифт(,,, Истина);
			КонецЕсли;
			
		КонецЕсли; 
		
		ВывестиСтроки(ТекущийИндекс + 1, ТекущаяВыборка, Таб);
	
	КонецЦикла; 

КонецПроцедуры

// Определим и заполним список объектов отчета
мСписокОбъектовОтчета = Новый СписокЗначений;
ТипыОбъектов = Метаданные.РегистрыСведений.КонтактнаяИнформация.Измерения.Объект.Тип.Типы();
Для каждого ТипОбъекта Из ТипыОбъектов Цикл
	ПустаяСсылкаОбъекта = Новый (ТипОбъекта);
	мСписокОбъектовОтчета.Добавить(ТипОбъекта, ПустаяСсылкаОбъекта.Метаданные().Синоним);
КонецЦикла;

// Определим значения переменных объекта
мМакет = ПолучитьМакет("Макет");
мКоличествоВыведенныхСтрокЗаголовка = 0;
мКолВоСтолбов = 0;
мСписокВсехВидовКИ = Новый СписокЗначений;
ПоказыватьЗаголовок = Истина;
#КонецЕсли
