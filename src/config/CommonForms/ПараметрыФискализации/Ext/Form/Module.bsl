﻿
//#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Идентификатор = Параметры.Идентификатор;
	Модель = Параметры.Модель;
	КассаККМ = Параметры.КассаККМ;
	
	ФискальноеУстройство = Строка(Модель)+" , "+Строка(КассаККМ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПолучитьСерверТО().ПодключитьКлиента(ЭтаФорма);
	
	ОбработкаОбслуживания = Неопределено;
	ОбъектДрайвера = Неопределено;
	
	Результат = ПолучитьСерверТО().ПолучитьОбъектДрайвера(Идентификатор, ОбработкаОбслуживания, ОбъектДрайвера);
	Попытка
		ТипОборудования = ОбработкаОбслуживания.мПараметрыПодключения.ТипОборудования;
	Исключение
		ТипОборудования = "ККТ";
	КонецПопытки;
	
	Если ТипОборудования = "ПринтерЧеков" Тогда
		ОбщегоНазначения.СообщитьИнформациюПользователю("Для оборудования ""Принтер чеков"" данная команда не поддерживается.");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Результат <> ПредопределенноеЗначение("Перечисление.ТООшибкиОбщие.ПустаяСсылка") Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Фискальное устройство не подключено!");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Результат = ОбработкаОбслуживания.ПолучитьПараметрыККТ(ОбъектДрайвера);
	Если Результат <> ПредопределенноеЗначение("Перечисление.ТООшибкиОбщие.ПустаяСсылка") Тогда
		ОбщегоНазначения.СообщитьОбОшибке(ОбъектДрайвера.ОписаниеОшибки);
		Отказ = Истина;
	Иначе
		ПараметрыККТ = ОбъектДрайвера.ВыходныеПараметры;
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыККТ);
		СистемыНалогообложения = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПараметрыККТ.КодыСистемыНалогообложения);
		КодыСистемыНалогообложения0 = СистемыНалогообложения.Найти("0") <> Неопределено;
		КодыСистемыНалогообложения1 = СистемыНалогообложения.Найти("1") <> Неопределено;
		КодыСистемыНалогообложения2 = СистемыНалогообложения.Найти("2") <> Неопределено;
		КодыСистемыНалогообложения3 = СистемыНалогообложения.Найти("3") <> Неопределено;
		КодыСистемыНалогообложения4 = СистемыНалогообложения.Найти("4") <> Неопределено;
		КодыСистемыНалогообложения5 = СистемыНалогообложения.Найти("5") <> Неопределено;
		
		НовыйФормат = НЕ ПустаяСтрока(ПараметрыККТ.ВерсияФФДККТ) И (ПараметрыККТ.ВерсияФФДККТ = "1.1" ИЛИ ПараметрыККТ.ВерсияФФДККТ = "1.0.5");
		Элементы.МестоПроведенияРасчетов.Видимость = НовыйФормат;
		Элементы.ГруппаНастройкиККТ15.Видимость = НовыйФормат;
	КонецЕсли;
	
КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗакрытьФорму(Команда)
	
	Закрыть(Неопределено); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ПолучитьСерверТО().ОтключитьКлиента(ЭтаФорма);
	
КонецПроцедуры

//#КонецОбласти

//#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПоддерживаетсяВидТО(Вид) Экспорт

	Результат = Ложь;

	Если Вид = ПредопределенноеЗначение("Перечисление.ВидыТорговогоОборудования.ККТ") Тогда
		Результат = Истина;
	КонецЕсли;

	Возврат Результат;

КонецФункции // ПоддерживаетсяВидТО()

&НаКлиенте
Процедура КомандаРучноеУправление(Команда)
	ОбъектДрайвера = Неопределено;
	ОбработкаОбслуживания = Неопределено;
	ПолучитьСерверТО().ПолучитьОбъектДрайвера(Идентификатор, ОбработкаОбслуживания, ОбъектДрайвера);
	Если ОбработкаОбслуживания = Неопределено Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Ошибка загрузки обработки обслуживания");
		Возврат;
	КонецЕсли;
	
	Если Команда.Имя = "КомандаОткрытьСмену" Тогда
		РезультатВыполнения = ОбработкаОбслуживания.ОткрытьСмену(ОбъектДрайвера);
		Если РезультатВыполнения <> ПредопределенноеЗначение("Перечисление.ТООшибкиОбщие.ПустаяСсылка") Тогда
			ОбщегоНазначения.СообщитьОбОшибке(ОбъектДрайвера.ОписаниеОшибки);
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаЗакрытьСмену" Тогда
		РезультатВыполнения = ОбработкаОбслуживания.ЗакрытьСмену(ОбъектДрайвера);
		Если РезультатВыполнения <> ПредопределенноеЗначение("Перечисление.ТООшибкиОбщие.ПустаяСсылка") Тогда
			ОбщегоНазначения.СообщитьОбОшибке(ОбъектДрайвера.ОписаниеОшибки);
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаВнесение" ИЛИ Команда.Имя = "КомандаВыемка" Тогда
		ОбработкаОбслуживания.ПолучитьТекущееСостояние(ОбъектДрайвера);
		Если ОбъектДрайвера.ВыходныеПараметры[2] <> 2 Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Кассовая смена не открыта");
			Возврат;
		КонецЕсли;
		Сумма = Неопределено;
		Если ВвестиЧисло(Сумма, "Введите сумму", 15, 2) Тогда
			Если Команда.Имя = "КомандаВыемка" Тогда
				Сумма = -Сумма;
			КонецЕсли;
			Пароль    = "";
			Результат = ПолучитьСерверТО().ВнестиСумму(Идентификатор, Пароль, Сумма);
			Если ЗначениеЗаполнено(Результат) Тогда
				ТекстОшибки = ПолучитьСерверТО().ПолучитьТекстОшибкиФРТО(Результат);
				ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаОткрытьДенежныйЯщик" Тогда
		РезультатВыполнения = ОбработкаОбслуживания.ОткрытьДенежныйЯщик(ОбъектДрайвера);
		Если РезультатВыполнения <> ПредопределенноеЗначение("Перечисление.ТООшибкиОбщие.ПустаяСсылка") Тогда
			ОбщегоНазначения.СообщитьОбОшибке(ОбъектДрайвера.ОписаниеОшибки);
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаОтчетОСостоянииРасчетов" Тогда
		РезультатВыполнения = ОбработкаОбслуживания.ОтчетОСостоянииРасчетов(ОбъектДрайвера);
		Если РезультатВыполнения <> ПредопределенноеЗначение("Перечисление.ТООшибкиОбщие.ПустаяСсылка") Тогда
			ОбщегоНазначения.СообщитьОбОшибке(ОбъектДрайвера.ОписаниеОшибки);
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаПолучитьТекущееСостояние" Тогда
		РезультатВыполнения = ОбработкаОбслуживания.ПолучитьТекущееСостояние(ОбъектДрайвера);
		Если РезультатВыполнения <> ПредопределенноеЗначение("Перечисление.ТООшибкиОбщие.ПустаяСсылка") Тогда
			ОбщегоНазначения.СообщитьОбОшибке(ОбъектДрайвера.ОписаниеОшибки);
		Иначе
			ВП = ОбъектДрайвера.ВыходныеПараметры;
			ОбщегоНазначения.СообщитьИнформациюПользователю("Номер смены: " + Строка(ВП[0]));
			ОбщегоНазначения.СообщитьИнформациюПользователю("Номер документа: " + Строка(ВП[1]));
			ОбщегоНазначения.СообщитьИнформациюПользователю("Статус смены: " + ?(ВП[2] = 2, "Открыта", "Закрыта"));
			ОбщегоНазначения.СообщитьИнформациюПользователю("Текущая дата: " + Строка(ВП[3]));
			Если ВП.Количество() > 4 И ТипЗнч(ВП[4]) = Тип("Структура") Тогда
				Для Каждого Элемент Из ВП[4] Цикл
					ОбщегоНазначения.СообщитьИнформациюПользователю(Элемент.Ключ + ": " + Строка(Элемент.Значение));
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаОтчетБезГашения" Тогда
		Пароль = ПолучитьСерверТО().ПолучитьПарольАдминистратораККМ();
		РезультатВыполнения = ОбработкаОбслуживания.XОтчет(ОбъектДрайвера, Пароль, Неопределено, Неопределено);
		Если РезультатВыполнения <> ПредопределенноеЗначение("Перечисление.ТООшибкиОбщие.ПустаяСсылка") Тогда
			ОбщегоНазначения.СообщитьОбОшибке(ОбъектДрайвера.ОписаниеОшибки);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

//#КонецОбласти
