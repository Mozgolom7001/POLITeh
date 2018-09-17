﻿
Перем мИнтерактивнаяЗапись Экспорт;
Перем мОткликИнтерактивнойЗаписи Экспорт;

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	Для каждого ЗаписьНабора Из ЭтотОбъект Цикл
		Если НЕ ЗначениеЗаполнено(ЗаписьНабора.ВидОбъектаДоступа) Тогда
			ЗаписьНабора.ВидОбъектаДоступа = НастройкаПравДоступа.ПолучитьВидОбъектаДоступа(ЗаписьНабора.ОбъектДоступа);
		КонецЕсли; 
	КонецЦикла; 
	
	Если мИнтерактивнаяЗапись = Истина Тогда
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВнешнийИсточник.ВидОбъектаДоступа КАК ВидОбъектаДоступа,
		|	ВнешнийИсточник.Пользователь КАК ГруппаПользователей
		|ПОМЕСТИТЬ
		|	ВременнаяТаблица
		|ИЗ
		|	&ВнешнийИсточник КАК ВнешнийИсточник
		|ГДЕ
		|	ВнешнийИсточник.ОбъектДоступа = ВнешнийИсточник.ВладелецПравДоступа
		|	И ВнешнийИсточник.Пользователь <> ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи)
		|";
		
		Запрос.УстановитьПараметр("ВнешнийИсточник", ЭтотОбъект.Выгрузить());
		Запрос.Выполнить();
		
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	Представление(ТаблицаНабора.ВидОбъектаДоступа) КАК ВидОбъектаДоступа,
		|	Представление(ТаблицаНабора.ГруппаПользователей) КАК ГруппаПользователей,
		|	НазначениеВидовОбъектовДоступа.ГруппаПользователей
		|ИЗ
		|	ВременнаяТаблица КАК ТаблицаНабора
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		РегистрСведений.НазначениеВидовОбъектовДоступа КАК НазначениеВидовОбъектовДоступа
		|		ПО НазначениеВидовОбъектовДоступа.ГруппаПользователей = ТаблицаНабора.ГруппаПользователей
		|		 И НазначениеВидовОбъектовДоступа.ВидОбъектаДоступа = ТаблицаНабора.ВидОбъектаДоступа
		|ГДЕ
		|	НазначениеВидовОбъектовДоступа.ГруппаПользователей ЕСТЬ NULL
		|УПОРЯДОЧИТЬ ПО ТаблицаНабора.ГруппаПользователей
		|";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			мОткликИнтерактивнойЗаписи = "Обнаружено несоответствие настроек!
							  |Для некоторых групп пользователей, используемых в текущих настройках ограничения прав, выключено использование ограничений по видам объектов доступа.
							  |Такие текущие настройки доступа не имеют смысла, потому что разрешения на указанные объекты такие группы пользователей все равно не получат.
							  |Возможно, следует скорректировать использование видов объектов доступа в форме группы пользователей.
							  |
							  |Следует проверить следующие группы пользователей:";
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				мОткликИнтерактивнойЗаписи = мОткликИнтерактивнойЗаписи + символы.ПС + " - " + Выборка.ГруппаПользователей + " (" + Выборка.ВидОбъектаДоступа + ")";
			КонецЦикла;
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры
