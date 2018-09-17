﻿// СписокЗначений для накапливания пакета сообщений в журнал регистрации, 
// формируемых в клиентской бизнес-логике.
Перем СообщенияДляЖурналаРегистрации Экспорт;

Перем глСерверТО Экспорт;

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ГЛОБАЛЬНОГО КОНТЕКСТА

// Процедура - обработчик события "При начале работы системы".
//
Процедура ПриНачалеРаботыСистемы()
	
	УправлениеСоединениямиИБКлиент.УстановитьКонтрольРежимаЗавершенияРаботыПользователей();

КонецПроцедуры 

// Функция возвращает объект для взаимодействия с торговым оборудованием.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  <ОбработкаОбъект> - Объект для взаимодействия с торговым оборудованием.
//
Функция ПолучитьСерверТО() Экспорт

	Если глСерверТО = Неопределено Тогда
		глСерверТО = ИнтеграцияЕГАИСВызовСервера.ПолучитьСерверТОНаСервере();
	КонецЕсли;

	Возврат глСерверТО;

КонецФункции // ПолучитьСерверТО()