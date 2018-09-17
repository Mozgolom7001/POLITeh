﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура добавляет запись в регистр по переданным значениям структуры
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(Новый Структура("Корреспондент", СтруктураЗаписи.Узел), "НастройкиТранспортаОбменаОбластиДанных");
	Иначе
		ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиТранспортаОбмена");
	КонецЕсли;
	
КонецПроцедуры

// Процедура обновляет запись в регистре по переданным значениям структуры
Процедура ОбновитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиТранспортаОбмена");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции получения значений настроек для узла плана обмена

// Получает значения настроек транспорта определенного вида.
// Если вид транспорта не указан (ВидТранспортаОбмена = Неопределено),
// то получает настройки всех видов транспорта, заведенных в системе
//
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  
//
Функция НастройкиТранспорта(Знач Узел, Знач ВидТранспортаОбмена = Неопределено) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Возврат РегистрыСведений["НастройкиТранспортаОбменаОбластиДанных"].НастройкиТранспорта(Узел);
	Иначе
		
		Возврат НастройкиТранспортаОбмена(Узел, ВидТранспортаОбмена);
	КонецЕсли;
	
КонецФункции

Функция НастройкиТранспортаWS(Узел, Пароль = "") Экспорт
	
	СтруктураНастроек = ПолучитьСтруктуруНастроек("WS");
	
	Результат = ПолучитьДанныеРегистраПоСтруктуре(Узел, СтруктураНастроек);
	
	Если Не Результат.WSЗапомнитьПароль Тогда
		
		Результат.WSПароль = Пароль;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы) Экспорт
	
	// возвращаемое значение функции
	ВидТранспортаСообщений = Неопределено;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	НастройкиТранспортаОбмена.ВидТранспортаСообщенийОбменаПоУмолчанию КАК ВидТранспортаСообщенийОбменаПоУмолчанию
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена
	|ГДЕ
	|	НастройкиТранспортаОбмена.Узел = &УзелИнформационнойБазы
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ВидТранспортаСообщений = Выборка.ВидТранспортаСообщенийОбменаПоУмолчанию;
		
	КонецЕсли;
	
	Возврат ВидТранспортаСообщений;
КонецФункции

Функция ИмяКаталогаОбменаИнформацией(ВидТранспортаСообщенийОбмена, УзелИнформационнойБазы) Экспорт
	
	// возвращаемое значение функции
	Результат = "";
	
	Если ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.FILE Тогда
		
		НастройкиТранспорта = НастройкиТранспорта(УзелИнформационнойБазы);
		
		Результат = НастройкиТранспорта["FILEКаталогОбменаИнформацией"];
		
	ИначеЕсли ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда
		
		НастройкиТранспорта = НастройкиТранспорта(УзелИнформационнойБазы);
		
		Результат = НастройкиТранспорта["FTPСоединениеПуть"];
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ПредставленияНастроекТранспорта(ВидТранспорта) Экспорт
	
	Результат = Новый Структура;
	
	Если ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.COM Тогда
		
		ДобавитьЭлементПредставленияНастройки(Результат, "COMВариантРаботыИнформационнойБазы");
		ДобавитьЭлементПредставленияНастройки(Результат, "COMИмяСервера1СПредприятия");
		ДобавитьЭлементПредставленияНастройки(Результат, "COMИмяИнформационнойБазыНаСервере1СПредприятия");
		ДобавитьЭлементПредставленияНастройки(Результат, "COMКаталогИнформационнойБазы");
		ДобавитьЭлементПредставленияНастройки(Результат, "COMАутентификацияОперационнойСистемы");
		ДобавитьЭлементПредставленияНастройки(Результат, "COMИмяПользователя");
		ДобавитьЭлементПредставленияНастройки(Результат, "COMПарольПользователя");
		
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.FILE Тогда
		
		ДобавитьЭлементПредставленияНастройки(Результат, "FILEКаталогОбменаИнформацией");
		ДобавитьЭлементПредставленияНастройки(Результат, "FILEСжиматьФайлИсходящегоСообщения");
		
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда
		
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСоединениеПуть");
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСоединениеПорт");
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСоединениеПользователь");
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСоединениеПароль");
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСоединениеМаксимальныйДопустимыйРазмерСообщения");
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСоединениеПассивноеСоединение");
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСжиматьФайлИсходящегоСообщения");
		
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL Тогда
		
		ДобавитьЭлементПредставленияНастройки(Результат, "EMAILУчетнаяЗапись");
		ДобавитьЭлементПредставленияНастройки(Результат, "EMAILМаксимальныйДопустимыйРазмерСообщения");
		ДобавитьЭлементПредставленияНастройки(Результат, "EMAILСжиматьФайлИсходящегоСообщения");
		
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS Тогда
		
		ДобавитьЭлементПредставленияНастройки(Результат, "WSURLВебСервиса");
		ДобавитьЭлементПредставленияНастройки(Результат, "WSИмяПользователя");
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция НастройкиТранспортаДляУзлаЗаданы(Узел) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ 1 ИЗ РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена
	|ГДЕ
	|	НастройкиТранспортаОбмена.Узел = &Узел
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Узел", Узел);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

Функция КоличествоЭлементовВТранзакцииЗагрузкиДанных(Узел) Экспорт
	
	// возвращаемое значение функции
	Результат = 0;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	НастройкиТранспортаОбмена.КоличествоЭлементовВТранзакцииЗагрузкиДанных КАК КоличествоЭлементовВТранзакции
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена
	|ГДЕ
	|	НастройкиТранспортаОбмена.Узел = &Узел
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Узел", Узел);
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Результат = Выборка.КоличествоЭлементовВТранзакции;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция КоличествоЭлементовВТранзакцииВыгрузкиДанных(Узел) Экспорт
	
	// возвращаемое значение функции
	Результат = 0;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	НастройкиТранспортаОбмена.КоличествоЭлементовВТранзакцииВыгрузкиДанных КАК КоличествоЭлементовВТранзакции
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена
	|ГДЕ
	|	НастройкиТранспортаОбмена.Узел = &Узел
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Узел", Узел);
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Результат = Выборка.КоличествоЭлементовВТранзакции;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция НастроенныеВидыТранспорта(УзелИнформационнойБазы) Экспорт
	
	Результат = Новый Массив;
	
	НастройкиТранспорта = НастройкиТранспорта(УзелИнформационнойБазы);
	
	Если ЗначениеЗаполнено(НастройкиТранспорта.COMКаталогИнформационнойБазы) 
		ИЛИ ЗначениеЗаполнено(НастройкиТранспорта.COMИмяИнформационнойБазыНаСервере1СПредприятия) Тогда
		
		Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.COM);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкиТранспорта.EMAILУчетнаяЗапись) Тогда
		
		Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкиТранспорта.FILEКаталогОбменаИнформацией) Тогда
		
		Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкиТранспорта.FTPСоединениеПуть) Тогда
		
		Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкиТранспорта.WSURLВебСервиса) Тогда
		
		Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции

// Получает значения настроек транспорта определенного вида.
// Если вид транспорта не указан (ВидТранспортаОбмена = Неопределено),
// то получает настройки всех видов транспорта, заведенных в системе
//
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  
//
Функция НастройкиТранспортаОбмена(Узел, ВидТранспортаОбмена)
	
	СтруктураНастроек = Новый Структура;
	
	// общие настройки для всех видов транспорта
	СтруктураНастроек.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию");
	СтруктураНастроек.Вставить("ПарольАрхиваСообщенияОбмена");
	СтруктураНастроек.Вставить("КоличествоЭлементовВТранзакцииВыгрузкиДанных");
	СтруктураНастроек.Вставить("КоличествоЭлементовВТранзакцииЗагрузкиДанных");
	
	Если ВидТранспортаОбмена = Неопределено Тогда
		
		Для Каждого ВидТранспорта ИЗ Перечисления.ВидыТранспортаСообщенийОбмена Цикл
			
			СтруктураНастроекТранспорта = ПолучитьСтруктуруНастроек(ОбщегоНазначения.ИмяЗначенияПеречисления(ВидТранспорта));
			
			СтруктураНастроек = ОбъединитьКоллекции(СтруктураНастроек, СтруктураНастроекТранспорта);
			
		КонецЦикла;
		
	Иначе
		
		СтруктураНастроекТранспорта = ПолучитьСтруктуруНастроек(ОбщегоНазначения.ИмяЗначенияПеречисления(ВидТранспортаОбмена));
		
		СтруктураНастроек = ОбъединитьКоллекции(СтруктураНастроек, СтруктураНастроекТранспорта);
		
	КонецЕсли;
	
	Результат = ПолучитьДанныеРегистраПоСтруктуре(Узел, СтруктураНастроек);
	Результат.Вставить("ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений", Истина);
	
	Возврат Результат;
КонецФункции

Функция ПолучитьДанныеРегистраПоСтруктуре(Узел, СтруктураНастроек)
	
	Если Не ЗначениеЗаполнено(Узел) Тогда
		Возврат СтруктураНастроек;
	КонецЕсли;
	
	Если СтруктураНастроек.Количество() = 0 Тогда
		Возврат СтруктураНастроек;
	КонецЕсли;
	
	// Формируем текст запроса только по необходимым полям -
	// параметрам для указанного вида транспорта
	ТекстЗапроса = "ВЫБРАТЬ ";
	
	Для Каждого ЭлементНастройки ИЗ СтруктураНастроек Цикл
		
		ТекстЗапроса = ТекстЗапроса + ЭлементНастройки.Ключ + ", ";
		
	КонецЦикла;
	
	// убираем последний символ ", "
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(ТекстЗапроса, 2);
	
	ТекстЗапроса = ТекстЗапроса + "
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена
	|ГДЕ
	|	НастройкиТранспортаОбмена.Узел = &Узел
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Узел", Узел);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Если есть данные для узла, то заполняем структуру
	Если Выборка.Следующий() Тогда
		
		Для Каждого ЭлементНастройки ИЗ СтруктураНастроек Цикл
			
			СтруктураНастроек[ЭлементНастройки.Ключ] = Выборка[ЭлементНастройки.Ключ];
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СтруктураНастроек;
	
КонецФункции

Функция ПолучитьСтруктуруНастроек(ПодстрокаПоиска)
	
	СтруктураНастроекТранспорта = Новый Структура();
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.НастройкиТранспортаОбмена;
	
	Для Каждого Ресурс ИЗ МетаданныеРегистра.Ресурсы Цикл
		
		Если Найти(Ресурс.Имя, ПодстрокаПоиска) <> 0 Тогда
			
			СтруктураНастроекТранспорта.Вставить(Ресурс.Имя, Ресурс.Синоним);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураНастроекТранспорта;
КонецФункции

Функция ОбъединитьКоллекции(Структура1, Структура2)
	
	СтруктураРезультат = Новый Структура;
	
	ДополнитьКоллекцию(Структура1, СтруктураРезультат);
	ДополнитьКоллекцию(Структура2, СтруктураРезультат);
	
	Возврат СтруктураРезультат;
КонецФункции

Процедура ДополнитьКоллекцию(Источник, Приемник)
	
	Для Каждого Элемент ИЗ Источник Цикл
		
		Приемник.Вставить(Элемент.Ключ, Элемент.Значение);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьЭлементПредставленияНастройки(Структура, ИмяНастройки)
	
	Структура.Вставить(ИмяНастройки, Метаданные.РегистрыСведений.НастройкиТранспортаОбмена.Ресурсы[ИмяНастройки].Представление());
	
КонецПроцедуры

#КонецЕсли