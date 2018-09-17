﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ОстаткиЕГАИС.УстановитьУсловноеОформлениеСтатусаОбработки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокЗапросовЕГАИС" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыгрузитьВЕГАИС(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВидДокумента = Элементы.Список.ТекущиеДанные.ВидДокумента;
	
	ПараметрыЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ПараметрыЗапроса.ДокументСсылка = Элементы.Список.ТекущиеДанные.Ссылка;
	
	Результат = ИнтеграцияЕГАИСКлиент.СформироватьИсходящийЗапрос(ВидДокумента, ПараметрыЗапроса);
	
	Если Результат.Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Запрос на загрузку остатков сформирован.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИнтеграцияЕГАИСКлиентСерверПереопределяемый.ПроверитьИспользованиеПодсистемы(Отказ);
КонецПроцедуры
