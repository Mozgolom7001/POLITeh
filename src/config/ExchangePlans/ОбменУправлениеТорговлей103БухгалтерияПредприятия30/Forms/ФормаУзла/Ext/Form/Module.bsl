﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтаФорма);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	УстановитьДоступностьЭлементамФормы(Элементы.Организации);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоСкладамПриИзменении(Элемент)
	УстановитьДоступностьЭлементамФормы(Элементы.Склады);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоПодразделениямПриИзменении(Элемент)
	УстановитьДоступностьЭлементамФормы(Элементы.Подразделения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьЭлементамФормы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ

&НаКлиенте
Процедура УстановитьДоступностьЭлементамФормы(ТекущаяСтраница = Неопределено)
	ЗначенияФлаговИСтраниц = Новый Соответствие();
	ЗначенияФлаговИСтраниц.Вставить(Элементы.Организации, Объект.ИспользоватьОтборПоОрганизациям);
	ЗначенияФлаговИСтраниц.Вставить(Элементы.Склады, Объект.ИспользоватьОтборПоСкладам);
	ЗначенияФлаговИСтраниц.Вставить(Элементы.Подразделения, Объект.ИспользоватьОтборПоПодразделениям);
	
	СтраницыОтбора = Новый Массив();
	Если Объект.ИспользоватьОтборПоОрганизациям Тогда
		СтраницыОтбора.Добавить(Элементы.Организации);
	КонецЕсли;
	Если Объект.ИспользоватьОтборПоСкладам Тогда
		СтраницыОтбора.Добавить(Элементы.Склады);
	КонецЕсли;
	Если Объект.ИспользоватьОтборПоПодразделениям Тогда
		СтраницыОтбора.Добавить(Элементы.Подразделения);
	КонецЕсли;
	Элементы.Страницы.Доступность = СтраницыОтбора.Количество() > 0.00;
	
	Если СтраницыОтбора.Количество() = 0.00 Тогда
		возврат;
	КонецЕсли;
	
	Элементы.Организации.Доступность = Объект.ИспользоватьОтборПоОрганизациям;
	Элементы.Подразделения.Доступность = Объект.ИспользоватьОтборПоПодразделениям;
	Элементы.Склады.Доступность = Объект.ИспользоватьОтборПоСкладам;
	Если ТекущаяСтраница <> Неопределено Тогда
		Если ЗначенияФлаговИСтраниц[ТекущаяСтраница] = Ложь И Элементы.Страницы.ТекущаяСтраница = ТекущаяСтраница Тогда
			Элементы.Страницы.ТекущаяСтраница = СтраницыОтбора[0];
		ИначеЕсли ЗначенияФлаговИСтраниц[ТекущаяСтраница] = Истина Тогда
			Элементы.Страницы.ТекущаяСтраница = ТекущаяСтраница;
		КонецЕсли;
	Иначе
		Элементы.Страницы.ТекущаяСтраница = СтраницыОтбора[0];
	КонецЕсли;
КонецПроцедуры
