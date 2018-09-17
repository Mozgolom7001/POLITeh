﻿// Обработчик регламентного задания ЗаданиеАвтономноеРешение.
Процедура ВыполнитьОбменДаннымиДляНастройкиОбмена(КодНастройки) Экспорт
	
	// Оставлен для совместимости с версиями ранее 10.3.5.
			
КонецПроцедуры

// Обработчик регламентного задания ЗаданиеОтложенныеДвижения.
Процедура ВыполнитьОтложенныеДвиженияДляНастройкиОбмена(КодНастройки) Экспорт
	
	// Оставлен для совместимости с версиями ранее 10.3.5.
			
КонецПроцедуры

Процедура ВыполнитьОбменДаннымиДляНастройкиАвтоматическогоОбменаДанными(КодНастройки) Экспорт
	
	Если НЕ ЗначениеЗаполнено(КодНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаОбмена = Справочники.НастройкиВыполненияОбмена.НайтиПоКоду(КодНастройки);
	
	Если НЕ ЗначениеЗаполнено(НастройкаОбмена)
		ИЛИ НастройкаОбмена.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ПроцедурыОбменаДанными.ВыполнитьОбменПоНастройкеАвтоматическогоВыполненияОбменаДанными(НастройкаОбмена, Ложь);
	
КонецПроцедуры

Процедура ВыполнитьОбменДаннымиЭлектроннымиДокументами(КодНастройки) Экспорт
	
	Если НЕ ЗначениеЗаполнено(КодНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаОбмена = Справочники.УчетныеЗаписиЭлектронногоОбмена.НайтиПоКоду(КодНастройки);
	
	Если НЕ ЗначениеЗаполнено(НастройкаОбмена) Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкаОбмена.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектронныеДокументы.ПолучитьЭлектронныеДокументы(НастройкаОбмена);	
				
КонецПроцедуры

// Процедура выполняет пересчет регистров накопления, для удаления нулевых записей
Процедура ПересчетИтоговРегистровНакопления() Экспорт

	НаДату = НачалоМесяца(ТекущаяДата())-1;	
	ПересчетРегистров(РегистрыНакопления, НаДату, Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки);
	
КонецПроцедуры

Процедура ПересчетРегистров(МенеджерРегистров, НаДату, ОграничениеПоВидуРегистра = Неопределено)
	
	Для Каждого МенеджерРегистра ИЗ МенеджерРегистров Цикл
		МетаданныеРегистра = Метаданные.НайтиПоТипу(ТипЗнч(МенеджерРегистра));
		
		Если ОграничениеПоВидуРегистра <> Неопределено И МетаданныеРегистра.ВидРегистра <> ОграничениеПоВидуРегистра Тогда
			Продолжить;
		КонецЕсли;
		ПересчитатьРегистрПоДате(МенеджерРегистра, НаДату);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПересчитатьРегистрПоДате(МенеджерРегистра, НаДату)
	
	Если МенеджерРегистра.ПолучитьПериодРассчитанныхИтогов()<НаДату Тогда
		МенеджерРегистра.УстановитьПериодРассчитанныхИтогов(НаДату);
	Иначе
		МенеджерРегистра.ПересчитатьИтоги();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновлениеИндексаПолнотекстовогоПоиска() Экспорт
	
	Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить Тогда
		
		Если НЕ ПолнотекстовыйПоиск.ИндексАктуален() Тогда
			Попытка	
				ЗаписьЖурналаРегистрации("Полнотекстовое индексирование", 
				УровеньЖурналаРегистрации.Информация, , ,
				"Начато регламентное индексирование порции");
				
				ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Истина);
				
				ЗаписьЖурналаРегистрации("Полнотекстовое индексирование", 
				УровеньЖурналаРегистрации.Информация, , ,
				"Закончено регламентное  индексирование порции");
			Исключение
				ЗаписьЖурналаРегистрации("Полнотекстовое индексирование", 
				УровеньЖурналаРегистрации.Ошибка, , ,
				"Во время регламентного обновления индекса произошла неизвестная ошибка: " + ОписаниеОшибки());
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
Конецпроцедуры

Процедура СлияниеИндексаПолнотекстовогоПоиска() Экспорт
	
	Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить Тогда
		
		Попытка	
			ЗаписьЖурналаРегистрации("Полнотекстовое индексирование", 
			УровеньЖурналаРегистрации.Информация, , ,
			"Начато регламентное слияние индексов");
				
			ПолнотекстовыйПоиск.ОбновитьИндекс(Истина);
				
			ЗаписьЖурналаРегистрации("Полнотекстовое индексирование", 
			УровеньЖурналаРегистрации.Информация, , ,
			"Закончено регламентное слияние индексов");
		Исключение
			ЗаписьЖурналаРегистрации("Полнотекстовое индексирование", 
			УровеньЖурналаРегистрации.Ошибка, , ,
			"Во время регламентного слияния индекса произошла неизвестная ошибка: " + ОписаниеОшибки());
		КонецПопытки;
		
	КонецЕсли;
	
Конецпроцедуры

// Процедура формирует задачи о необходимости поздравить с днем рождения
//
Процедура СоздатьЗадачиПоздравленияСДнемРождения() Экспорт
	
	УсловиеЗадачи = УправлениеКонтактами.ПолучитьСтрокуУсловияДР();
	
	Запрос = Новый Запрос;

	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Контакты.КонтактноеЛицо                             КАК КонтактноеЛицо,
	|	Контакты.Владелец.ОсновнойМенеджерПокупателя        КАК Исполнитель,
	|	Контакты.КонтактноеЛицо.КоличествоДнейДоНапоминания КАК ИнтервалДней,
	|	Контакты.КонтактноеЛицо.ДатаРождения                КАК ДатаРождения,
	|	Задачи.СрокИсполнения                               КАК Срок
	|ИЗ
	|	Справочник.КонтактныеЛицаКонтрагентов КАК Контакты
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Задача.ЗадачиПользователя КАК Задачи
	|ПО
	|	Задачи.Объект = Контакты.КонтактноеЛицо
	|	И Задачи.Оповещение = ИСТИНА
	|	И Задачи.СрокИсполнения > ДОБАВИТЬКДАТЕ(Контакты.КонтактноеЛицо.ДатаРождения, ГОД, РАЗНОСТЬДАТ(Контакты.КонтактноеЛицо.ДатаРождения, ДОБАВИТЬКДАТЕ(&ТекДата, ДЕНЬ, Контакты.КонтактноеЛицо.КоличествоДнейДоНапоминания), МЕСЯЦ)/12 - 1)
	|	И Задачи.ПамятнаяДата = ИСТИНА
	|ГДЕ
	|	Контакты.КонтактноеЛицо.НапоминатьОДнеРождения = ИСТИНА
	|	И Контакты.КонтактноеЛицо.ДатаРождения <> ДАТАВРЕМЯ(1, 1, 1)
	|	И Контакты.Владелец ССЫЛКА Справочник.Контрагенты
	|	И Контакты.Владелец <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	И Контакты.Владелец.ОсновнойМенеджерПокупателя <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	И ((ДОБАВИТЬКДАТЕ(Контакты.КонтактноеЛицо.ДатаРождения, ГОД, (ГОД(&ТекДата) - ГОД (Контакты.КонтактноеЛицо.ДатаРождения))) >= &ТекДата
	|	И ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(Контакты.КонтактноеЛицо.ДатаРождения, ДЕНЬ, -(Контакты.КонтактноеЛицо.КоличествоДнейДоНапоминания)), ГОД, (ГОД(&ТекДата) - ГОД (Контакты.КонтактноеЛицо.ДатаРождения))) <= &ТекДата)
	|	ИЛИ (ДОБАВИТЬКДАТЕ(Контакты.КонтактноеЛицо.ДатаРождения, ГОД, (ГОД(&ТекДата) - ГОД (Контакты.КонтактноеЛицо.ДатаРождения))) >= ДОБАВИТЬКДАТЕ(&ТекДата, ГОД, -1)
	|	И ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(Контакты.КонтактноеЛицо.ДатаРождения, ДЕНЬ, -(Контакты.КонтактноеЛицо.КоличествоДнейДоНапоминания)), ГОД, (ГОД(&ТекДата) - ГОД (Контакты.КонтактноеЛицо.ДатаРождения))) <= ДОБАВИТЬКДАТЕ(&ТекДата, ГОД, -1)))
	|	И Задачи.СрокИсполнения ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ЛичныеКонтакты.Ссылка,
	|	ЛичныеКонтакты.ПользовательДляОграниченияПравДоступа,
	|	ЛичныеКонтакты.КоличествоДнейДоНапоминания,
	|	ЛичныеКонтакты.ДатаРождения,
	|	Задачи.СрокИсполнения
	|ИЗ
	|	Справочник.ЛичныеКонтакты КАК ЛичныеКонтакты
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Задача.ЗадачиПользователя КАК Задачи
	|ПО
	|	Задачи.Объект = ЛичныеКонтакты.Ссылка
	|	И Задачи.Оповещение = ИСТИНА
	|	И Задачи.СрокИсполнения > ДОБАВИТЬКДАТЕ(ЛичныеКонтакты.ДатаРождения, ГОД, РАЗНОСТЬДАТ(ЛичныеКонтакты.ДатаРождения, ДОБАВИТЬКДАТЕ(&ТекДата, ДЕНЬ, ЛичныеКонтакты.КоличествоДнейДоНапоминания), МЕСЯЦ)/12 - 1)
	|	И Задачи.ПамятнаяДата = ИСТИНА
	|ГДЕ
	|	ЛичныеКонтакты.НапоминатьОДнеРождения = ИСТИНА
	|	И ЛичныеКонтакты.ДатаРождения <> ДАТАВРЕМЯ(1, 1, 1)
	|	И ЛичныеКонтакты.ПользовательДляОграниченияПравДоступа <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	И ((ДОБАВИТЬКДАТЕ(ЛичныеКонтакты.ДатаРождения, ГОД, (ГОД(&ТекДата) - ГОД (ЛичныеКонтакты.ДатаРождения))) >= &ТекДата
	|	И ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ЛичныеКонтакты.ДатаРождения, ДЕНЬ, -(ЛичныеКонтакты.КоличествоДнейДоНапоминания)), ГОД, (ГОД(&ТекДата) - ГОД (ЛичныеКонтакты.ДатаРождения))) <= &ТекДата)
	|	ИЛИ (ДОБАВИТЬКДАТЕ(ЛичныеКонтакты.ДатаРождения, ГОД, (ГОД(&ТекДата) - ГОД (ЛичныеКонтакты.ДатаРождения))) >= ДОБАВИТЬКДАТЕ(&ТекДата, ГОД, -1)
	|	И ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ЛичныеКонтакты.ДатаРождения, ДЕНЬ, -(ЛичныеКонтакты.КоличествоДнейДоНапоминания)), ГОД, (ГОД(&ТекДата) - ГОД (ЛичныеКонтакты.ДатаРождения))) <= ДОБАВИТЬКДАТЕ(&ТекДата, ГОД, -1)))
	|	И Задачи.СрокИсполнения ЕСТЬ NULL
	|";
	
	Запрос.УстановитьПараметр("ТекДата"      , ТекущаяДата());
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	Пока РезультатЗапроса.Следующий()Цикл
		
		НоваяЗадача = Задачи.ЗадачиПользователя.СоздатьЗадачу();
		НоваяЗадача.Дата           =ТекущаяДата();
		НоваяЗадача.Наименование   = Строка(РезультатЗапроса.КонтактноеЛицо) + ". " + УсловиеЗадачи;
		НоваяЗадача.ПамятнаяДата   = Истина;
		НоваяЗадача.Исполнитель    = РезультатЗапроса.Исполнитель;
		НоваяЗадача.Инициатор      = РезультатЗапроса.Исполнитель;
		НоваяЗадача.СрокИсполнения = Дата(Год(ТекущаяДата() + (РезультатЗапроса.ИнтервалДней * 24 * 60 * 60)), Месяц(РезультатЗапроса.ДатаРождения), День(РезультатЗапроса.ДатаРождения), 00, 00, 00);
		НоваяЗадача.Оповещение     = Истина;
		НоваяЗадача.СрокОповещения = НоваяЗадача.СрокИсполнения - (РезультатЗапроса.ИнтервалДней * 24 * 60 * 60);
		НоваяЗадача.Объект         = РезультатЗапроса.КонтактноеЛицо;
		
		Попытка
			НоваяЗадача.Записать();
		Исключение
		КонецПопытки;
		
	КонецЦикла;
		
КонецПроцедуры // СоздатьЗадачиПоздравленияСДнемРождения()

///////////////////////////////////////////
// Процедуры получения электронных сообщений
//

Процедура ПолучениеЭлектронныхСообщений() Экспорт
	
	Если НЕ Константы.ИспользованиеВстроенногоПочтовогоКлиента.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.АвтоПолучениеОтправкаСообщений";
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	УчетныеЗаписиДляПроверки = Новый Массив;
	Пока Выборка.Следующий() Цикл
		УчетныеЗаписиДляПроверки.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	ТекстОшибок = "";
	УправлениеЭлектроннойПочтой.ПолучениеОтправкаПисем(Неопределено, Справочники.Пользователи.ПустаяСсылка(),УчетныеЗаписиДляПроверки,,, Истина, Ложь, ТекстОшибок);
	
	Если ПустаяСтрока(ТекстОшибок) Тогда
		ЗаписьЖурналаРегистрации("Получение электронных сообщений", 
			УровеньЖурналаРегистрации.Информация, Метаданные.Документы.ЭлектронноеПисьмо, ,
			"Получение электронных сообщений выполнено успешно");
	Иначе
		ЗаписьЖурналаРегистрации("Получение электронных сообщений", 
			УровеньЖурналаРегистрации.Ошибка, Метаданные.Документы.ЭлектронноеПисьмо, ,
			"Получение электронных сообщений выполнено с ошибками:" + Символы.ПС + ТекстОшибок);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОтправитьЧеки() Экспорт
	ОтправитьЧекиИзОчереди();
КонецПроцедуры

Процедура ОтправитьЧекиИзОчереди(Интерактивно = Ложь) Экспорт
	
	ПривилегированныйРежимБылУстановлен = ПривилегированныйРежим();
	
	УстановитьПривилегированныйРежим(Истина);
	
	// I. Удаление отправленных записей с битыми ссылками
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭлектронныеЧекиККМ.Источник,
	|	ЭлектронныеЧекиККМ.ПорядковыйНомер,
	|	ЭлектронныеЧекиККМ.ТекстЧека,
	|	ЭлектронныеЧекиККМ.АдресПолучателя,
	|	ЭлектронныеЧекиККМ.ДатаПостановкиВОчередь КАК ДатаПостановкиВОчередь,
	|	ЭлектронныеЧекиККМ.ДатаОтправки КАК ДатаОтправки,
	|	ЭлектронныеЧекиККМ.ОписаниеОшибки
	|ИЗ
	|	РегистрСведений.ЭлектронныеЧекиККМ КАК ЭлектронныеЧекиККМ
	|ГДЕ
	|	ЭлектронныеЧекиККМ.ДатаОтправки <> &ПустаяДата
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаОтправки";
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1,1,1));
	Выборка = Запрос.Выполнить().Выбрать();
	
	нзЭЧ = РегистрыСведений.ЭлектронныеЧекиККМ.СоздатьНаборЗаписей();
	нзЭЧ.Отбор.Источник.Использование = Истина;
	нзЭЧ.Отбор.ПорядковыйНомер.Использование = Истина;
	
	Пока Выборка.Следующий() Цикл
		Если Не ОбщегоНазначения.СсылкаСуществует(Выборка.Источник) Тогда
			
			нзЭЧ.Отбор.Источник.Значение = Выборка.Источник;
			нзЭЧ.Отбор.ПорядковыйНомер.Значение = Выборка.ПорядковыйНомер;
			нзЭЧ.Прочитать();
			нзЭЧ.Очистить();
			нзЭЧ.Записать(Истина);
			
		КонецЕсли;
	КонецЦикла;
	
	// II. Отправка чеков
	
	// 1. Выбрать чеки для отправки
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭлектронныеЧекиККМ.Источник,
	|	ЭлектронныеЧекиККМ.ПорядковыйНомер,
	|	ЭлектронныеЧекиККМ.ТекстЧека,
	|	ЭлектронныеЧекиККМ.АдресПолучателя,
	|	ЭлектронныеЧекиККМ.ДатаПостановкиВОчередь КАК ДатаПостановкиВОчередь,
	|	ЭлектронныеЧекиККМ.ДатаОтправки,
	|	ЭлектронныеЧекиККМ.ОписаниеОшибки
	|ИЗ
	|	РегистрСведений.ЭлектронныеЧекиККМ КАК ЭлектронныеЧекиККМ
	|ГДЕ
	|	ЭлектронныеЧекиККМ.ДатаОтправки = &ПустаяДата
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаПостановкиВОчередь";
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1,1,1));
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат; // Нет чеков для отправки
	Иначе
		Выборка.Сбросить(); // Переход в начало
	КонецЕсли;
	
	// 2. Определить учетную запись для отправки
	УчетнаяЗапись = МенеджерОборудованияВызовСервера.УчетнаяЗаписьЭлектроннойПочтыДляОтправкиЧеков();
	Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ТекстОшибки = "Не определена учетная запись электронной почты для рассылки чеков";
		ЗаписьЖурналаРегистрации("ОтправкаЧековИзОчереди", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегламентныеЗадания.ОтправкаЭлектронныхЧеков, ,
			ТекстОшибки);
		Если Интерактивно Тогда
			ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// 3. Сформировать профиль подключения
	ПрофильПодключения = ЭлектроннаяПочта.СформироватьИнтернетПрофиль(УчетнаяЗапись);
	
	// 4. Подключиться
 	Соединение = Новый ИнтернетПочта;
	Попытка
 		Соединение.Подключиться(ПрофильПодключения);
	Исключение
		Инфо = ИнформацияОбОшибке();
		ТекстОшибки = "Не удалось подключиться с параметрами, заданными в учетной записи " + """" + СокрЛП(УчетнаяЗапись.Наименование) + """:" 
			+ Символы.ПС + Инфо.Описание;
		ЗаписьЖурналаРегистрации("ОтправкаЧековИзОчереди", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегламентныеЗадания.ОтправкаЭлектронныхЧеков, ,
			ТекстОшибки);
		Если Интерактивно Тогда
			ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки);
		КонецЕсли;
		Возврат;
	КонецПопытки;
	
	// 5. Отправить чеки
	нзЭЧ = РегистрыСведений.ЭлектронныеЧекиККМ.СоздатьНаборЗаписей();
	
	Пока Выборка.Следующий() Цикл
		
		нзЭЧ.Очистить();
		нзЭЧ.Отбор.Источник.Значение = Выборка.Источник;
		нзЭЧ.Отбор.Источник.Использование = Истина;
		нзЭЧ.Отбор.ПорядковыйНомер.Значение = Выборка.ПорядковыйНомер;
		нзЭЧ.Отбор.ПорядковыйНомер.Использование = Истина;
		
		ЭлектронныйЧек = нзЭЧ.Добавить();
		ЗаполнитьЗначенияСвойств(ЭлектронныйЧек, Выборка);
		
		ПараметрыПисьма = Новый Структура;
		ПараметрыПисьма.Вставить("Кому", Выборка.АдресПолучателя);
		ПараметрыПисьма.Вставить("Тема", "Электронный чек");
		ПараметрыПисьма.Вставить("Тело", Выборка.ТекстЧека);
		
		Попытка
			ЭлектроннаяПочта.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма, Соединение);
			ЭлектронныйЧек.ДатаОтправки = ТекущаяДата();
			ЭлектронныйЧек.ОписаниеОшибки = "";
		Исключение
			Инфо = ИнформацияОбОшибке();
			ЭлектронныйЧек.ОписаниеОшибки = Инфо.Описание;
		КонецПопытки;
		
		нзЭЧ.Записать(Истина);
		
	КонецЦикла;
	
	// 6. Отключиться
	Соединение.Отключиться();
	
	Если Не ПривилегированныйРежимБылУстановлен Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры
