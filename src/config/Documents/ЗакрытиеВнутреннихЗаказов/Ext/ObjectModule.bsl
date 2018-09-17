﻿Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по регистру 
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
Функция ПодготовитьТаблицуПоВнутреннимЗаказамУпр()

	СписокЗаказов = Заказы.ВыгрузитьКолонку("ВнутреннийЗаказ");

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр( "ДокументСсылка",  Ссылка);
	Запрос.УстановитьПараметр( "МоментДокумента", МоментВремени());
	Запрос.УстановитьПараметр( "СписокЗаказов",   СписокЗаказов);
	
	Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВнутренниеЗаказыОстатки.Заказчик,
		|	ВнутренниеЗаказыОстатки.ВнутреннийЗаказ КАК ВнутреннийЗаказ,
		|	ВнутренниеЗаказыОстатки.ВнутреннийЗаказ.Организация КАК Организация,
		|	ВнутренниеЗаказыОстатки.Номенклатура,
		|	ВнутренниеЗаказыОстатки.ХарактеристикаНоменклатуры,
		|	ВнутренниеЗаказыОстатки.СтатусПартии,
		|	ВнутренниеЗаказыОстатки.КоличествоОстаток КАК Количество,
		|	ВнутренниеЗаказыОстатки.ЕдиницаИзмерения
		|ИЗ
		|	РегистрНакопления.ВнутренниеЗаказы.Остатки(&МоментДокумента, ВнутреннийЗаказ В (&СписокЗаказов)) КАК ВнутренниеЗаказыОстатки
		|Упорядочить по
		|	Заказчик,
		|	ВнутреннийЗаказ,
		|	Номенклатура,
		|	ХарактеристикаНоменклатуры,
		|	СтатусПартии,
		|	ЕдиницаИзмерения
		|";
	
	ТаблицаЗаказов = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаЗаказов;

КонецФункции // ПодготовитьТаблицуТоваров()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТаре  - результат запроса по табличной части "ВозвратнаяТара",
//  ВыборкаПоШапкеДокумента - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ВидОперации");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  ВыборкаПоШапкеДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиЗаказы(ТаблицаПоТоварам, ВыборкаПоШапкеДокумента, 
	                                              Отказ, Заголовок)

	// Проверим даты Заказов, они не должны быть больше даты документа
	Для Каждого СтрокаТЧ Из Заказы Цикл
		Если СтрокаТЧ.ВнутреннийЗаказ.Дата > Дата Тогда
			СтрокаСообщения = "Дата и время Заказа в строке " + СокрЛП(СтрокаТЧ.НомерСтроки) + " больше даты и времени документа!";			
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщения, Отказ, Заголовок);
		КонецЕсли;
	КонецЦикла;

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ВнутреннийЗаказ");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Заказы", СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  ВыборкаПоШапкеДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  ТаблицаПоТаре             - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам( РежимПроведения, ВыборкаПоШапкеДокумента, ТаблицаПоЗаказамПокупателей, ТаблицаПоРазмещению, ТаблицаПоРезервам, Отказ, Заголовок)
								
	ДвиженияПоРегистрамУпр(
		РежимПроведения,
		ВыборкаПоШапкеДокумента,
		ТаблицаПоЗаказамПокупателей,
		ТаблицаПоРазмещению, 
		ТаблицаПоРезервам,
		Отказ, Заголовок);

КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегистрамУпр(РежимПроведения, ВыборкаПоШапкеДокумента, ТаблицаПоЗаказамПокупателей, ТаблицаПоРазмещению, 
								 ТаблицаПоРезервам, Отказ, Заголовок)
								
	Если ВидОперации = Перечисления.ВидыОперацийЗакрытиеВнутреннихЗаказов.ЗакрытиеЗаказов Тогда
	
		Если ТаблицаПоЗаказамПокупателей.Количество() > 0 Тогда
			
			//Движения по внутренним заказам
			НаборДвижений   = Движения.ВнутренниеЗаказы;
			
			СтруктТаблицДокумента = Новый Структура;
			СтруктТаблицДокумента.Вставить("ТаблицаПоТоварам", ТаблицаПоЗаказамПокупателей);
				
			ТаблицыДанныхДокумента = ОбщегоНазначения.ЗагрузитьТаблицыДокументаВСтруктуру(НаборДвижений, СтруктТаблицДокумента);
			
			ОбщегоНазначения.ЗаписатьТаблицыДокументаВРегистр(НаборДвижений, ВидДвиженияНакопления.Расход, ТаблицыДанныхДокумента, Дата);
		
		КонецЕсли;

	КонецЕсли;
	
	Если ТаблицаПоРазмещению.Количество() > 0 Тогда
		
		НаборДвижений = Движения.РазмещениеЗаказовПокупателей;
		
		СтруктТаблицДокумента = Новый Структура;
		СтруктТаблицДокумента.Вставить("ТаблицаПоТоварам", ТаблицаПоРазмещению);
				
		ТаблицыДанныхДокумента = ОбщегоНазначения.ЗагрузитьТаблицыДокументаВСтруктуру(НаборДвижений, СтруктТаблицДокумента);
			
		ОбщегоНазначения.ЗаписатьТаблицыДокументаВРегистр(НаборДвижений, ВидДвиженияНакопления.Расход, ТаблицыДанныхДокумента, Дата);
			
	КонецЕсли;
	
	Если ТаблицаПоРезервам.Количество() > 0 Тогда
		
		НаборДвижений = Движения.ТоварыВРезервеНаСкладах;
		
		СтруктТаблицДокумента = Новый Структура;
		СтруктТаблицДокумента.Вставить("ТаблицаПоТоварам", ТаблицаПоРезервам);
				
		ТаблицыДанныхДокумента = ОбщегоНазначения.ЗагрузитьТаблицыДокументаВСтруктуру(НаборДвижений, СтруктТаблицДокумента);
			
		ОбщегоНазначения.ЗаписатьТаблицыДокументаВРегистр(НаборДвижений, ВидДвиженияНакопления.Расход, ТаблицыДанныхДокумента, Дата);
		
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ВнутреннийЗаказ") Тогда
		// Заполнение шапки
		Ответственный = Основание.Ответственный;
		Подразделение = Основание.Подразделение;
		ВидОперации = Перечисления.ВидыОперацийЗакрытиеВнутреннихЗаказов.ЗакрытиеЗаказов;

		// Заполнение строки
		НоваяСтрока = Заказы.Добавить();
		НоваяСтрока.ВнутреннийЗаказ = Основание.Ссылка;
		
	КонецЕсли;

КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;

	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке      = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	СписокЗаказов = Заказы.ВыгрузитьКолонку("ВнутреннийЗаказ");

	// Подготовим таблицу товаров для проведения.
	ТаблицаПоЗаказамПокупателей = ПодготовитьТаблицуПоВнутреннимЗаказамУпр();
	
	// Проверить заполнение ТЧ "Заказы".
	ПроверитьЗаполнениеТабличнойЧастиЗаказы(ТаблицаПоЗаказамПокупателей, СтруктураШапкиДокумента, 
											Отказ, Заголовок);
	

	// Движения по документу
	Если Не Отказ Тогда
       ТаблицаПоРазмещению = УправлениеЗаказами.ПодготовитьТаблицуДляЗакрытияРазмещения(Ссылка,МоментВремени(),СписокЗаказов,истина,истина);
	
		ТаблицаПоРезервам = УправлениеЗаказами.ПодготовитьТаблицуДляЗакрытияРезервов(Ссылка,МоментВремени(),СписокЗаказов);
	

		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, 
							ТаблицаПоЗаказамПокупателей, ТаблицаПоРазмещению,
							ТаблицаПоРеЗервам, Отказ, Заголовок);

	КонецЕсли; 

КонецПроцедуры	// ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры // ПередЗаписью

Процедура ОбработкаУдаленияПроведения(Отказ)

	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры // ОбработкаУдаленияПроведения


мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

