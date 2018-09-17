﻿//Функция возвращает данные номеров документов оплаты для формирования движений по РН НДСЗаписиКнигиПродаж
//
Функция СформироватьТаблицуНомеровДокументовОплаты(СтруктураПараметров) Экспорт
	
	Если УчетНДС.ВерсияПостановленияНДС1137(СтруктураПараметров.Дата) < 3 Тогда
		ТаблицаНДСНомераДокументовОплаты = Неопределено;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НДСНачисленный.Организация,
	|	НДСНачисленный.СчетФактура,
	|	НДСНачисленный.Покупатель,
	|	&Ссылка КАК СчетФактураДокумент,
	|	НДСНачисленный.СтавкаНДС,
	|	НДСНачисленный.ВидЦенности,
	|	НДСНачисленный.ДоговорАванса КАК ДоговорКонтрагента
	|ПОМЕСТИТЬ ВТ_ЗаписиКнигиПродажПредварительная
	|ИЗ
	|	РегистрНакопления.НДСНачисленный КАК НДСНачисленный
	|ГДЕ
	|	НДСНачисленный.СчетФактура = &ДокументОснование
	|	И НДСНачисленный.Активность
	|	И НДСНачисленный.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И НЕ НДСНачисленный.СтавкаНДС В (ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС), ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НДСНачисленный.Организация,
	|	НДСНачисленный.СчетФактура,
	|	НДСНачисленный.Покупатель,
	|	НДСНачисленный.СчетФактура,
	|	НДСНачисленный.СтавкаНДС,
	|	НДСНачисленный.ВидЦенности,
	|	НДСНачисленный.ДоговорАванса
	|ИЗ
	|	РегистрНакопления.НДСНачисленный КАК НДСНачисленный
	|ГДЕ
	|	НДСНачисленный.СчетФактура = &Ссылка
	|	И НДСНачисленный.Активность
	|	И НДСНачисленный.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И НЕ НДСНачисленный.СтавкаНДС В (ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС), ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВТ_ЗаписиКнигиПродажПредварительная.Организация,
	|	ВТ_ЗаписиКнигиПродажПредварительная.СчетФактура,
	|	ВТ_ЗаписиКнигиПродажПредварительная.Покупатель,
	|	ВТ_ЗаписиКнигиПродажПредварительная.СчетФактураДокумент,
	|	ВТ_ЗаписиКнигиПродажПредварительная.СтавкаНДС,
	|	ВТ_ЗаписиКнигиПродажПредварительная.ВидЦенности,
	|	ВТ_ЗаписиКнигиПродажПредварительная.ДоговорКонтрагента
	|ПОМЕСТИТЬ ВТ_ЗаписиКнигиПродаж
	|ИЗ
	|	ВТ_ЗаписиКнигиПродажПредварительная КАК ВТ_ЗаписиКнигиПродажПредварительная
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетФактураВыданныйПлатежноРасчетныеДокументы.ДатаПлатежноРасчетногоДокумента КАК ДатаДокументаОплаты,
	|	СчетФактураВыданныйПлатежноРасчетныеДокументы.НомерПлатежноРасчетногоДокумента КАК НомерДокументаОплаты,
	|	ВТ_ЗаписиКнигиПродаж.Организация КАК Организация,
	|	ВТ_ЗаписиКнигиПродаж.СчетФактура КАК СчетФактура,
	|	&Период КАК Период,
	|	ВТ_ЗаписиКнигиПродаж.Покупатель КАК Покупатель,
	|	ВТ_ЗаписиКнигиПродаж.СтавкаНДС,
	|	ВТ_ЗаписиКнигиПродаж.ВидЦенности,
	|	ВТ_ЗаписиКнигиПродаж.ДоговорКонтрагента
	|ИЗ
	|	ВТ_ЗаписиКнигиПродаж КАК ВТ_ЗаписиКнигиПродаж
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный.ДатаНомерДокументовОплаты КАК СчетФактураВыданныйПлатежноРасчетныеДокументы
	|		ПО ВТ_ЗаписиКнигиПродаж.СчетФактураДокумент = СчетФактураВыданныйПлатежноРасчетныеДокументы.Ссылка
	|ГДЕ
	|	СчетФактураВыданныйПлатежноРасчетныеДокументы.Ссылка = &Ссылка
	|	И СчетФактураВыданныйПлатежноРасчетныеДокументы.ДатаПлатежноРасчетногоДокумента <> ДАТАВРЕМЯ(1, 1, 1)";
	
	Запрос.УстановитьПараметр("Ссылка", СтруктураПараметров.Ссылка);
	Запрос.УстановитьПараметр("Период", СтруктураПараметров.Дата);
	Запрос.УстановитьПараметр("ДокументОснование", СтруктураПараметров.ДокументОснование);
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ

// Обработчик обновления
//
// Устанавливает новый код вида операции для сводных счетов-фактур по комиссии
Процедура УстановитьКодВидаОперацииСводныйКомиссионный() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтчетКомиссионераОПродажахПокупатели.СчетФактура КАК СчетФактура,
	|	СУММА(1) КАК Количество
	|ПОМЕСТИТЬ ВТ_СводныеСгенерированныеПредварительная
	|ИЗ
	|	Документ.ОтчетКомиссионераОПродажах.Покупатели КАК ОтчетКомиссионераОПродажахПокупатели
	|ГДЕ
	|	ОтчетКомиссионераОПродажахПокупатели.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И ОтчетКомиссионераОПродажахПокупатели.Ссылка.ВыписыватьСчетаФактурыСводно
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтчетКомиссионераОПродажахПокупатели.СчетФактура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетФактура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_СводныеСгенерированныеПредварительная.СчетФактура КАК СчетФактура
	|ПОМЕСТИТЬ ВТ_СводныеСгенерированные
	|ИЗ
	|	ВТ_СводныеСгенерированныеПредварительная КАК ВТ_СводныеСгенерированныеПредварительная
	|ГДЕ
	|	ВТ_СводныеСгенерированныеПредварительная.Количество > 1
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетФактура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетФактураВыданный.Ссылка КАК Ссылка,
	|	""27"" КАК КодВидаОперации,
	|	ВЫБОР
	|		КОГДА СчетФактураВыданный.КодВидаОперации = ""27""
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КодУстановлен
	|ИЗ
	|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|ГДЕ
	|	(СчетФактураВыданный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыВыставленного.НаРеализацию)
	|			ИЛИ СчетФактураВыданный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыВыставленного.Корректировочный))
	|	И СчетФактураВыданный.ПометкаУдаления = ЛОЖЬ
	|	И СчетФактураВыданный.СводныйКомиссионный = ИСТИНА
	|	И СчетФактураВыданный.Ссылка В
	|			(ВЫБРАТЬ
	|				ВТ_СводныеСгенерированные.СчетФактура
	|			ИЗ
	|				ВТ_СводныеСгенерированные)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СчетФактураВыданный.Ссылка,
	|	""28"",
	|	ВЫБОР
	|		КОГДА СчетФактураВыданный.КодВидаОперации = ""28""
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ
	|ИЗ
	|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|ГДЕ
	|	(СчетФактураВыданный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыВыставленного.НаАванс)
	|			ИЛИ СчетФактураВыданный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыВыставленного.НаАвансКомитента))
	|	И СчетФактураВыданный.ПометкаУдаления = ЛОЖЬ
	|	И СчетФактураВыданный.СводныйКомиссионный = ИСТИНА
	|ИТОГИ
	|	СУММА(КодУстановлен)
	|ПО
	|	ОБЩИЕ";
	
	ВыборкаИтоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если ВыборкаИтоги.Следующий()
		И ВыборкаИтоги.КодУстановлен = 0 Тогда
		ВыборкаДокументы = ВыборкаИтоги.Выбрать();
		Пока ВыборкаДокументы.Следующий() Цикл
			СчетФактураДокумент = ВыборкаДокументы.Ссылка.ПолучитьОбъект();
			СчетФактураДокумент.КодВидаОПерации = ВыборкаДокументы.КодВидаОперации;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СчетФактураДокумент);
		КонецЦикла;
	Иначе
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

// Обработчик обновления. Заполняет новый реквизит "КодВидаОперацииНаУменьшение" 
// для корректировочных счетов-фактур дата которых больше или равна 1 января 2015 года
Процедура УстановитьКодВидаОперацииНаУменьшение() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СчетФактураВыданный.Ссылка
	|ИЗ
	|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|ГДЕ
	|	НЕ СчетФактураВыданный.ПометкаУдаления
	|	И СчетФактураВыданный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыВыставленного.Корректировочный)
	|	И СчетФактураВыданный.Дата >= ДАТАВРЕМЯ(2015, 1, 1)
	|	И СчетФактураВыданный.КодВидаОперацииНаУменьшение = """"";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ОбрабатываемыйСчетФактура = Выборка.Ссылка;
			СчетФактураДокумент = ОбрабатываемыйСчетФактура.ПолучитьОбъект();
			
			СчетФактураДокумент.КодВидаОперацииНаУменьшение = "18";
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СчетФактураДокумент);
			
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры
