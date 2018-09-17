﻿Перем мВалютаРегламентированногоУчета Экспорт;
Перем ЭтоВалютныйСчет Экспорт;

Функция ПроверитьКорректностьНомераСчета(Номер, ТекстОшибки = "") Экспорт

	Если НЕ ТипЗнч(Номер) = Тип("Строка") Тогда
		ТекстОшибки = "Номер счета должен быть строкой.";
		Возврат Ложь;
	КонецЕсли;
	
	Если ПустаяСтрока(Номер) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЭтоВалютныйСчет И СтрДлина(Номер) <> 20 Тогда
			ТекстОшибки = "Номер счета должен состоять из 20 знаков.";
			Возврат Ложь;
	КонецЕсли;

	Если НЕ ОбщегоНазначения.ТолькоЦифрыВСтроке(Номер) Тогда
		ТекстОшибки = "В номере счета есть не только цифры. Возможно, номер указан неверно.";
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ПроверитьКорректностьНомераСчета()

Функция ПроверитьКорректностьБИК(БИК, ТекстОшибки = "") Экспорт

	Если НЕ ТипЗнч(БИК) = Тип("Строка") Тогда
		ТекстОшибки = "БИК банка должен быть строкой.";
		Возврат Ложь;
	КонецЕсли;
	
	Если ПустаяСтрока(БИК) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтрДлина(БИК) <> 9 Тогда
		ТекстОшибки = "БИК банка должен состоять из 9 знаков.";
		Возврат Ложь;
	КонецЕсли;

	Если НЕ ОбщегоНазначения.ТолькоЦифрыВСтроке(БИК) Тогда
		ТекстОшибки = "В составе БИК банка должны быть только цифры.";
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ Лев(БИК, 2) = "04" Тогда
		ТекстОшибки = "Первые 2 цифры БИК банка должны быть ""04"".";
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ПроверитьКорректностьБИК()

Функция ПроверитьКорректностьКоррсчета(Коррсчет, ТекстОшибки = "") Экспорт

	Если НЕ ТипЗнч(Коррсчет) = Тип("Строка") Тогда
		ТекстОшибки = "Корр.счет банка должен быть строкой.";
		Возврат Ложь;
	КонецЕсли;
	
	Если ПустаяСтрока(Коррсчет) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтрДлина(Коррсчет) <> 20 Тогда
		ТекстОшибки = "Корр.счет банка должен состоять из 20 знаков.";
		Возврат Ложь;
	КонецЕсли;

	Если НЕ ОбщегоНазначения.ТолькоЦифрыВСтроке(Коррсчет) Тогда
		ТекстОшибки = "В составе корр.счета банка должны быть только цифры.";
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ПроверитьКорректностьКоррсчета()

// Обработчик события ПередЗаписью формы.
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ПометкаУдаления ИЛИ Ссылка.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = "Запись банковского счета (" + Владелец + ") " + Наименование + ", код " + Код;
	
	Если НЕ ОбщегоНазначения.ТолькоЦифрыВСтроке(СокрЛП(НомерСчета)) Тогда 
		ОбщегоНазначения.СообщитьОбОшибке("В номере счета есть не только цифры. Возможно, номер указан неверно.", Отказ, Заголовок);
	КонецЕсли;

	// Проверка заполнения обязательных реквизитов
	Если НЕ ЗначениеЗаполнено(ВалютаДенежныхСредств) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не выбрана валюта.", Отказ, Заголовок);
	КонецЕсли;
	Если ВалютаДенежныхСредств = мВалютаРегламентированногоУчета Тогда
	
		Если НЕ ЗначениеЗаполнено(НомерСчета) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не указан номер счета.", Отказ, Заголовок);
		ИначеЕсли СтрДлина(НомерСчета) <> 20 Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Номер счета должен состоять из 20 знаков.", Отказ, Заголовок);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Банк) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не выбран банк.", Отказ, Заголовок);
		КонецЕсли;
	
	КонецЕсли;


КонецПроцедуры

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

