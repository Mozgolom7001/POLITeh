﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СтруктураСертификата = Параметры.СтруктураСертификата;
	Отпечаток = Параметры.Отпечаток;
	
	УстановившийПодпись = Параметры.УстановившийПодпись;
	Комментарий  = Параметры.Комментарий;
	АдресПодписи = Параметры.АдресПодписи;
	ДатаПодписи  = Параметры.ДатаПодписи;
	
	Если ТипЗнч(Параметры.УстановившийПодпись) = Тип("Строка") Тогда
		УстановившийПодписьСтрока = Параметры.УстановившийПодпись;
		Элементы.УстановившийПодпись.Видимость = Ложь;
		Элементы.УстановившийПодписьСтрока.Видимость = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресСертификата") Тогда
		АдресСертификата = Параметры.АдресСертификата;
	КонецЕсли;	
	
	КомуВыдан = СтруктураСертификата.КомуВыдан;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выгрузить(Команда)
	ЭлектроннаяЦифроваяПодписьКлиент.СохранитьПодпись(АдресПодписи);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	ЭлектроннаяЦифроваяПодписьКлиент.ОткрытьСертификатПоОтпечаткуИАдресу(Отпечаток, АдресСертификата);
КонецПроцедуры
