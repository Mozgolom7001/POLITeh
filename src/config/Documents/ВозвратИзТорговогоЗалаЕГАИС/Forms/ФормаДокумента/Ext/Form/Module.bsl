﻿
//#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ Тогда
		ДокументОбъект = ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.ВозвратИзТорговогоЗалаЕГАИС"));
		ЭтоНовыйДокумент = ДокументОбъект.ЭтоНовый();
	КонецЕсли;
	
	Документы.ВозвратИзТорговогоЗалаЕГАИС.УстановитьУсловноеОформлениеСтатусаОбработки(ЭтаФорма, "СтатусОбработки", "Объект.СтатусОбработки");
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПроверитьИнформациюОбОшибке();
		
		ДоступностьЭлементовФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПроверитьИнформациюОбОшибке();
	
	ДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИнтеграцияЕГАИСКлиентСерверПереопределяемый.ПроверитьИспользованиеПодсистемы(Отказ);
	Если СокрЛП(Объект.Комментарий) = "Отказ" Тогда
		Отказ = Истина;
	КонецЕсли;
	Если ЭтоНовыйДокумент Тогда
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСправкаБПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.СправкаБ) Тогда
			ТекущиеДанные.АлкогольнаяПродукция = ИнтеграцияЕГАИСВызовСервера.ЗначениеРеквизитаОбъекта(ТекущиеДанные.СправкаБ, "АлкогольнаяПродукция");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьВЕГАИС(Команда)
	
	Если Модифицированность Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Документ не сохранен.'"));
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	
	Если НЕ Объект.Проведен Тогда
		Если НЕ Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение)) Тогда
			Возврат;
		КонецЕсли;
		
		ДополнительныеПараметры.Вставить("ПроведенПередОтправкой", Истина);
	КонецЕсли;
	
	ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ВозвратИзТорговогоЗала");
	
	ПараметрыЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ПараметрыЗапроса.ДокументСсылка = Объект.Ссылка;
	
	Результат = ИнтеграцияЕГАИСКлиент.СформироватьИсходящийЗапрос(ВидДокумента, ПараметрыЗапроса);
	
	Если Результат.Результат Тогда
		Прочитать();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Документ успешно выгружен.'"));
	ИначеЕсли ДополнительныеПараметры.Свойство("ПроведенПередОтправкой") Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения));
	КонецЕсли;
	
КонецПроцедуры

//#КонецОбласти

//#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьИнформациюОбОшибке()

	ИнформацияОбОшибке = РегистрыСведений.ПротоколОбменаЕГАИС.ТекстПоследнейОшибки(Объект.Ссылка);
	Элементы.ИнформацияОбОшибке.Видимость = НЕ ПустаяСтрока(ИнформацияОбОшибке);

КонецПроцедуры

&НаСервере
Процедура ДоступностьЭлементовФормы()
	
	ТолькоПросмотр =
		Объект.СтатусОбработки <> Перечисления.СтатусыОбработкиВозвратаИзТорговогоЗалаЕГАИС.Новый
		И Объект.СтатусОбработки <> Перечисления.СтатусыОбработкиВозвратаИзТорговогоЗалаЕГАИС.ОшибкаПередачиВЕГАИС;
		
	Элементы.ФормаОтправитьВЕГАИС.Видимость = НЕ ТолькоПросмотр;
	
КонецПроцедуры

//#КонецОбласти