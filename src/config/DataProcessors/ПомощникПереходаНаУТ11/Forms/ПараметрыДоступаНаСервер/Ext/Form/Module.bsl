﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроксиСерверТребуетАутентификации = ВосстановитьЗначение("ПроксиСерверТребуетАутентификации");
	
	Если ПроксиСерверТребуетАутентификации Тогда
		ПользовательПроксиСервера = ВосстановитьЗначение("ИмяПользователяПрокси");
		ПарольПроксиСервера = ВосстановитьЗначение("ПарольПользователяПрокси");
	КонецЕсли;
	
	НастройкиОбновления = ВосстановитьЗначение("ОбновлениеКонфигурации_НастройкиОбновления");
	Если НастройкиОбновления <> Неопределено Тогда
		КодПользователяСервераОбновлений  = НастройкиОбновления.КодПользователяСервераОбновлений;
		ПарольСервераОбновлений           = НастройкиОбновления.ПарольСервераОбновлений;
	КонецЕсли;
	
	УстановитьДоступность();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПроксиСерверТребуетАутентификацииПриИзменении(Элемент)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если ПроксиСерверТребуетАутентификации Тогда
		СохранитьЗначение("ИмяПользователяПрокси", ПользовательПроксиСервера);
		СохранитьЗначение("ПарольПользователяПрокси", ПарольПроксиСервера);
	КонецЕсли;
	
	НастройкиОбновления = ВосстановитьЗначение("ОбновлениеКонфигурации_НастройкиОбновления");
	Если НастройкиОбновления = Неопределено Тогда
		НастройкиОбновления = Новый Структура("КодПользователяСервераОбновлений, ПарольСервераОбновлений, ЗапомнитьПарольСервераОбновлений");
		НастройкиОбновления.ЗапомнитьПарольСервераОбновлений = Ложь;
	КонецЕсли;
	
	НастройкиОбновления.КодПользователяСервераОбновлений = КодПользователяСервераОбновлений;
	НастройкиОбновления.ПарольСервераОбновлений = ПарольСервераОбновлений;
	
	СохранитьЗначение("ОбновлениеКонфигурации_НастройкиОбновления", НастройкиОбновления);
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.ПользовательПроксиСервера.ТолькоПросмотр = НЕ ПроксиСерверТребуетАутентификации;
	Элементы.ПарольПроксиСервера.ТолькоПросмотр = НЕ ПроксиСерверТребуетАутентификации;
	
КонецПроцедуры
